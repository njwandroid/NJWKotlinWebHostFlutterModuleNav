#!/bin/bash

# Robust Maestro Test Runner with Multi-Device Support
# This script provides enhanced device handling for scenarios with multiple connected devices
# Author: Assistant
# Version: 1.0

# Define colors for output
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Default settings
GENERATE_AI_REPORT=false
CLEAN_BUILD=false
RECORD_VIDEO=true
TEST_FLOW=""
TARGET_DEVICE=""
AUTO_SELECT_FIRST=false
VERBOSE=false

# Help message
print_help() {
    echo -e "${CYAN}Robust Maestro Test Runner - Multi-Device Support${NC}"
    echo ""
    echo "Usage: $0 [OPTIONS] <test_flow_file>"
    echo "Run a Maestro test with enhanced device selection and management."
    echo ""
    echo "Arguments:"
    echo "  <test_flow_file>       Path to the Maestro flow YAML file to run (required)"
    echo ""
    echo "Options:"
    echo "  -h, --help             Show help message and exit"
    echo "  -a, --ai-report        Generate an AI-enhanced test report (default: false)"
    echo "  -c, --clean            Clean build before running tests (default: false)"
    echo "  -n, --no-video         Skip video recording (default: record video)"
    echo "  -d, --device <id>      Target specific device by ID (e.g., emulator-5554)"
    echo "  -f, --first            Automatically select first available device"
    echo "  -e, --emulator-first   Prefer emulators over physical devices"
    echo "  -v, --verbose          Enable verbose output for debugging"
    echo ""
    echo "Device Selection Behavior:"
    echo "  • Single device: Automatically selected"
    echo "  • Multiple devices: Interactive selection menu (unless -f or -d specified)"
    echo "  • No devices: Attempts to start first available emulator"
    echo ""
    echo "Examples:"
    echo "  $0 ../flows/hello_world.yaml"
    echo "  $0 --device emulator-5554 ../flows/basic_navigation.yaml"
    echo "  $0 --first --ai-report ../flows/hello_world.yaml"
    echo "  $0 --emulator-first --clean --verbose ../flows/basic_navigation.yaml"
    echo ""
    echo "Troubleshooting:"
    echo "  • Use --verbose for detailed device detection logs"
    echo "  • List devices manually: adb devices"
    echo "  • Check emulators: emulator -list-avds"
}

# Verbose logging function
log_verbose() {
    if [ "$VERBOSE" = true ]; then
        echo -e "${BLUE}[VERBOSE] $1${NC}"
    fi
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
        -n|--no-video)
            RECORD_VIDEO=false
            shift
            ;;
        -d|--device)
            TARGET_DEVICE="$2"
            shift 2
            ;;
        -f|--first)
            AUTO_SELECT_FIRST=true
            shift
            ;;
        -e|--emulator-first)
            PREFER_EMULATOR=true
            shift
            ;;
        -v|--verbose)
            VERBOSE=true
            shift
            ;;
        -*)
            echo -e "${RED}Unknown option: $1${NC}"
            print_help
            exit 1
            ;;
        *)
            # Assume this is the test flow file
            TEST_FLOW="$1"
            shift
            ;;
    esac
done

# Check if test flow was provided
if [ -z "$TEST_FLOW" ]; then
    echo -e "${RED}Error: Test flow file is required${NC}"
    print_help
    exit 1
fi

# Check if test flow exists
if [ ! -f "$TEST_FLOW" ]; then
    echo -e "${RED}Error: Test flow file not found: $TEST_FLOW${NC}"
    exit 1
fi

# Extract test name for naming output files
TEST_NAME=$(basename "$TEST_FLOW" .yaml)

log_verbose "Test flow: $TEST_FLOW"
log_verbose "Test name: $TEST_NAME"
log_verbose "Target device: $TARGET_DEVICE"
log_verbose "Auto select first: $AUTO_SELECT_FIRST"

# Find and setup Android SDK tools
setup_android_tools() {
    echo -e "${YELLOW}Setting up Android SDK tools...${NC}"
    
    # Common locations for Android SDK on Mac
    POSSIBLE_SDK_LOCATIONS=(
        "$HOME/Library/Android/sdk"
        "/Applications/Android Studio.app/Contents/sdk"
        "/Users/Shared/Android/sdk"
        "$ANDROID_SDK_ROOT"
        "$ANDROID_HOME"
    )
    
    SDK_FOUND=false
    for SDK_PATH in "${POSSIBLE_SDK_LOCATIONS[@]}"; do
        if [ -n "$SDK_PATH" ] && [ -d "$SDK_PATH" ]; then
            log_verbose "Checking SDK path: $SDK_PATH"
            if [ -f "$SDK_PATH/platform-tools/adb" ]; then
                echo -e "${GREEN}Found Android SDK at: $SDK_PATH${NC}"
                export ANDROID_SDK_ROOT="$SDK_PATH"
                export PATH="$SDK_PATH/platform-tools:$SDK_PATH/tools:$SDK_PATH/tools/bin:$PATH"
                SDK_FOUND=true
                break
            fi
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
    
    log_verbose "Android SDK tools set up successfully"
    return 0
}

# Function to get detailed device information
get_device_info() {
    local device_id="$1"
    local device_type=""
    local device_name=""
    local api_level=""
    
    # Determine device type
    if [[ "$device_id" == emulator-* ]]; then
        device_type="Emulator"
        # Try to get emulator name
        device_name=$(adb -s "$device_id" shell getprop ro.kernel.qemu.avd_name 2>/dev/null || echo "Unknown AVD")
    else
        device_type="Physical"
        # Try to get device model
        device_name=$(adb -s "$device_id" shell getprop ro.product.model 2>/dev/null || echo "Unknown Device")
    fi
    
    # Get API level
    api_level=$(adb -s "$device_id" shell getprop ro.build.version.sdk 2>/dev/null || echo "Unknown")
    
    echo "$device_type|$device_name|API $api_level"
}

# Enhanced device availability check with detailed information
check_and_select_device() {
    echo -e "${YELLOW}Checking for connected devices...${NC}"
    
    # Get raw device list
    DEVICE_LIST=$(adb devices | grep -v "List" | grep -v "^$" | grep "device$")
    
    if [ -z "$DEVICE_LIST" ]; then
        echo -e "${RED}No devices connected.${NC}"
        return 1
    fi
    
    # Parse devices into arrays
    declare -a DEVICE_IDS=()
    declare -a DEVICE_INFO=()
    
    while IFS= read -r line; do
        if [ -n "$line" ]; then
            device_id=$(echo "$line" | awk '{print $1}')
            DEVICE_IDS+=("$device_id")
            
            log_verbose "Getting info for device: $device_id"
            info=$(get_device_info "$device_id")
            DEVICE_INFO+=("$info")
        fi
    done <<< "$DEVICE_LIST"
    
    DEVICE_COUNT=${#DEVICE_IDS[@]}
    echo -e "${GREEN}Found $DEVICE_COUNT connected device(s):${NC}"
    
    # Display device information
    for i in "${!DEVICE_IDS[@]}"; do
        IFS='|' read -r device_type device_name api_level <<< "${DEVICE_INFO[i]}"
        echo -e "  $((i+1)). ${CYAN}${DEVICE_IDS[i]}${NC} - $device_type: $device_name ($api_level)"
    done
    
    # Device selection logic
    SELECTED_DEVICE=""
    
    if [ -n "$TARGET_DEVICE" ]; then
        # Check if specified device exists
        for device_id in "${DEVICE_IDS[@]}"; do
            if [ "$device_id" = "$TARGET_DEVICE" ]; then
                SELECTED_DEVICE="$TARGET_DEVICE"
                echo -e "${GREEN}Using specified device: $SELECTED_DEVICE${NC}"
                break
            fi
        done
        
        if [ -z "$SELECTED_DEVICE" ]; then
            echo -e "${RED}Specified device '$TARGET_DEVICE' not found in connected devices.${NC}"
            return 1
        fi
    elif [ "$DEVICE_COUNT" -eq 1 ]; then
        # Single device - auto select
        SELECTED_DEVICE="${DEVICE_IDS[0]}"
        echo -e "${GREEN}Auto-selecting single device: $SELECTED_DEVICE${NC}"
    elif [ "$AUTO_SELECT_FIRST" = true ]; then
        # Auto select first device
        SELECTED_DEVICE="${DEVICE_IDS[0]}"
        echo -e "${GREEN}Auto-selecting first device: $SELECTED_DEVICE${NC}"
    elif [ "$PREFER_EMULATOR" = true ]; then
        # Find first emulator
        for device_id in "${DEVICE_IDS[@]}"; do
            if [[ "$device_id" == emulator-* ]]; then
                SELECTED_DEVICE="$device_id"
                echo -e "${GREEN}Selecting preferred emulator: $SELECTED_DEVICE${NC}"
                break
            fi
        done
        
        # Fallback to first device if no emulator found
        if [ -z "$SELECTED_DEVICE" ]; then
            SELECTED_DEVICE="${DEVICE_IDS[0]}"
            echo -e "${YELLOW}No emulator found, using first device: $SELECTED_DEVICE${NC}"
        fi
    else
        # Interactive selection
        echo ""
        echo -e "${YELLOW}Multiple devices available. Please select one:${NC}"
        
        while true; do
            echo -n "Enter device number (1-$DEVICE_COUNT): "
            read -r selection
            
            if [[ "$selection" =~ ^[0-9]+$ ]] && [ "$selection" -ge 1 ] && [ "$selection" -le "$DEVICE_COUNT" ]; then
                SELECTED_DEVICE="${DEVICE_IDS[$((selection-1))]}"
                echo -e "${GREEN}Selected device: $SELECTED_DEVICE${NC}"
                break
            else
                echo -e "${RED}Invalid selection. Please enter a number between 1 and $DEVICE_COUNT.${NC}"
            fi
        done
    fi
    
    # Set the selected device for adb commands
    export ANDROID_SERIAL="$SELECTED_DEVICE"
    log_verbose "Set ANDROID_SERIAL to: $ANDROID_SERIAL"
    
    return 0
}

# Function to start an emulator with better selection
start_emulator() {
    echo -e "${YELLOW}Attempting to start an Android emulator...${NC}"
    
    # Find emulator binary
    EMULATOR_BIN=""
    for possible_path in "$ANDROID_SDK_ROOT/emulator/emulator" "$ANDROID_SDK_ROOT/tools/emulator"; do
        if [ -f "$possible_path" ]; then
            EMULATOR_BIN="$possible_path"
            log_verbose "Found emulator at: $EMULATOR_BIN"
            break
        fi
    done
    
    if [ -z "$EMULATOR_BIN" ]; then
        echo -e "${RED}Could not find emulator binary in the Android SDK.${NC}"
        return 1
    fi
    
    # Get list of available AVDs
    EMULATORS=$("$EMULATOR_BIN" -list-avds)
    
    if [ -z "$EMULATORS" ]; then
        echo -e "${RED}No Android Virtual Devices (AVDs) found.${NC}"
        echo -e "${YELLOW}Please create an AVD in Android Studio before running this script.${NC}"
        return 1
    fi
    
    echo -e "${YELLOW}Available emulators:${NC}"
    declare -a EMULATOR_ARRAY=()
    while IFS= read -r line; do
        if [ -n "$line" ]; then
            EMULATOR_ARRAY+=("$line")
            echo -e "  • $line"
        fi
    done <<< "$EMULATORS"
    
    # Select emulator
    SELECTED_EMULATOR=""
    if [ "${#EMULATOR_ARRAY[@]}" -eq 1 ]; then
        SELECTED_EMULATOR="${EMULATOR_ARRAY[0]}"
        echo -e "${GREEN}Auto-selecting single emulator: $SELECTED_EMULATOR${NC}"
    elif [ "$AUTO_SELECT_FIRST" = true ]; then
        SELECTED_EMULATOR="${EMULATOR_ARRAY[0]}"
        echo -e "${GREEN}Auto-selecting first emulator: $SELECTED_EMULATOR${NC}"
    else
        echo ""
        echo -e "${YELLOW}Multiple emulators available. Select one:${NC}"
        for i in "${!EMULATOR_ARRAY[@]}"; do
            echo -e "  $((i+1)). ${EMULATOR_ARRAY[i]}"
        done
        
        while true; do
            echo -n "Enter emulator number (1-${#EMULATOR_ARRAY[@]}): "
            read -r selection
            
            if [[ "$selection" =~ ^[0-9]+$ ]] && [ "$selection" -ge 1 ] && [ "$selection" -le "${#EMULATOR_ARRAY[@]}" ]; then
                SELECTED_EMULATOR="${EMULATOR_ARRAY[$((selection-1))]}"
                echo -e "${GREEN}Selected emulator: $SELECTED_EMULATOR${NC}"
                break
            else
                echo -e "${RED}Invalid selection. Please enter a number between 1 and ${#EMULATOR_ARRAY[@]}.${NC}"
            fi
        done
    fi
    
    echo -e "${YELLOW}Starting emulator: $SELECTED_EMULATOR${NC}"
    
    # Start emulator in background
    "$EMULATOR_BIN" -avd "$SELECTED_EMULATOR" -no-window -no-audio -no-boot-anim &
    EMULATOR_PID=$!
    log_verbose "Emulator PID: $EMULATOR_PID"
    
    # Wait for emulator to boot completely
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
    
    # Show target device info
    if [ -n "$ANDROID_SERIAL" ]; then
        echo -e "${CYAN}Target device: $ANDROID_SERIAL${NC}"
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
    
    # Install the app on the selected device
    echo -e "${YELLOW}Installing app on device...${NC}"
    APK_PATH="app/build/outputs/apk/debug/app-debug.apk"
    if [ -f "$APK_PATH" ]; then
        install_cmd="adb install -r \"$APK_PATH\""
        if [ -n "$ANDROID_SERIAL" ]; then
            install_cmd="adb -s $ANDROID_SERIAL install -r \"$APK_PATH\""
        fi
        
        log_verbose "Install command: $install_cmd"
        
        if eval "$install_cmd"; then
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
    
    JSON_RESULTS="./maestro_results_${TEST_NAME}_$(date +%Y%m%d_%H%M%S).json"
    
    # Run the test with JSON output on selected device
    test_cmd="maestro test --format=json --output=\"$JSON_RESULTS\" \"$TEST_FLOW\""
    if [ -n "$ANDROID_SERIAL" ]; then
        test_cmd="maestro --device $ANDROID_SERIAL test --format=json --output=\"$JSON_RESULTS\" \"$TEST_FLOW\""
    fi
    
    if eval "$test_cmd"; then
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

# Main execution starts here
echo -e "${CYAN}===========================================${NC}"
echo -e "${CYAN} Robust Maestro Test Runner v1.0${NC}"
echo -e "${CYAN}===========================================${NC}"

# Output directory for video
VIDEO_DIR="./maestro_videos"
VIDEO_PATH="$VIDEO_DIR/${TEST_NAME}_$(date +%Y%m%d_%H%M%S).mp4"

echo -e "${YELLOW}Creating output directory for videos if it doesn't exist...${NC}"
mkdir -p "$VIDEO_DIR"

# Setup Android tools
if ! setup_android_tools; then
    echo -e "${RED}Failed to setup Android tools. Exiting.${NC}"
    exit 1
fi

# Check and select device
if ! check_and_select_device; then
    echo -e "${YELLOW}No devices found. Automatically starting an emulator...${NC}"
    
    if ! start_emulator; then
        echo -e "${RED}Failed to start emulator. Please connect a device or start an emulator manually.${NC}"
        exit 1
    fi
    
    # Verify device is now available and select it
    if ! check_and_select_device; then
        echo -e "${RED}Still no devices available after attempting to start emulator.${NC}"
        exit 1
    fi
fi

# Build and install the app
if ! build_and_install_app; then
    echo -e "${RED}Failed to build and install the app. Exiting.${NC}"
    exit 1
fi

echo -e "${YELLOW}Running Maestro test: $TEST_FLOW...${NC}"
echo -e "${YELLOW}Target device: $ANDROID_SERIAL${NC}"

# Run the test on selected device
test_cmd="maestro test \"$TEST_FLOW\""
if [ -n "$ANDROID_SERIAL" ]; then
    test_cmd="maestro --device $ANDROID_SERIAL test \"$TEST_FLOW\""
fi

if eval "$test_cmd"; then
    echo -e "${GREEN}Test completed successfully!${NC}"
    
    # Record video if requested
    if [ "$RECORD_VIDEO" = true ]; then
        echo -e "${YELLOW}Now recording a video of the test...${NC}"
        
        record_cmd="maestro record \"$TEST_FLOW\" \"$VIDEO_PATH\""
        if [ -n "$ANDROID_SERIAL" ]; then
            record_cmd="maestro --device $ANDROID_SERIAL record \"$TEST_FLOW\" \"$VIDEO_PATH\""
        fi
        
        if eval "$record_cmd"; then
            echo -e "${GREEN}Video recording completed successfully!${NC}"
            echo -e "${GREEN}Video saved to: ${VIDEO_PATH}${NC}"
            
            if [ -f "$VIDEO_PATH" ]; then
                VIDEO_SIZE=$(du -h "$VIDEO_PATH" | cut -f1)
                echo -e "${GREEN}Video file size: ${VIDEO_SIZE}${NC}"
                echo -e "${YELLOW}You can play the video with:${NC}"
                echo -e "open \"$VIDEO_PATH\""
            fi
        else
            echo -e "${RED}Video recording failed!${NC}"
        fi
    fi
    
    # Generate AI report if requested
    if [ "$GENERATE_AI_REPORT" = true ]; then
        generate_ai_report
    fi
    
else
    echo -e "${RED}Test failed!${NC}"
    exit 1
fi

echo -e "${GREEN}===========================================${NC}"
echo -e "${GREEN} Test execution completed successfully!${NC}"
echo -e "${GREEN}===========================================${NC}"