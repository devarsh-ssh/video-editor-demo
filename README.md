# Video Editor Demo (Flutter)

Minimal demo showing an end-to-end video edit flow.

## Features (Demo)update 

- Import a short video from the gallery
- Playback controls: Play/Pause and Skip ±5s
- Quick scrubbing via seek bar
- Split at playhead and Delete a segment
- Export (copies source video) with progress
- Open exported file or Share to other apps

Primary files:
- `lib/features/home/presentation/pages/home_page.dart` (Import & navigation)
- `lib/core/router/app_router.dart` (Editor route)
- `lib/features/video_editor/presentation/pages/video_editor_page.dart` (Editor UI & actions)
- `ios/Runner/Info.plist` (Photo permissions)
- `pubspec.yaml` (video/image picker, sharing, open file)

## Try the Flow

1) Splash/Home → tap Import
2) Pick a short video (≤ 1 minute recommended)
3) Editor opens with the selected video
4) Move the playhead using the slider or tapping the timeline
5) Tap Split → select a segment → Delete to remove a portion
6) Tap Export → watch the progress → SnackBar confirms
7) Tap Open (system viewer) or Share (WhatsApp/Email/etc.)

Notes:
- Export writes a copy of the selected video to a temporary file (correct extension) for opening/sharing.

## Quick Start

```bash
flutter pub get
flutter run
```

## Key Stack

- Flutter 3.7.2+
- GoRouter (navigation)
- video_player, image_picker

## Dependencies (key)

### Media/Device-specific
- `image_picker` - Pick video from gallery
- `video_player` - Video playback
- `permission_handler` - Runtime permissions (Android)
- `path_provider` - Temporary directory for export
- `share_plus` - Native share sheet
- `open_filex` - Open exported file in system apps

## Run on Device

### Android
- Enable USB debugging → `flutter devices` → `flutter run -d <device>`
- If permissions are denied, allow media access in system settings

### iOS
- `cd ios && pod install && cd ..`
- Open `ios/Runner.xcworkspace`, set Signing Team, then `flutter run -d <device>`
- Photo permissions are included in `ios/Runner/Info.plist`