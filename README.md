# Samachar Plus OTT App

A Flutter-based multi-platform news and media application built with the same Supabase + R2 backend as the web platform.

## 🎯 Project Overview

This is the mobile application counterpart to the web platform, featuring live streaming, news consumption, and user engagement capabilities across iOS and Android.

## 🏗️ Architecture

### Monorepo Structure
```
samachar-plus-ott-app/
├── lib/
│   ├── main.dart                    # App entry point
│   ├── firebase_options.dart        # Firebase configuration
│   ├── models/                      # Data models
│   │   ├── user_model.dart         # User and user preferences
│   │   └── news_model.dart         # News articles and live channels
│   ├── providers/                   # State management
│   │   ├── auth_provider.dart      # Authentication state
│   │   └── news_provider.dart      # News data management
│   ├── services/                    # External services
│   │   └── firebase_service.dart   # Firebase integration
│   ├── screens/                     # UI screens
│   │   └── splash_screen.dart      # App splash screen
│   ├── utils/                       # Utilities
│   │   ├── app_routes.dart         # Navigation routes
│   │   └── app_theme.dart          # App theming
│   └── widgets/                     # Reusable components
├── assets/                          # Static assets
│   ├── images/                      # App images
│   ├── icons/                       # App icons
│   ├── videos/                      # Video content
│   └── fonts/                       # Custom fonts
├── pubspec.yaml                     # Dependencies
└── README.md                        # This file
```

## 🔧 Technology Stack

### Frontend
- **Framework**: Flutter 3.0+
- **Language**: Dart
- **State Management**: Provider pattern
- **UI**: Material Design 3
- **Video Playback**: video_player, chewie
- **Image Handling**: cached_network_image

### Backend & Services
- **Database**: Firebase Firestore (same as web)
- **Authentication**: Firebase Auth
- **Storage**: Firebase Storage (same as web)
- **Messaging**: Firebase Messaging
- **Cloud Functions**: Firebase Functions

### Key Features

#### User Features
- **News Consumption**: Browse news by category and location
- **Live Streaming**: Watch live TV channels with video player
- **User Authentication**: Email/password login with Firebase Auth
- **User Profiles**: Personalized preferences and settings
- **Push Notifications**: Breaking news notifications
- **Offline Support**: Cached content for offline reading
- **Search**: Full-text search across news articles
- **Categories**: Regional, National, Sports, Entertainment

#### Live Streaming
- **HLS Support**: Video streaming with HLS.js compatibility
- **Multiple Channels**: Various news and entertainment channels
- **Player Controls**: Play/pause, volume, quality controls
- **Live Status**: Real-time viewer count and status

#### User Experience
- **Dark/Light Mode**: System and manual theme switching
- **Multi-language**: Hindi and English localization
- **Responsive**: Optimized for all screen sizes
- **Smooth Navigation**: Animated transitions and interactions

## 🚀 Development Setup

### Prerequisites
1. **Flutter SDK** (v3.0 or higher)
   ```bash
   flutter doctor
   ```

2. **Firebase CLI**
   ```bash
   npm install -g firebase-tools
   ```

3. **Firebase Project**
   - Uses the same Firebase project as the web platform: `bharatott-3479f`
   - Ensure Firestore, Auth, Storage, and Messaging are enabled

### Installation & Setup

1. **Clone and Setup**
   ```bash
   cd samachar-plus-ott-app
   flutter pub get
   ```

2. **Firebase Configuration**
   - The `firebase_options.dart` file is pre-configured
   - Update API keys if using a different Firebase project

3. **Platform-Specific Setup**
   
   **iOS:**
   ```bash
   cd ios
   pod install
   cd ..
   flutter run
   ```
   
   **Android:**
   ```bash
   flutter run
   ```

### Development Commands

```bash
# Run the app
flutter run

# Build for Android
flutter build apk

# Build for iOS
flutter build ios

# Analyze code
flutter analyze

# Run tests
flutter test

# Format code
flutter format .
```

## 📱 Application Flow

### Authentication Flow
1. **Splash Screen** → Check authentication status
2. **Auth Screen** → Login/Signup if not authenticated
3. **Home Screen** → Main news feed if authenticated

### News Consumption
1. **Home Feed** → Latest news articles
2. **Categories** → Filter by news categories
3. **Live TV** → Live streaming channels
4. **Search** → Find specific articles
5. **Profile** → User settings and preferences

### State Management
- **AuthProvider**: Manages user authentication state
- **NewsProvider**: Handles news data, filtering, and search
- **Real-time Updates**: Firestore listeners for live data

## 🔄 Integration with Web Platform

### Shared Backend
- **Firestore**: Same collections and document structure
- **Storage**: Shared image and video assets
- **Auth**: Unified user authentication
- **Functions**: Same cloud functions for API endpoints

### Data Synchronization
- **Real-time Updates**: News articles appear simultaneously on web and mobile
- **User Profiles**: Shared user preferences and settings
- **Notifications**: Cross-platform notification delivery

## 🎨 Design System

### Theme
- **Primary Color**: Blue (#1E3A8A) - News authority
- **Secondary Color**: Green (#10B981) - Live content
- **Accent Color**: Orange (#F59E0B) - Breaking news

### Components
- **NewsCard**: Reusable news article display
- **VideoPlayer**: Live streaming player
- **CategoryFilter**: News category navigation
- **BottomNavigation**: Main app navigation

## 📊 Performance

### Optimizations
- **Image Caching**: CachedNetworkImage for fast loading
- **Lazy Loading**: Pagination for large datasets
- **State Management**: Efficient Provider pattern
- **Memory Management**: Proper widget disposal

### Build Optimization
- **Tree Shaking**: Remove unused code
- **Asset Optimization**: Compressed images and videos
- **Code Splitting**: Separate features into modules

## 🚀 Deployment

### Firebase App Distribution
```bash
# Build and upload to Firebase App Distribution
flutter build apk --release
firebase appdistribution:distribute build/app/outputs/flutter-apk/app-release.apk
```

### App Store/Play Store
```bash
# Android
flutter build appbundle --release

# iOS
flutter build ipa --release
```

## 🧪 Testing

### Unit Tests
```bash
flutter test
```

### Integration Tests
```bash
flutter drive --target=test_driver/app.dart
```

## 📚 Documentation

- **API Documentation**: Available in the web platform documentation
- **Firebase Setup**: Same configuration as web platform
- **State Management**: Provider pattern documentation

## 🤝 Contributing

1. **Code Standards**: Follow Flutter style guide
2. **Testing**: Add tests for new features
3. **Documentation**: Update docs for significant changes
4. **Reviews**: All changes require code review

## 🔧 Troubleshooting

### Common Issues
1. **Firebase Configuration**: Ensure project IDs match
2. **Platform Setup**: iOS/Android specific configuration
3. **Dependencies**: Run `flutter pub get` after changes
4. **Build Errors**: Check Flutter and Dart SDK versions

### Debug Tools
- **Flutter Inspector**: Widget tree debugging
- **Firebase Console**: Database and storage management
- **Logcat/Xcode**: Platform-specific debugging

---

**Project Type**: Flutter Mobile Application  
**Backend**: Firebase (Shared with web platform)  
**Status**: Development Ready  
**Last Updated**: November 14, 2025