#!/usr/bin/env python3
"""
Maestro AI Test Report Generator

This script takes Maestro test results in JSON format and generates an enhanced
report with AI-powered insights on the UI and user experience.

Usage:
  python generate_ai_report.py test-results.json

Requirements:
  - Python 3.6+
  - OpenAI API key (set as environment variable OPENAI_API_KEY)
  - Pillow library (PIL)
  - requests

Note: This is a simplified demo script. In a production environment, you'd want
more robust error handling and configuration options.
"""

import argparse
import json
import os
import sys
from datetime import datetime
import base64
from pathlib import Path

# Check for optional dependencies - if not available, provide fallback functionality
try:
    from PIL import Image
    from PIL.ExifTags import TAGS
    HAS_PIL = True
except ImportError:
    HAS_PIL = False
    print("Warning: Pillow not installed. Image processing will be limited.")

try:
    import requests
    HAS_REQUESTS = True
except ImportError:
    HAS_REQUESTS = False
    print("Warning: Requests not installed. AI analysis will be skipped.")

def get_screenshot_metadata(screenshot_path):
    """Extract metadata from a screenshot."""
    if not HAS_PIL:
        return {"path": screenshot_path}
    
    try:
        img = Image.open(screenshot_path)
        metadata = {
            "path": screenshot_path,
            "width": img.width,
            "height": img.height,
            "format": img.format,
            "mode": img.mode,
        }
        
        # Get EXIF data if available
        if hasattr(img, '_getexif') and img._getexif():
            exif = {TAGS.get(k, k): v for k, v in img._getexif().items()}
            metadata["datetime"] = exif.get("DateTime", "Unknown")
        
        return metadata
    except Exception as e:
        print(f"Error processing image {screenshot_path}: {e}")
        return {"path": screenshot_path, "error": str(e)}

def analyze_screenshot_with_ai(screenshot_path):
    """Analyze screenshot with AI to identify UI elements and potential issues."""
    if not HAS_REQUESTS:
        return {"status": "skipped", "reason": "requests library not available"}
        
    # Check for API key
    api_key = os.environ.get("OPENAI_API_KEY")
    if not api_key:
        return {"status": "skipped", "reason": "OpenAI API key not found in environment"}
    
    try:
        # Convert image to base64
        with open(screenshot_path, "rb") as image_file:
            encoded_image = base64.b64encode(image_file.read()).decode('utf-8')
        
        # Send to OpenAI API
        headers = {
            "Content-Type": "application/json",
            "Authorization": f"Bearer {api_key}"
        }
        
        payload = {
            "model": "gpt-4-vision-preview",
            "messages": [
                {
                    "role": "user",
                    "content": [
                        {
                            "type": "text",
                            "text": "Analyze this mobile app UI screenshot. Identify UI elements, layout structure, and point out any potential UX issues or improvements."
                        },
                        {
                            "type": "image_url",
                            "image_url": {
                                "url": f"data:image/jpeg;base64,{encoded_image}"
                            }
                        }
                    ]
                }
            ],
            "max_tokens": 300
        }
        
        response = requests.post(
            "https://api.openai.com/v1/chat/completions",
            headers=headers,
            json=payload
        )
        
        if response.status_code == 200:
            result = response.json()
            analysis = result["choices"][0]["message"]["content"]
            return {
                "status": "success",
                "analysis": analysis
            }
        else:
            return {
                "status": "error",
                "reason": f"API error: {response.status_code}",
                "details": response.text
            }
    
    except Exception as e:
        return {"status": "error", "reason": str(e)}

def generate_report(test_results, output_dir="."):
    """Generate an HTML report with AI insights from test results."""
    # Create output directory if it doesn't exist
    Path(output_dir).mkdir(parents=True, exist_ok=True)
    
    # Parse test results
    results = {}
    try:
        with open(test_results, 'r') as f:
            results = json.load(f)
    except Exception as e:
        print(f"Error reading test results: {e}")
        return False
    
    # Basic validation
    if not isinstance(results, dict):
        print("Error: Invalid test results format")
        return False
    
    # Create report filename
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    report_path = os.path.join(output_dir, f"maestro_report_{timestamp}.html")
    
    # Find screenshots - this is just a simplified example
    # In a real script, you would parse the test results to find the actual screenshots
    screenshot_dir = os.path.join(os.path.dirname(test_results), ".maestro/screenshots")
    screenshots = []
    
    if os.path.exists(screenshot_dir):
        for root, _, files in os.walk(screenshot_dir):
            for file in files:
                if file.lower().endswith(('.png', '.jpg', '.jpeg')):
                    screenshot_path = os.path.join(root, file)
                    metadata = get_screenshot_metadata(screenshot_path)
                    
                    # Only do AI analysis if explicitly requested and dependencies are available
                    ai_analysis = {"status": "skipped", "reason": "AI analysis not requested"}
                    if HAS_REQUESTS and os.environ.get("OPENAI_API_KEY"):
                        print(f"Analyzing screenshot: {file}")
                        ai_analysis = analyze_screenshot_with_ai(screenshot_path)
                    
                    screenshots.append({
                        "metadata": metadata,
                        "ai_analysis": ai_analysis,
                        "relative_path": os.path.relpath(screenshot_path, start=os.path.dirname(test_results))
                    })
    
    # Generate HTML report
    with open(report_path, 'w') as f:
        f.write(f"""<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Maestro AI Test Report</title>
    <style>
        body {{
            font-family: Arial, sans-serif;
            line-height: 1.6;
            color: #333;
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }}
        h1, h2, h3 {{
            color: #2c3e50;
        }}
        .screenshot-container {{
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
            margin: 20px 0;
        }}
        .screenshot-item {{
            border: 1px solid #ddd;
            border-radius: 4px;
            padding: 15px;
            width: 100%;
            max-width: 500px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }}
        .screenshot-item img {{
            max-width: 100%;
            height: auto;
            display: block;
            margin-bottom: 10px;
        }}
        .analysis {{
            background-color: #f9f9f9;
            padding: 10px;
            border-radius: 4px;
            white-space: pre-wrap;
        }}
        .success {{
            color: green;
        }}
        .error {{
            color: red;
        }}
        .skipped {{
            color: orange;
        }}
    </style>
</head>
<body>
    <h1>Maestro AI Test Report</h1>
    <p>Generated on {datetime.now().strftime("%Y-%m-%d %H:%M:%S")}</p>
    
    <h2>Test Summary</h2>
    <p>File: {os.path.basename(test_results)}</p>
    
    <h2>Screenshots Analysis</h2>
    <div class="screenshot-container">
""")

        for i, screenshot in enumerate(screenshots):
            metadata = screenshot["metadata"]
            ai_analysis = screenshot["ai_analysis"]
            
            status_class = "skipped"
            if ai_analysis["status"] == "success":
                status_class = "success"
            elif ai_analysis["status"] == "error":
                status_class = "error"
            
            f.write(f"""
        <div class="screenshot-item">
            <h3>Screenshot {i+1}: {os.path.basename(metadata["path"])}</h3>
            <img src="{screenshot['relative_path']}" alt="Screenshot {i+1}">
            <div class="metadata">
                <p><strong>Path:</strong> {metadata["path"]}</p>
""")
            
            # Add extra metadata if available
            if "width" in metadata:
                f.write(f"""                <p><strong>Dimensions:</strong> {metadata["width"]}x{metadata["height"]}</p>\n""")
            if "format" in metadata:
                f.write(f"""                <p><strong>Format:</strong> {metadata["format"]}</p>\n""")
            
            f.write(f"""            </div>
            <h4>AI Analysis <span class="{status_class}">({ai_analysis["status"]})</span></h4>
""")

            if ai_analysis["status"] == "success":
                f.write(f"""            <div class="analysis">{ai_analysis["analysis"]}</div>\n""")
            else:
                f.write(f"""            <div class="analysis">Reason: {ai_analysis.get("reason", "Unknown")}</div>\n""")
            
            f.write("""        </div>\n""")
        
        f.write("""
    </div>
    
    <h2>Recommendations</h2>
    <p>Based on the AI analysis of the screenshots, consider the following improvements:</p>
    <ul>
        <li>Review any highlighted UI inconsistencies</li>
        <li>Address accessibility issues identified in the analysis</li>
        <li>Consider UI/UX improvements suggested by the AI</li>
    </ul>
    
    <footer>
        <p>© Maestro AI Report Generator</p>
    </footer>
</body>
</html>
""")
    
    print(f"Report generated: {report_path}")
    return True

def main():
    parser = argparse.ArgumentParser(description="Generate AI-enhanced report from Maestro test results")
    parser.add_argument("results_file", help="Path to Maestro test results JSON file")
    parser.add_argument("--output-dir", "-o", default=".", help="Directory to save the report")
    
    args = parser.parse_args()
    
    if not os.path.exists(args.results_file):
        print(f"Error: Results file not found: {args.results_file}")
        return 1
    
    success = generate_report(args.results_file, args.output_dir)
    return 0 if success else 1

if __name__ == "__main__":
    sys.exit(main())