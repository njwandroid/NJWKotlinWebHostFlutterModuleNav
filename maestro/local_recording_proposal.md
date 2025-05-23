# Maestro Local Recording Proposal

## Overview

Currently, Maestro's video recording functionality requires a connection to Maestro's cloud
services. This document proposes multiple approaches for implementing local video recording
capabilities, eliminating the dependency on external services and internet connectivity.

## Motivation

- **Offline Development**: Enable testing and recording in environments without internet access
- **Privacy**: Keep sensitive app interactions completely local
- **Performance**: Avoid upload/download latency when working with video recordings
- **Cost Efficiency**: Remove dependency on cloud services for basic recording needs

## Proposed Solutions

### 1. Android: Integrated scrcpy Recording

[scrcpy](https://github.com/Genymobile/scrcpy) is an open-source tool for displaying and controlling
Android devices from a desktop. It includes robust screen recording capabilities that can be
triggered via command line.

#### Implementation Steps

1. Check for scrcpy installation during script initialization
2. Start scrcpy recording before Maestro test starts
3. Stop recording after test completion
4. Process and format the video (trim, add timestamps, etc.)
5. Save to specified output location

```bash
# Example implementation
START_RECORDING() {
    # Start scrcpy recording in background
    scrcpy --record="$OUTPUT_FILE" --no-display &
    RECORDING_PID=$!
    sleep 2  # Allow recording to initialize
}

STOP_RECORDING() {
    # Kill scrcpy process to stop recording
    kill $RECORDING_PID
    wait $RECORDING_PID 2>/dev/null
}
```

### 2. Android: ADB Shell Screenrecord

Android's `screenrecord` utility can be accessed via ADB and provides native screen recording
without additional dependencies.

#### Implementation Steps

1. Verify device supports screenrecord via ADB
2. Start recording before test execution
3. Stop recording after test completion
4. Pull recorded file from device to local storage

```bash
# Example implementation
START_RECORDING() {
    # Start screen recording on device
    adb shell "screenrecord --verbose /sdcard/recording.mp4" &
    RECORDING_PID=$!
    sleep 2  # Allow recording to initialize
}

STOP_RECORDING() {
    # Stop recording process
    adb shell "pkill -l SIGINT screenrecord"
    sleep 2  # Allow file to finalize
    # Pull file from device
    adb pull /sdcard/recording.mp4 "$OUTPUT_FILE"
    # Clean up device storage
    adb shell "rm /sdcard/recording.mp4"
}
```

### 3. iOS: Simulator Recording

For iOS simulators, the `xcrun simctl io` command can capture screen recordings directly.

#### Implementation Steps

1. Detect if running on iOS simulator
2. Get simulator UDID from Maestro/XCode
3. Start recording before test execution
4. Stop recording after test completion

```bash
# Example implementation
START_IOS_RECORDING() {
    # Get simulator UDID
    SIM_UDID=$(xcrun simctl list | grep Booted | awk '{print $NF}' | tr -d '()')
    # Start recording
    xcrun simctl io "$SIM_UDID" recordVideo "$OUTPUT_FILE" &
    RECORDING_PID=$!
}

STOP_IOS_RECORDING() {
    # Stop recording process
    kill -SIGINT $RECORDING_PID
    wait $RECORDING_PID 2>/dev/null
}
```

### 4. Cross-Platform: FFmpeg-based Screen Capture

Using FFmpeg to capture the device screen via ADB or iOS display streaming.

#### Implementation Steps

1. Verify FFmpeg installation
2. Configure input source based on platform (Android/iOS)
3. Start FFmpeg recording process before test execution
4. Stop recording after test completion

```bash
# Example implementation for Android
START_FFMPEG_RECORDING() {
    # Start FFmpeg recording of device screen
    ffmpeg -f android_camera -i /dev/video0 -preset ultrafast "$OUTPUT_FILE" &
    RECORDING_PID=$!
}

STOP_FFMPEG_RECORDING() {
    # Stop FFmpeg process
    kill -SIGINT $RECORDING_PID
    wait $RECORDING_PID 2>/dev/null
}
```

## Integration with Maestro

To integrate local recording with the Maestro test runner:

1. Add a `--recording-method` parameter to specify which recording approach to use
2. Create wrapper functions to initialize the appropriate recording method
3. Add pre-test and post-test hooks to start and stop recording
4. Add post-processing options for video enhancement (timestamps, annotations, etc.)

Example CLI syntax:

```bash
run_maestro_test.sh --record-local=scrcpy maestro/flows/hello_world.yaml
run_maestro_test.sh --record-local=adb maestro/flows/hello_world.yaml
run_maestro_test.sh --record-local=ffmpeg maestro/flows/hello_world.yaml
```

## Implementation Roadmap

1. **Phase 1**: Implement basic scrcpy recording for Android (simplest approach)
2. **Phase 2**: Add ADB screenrecord support for Android devices without scrcpy
3. **Phase 3**: Add iOS simulator recording support
4. **Phase 4**: Add FFmpeg support for advanced recording options
5. **Phase 5**: Add video post-processing (annotations, device info overlay, etc.)

## Technical Challenges and Considerations

- **Device Compatibility**: Different Android versions support different recording parameters
- **Performance Overhead**: Recording may affect test performance, especially on older devices
- **Video Quality**: Balance between file size and video quality for different use cases
- **Synchronization**: Ensuring recording starts before test and captures complete test execution

## Conclusion

Local recording capability would significantly enhance Maestro's utility in offline, secure, and
bandwidth-constrained environments. The proposed approaches leverage existing, proven tools while
offering flexibility for different platforms and use cases.

By implementing these local recording options, Maestro testing workflows would become more
self-contained and versatile without sacrificing the convenience of video recordings for test
documentation and debugging.