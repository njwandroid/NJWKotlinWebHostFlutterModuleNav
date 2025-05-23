#!/bin/bash

# Define colors for output
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Default settings
GENERATE_AI_REPORT=false
CLEAN_BUILD=false

# Help message
print_help() {
    echo "Usage: $0 [OPTIONS]"
    echo "Run a Maestro hello world test and generate a video of its output."
    echo ""
    echo "Options:"
    echo "  -h, --help             Show this help message and exit"
    echo "  -a, --ai-report        Generate an AI-enhanced test report (default: false)"
    echo "  -c, --clean            Clean build before running tests (default: false)"
    echo ""
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            print_help
            exit 0
            ;;
        -a|--ai-report)
            GENERATE_AI_REPORT=true
            shift
            ;;
        -c|--clean)
            CLEAN_BUILD=true
            shift
            ;;
        *)
            echo "Unknown option: $1"
            print_help
            exit 1
            ;;
    esac
done

# Find and setup Android SDK tools
setup_android_tools() {
    echo -e "${YELLOW}Setting up Android SDK tools...${NC}"
    
    # Common locations for Android SDK on Mac
    POSSIBLE_SDK_LOCATIONS=(
        "$HOME/Library/Android/sdk"
        "/Applications/Android Studio.app/Contents/sdk"
        "/Users/Shared/Android/sdk"
    )
    
    SDK_FOUND=false
    for SDK_PATH in "${POSSIBLE_SDK_LOCATIONS[@]}"; do
        if [ -d "$SDK_PATH" ]; then
            echo -e "${GREEN}Found Android SDK at: $SDK_PATH${NC}"
            export ANDROID_SDK_ROOT="$SDK_PATH"
            export PATH="$SDK_PATH/platform-tools:$SDK_PATH/tools:$SDK_PATH/tools/bin:$PATH"
            SDK_FOUND=true
            break
        fi
    done
    
    if ! $SDK_FOUND; then
        echo -e "${RED}Android SDK not found in common locations. Please set ANDROID_SDK_ROOT manually.${NC}"
        return 1
    fi
    
    # Verify adb is available
    if ! command -v adb &> /dev/null; then
        echo -e "${RED}adb command not found in PATH even after setup. Please check your Android SDK installation.${NC}"
        return 1
    fi
    
    echo -e "${GREEN}Android SDK tools set up successfully.${NC}"
    return 0
}

# Function to check for available devices
check_device_availability() {
    echo -e "${YELLOW}Checking for connected devices...${NC}"
    
    # Get list of devices
    DEVICES=$(adb devices | grep -v "List" | grep -v "^$" | wc -l)
    
    if [ "$DEVICES" -gt 0 ]; then
        echo -e "${GREEN}Found $DEVICES connected device(s):${NC}"
        adb devices | grep -v "List" | grep -v "^$"
        return 0
    else
        echo -e "${RED}No devices connected.${NC}"
        return 1
    fi
}

# Function to start an emulator
start_emulator() {
    echo -e "${YELLOW}Attempting to start an Android emulator...${NC}"
    
    # Find emulator binary - could be in different locations
    EMULATOR_BIN=""
    for possible_path in "$ANDROID_SDK_ROOT/emulator/emulator" "$ANDROID_SDK_ROOT/tools/emulator" "$ANDROID_SDK_ROOT/emulator"; do
        if [ -f "$possible_path" ]; then
            EMULATOR_BIN="$possible_path"
            echo -e "${GREEN}Found emulator at: $EMULATOR_BIN${NC}"
            break
        fi
    done
    
    if [ -z "$EMULATOR_BIN" ]; then
        echo -e "${RED}Could not find emulator binary in the Android SDK.${NC}"
        return 1
    fi
    
    # Get list of available AVDs
    EMULATORS=$("$EMULATOR_BIN" -list-avds)
    
    # Check if we have any emulators
    if [ -z "$EMULATORS" ]; then
        echo -e "${RED}No Android Virtual Devices (AVDs) found.${NC}"
        echo -e "${YELLOW}Please create an AVD in Android Studio before running this script.${NC}"
        return 1
    fi
    
    # Show available emulators
    echo -e "${YELLOW}Available emulators:${NC}"
    echo "$EMULATORS"
    
    # Use first emulator by default
    FIRST_EMULATOR=$(echo "$EMULATORS" | head -n 1)
    echo -e "${YELLOW}Starting emulator: $FIRST_EMULATOR${NC}"
    
    # Start emulator in background
    "$EMULATOR_BIN" -avd "$FIRST_EMULATOR" -no-window -no-audio -no-boot-anim &
    EMULATOR_PID=$!
    
    # Wait for emulator to boot completely (max 60 seconds)
    echo -e "${YELLOW}Waiting for emulator to boot (this may take a minute)...${NC}"
    for i in {1..30}; do
        if adb shell getprop sys.boot_completed 2>/dev/null | grep -q "1"; then
            echo -e "${GREEN}Emulator is ready!${NC}"
            return 0
        fi
        echo -n "."
        sleep 2
    done
    
    echo -e "${RED}Timeout waiting for emulator to start.${NC}"
    return 1
}

# Function to build and install the app
build_and_install_app() {
    echo -e "${YELLOW}Building and installing the app...${NC}"
    
    # Check for Gradle wrapper
    if [ ! -f "./gradlew" ]; then
        echo -e "${RED}Gradle wrapper not found. Make sure you're in the correct directory.${NC}"
        return 1
    fi
    
    # Clean if requested
    if [ "$CLEAN_BUILD" = true ]; then
        echo -e "${YELLOW}Cleaning previous builds...${NC}"
        if ./gradlew clean; then
            echo -e "${GREEN}Clean completed.${NC}"
        else
            echo -e "${RED}Clean failed.${NC}"
            return 1
        fi
    fi
    
    # Build the app
    echo -e "${YELLOW}Building app for debugging...${NC}"
    if ./gradlew assembleDebug; then
        echo -e "${GREEN}App build successful!${NC}"
    else
        echo -e "${RED}App build failed.${NC}"
        return 1
    fi
    
    # Install the app on the device
    echo -e "${YELLOW}Installing app on device...${NC}"
    APK_PATH="app/build/outputs/apk/debug/app-debug.apk"
    if [ -f "$APK_PATH" ]; then
        if adb install -r "$APK_PATH"; then
            echo -e "${GREEN}App installed successfully!${NC}"
            return 0
        else
            echo -e "${RED}App installation failed.${NC}"
            return 1
        fi
    else
        echo -e "${RED}APK not found at $APK_PATH${NC}"
        return 1
    fi
}

# Function to generate AI report
generate_ai_report() {
    echo -e "${YELLOW}Generating AI-enhanced report...${NC}"
    
    # Define output paths
    JSON_RESULTS="./maestro_results_$(date +%Y%m%d_%H%M%S).json"
    
    # Run the test with JSON output
    if maestro test --format=json --output="$JSON_RESULTS" maestro/flows/hello_world.yaml; then
        # Generate the AI report
        if [ -f "maestro/scripts/generate_ai_report.py" ]; then
            if python maestro/scripts/generate_ai_report.py "$JSON_RESULTS"; then
                echo -e "${GREEN}AI report generated!${NC}"
                return 0
            else
                echo -e "${RED}AI report generation failed!${NC}"
                return 1
            fi
        else
            echo -e "${RED}AI report script not found at maestro/scripts/generate_ai_report.py${NC}"
            return 1
        fi
    else
        echo -e "${RED}Failed to generate JSON test results for AI report.${NC}"
        return 1
    fi
}

# Output directory for video
VIDEO_DIR="./maestro_videos"
VIDEO_PATH="$VIDEO_DIR/hello_world_$(date +%Y%m%d_%H%M%S).mp4"

echo -e "${YELLOW}Creating output directory for videos if it doesn't exist...${NC}"
mkdir -p "$VIDEO_DIR"

# Setup Android tools
if ! setup_android_tools; then
    echo -e "${RED}Failed to setup Android tools. Exiting.${NC}"
    exit 1
fi

# Check if device is available
if ! check_device_availability; then
    echo -e "${YELLOW}No devices found. Automatically starting an emulator...${NC}"
    
    if ! start_emulator; then
        echo -e "${RED}Failed to start emulator. Please connect a device or start an emulator manually.${NC}"
        exit 1
    fi
    # Verify device is now available
    if ! check_device_availability; then
        echo -e "${RED}Still no devices available after attempting to start emulator.${NC}"
        exit 1
    fi
fi

# Build and install the app
if ! build_and_install_app; then
    echo -e "${RED}Failed to build and install the app. Exiting.${NC}"
    exit 1
fi

echo -e "${YELLOW}Running Maestro Hello World test...${NC}"
echo -e "${YELLOW}This will launch the app and perform basic navigation testing${NC}"

# First run the test to make sure it works
if maestro test maestro/flows/hello_world.yaml; then
    echo -e "${GREEN}Test completed successfully!${NC}"
    
    echo -e "${YELLOW}Now recording a video of the test...${NC}"
    # Use the record command to generate a video
    # Note: --local flag first, then flow file, then output path
    if maestro record --local maestro/flows/hello_world.yaml "$VIDEO_PATH"; then
        echo -e "${GREEN}Video recording completed successfully!${NC}"
        echo -e "${GREEN}Video saved to: ${VIDEO_PATH}${NC}"
        
        # Show the video location and size
        if [ -f "$VIDEO_PATH" ]; then
            VIDEO_SIZE=$(du -h "$VIDEO_PATH" | cut -f1)
            echo -e "${GREEN}Video file size: ${VIDEO_SIZE}${NC}"
            
            echo -e "${YELLOW}You can play the video with:${NC}"
            echo -e "open \"$VIDEO_PATH\""
        else
            echo -e "${RED}Video file not found at expected location: ${VIDEO_PATH}${NC}"
        fi
    else
        echo -e "${RED}Video recording failed!${NC}"
    fi
    
    # Generate AI report if requested
    if [ "$GENERATE_AI_REPORT" = true ]; then
        generate_ai_report
    fi
    
else
    echo -e "${RED}Test failed! Not proceeding with video recording.${NC}"
    echo -e "${YELLOW}Fix the test errors before attempting to record a video.${NC}"
    exit 1
fi

echo -e "${GREEN}Done!${NC}"