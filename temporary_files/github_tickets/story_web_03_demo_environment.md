# Story: Create Web Demo Environment with Clear Instructions

## Summary (TLDR)

**Create a user-friendly demo environment with easy-to-follow setup instructions.**

* **Key Components**:
    * Custom **index.html** with clear entry point
    * **macOS-specific setup instructions** for local development
    * Demo flow highlighting all navigation features
    * Multiple browser testing (Chrome, Firefox, Safari)
* **Technical Focus**:
    * Simplifying the demo experience for non-technical users
    * Providing IDE-specific debugging workflows
* **Time Estimate**: 5-7 hours

## Description

Develop a web demonstration environment with easy-to-follow setup instructions that allow team
members and stakeholders to quickly run and test the application in a browser. This includes
configuring a custom index.html and providing detailed steps for launching the demo with
Flutter web development tools on macOS.

## Requirements

- Create a user-friendly index.html as the entry point for web demonstration
- Configure Flutter web development environment for macOS
- Implement a demo flow showcasing all key navigation patterns
- Provide clear step-by-step demo guide for non-technical users
- Ensure demo works consistently across different browsers

## Technical Tasks

- [ ] Create a custom index.html with appropriate styling and metadata
- [ ] Add welcome information and navigation instructions to the landing page
- [ ] Configure macOS-specific Flutter web development settings
- [ ] Document IDE-based debugging workflow for Flutter web
- [ ] Create a demo script that highlights all key navigation features
- [ ] Document step-by-step instructions for running the demo
- [ ] Create a troubleshooting guide for common demo issues
- [ ] Test the demo flow on multiple browsers (Chrome, Firefox, Safari)
- [ ] Optimize performance for demo scenarios

## Acceptance Criteria

- [ ] Demo can be launched with a single command following the instructions
- [ ] index.html provides clear context and instructions for the application
- [ ] All navigation patterns can be demonstrated through the web interface
- [ ] Demo guide includes clear, non-technical instructions with screenshots
- [ ] Demo works consistently in Chrome, Firefox, and Safari
- [ ] Non-technical users can follow the instructions to run the demo successfully

## Dependencies

- Story: Configure Flutter Project for Web Platform
- Story: Adapt Navigation Patterns for Web Platform

## Notes

This story focuses on creating an accessible demonstration environment that makes it easy for all
team members and stakeholders to experience the application's navigation patterns in a web browser,
regardless of their technical expertise.

## AI Analysis

### Development Assistance Metrics

- **LOE with Firebender using Claude Sonnet 3.7:** Medium-Low
- **LOE with Firebender using Gemini 2.5 Pro:** Medium

### Project Metrics (Scale 1-10)

- **Likelihood of Success:** 9/10
- **Likelihood of Frustration:** 4/10
- **Likelihood of Manual Steps:** 6/10

### Time Estimate

- **Estimated Hours:** 5-7 hours

### Notes

For a Flutter developer with minimal web knowledge, creating a demo environment is relatively
straightforward once the core web functionality is working. The main challenges will be:

1. Creating a professional-looking index.html entry point
2. Documenting the process in a way that's accessible to non-technical users
3. Ensuring consistent behavior across different browsers

**Demo Steps to Include:**

```
# Web Demo Quick Start Guide for macOS

## Setup (One-time)
1. Install Flutter (if not already installed)
   ```

flutter doctor
   ```

2. Enable web support
   ```

flutter config --enable-web
   ```

3. Clone the repository
   ```

git clone [repository-url]
cd [project-directory]

   ```

## Running the Demo on macOS

### Using Terminal
1. Launch the app in Chrome from Terminal:
   ```

flutter run -d chrome
   ```
   The app will open automatically in Chrome browser


### Using Android Studio / IntelliJ
1. Open the project in Android Studio or IntelliJ
2. Select Chrome from the device dropdown
3. Click the Run/Debug button
4. For debugging:
   - Set breakpoints in your Dart code
   - Use the Debug panel to inspect variables
   - Use Chrome DevTools (Option+Cmd+I) for web-specific debugging

### Using VS Code
1. Open the project in VS Code
2. Install the Flutter and Dart extensions if not already installed
3. Select Chrome from the device selector in the status bar
4. Run using F5 or the Run menu
5. For debugging:
   - Set breakpoints in your Dart code
   - Use the Debug sidebar to inspect variables
   - Access Chrome DevTools through VS Code

### Local Web Server Option
For a simpler local testing approach without debugging:
1. Build the web app:
   ```

flutter build web

   ```
2. Navigate to the build directory:
   ```

cd build/web

   ```
3. Start a local server:
   ```

python3 -m http.server 8000

   ```
4. Open http://localhost:8000 in your browser

## Demo Navigation Flow
1. Start by exploring the bottom navigation tabs
2. In the "My" tab, test both in-tab and full-screen navigation patterns
3. In the "Billing" tab, observe navigation to the Kotlin-implemented detail page
4. In the "Items" tab, select Item7 to demonstrate deep linking
5. In the "ThTif" tab, test the complex navigation patterns:
   - Click "To Host" to navigate to a Kotlin view
   - Return and click "To Inner Flutter View" to navigate to another Flutter view

## Troubleshooting
- If the app doesn't load, check browser console (Option+Cmd+C in Safari, Option+Cmd+J in Chrome)
- For rendering issues, try switching renderers:
  ```

flutter run -d chrome --web-renderer html
  ```
  or
  ```

flutter run -d chrome --web-renderer canvaskit
  ```
- If web hot reload isn't working, try stopping and restarting the debug session
- For macOS permission issues when running local server, try using port 8000+
- For performance issues, prefer Chrome for development as it has better Flutter web tools
- If you see CORS errors in console, use the local server approach instead of file:// URLs
```

The documentation should include screenshots for key steps, especially for non-technical users.
Create a separate document with IDE setup screenshots for both Android Studio and VS Code.