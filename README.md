# Video Editor Pro

A professional Flutter application built with Clean Architecture principles, designed to scale for billions of users.

## 🏗️ Architecture

This project follows **Clean Architecture** principles with clear separation of concerns:

- **Presentation Layer**: UI components, BLoC state management, pages, and widgets
- **Domain Layer**: Business logic, entities, use cases, and repository interfaces
- **Data Layer**: Data sources, models, and repository implementations

## 🚀 Features

- **Authentication System**: Login, register, password reset with secure token management
- **Clean Architecture**: Scalable and maintainable code structure
- **State Management**: BLoC pattern for predictable state management
- **Dependency Injection**: Injectable for automatic dependency management
- **Network Layer**: Dio with interceptors for API communication
- **Local Storage**: SharedPreferences and Hive for data persistence
- **Error Handling**: Comprehensive error handling with custom exceptions
- **Theming**: Material 3 design with light/dark theme support
- **Internationalization**: Multi-language support ready
- **Performance Monitoring**: Firebase Analytics and Crashlytics integration
- **Security**: Encrypted storage and secure API communication

## 🎬 Video Editing Demo Walkthrough (What we implemented)

This repo now includes a minimal, working video-editing demo that showcases an end-to-end flow:

- Import a short video from the gallery
- Preview playback with play/pause and skip ±5s controls
- Scrub/seek quickly without playing through
- Split the timeline at the playhead and delete a segment
- Export a result (demo copies the source clip) with a visible progress bar
- Open the exported file in a system viewer or share to apps (WhatsApp, Email, etc.)

Primary files touched:
- `lib/features/home/presentation/pages/home_page.dart`: Import (FAB) → pick video and navigate to editor
- `lib/core/router/app_router.dart`: Added `/editor` route
- `lib/features/video_editor/presentation/pages/video_editor_page.dart`: Editor UI, timeline, split/delete, export, open/share
- `ios/Runner/Info.plist`: Photo library usage descriptions
- `pubspec.yaml`: Added `image_picker`, `video_player`, `permission_handler`, `path_provider`, `share_plus`, and `open_filex`

## ▶️ How to try the demo flow

1) Splash/Home → tap Import
2) Pick a short video (≤ 1 minute recommended)
3) Editor opens with the selected video
4) Move the playhead using the slider or tapping the timeline
5) Tap Split → select a segment → Delete to remove a portion
6) Tap Export → watch the progress → SnackBar confirms
7) Tap Open (system viewer) or Share (WhatsApp/Email/etc.)

Notes:
- Export writes a copy of the selected video to a temporary file with the correct extension for compatibility when opening/sharing.
- Timeline is a simple visual placeholder; split/delete are functional within the demo.

## 📱 Screenshots

*Coming soon...*

## 🛠️ Tech Stack

- **Framework**: Flutter 3.7.2+
- **State Management**: BLoC (flutter_bloc)
- **Dependency Injection**: Injectable + GetIt
- **Navigation**: GoRouter
- **Network**: Dio + Retrofit
- **Local Storage**: SharedPreferences + Hive
- **Code Generation**: Freezed + JSON Serializable
- **Testing**: Mockito + BLoC Test
- **Linting**: Very Good Analysis
- **CI/CD**: GitHub Actions (ready to configure)

## 📦 Dependencies

### Core Dependencies
- `flutter_bloc` - State management
- `get_it` + `injectable` - Dependency injection
- `go_router` - Navigation
- `dio` + `retrofit` - Network layer
- `shared_preferences` + `hive` - Local storage
- `freezed` + `json_annotation` - Code generation
- `equatable` - Value equality
- `dartz` - Functional programming

### Media/Device-specific
- `image_picker` - Pick video from gallery
- `video_player` - Video playback
- `permission_handler` - Runtime permissions (Android)
- `path_provider` - Temporary directory for export
- `share_plus` - Native share sheet
- `open_filex` - Open exported file in system apps

### UI/UX Dependencies
- `flutter_svg` - SVG support
- `cached_network_image` - Image caching
- `shimmer` - Loading animations
- `lottie` - Advanced animations

### Development Dependencies
- `build_runner` - Code generation
- `mockito` - Testing mocks
- `bloc_test` - BLoC testing
- `very_good_analysis` - Linting rules

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.7.2 or higher
- Dart SDK 3.0.0 or higher
- Android Studio / VS Code
- Git

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd video_editor_demo
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate code**
   ```bash
   flutter packages pub run build_runner build
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

### Firebase Setup (Optional)

1. Create a Firebase project
2. Add your `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
3. Enable Analytics and Crashlytics in Firebase Console

## 📁 Project Structure

```
lib/
├── core/                    # Core functionality
│   ├── constants/          # App constants and strings
│   ├── di/                 # Dependency injection
│   ├── errors/             # Error handling
│   ├── network/            # Network configuration
│   ├── router/             # Navigation setup
│   ├── theme/              # App theming
│   └── utils/              # Utility functions
├── features/               # Feature modules
│   ├── auth/               # Authentication feature
│   │   ├── data/           # Data layer
│   │   ├── domain/         # Domain layer
│   │   └── presentation/   # Presentation layer
│   ├── home/               # Home feature
│   ├── profile/            # Profile feature
│   ├── settings/           # Settings feature
│   └── splash/             # Splash screen
├── shared/                 # Shared components
│   ├── widgets/            # Reusable widgets
│   └── utils/              # Shared utilities
└── l10n/                   # Internationalization
```

## 🧪 Testing

### Unit Tests
```bash
flutter test
```

### Integration Tests
```bash
flutter test integration_test/
```

### Code Coverage
```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

## 🏗️ Code Generation

The project uses several code generation tools:

```bash
# Generate all code
flutter packages pub run build_runner build

# Watch for changes
flutter packages pub run build_runner watch

# Clean and rebuild
flutter packages pub run build_runner build --delete-conflicting-outputs
```

## 📱 Building for Production

### Android
```bash
flutter build apk --release
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

### Web
```bash
flutter build web --release
```

## 🔧 Configuration

### Environment Variables
Create a `.env` file in the root directory:
```
API_BASE_URL=https://api.videoeditor.com
API_VERSION=v1
```

### Build Configuration
- `android/app/build.gradle` - Android build settings
- `ios/Runner.xcodeproj` - iOS build settings
- `web/index.html` - Web configuration

## 🚀 Deployment

### Android Play Store
1. Build release APK/AAB
2. Upload to Google Play Console
3. Configure store listing
4. Submit for review

### iOS App Store
1. Build release IPA
2. Upload to App Store Connect
3. Configure app information
4. Submit for review

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Very Good Ventures for the excellent analysis package
- The open-source community for the wonderful packages

## 📞 Support

For support, email support@videoeditor.com or join our Discord community.

---

**Built with ❤️ using Flutter**

## 📲 Run on a real device (Android & iOS)

Follow these steps to run and validate the demo on physical hardware.

### Android (Device)

1. Enable Developer Options and USB debugging on your Android phone.
2. Connect via USB (or use wireless ADB) and verify the device:
   ```bash
   flutter devices
   ```
3. Ensure required Android permissions are declared (already included):
   - Image picking and storage access via `permission_handler`
4. Run the app to your device:
   ```bash
   flutter run -d <device_id>
   ```
5. Test the flow:
   - Tap Import → choose a short video from Gallery
   - Use Play/Pause and ±5s skip
   - Split at playhead and Delete a segment
   - Export → watch progress → confirmation SnackBar
   - Open or Share the exported file

Troubleshooting (Android):
- If pick/share fails, confirm the selected video is local and not DRM-protected.
- On Android 13+, runtime Media permissions may be required. If denied, enable from Settings → Apps → Permissions.

### iOS (iPhone)

1. Prerequisites: Xcode, CocoaPods, Apple Developer setup for device deployment.
2. Install pods:
   ```bash
   cd ios && pod install && cd ..
   ```
3. Open the iOS workspace and set a valid signing team:
   ```bash
   open ios/Runner.xcworkspace
   ```
   - Select the `Runner` target → Signing & Capabilities → Team = your Apple ID team.
4. Ensure photo permissions are present (already configured in `ios/Runner/Info.plist`):
   - `NSPhotoLibraryUsageDescription`
   - `NSPhotoLibraryAddUsageDescription`
5. Plug in your iPhone and trust the computer if prompted. Then run:
   ```bash
   flutter run -d <device_id>
   ```
6. Test the flow as on Android.

Troubleshooting (iOS):
- Run on a physical device for video pick/share; the Simulator has limited media libraries.
- If sharing doesn’t show apps, ensure target apps (e.g., WhatsApp, Mail) are installed on the device.
- If build errors occur after dependency changes, do a clean build:
  ```bash
  flutter clean
  cd ios && pod install && cd ..
  flutter pub get
  flutter run
  ```