# Samachar Plus OTT App

A Flutter application for news and live TV streaming.

## Getting Started

### Prerequisites

- Flutter SDK (v3.38.5 or higher recommended)
- Chrome/Edge for Web debugging (optional but recommended)

### Running the Application

To run the application on the web with a stable connection, use the following command:

```bash
flutter run -d chrome --web-hostname 127.0.0.1 --web-port 4000
```

**Why this command?**
- `--web-hostname 127.0.0.1`: Bypasses potential `AppConnectionException` issues related to `localhost` resolution on some macOS environments.
- `--web-port 4000`: Ensures the app runs on a fixed port (http://127.0.0.1:4000) for consistent testing and configuration.

### Troubleshooting

- **SocketException or Connection Refused**: Run `flutter clean && flutter pub get` and try again.
- **Breaking Changes**: Check `pubspec.yaml` updates if you encounter package errors.