# Flutter Installation Guide

Since Flutter is not installed, here's how to set it up on your system:

## For macOS

### 1. Download Flutter SDK
```bash
# Download latest Flutter
curl -O https://storage.googleapis.com/flutter_infra_release/releases/stable/macos/flutter_macos_arm64_3.16.0-stable.zip
unzip flutter_macos_arm64_3.16.0-stable.zip
```

### 2. Add to PATH
```bash
# Add to your shell profile
echo 'export PATH="$PATH:`pwd`/flutter/bin"' >> ~/.zshrc
source ~/.zshrc
```

### 3. Verify Installation
```bash
flutter --version
flutter doctor
```

## For Windows

### 1. Download Flutter SDK
- Go to https://flutter.dev/docs/get-started/install/windows
- Download the Flutter SDK
- Extract to `C:\flutter`

### 2. Add to PATH
- Add `C:\flutter\bin` to your PATH environment variable
- Restart command prompt/terminal

### 3. Verify Installation
```cmd
flutter --version
flutter doctor
```

## For Linux

### 1. Download Flutter SDK
```bash
# Download latest Flutter
wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.16.0-stable.tar.xz
tar xf flutter_linux_3.16.0-stable.tar.xz
```

### 2. Add to PATH
```bash
# Add to your shell profile
echo 'export PATH="$PATH:`pwd`/flutter/bin"' >> ~/.bashrc
source ~/.bashrc
```

### 3. Verify Installation
```bash
flutter --version
flutter doctor
```

## After Installing Flutter

### 1. Accept Android Licenses
```bash
flutter doctor --android-licenses
# Accept all licenses by typing 'y'
```

### 2. Install Additional Dependencies
Flutter doctor will show what else you need to install. Common requirements:
- **Android Studio** (for Android development)
- **Xcode** (for iOS development on macOS)
- **Chrome** (for web development)

### 3. Run Flutter Doctor
```bash
flutter doctor
```
This will show what additional tools you need to install.

## Quick Setup Commands

Once Flutter is installed:

```bash
# Navigate to your app directory
cd /path/to/samachar-plus-ott-app

# Install dependencies
flutter pub get

# Check project configuration
flutter doctor

# Run the app
flutter run
```

## Alternative: Use Existing Flutter Installation

If you have Flutter installed elsewhere:

1. **Find your Flutter installation**:
   ```bash
   # On macOS/Linux, common locations:
   /usr/local/opt/flutter/bin/flutter
   ~/development/flutter/bin/flutter
   /opt/flutter/bin/flutter
   ```

2. **Add to PATH temporarily**:
   ```bash
   export PATH="$PATH:/path/to/your/flutter/bin"
   flutter --version
   ```

3. **Or create a symlink**:
   ```bash
   sudo ln -s /path/to/your/flutter/bin/flutter /usr/local/bin/flutter
   ```

## Need More Help?

- **Official Flutter docs**: https://flutter.dev/docs/get-started/install
- **Flutter doctor**: Use `flutter doctor` to see exactly what's missing
- **Android Studio setup**: For Android development
- **VS Code setup**: Install Flutter extension

---

**After Flutter is installed, you can proceed with testing the migrated app!**