#!/bin/bash

# Emulator management script for testing
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
EMULATOR_NAME="temporary_claude_${TIMESTAMP}"
AVD_PREFIX="temporary_"

echo "🤖 Managing test emulators..."

# Function to clean up old temporary emulators
cleanup_old_emulators() {
    echo "🧹 Cleaning up old temporary emulators..."
    
    # Kill any running emulators
    pkill -f emulator
    sleep 3
    
    # List and delete old temporary AVDs
    avd_list=$($ANDROID_HOME/emulator/emulator -list-avds)
    for avd in $avd_list; do
        if [[ $avd == ${AVD_PREFIX}* ]]; then
            echo "   Deleting old AVD: $avd"
            rm -rf $HOME/.android/avd/${avd}.avd
            rm -f $HOME/.android/avd/${avd}.ini
        fi
    done
}

# Function to create new emulator
create_emulator() {
    echo "🚀 Creating new emulator: $EMULATOR_NAME"
    
    # Check if we have the system image
    if ! $ANDROID_HOME/emulator/emulator -list-avds | grep -q "system-images;android-34"; then
        echo "📱 Using available system image..."
    fi
    
    # Create AVD with more storage
    $ANDROID_HOME/tools/bin/avdmanager create avd \
        -n $EMULATOR_NAME \
        -k "system-images;android-34;google_apis;arm64-v8a" \
        -d pixel_6 \
        --force \
        -c 8192M 2>/dev/null || {
        
        # Fallback: try with available image
        echo "⚠️  Falling back to available system image..."
        $ANDROID_HOME/emulator/emulator -list-avds | head -1 | while read existing_avd; do
            if [ ! -z "$existing_avd" ]; then
                echo "   Creating based on: $existing_avd"
                cp -r $HOME/.android/avd/${existing_avd}.avd $HOME/.android/avd/${EMULATOR_NAME}.avd
                cp $HOME/.android/avd/${existing_avd}.ini $HOME/.android/avd/${EMULATOR_NAME}.ini
                # Update the new ini file
                sed -i "s/${existing_avd}/${EMULATOR_NAME}/g" $HOME/.android/avd/${EMULATOR_NAME}.ini
            fi
        done
    }
}

# Function to start emulator
start_emulator() {
    echo "🎬 Starting emulator: $EMULATOR_NAME"
    
    $ANDROID_HOME/emulator/emulator \
        -avd $EMULATOR_NAME \
        -memory 4096 \
        -partition-size 8192 \
        -wipe-data \
        -no-snapshot-save \
        -no-snapshot-load &
    
    # Wait for emulator to be ready
    echo "⏳ Waiting for emulator to boot..."
    timeout 180 bash -c 'until adb devices | grep -q "device$"; do sleep 2; done'
    
    if adb devices | grep -q "device$"; then
        echo "✅ Emulator ready!"
        return 0
    else
        echo "❌ Emulator failed to start"
        return 1
    fi
}

# Main execution
case "${1:-create}" in
    "cleanup")
        cleanup_old_emulators
        ;;
    "create")
        cleanup_old_emulators
        create_emulator
        start_emulator
        ;;
    "start")
        start_emulator
        ;;
    *)
        echo "Usage: $0 {cleanup|create|start}"
        echo "  cleanup - Remove old temporary emulators"
        echo "  create  - Clean up old, create new, and start emulator"
        echo "  start   - Start the emulator"
        ;;
esac