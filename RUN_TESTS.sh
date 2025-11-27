#!/bin/bash

# Samachar Plus OTT App - Test Runner Script

echo "======================================"
echo "Samachar Plus OTT App - Test Runner"
echo "======================================"
echo ""

# Check Flutter installation
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter is not installed. Please install it first."
    exit 1
fi

echo "✅ Flutter is installed: $(flutter --version | head -1)"
echo ""

# Get dependencies
echo "📦 Installing dependencies..."
flutter pub get

if [ $? -ne 0 ]; then
    echo "❌ Failed to get dependencies"
    exit 1
fi

# Generate environment files
echo "🔧 Generating environment configuration..."
dart run build_runner build

if [ $? -ne 0 ]; then
    echo "❌ Failed to generate environment files"
    exit 1
fi

echo ""
echo "Available devices:"
flutter devices

echo ""
echo "Choose how to run the app:"
echo "1. Run on iOS simulator"
echo "2. Run on Android emulator"
echo "3. Run on connected device"
echo "4. Run on Chrome (web)"
echo ""

read -p "Enter your choice (1-4): " choice

case $choice in
    1)
        echo "🚀 Running on iOS simulator..."
        flutter run -d ios
        ;;
    2)
        echo "🚀 Running on Android emulator..."
        flutter run -d android
        ;;
    3)
        echo "🚀 Running on connected device..."
        flutter run
        ;;
    4)
        echo "🚀 Running on Chrome..."
        flutter run -d chrome
        ;;
    *)
        echo "❌ Invalid choice"
        exit 1
        ;;
esac
