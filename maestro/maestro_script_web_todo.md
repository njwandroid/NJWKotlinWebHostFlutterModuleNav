# Web Browser Support for Robust Maestro Test Runner

## Overview

This document outlines the modifications needed to extend the `robust_run_maestro_test.sh` script to
support web browsers for testing Flutter web applications. This will create a comprehensive testing
solution supporting Android, iOS, and web platforms.

## Key Modifications Required

### 1. Web Browser Detection and Management

**Add browser detection and control functions:**

```bash
# Function to detect available browsers
detect_available_browsers() {
    echo -e "${YELLOW}Detecting available browsers...${NC}"
    
    declare -a BROWSER_ARRAY=()
    declare -a BROWSER_INFO=()
    
    # Chrome/Chromium detection
    if command -v google-chrome &> /dev/null || command -v chromium-browser &> /dev/null || [ -d "/Applications/Google Chrome.app" ]; then
        BROWSER_ARRAY+=("chrome")
        BROWSER_INFO+=("Browser|Google Chrome|Latest")
        log_verbose "Found Google Chrome"
    fi
    
    # Firefox detection
    if command -v firefox &> /dev/null || [ -d "/Applications/Firefox.app" ]; then
        BROWSER_ARRAY+=("firefox")
        BROWSER_INFO+=("Browser|Mozilla Firefox|Latest")
        log_verbose "Found Mozilla Firefox"
    fi
    
    # Safari detection (macOS only)
    if [[ "$OSTYPE" == "darwin"* ]] && [ -d "/Applications/Safari.app" ]; then
        BROWSER_ARRAY+=("safari")
        BROWSER_INFO+=("Browser|Safari|Latest")
        log_verbose "Found Safari"
    fi
    
    # Edge detection
    if command -v microsoft-edge &> /dev/null || [ -d "/Applications/Microsoft Edge.app" ]; then
        BROWSER_ARRAY+=("edge")
        BROWSER_INFO+=("Browser|Microsoft Edge|Latest")
        log_verbose "Found Microsoft Edge"
    fi
    
    if [ ${#BROWSER_ARRAY[@]} -eq 0 ]; then
        echo -e "${RED}No supported browsers found.${NC}"
        return 1
    fi
    
    echo -e "${GREEN}Found ${#BROWSER_ARRAY[@]} supported browser(s):${NC}"
    for i in "${!BROWSER_ARRAY[@]}"; do
        IFS='|' read -r device_type device_name version <<< "${BROWSER_INFO[i]}"
        echo -e "  • ${CYAN}${BROWSER_ARRAY[i]}${NC} - $device_type: $device_name ($version)"
    done
    
    return 0
}

# Function to start a browser with specific URL
start_browser_with_url() {
    local browser="$1"
    local url="$2"
    
    echo -e "${YELLOW}Starting $browser with URL: $url${NC}"
    
    case "$browser" in
        "chrome")
            if [[ "$OSTYPE" == "darwin"* ]]; then
                open -a "Google Chrome" "$url"
            else
                google-chrome "$url" &
            fi
            ;;
        "firefox")
            if [[ "$OSTYPE" == "darwin"* ]]; then
                open -a "Firefox" "$url"
            else
                firefox "$url" &
            fi
            ;;
        "safari")
            if [[ "$OSTYPE" == "darwin"* ]]; then
                open -a "Safari" "$url"
            else
                echo -e "${RED}Safari is only available on macOS${NC}"
                return 1
            fi
            ;;
        "edge")
            if [[ "$OSTYPE" == "darwin"* ]]; then
                open -a "Microsoft Edge" "$url"
            else
                microsoft-edge "$url" &
            fi
            ;;
        *)
            echo -e "${RED}Unsupported browser: $browser${NC}"
            return 1
            ;;
    esac
    
    # Wait for browser to start
    sleep 3
    return 0
}
```

### 2. Flutter Web Development Server

**Add Flutter web server management:**

```bash
# Function to start Flutter web development server
start_flutter_web_server() {
    echo -e "${YELLOW}Starting Flutter web development server...${NC}"
    
    # Check for Flutter project
    if [ ! -f "pubspec.yaml" ]; then
        echo -e "${RED}pubspec.yaml not found. Make sure you're in a Flutter project directory.${NC}"
        return 1
    fi
    
    # Check if web is enabled
    if ! flutter config --list | grep -q "enable-web: true"; then
        echo -e "${YELLOW}Enabling Flutter web support...${NC}"
        flutter config --enable-web
    fi
    
    # Find available port
    WEB_PORT=$(find_available_port 8080)
    WEB_URL="http://localhost:$WEB_PORT"
    
    echo -e "${YELLOW}Starting Flutter web server on port $WEB_PORT...${NC}"
    
    # Start Flutter web server in background
    flutter run -d web-server --web-port="$WEB_PORT" --web-hostname=localhost &
    FLUTTER_WEB_PID=$!
    
    log_verbose "Flutter web server PID: $FLUTTER_WEB_PID"
    
    # Wait for server to be ready
    echo -e "${YELLOW}Waiting for Flutter web server to be ready...${NC}"
    for i in {1..30}; do
        if curl -s "$WEB_URL" > /dev/null 2>&1; then
            echo -e "${GREEN}Flutter web server is ready at: $WEB_URL${NC}"
            export FLUTTER_WEB_URL="$WEB_URL"
            return 0
        fi
        echo -n "."
        sleep 2
    done
    
    echo -e "${RED}Timeout waiting for Flutter web server to start.${NC}"
    return 1
}

# Function to find available port
find_available_port() {
    local start_port="$1"
    local port="$start_port"
    
    while [ $port -le 9000 ]; do
        if ! lsof -i :$port > /dev/null 2>&1; then
            echo $port
            return 0
        fi
        ((port++))
    done
    
    echo $start_port
    return 1
}

# Function to stop Flutter web server
stop_flutter_web_server() {
    if [ -n "$FLUTTER_WEB_PID" ]; then
        echo -e "${YELLOW}Stopping Flutter web server (PID: $FLUTTER_WEB_PID)...${NC}"
        kill $FLUTTER_WEB_PID 2>/dev/null
        wait $FLUTTER_WEB_PID 2>/dev/null
        echo -e "${GREEN}Flutter web server stopped.${NC}"
    fi
}
```

### 3. Web-Specific Device Selection

**Extend device selection for web browsers:**

```bash
# Enhanced device selection supporting Android, iOS, and Web
check_and_select_universal_device() {
    echo -e "${YELLOW}Checking for devices, simulators, and browsers...${NC}"
    
    # Arrays for all devices/targets
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
    
    # Check iOS simulators (if on macOS)
    if [[ "$OSTYPE" == "darwin"* ]] && check_ios_simulators; then
        for i in "${!IOS_DEVICE_IDS[@]}"; do
            ALL_DEVICE_IDS+=("${IOS_DEVICE_IDS[i]}")
            ALL_DEVICE_INFO+=("${IOS_DEVICE_INFO[i]}")
            ALL_DEVICE_PLATFORMS+=("ios")
        done
    fi
    
    # Check available browsers
    if detect_available_browsers; then
        for i in "${!BROWSER_ARRAY[@]}"; do
            ALL_DEVICE_IDS+=("${BROWSER_ARRAY[i]}")
            ALL_DEVICE_INFO+=("${BROWSER_INFO[i]}")
            ALL_DEVICE_PLATFORMS+=("web")
        done
    fi
    
    TOTAL_TARGETS=${#ALL_DEVICE_IDS[@]}
    
    if [ "$TOTAL_TARGETS" -eq 0 ]; then
        echo -e "${RED}No devices, simulators, or browsers found.${NC}"
        return 1
    fi
    
    echo -e "${GREEN}Found $TOTAL_TARGETS testing target(s):${NC}"
    
    # Display unified target list
    for i in "${!ALL_DEVICE_IDS[@]}"; do
        IFS='|' read -r device_type device_name version <<< "${ALL_DEVICE_INFO[i]}"
        platform_icon="🤖"
        case "${ALL_DEVICE_PLATFORMS[i]}" in
            "ios") platform_icon="🍎" ;;
            "web") platform_icon="🌐" ;;
        esac
        echo -e "  $((i+1)). $platform_icon ${CYAN}${ALL_DEVICE_IDS[i]}${NC} - $device_type: $device_name ($version)"
    done
    
    # Device/target selection logic
    SELECTED_TARGET=""
    SELECTED_PLATFORM=""
    
    # ... selection logic similar to existing device selection ...
    
    # Set platform-specific environment variables
    case "$SELECTED_PLATFORM" in
        "android")
            export ANDROID_SERIAL="$SELECTED_TARGET"
            export MAESTRO_PLATFORM="android"
            ;;
        "ios")
            export IOS_SIMULATOR_UDID="$SELECTED_TARGET"
            export MAESTRO_PLATFORM="ios"
            ;;
        "web")
            export WEB_BROWSER="$SELECTED_TARGET"
            export MAESTRO_PLATFORM="web"
            ;;
    esac
    
    return 0
}
```

### 4. Web Application Testing Flow

**Add web-specific testing workflow:**

```bash
# Function to handle web testing workflow
run_web_test_workflow() {
    echo -e "${YELLOW}Preparing web testing environment...${NC}"
    
    # Start Flutter web development server
    if ! start_flutter_web_server; then
        echo -e "${RED}Failed to start Flutter web server.${NC}"
        return 1
    fi
    
    # Start selected browser with the web app URL
    if ! start_browser_with_url "$WEB_BROWSER" "$FLUTTER_WEB_URL"; then
        echo -e "${RED}Failed to start browser.${NC}"
        stop_flutter_web_server
        return 1
    fi
    
    # Wait for app to load in browser
    echo -e "${YELLOW}Waiting for web app to load in browser...${NC}"
    sleep 5
    
    # Run Maestro test targeting the browser
    echo -e "${YELLOW}Running Maestro test on web browser...${NC}"
    
    # Maestro web testing command
    test_cmd="maestro --host localhost --port $WEB_PORT test \"$TEST_FLOW\""
    
    if eval "$test_cmd"; then
        echo -e "${GREEN}Web test completed successfully!${NC}"
        TEST_SUCCESS=true
    else
        echo -e "${RED}Web test failed!${NC}"
        TEST_SUCCESS=false
    fi
    
    # Clean up
    stop_flutter_web_server
    
    if [ "$TEST_SUCCESS" = true ]; then
        return 0
    else
        return 1
    fi
}
```

### 5. Web-Specific Maestro Configuration

**Handle web-specific Maestro settings:**

```bash
# Function to configure Maestro for web testing
configure_maestro_for_web() {
    echo -e "${YELLOW}Configuring Maestro for web testing...${NC}"
    
    # Create temporary Maestro config for web
    WEB_CONFIG_FILE="/tmp/maestro_web_config.yaml"
    
    cat > "$WEB_CONFIG_FILE" << EOF
# Maestro Web Configuration
platform: web
browser: $WEB_BROWSER
baseUrl: $FLUTTER_WEB_URL
timeout: 30000
headless: false
windowSize:
  width: 1920
  height: 1080
EOF
    
    export MAESTRO_CONFIG_FILE="$WEB_CONFIG_FILE"
    log_verbose "Created Maestro web config: $WEB_CONFIG_FILE"
    
    return 0
}

# Function to clean up web configuration
cleanup_web_config() {
    if [ -n "$WEB_CONFIG_FILE" ] && [ -f "$WEB_CONFIG_FILE" ]; then
        rm -f "$WEB_CONFIG_FILE"
        log_verbose "Cleaned up web config file"
    fi
}
```

## Command Line Options

**Add web-specific options:**

```bash
# New command line options to add:
echo "  -w, --web-first        Prefer web browsers over mobile devices"
echo "  -b, --browser <name>   Target specific browser (chrome|firefox|safari|edge)"
echo "  --web-port <port>      Use specific port for Flutter web server (default: 8080)"
echo "  --headless             Run browser in headless mode (if supported)"
```

## Web Test Flow Considerations

### 1. Flutter Web Test Adaptations

```yaml
# flows/web_compatible_test.yaml
appId: localhost:8080  # Web URL instead of mobile app ID
---
- launchApp:
    url: "http://localhost:8080"
- assertVisible: "Home"
- tapOn: "Navigate"
- assertVisible: "Second Screen"
- scroll:
    direction: DOWN
    element: "main-content"
```

### 2. Browser-Specific Considerations

**Chrome/Chromium:**

- Best Maestro support
- DevTools integration
- Headless mode available

**Firefox:**

- Good compatibility
- Different developer tools
- May require specific selectors

**Safari:**

- macOS only
- WebKit rendering differences
- May require additional configuration

**Edge:**

- Chromium-based (similar to Chrome)
- Good compatibility
- Cross-platform availability

### 3. Responsive Testing

```bash
# Function to test multiple viewport sizes
test_responsive_layouts() {
    local test_flow="$1"
    
    declare -a VIEWPORT_SIZES=(
        "1920x1080"  # Desktop
        "1366x768"   # Laptop
        "768x1024"   # Tablet
        "375x667"    # Mobile
    )
    
    for size in "${VIEWPORT_SIZES[@]}"; do
        IFS='x' read -r width height <<< "$size"
        echo -e "${YELLOW}Testing viewport: ${width}x${height}${NC}"
        
        # Resize browser window
        # Run test with current viewport
        # Record results
    done
}
```

## Prerequisites and Dependencies

### System Requirements

1. **Flutter Web Support**: `flutter config --enable-web`
2. **Supported Browsers**: At least one of Chrome, Firefox, Safari, or Edge
3. **Network Tools**: `curl`, `lsof` for port management
4. **Process Management**: `kill`, `wait` for server lifecycle

### Development Environment

- **Flutter SDK**: Latest stable with web support
- **Browser Developer Tools**: For debugging web-specific issues
- **Local Development Server**: Flutter's built-in web server
- **Port Management**: Handle dynamic port allocation

## Error Handling

### Web-Specific Error Scenarios

1. **No Browsers Available**: Guide user to install supported browser
2. **Port Conflicts**: Automatically find available ports
3. **Flutter Web Server Failures**: Detect and restart server
4. **Browser Launch Failures**: Try alternative browsers
5. **Network Connectivity**: Handle localhost connection issues

### Browser Compatibility Issues

```bash
# Function to handle browser-specific quirks
handle_browser_compatibility() {
    local browser="$1"
    
    case "$browser" in
        "safari")
            # Safari-specific configurations
            echo -e "${YELLOW}Note: Safari may require allowing localhost connections${NC}"
            ;;
        "firefox")
            # Firefox-specific configurations
            echo -e "${YELLOW}Note: Firefox may require additional security settings${NC}"
            ;;
    esac
}
```

## Implementation Phases

### Phase 1: Basic Web Support

1. Add browser detection
2. Implement Flutter web server management
3. Create basic web testing workflow
4. Add web-specific command line options

### Phase 2: Enhanced Browser Management

1. Add multiple browser support
2. Implement browser preference options
3. Handle browser-specific configurations
4. Add headless mode support

### Phase 3: Advanced Web Testing

1. Add responsive viewport testing
2. Implement browser performance monitoring
3. Add web-specific error handling
4. Create comprehensive web test flows

### Phase 4: Integration and Polish

1. Integrate with existing Android/iOS functionality
2. Add comprehensive documentation
3. Create cross-platform test suite
4. Add CI/CD integration examples

## Testing Strategy

### Web Test Categories

1. **Functional Tests**: Core app functionality in browser
2. **Responsive Tests**: Different viewport sizes and orientations
3. **Cross-Browser Tests**: Compatibility across different browsers
4. **Performance Tests**: Web app loading and runtime performance
5. **Integration Tests**: Web-to-mobile feature parity

### Test Flow Examples

```yaml
# Cross-platform navigation test
- if:
    platform: web
  then:
    - assertVisible: "nav-menu"
  else:
    - assertVisible: "BottomNavigationBar"
```

## Success Criteria

- Script detects and lists available browsers alongside mobile devices
- Flutter web development server starts and stops reliably
- Web browsers launch with the correct URL
- Maestro tests execute successfully in web browsers
- Video recording works for web tests (if supported)
- Responsive testing across different viewport sizes
- Cross-browser compatibility testing
- Seamless integration with existing mobile testing functionality

## Future Enhancements

1. **PWA Testing**: Progressive Web App specific test flows
2. **Web Performance Monitoring**: Integration with Lighthouse or similar tools
3. **Visual Regression Testing**: Screenshot comparison across browsers
4. **Accessibility Testing**: Web accessibility compliance testing
5. **Cloud Browser Testing**: Integration with cloud browser services

## Related Documentation

- [Maestro Web Testing](https://maestro.mobile.dev/platform-support/web)
- [Flutter Web Development](https://docs.flutter.dev/platform-integration/web)
- [Browser Automation Tools](https://developer.mozilla.org/en-US/docs/Web/WebDriver)
- [Responsive Web Design Testing](https://web.dev/responsive-web-design-basics/)