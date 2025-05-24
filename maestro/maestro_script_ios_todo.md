# iOS Simulator Support for Robust Maestro Test Runner

## Overview

This document outlines the modifications needed to extend the `robust_run_maestro_test.sh` script to
support iOS simulators alongside Android devices. The enhanced script will provide unified device
management across both platforms.

## Key Modifications Required

### 1. iOS Simulator Detection

**Add iOS-specific device detection functions:**

```bash
# Function to get iOS simulator information
get_ios_device_info() {
    local device_id="$1"
    local device_name=""
    local ios_version=""
    local device_type=""
    
    # Extract device info from xcrun simctl list
    device_info=$(xcrun simctl list devices --json | jq -r --arg udid "$device_id" '.devices[][] | select(.udid == $udid)')
    
    if [ -n "$device_info" ]; then
        device_name=$(echo "$device_info" | jq -r '.name')
        device_type="iOS Simulator"
        ios_version=$(echo "$device_info" | jq -r '.runtimeIdentifier' | sed 's/com.apple.CoreSimulator.SimRuntime.iOS-/iOS /')
    else
        device_name="Unknown iOS Device"
        device_type="iOS Device"
        ios_version="Unknown"
    fi
    
    echo "$device_type|$device_name|$ios_version"
}

# Function to check for available iOS simulators
check_ios_simulators() {
    echo -e "${YELLOW}Checking for iOS simulators...${NC}"
    
    # Check if Xcode command line tools are available
    if ! command -v xcrun &> /dev/null; then
        log_verbose "Xcode command line tools not found"
        return 1
    fi
    
    # Get list of booted simulators
    IOS_DEVICES=$(xcrun simctl list devices --json | jq -r '.devices[][] | select(.state == "Booted") | .udid')
    
    if [ -n "$IOS_DEVICES" ]; then
        echo -e "${GREEN}Found iOS simulators:${NC}"
        while IFS= read -r device_id; do
            if [ -n "$device_id" ]; then
                info=$(get_ios_device_info "$device_id")
                IFS='|' read -r device_type device_name ios_version <<< "$info"
                echo -e "  • ${CYAN}$device_id${NC} - $device_type: $device_name ($ios_version)"
                IOS_DEVICE_IDS+=("$device_id")
                IOS_DEVICE_INFO+=("$info")
            fi
        done <<< "$IOS_DEVICES"
        return 0
    else
        log_verbose "No booted iOS simulators found"
        return 1
    fi
}
```

### 2. Unified Device Selection

**Modify device selection to handle both platforms:**

```bash
# Enhanced device selection supporting both Android and iOS
check_and_select_unified_device() {
    echo -e "${YELLOW}Checking for connected devices and simulators...${NC}"
    
    # Arrays for all devices
    declare -a ALL_DEVICE_IDS=()
    declare -a ALL_DEVICE_INFO=()
    declare -a ALL_DEVICE_PLATFORMS=()
    
    # Check Android devices
    if check_android_devices; then
        for i in "${!ANDROID_DEVICE_IDS[@]}"; do
            ALL_DEVICE_IDS+=("${ANDROID_DEVICE_IDS[i]}")
            ALL_DEVICE_INFO+=("${ANDROID_DEVICE_INFO[i]}")
            ALL_DEVICE_PLATFORMS+=("android")
        done
    fi
    
    # Check iOS simulators
    if check_ios_simulators; then
        for i in "${!IOS_DEVICE_IDS[@]}"; do
            ALL_DEVICE_IDS+=("${IOS_DEVICE_IDS[i]}")
            ALL_DEVICE_INFO+=("${IOS_DEVICE_INFO[i]}")
            ALL_DEVICE_PLATFORMS+=("ios")
        done
    fi
    
    TOTAL_DEVICES=${#ALL_DEVICE_IDS[@]}
    
    if [ "$TOTAL_DEVICES" -eq 0 ]; then
        echo -e "${RED}No devices or simulators found.${NC}"
        return 1
    fi
    
    echo -e "${GREEN}Found $TOTAL_DEVICES device(s)/simulator(s):${NC}"
    
    # Display unified device list
    for i in "${!ALL_DEVICE_IDS[@]}"; do
        IFS='|' read -r device_type device_name version <<< "${ALL_DEVICE_INFO[i]}"
        platform_icon="🤖"
        if [ "${ALL_DEVICE_PLATFORMS[i]}" = "ios" ]; then
            platform_icon="🍎"
        fi
        echo -e "  $((i+1)). $platform_icon ${CYAN}${ALL_DEVICE_IDS[i]}${NC} - $device_type: $device_name ($version)"
    done
    
    # Device selection logic (similar to Android-only version but platform-aware)
    # ... selection logic here ...
    
    # Set platform-specific environment variables
    if [ "${SELECTED_PLATFORM}" = "android" ]; then
        export ANDROID_SERIAL="$SELECTED_DEVICE"
        export MAESTRO_PLATFORM="android"
    else
        export IOS_SIMULATOR_UDID="$SELECTED_DEVICE"
        export MAESTRO_PLATFORM="ios"
    fi
    
    return 0
}
```

### 3. iOS Simulator Management

**Add functions to start and manage iOS simulators:**

```bash
# Function to start an iOS simulator
start_ios_simulator() {
    echo -e "${YELLOW}Attempting to start an iOS simulator...${NC}"
    
    # Get list of available simulators
    AVAILABLE_SIMS=$(xcrun simctl list devices --json | jq -r '.devices[][] | select(.isAvailable == true) | "\(.udid)|\(.name)|\(.runtimeIdentifier)"')
    
    if [ -z "$AVAILABLE_SIMS" ]; then
        echo -e "${RED}No available iOS simulators found.${NC}"
        echo -e "${YELLOW}Please create an iOS simulator in Xcode before running this script.${NC}"
        return 1
    fi
    
    echo -e "${YELLOW}Available iOS simulators:${NC}"
    declare -a SIM_ARRAY=()
    while IFS='|' read -r udid name runtime; do
        if [ -n "$udid" ]; then
            SIM_ARRAY+=("$udid|$name|$runtime")
            runtime_display=$(echo "$runtime" | sed 's/com.apple.CoreSimulator.SimRuntime.iOS-/iOS /')
            echo -e "  • $name ($runtime_display)"
        fi
    done <<< "$AVAILABLE_SIMS"
    
    # Select simulator (similar logic to emulator selection)
    SELECTED_SIM=""
    if [ "${#SIM_ARRAY[@]}" -eq 1 ]; then
        IFS='|' read -r sim_udid sim_name sim_runtime <<< "${SIM_ARRAY[0]}"
        SELECTED_SIM="$sim_udid"
        echo -e "${GREEN}Auto-selecting single simulator: $sim_name${NC}"
    elif [ "$AUTO_SELECT_FIRST" = true ]; then
        IFS='|' read -r sim_udid sim_name sim_runtime <<< "${SIM_ARRAY[0]}"
        SELECTED_SIM="$sim_udid"
        echo -e "${GREEN}Auto-selecting first simulator: $sim_name${NC}"
    else
        # Interactive selection menu
        echo ""
        echo -e "${YELLOW}Multiple simulators available. Select one:${NC}"
        for i in "${!SIM_ARRAY[@]}"; do
            IFS='|' read -r sim_udid sim_name sim_runtime <<< "${SIM_ARRAY[i]}"
            runtime_display=$(echo "$sim_runtime" | sed 's/com.apple.CoreSimulator.SimRuntime.iOS-/iOS /')
            echo -e "  $((i+1)). $sim_name ($runtime_display)"
        done
        
        while true; do
            echo -n "Enter simulator number (1-${#SIM_ARRAY[@]}): "
            read -r selection
            
            if [[ "$selection" =~ ^[0-9]+$ ]] && [ "$selection" -ge 1 ] && [ "$selection" -le "${#SIM_ARRAY[@]}" ]; then
                IFS='|' read -r sim_udid sim_name sim_runtime <<< "${SIM_ARRAY[$((selection-1))]}"
                SELECTED_SIM="$sim_udid"
                echo -e "${GREEN}Selected simulator: $sim_name${NC}"
                break
            else
                echo -e "${RED}Invalid selection. Please enter a number between 1 and ${#SIM_ARRAY[@]}.${NC}"
            fi
        done
    fi
    
    echo -e "${YELLOW}Starting iOS simulator...${NC}"
    
    # Boot the simulator
    if xcrun simctl boot "$SELECTED_SIM" 2>/dev/null; then
        echo -e "${GREEN}iOS simulator started successfully!${NC}"
        
        # Wait for simulator to be ready
        echo -e "${YELLOW}Waiting for simulator to be ready...${NC}"
        for i in {1..30}; do
            if xcrun simctl list devices --json | jq -r --arg udid "$SELECTED_SIM" '.devices[][] | select(.udid == $udid) | .state' | grep -q "Booted"; then
                echo -e "${GREEN}Simulator is ready!${NC}"
                return 0
            fi
            echo -n "."
            sleep 2
        done
        
        echo -e "${RED}Timeout waiting for simulator to be ready.${NC}"
        return 1
    else
        echo -e "${RED}Failed to start iOS simulator.${NC}"
        return 1
    fi
}
```

### 4. iOS App Building and Installation

**Add iOS-specific build and install functions:**

```bash
# Function to build and install iOS app
build_and_install_ios_app() {
    echo -e "${YELLOW}Building and installing iOS app...${NC}"
    
    # Check for Flutter project
    if [ ! -f "pubspec.yaml" ]; then
        echo -e "${RED}pubspec.yaml not found. Make sure you're in a Flutter project directory.${NC}"
        return 1
    fi
    
    # Show target simulator info
    if [ -n "$IOS_SIMULATOR_UDID" ]; then
        sim_info=$(get_ios_device_info "$IOS_SIMULATOR_UDID")
        IFS='|' read -r device_type device_name ios_version <<< "$sim_info"
        echo -e "${CYAN}Target simulator: $device_name ($ios_version)${NC}"
    fi
    
    # Clean if requested
    if [ "$CLEAN_BUILD" = true ]; then
        echo -e "${YELLOW}Cleaning previous builds...${NC}"
        if flutter clean; then
            echo -e "${GREEN}Clean completed.${NC}"
        else
            echo -e "${RED}Clean failed.${NC}"
            return 1
        fi
    fi
    
    # Build the iOS app
    echo -e "${YELLOW}Building iOS app for simulator...${NC}"
    if flutter build ios --simulator; then
        echo -e "${GREEN}iOS app build successful!${NC}"
    else
        echo -e "${RED}iOS app build failed.${NC}"
        return 1
    fi
    
    # Install the app on the simulator
    echo -e "${YELLOW}Installing app on iOS simulator...${NC}"
    
    # Find the .app bundle
    APP_BUNDLE=$(find build/ios/iphonesimulator -name "*.app" -type d | head -n 1)
    
    if [ -n "$APP_BUNDLE" ] && [ -d "$APP_BUNDLE" ]; then
        if xcrun simctl install "$IOS_SIMULATOR_UDID" "$APP_BUNDLE"; then
            echo -e "${GREEN}iOS app installed successfully!${NC}"
            return 0
        else
            echo -e "${RED}iOS app installation failed.${NC}"
            return 1
        fi
    else
        echo -e "${RED}iOS app bundle not found in build directory${NC}"
        return 1
    fi
}
```

### 5. Platform-Aware Test Execution

**Modify test execution to handle both platforms:**

```bash
# Platform-aware test execution
run_maestro_test_unified() {
    echo -e "${YELLOW}Running Maestro test: $TEST_FLOW...${NC}"
    
    if [ "$MAESTRO_PLATFORM" = "android" ]; then
        echo -e "${YELLOW}Target Android device: $ANDROID_SERIAL${NC}"
        test_cmd="maestro --device $ANDROID_SERIAL test \"$TEST_FLOW\""
    elif [ "$MAESTRO_PLATFORM" = "ios" ]; then
        ios_info=$(get_ios_device_info "$IOS_SIMULATOR_UDID")
        IFS='|' read -r device_type device_name ios_version <<< "$ios_info"
        echo -e "${YELLOW}Target iOS simulator: $device_name${NC}"
        test_cmd="maestro --device $IOS_SIMULATOR_UDID test \"$TEST_FLOW\""
    else
        echo -e "${RED}Unknown platform: $MAESTRO_PLATFORM${NC}"
        return 1
    fi
    
    if eval "$test_cmd"; then
        echo -e "${GREEN}Test completed successfully on $MAESTRO_PLATFORM!${NC}"
        return 0
    else
        echo -e "${RED}Test failed on $MAESTRO_PLATFORM!${NC}"
        return 1
    fi
}
```

## Command Line Options

**Add iOS-specific options:**

```bash
# New command line options to add:
echo "  -i, --ios-first        Prefer iOS simulators over Android devices"
echo "  -p, --platform <name>  Target specific platform (android|ios)"
echo "  --simulator <udid>     Target specific iOS simulator by UDID"
```

## Prerequisites

### iOS Development Setup

1. **Xcode Installation**: Full Xcode (not just command line tools)
2. **iOS Simulators**: At least one iOS simulator installed
3. **Flutter iOS Setup**: `flutter doctor` shows iOS toolchain ready
4. **Simulator Management**: Familiarity with `xcrun simctl` commands

### Dependencies

- **jq**: JSON parsing for simulator information (`brew install jq`)
- **Xcode Command Line Tools**: `xcode-select --install`
- **Flutter**: Configured for iOS development

## Testing Strategy

### iOS-Specific Test Considerations

1. **Simulator States**: Handle booted/shutdown states
2. **iOS Version Compatibility**: Test across different iOS versions
3. **Device Types**: Support iPhone and iPad simulators
4. **App Installation**: Handle iOS app bundle installation
5. **Permission Dialogs**: Account for iOS-specific permission prompts

### Cross-Platform Test Flows

Create test flows that work on both platforms:

```yaml
# flows/cross_platform_navigation.yaml
appId: com.example.myflutternavbarapplication
---
- launchApp
- assertVisible: "Home" # Works on both platforms
- tapOn: "Navigate"
- assertVisible: "Second Screen"
```

## Error Handling

### iOS-Specific Error Scenarios

1. **Simulator Not Booted**: Auto-boot or provide clear instructions
2. **Xcode Not Installed**: Detect and provide installation guidance
3. **iOS App Build Failures**: Flutter iOS setup issues
4. **Simulator Permissions**: Handle macOS permission requirements

### Graceful Degradation

- Fall back to Android if iOS setup is incomplete
- Provide clear error messages for iOS-specific issues
- Skip iOS tests gracefully in Android-only environments

## Implementation Checklist

- [ ] Add iOS simulator detection functions
- [ ] Implement unified device selection menu
- [ ] Create iOS simulator start/stop management
- [ ] Add iOS app building and installation
- [ ] Implement platform-aware test execution
- [ ] Add iOS-specific command line options
- [ ] Create cross-platform test flows
- [ ] Add comprehensive error handling
- [ ] Update help documentation
- [ ] Test on various iOS simulator configurations

## Future Enhancements

1. **Physical iOS Device Support**: Extend to real iOS devices
2. **iOS App Signing**: Handle code signing for device testing
3. **Parallel Testing**: Run tests on multiple simulators simultaneously
4. **iOS-Specific Features**: Deep linking, push notifications, etc.
5. **Cloud Testing**: Integration with iOS cloud testing services

## Related Documentation

- [Maestro iOS Documentation](https://maestro.mobile.dev/platform-support/ios)
- [Flutter iOS Development](https://docs.flutter.dev/get-started/install/macos#ios-setup)
- [iOS Simulator Guide](https://developer.apple.com/documentation/xcode/running-your-app-in-the-simulator)
- [xcrun simctl Reference](https://nshipster.com/simctl/)