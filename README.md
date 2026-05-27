# Remind Me Later - Flutter Port

This is the cross-platform Flutter port of the **Remind Me Later** app, ready to be built and run on iOS and Android.

## Setup Instructions

1. **Install Flutter:**
   Ensure you have the Flutter SDK installed on your system. If not, follow the guide on [flutter.dev](https://docs.flutter.dev/get-started/install).

2. **Generate Native Configurations:**
   Open a terminal, navigate to this directory, and run the following command to generate the platform-specific files (for iOS, Android, etc.):
   ```bash
   flutter create --org com.impactdevelopment .
   ```
   *Note: This will safely generate the `ios/`, `android/`, and other configuration folders without overwriting your `lib/` code and `pubspec.yaml`.*

3. **Install Dependencies:**
   Run:
   ```bash
   flutter pub get
   ```

4. **Verify and Run:**
   - For iOS (on macOS with Xcode installed):
     ```bash
     flutter run -d ios
     ```
   - For Android:
     ```bash
     flutter run -d android
     ```

## Project Architecture

- **`lib/main.dart`**: Entry point orchestrating terms agreement, comfort hour onboarding, tab navigation, and foreground alarm rendering.
- **`lib/models/`**:
  - `reminder.dart`: Data structures and serialization.
  - `timeframe.dart`: Definitions of Dump categories.
- **`lib/database/database_helper.dart`**: SQLite CRUD logic using `sqflite`.
- **`lib/services/`**:
  - `settings_service.dart`: User preferences via `shared_preferences`.
  - `notification_service.dart`: Timezone-aware local notification scheduling and snooze/done action callback handlers.
- **`lib/providers/reminder_provider.dart`**: State manager implementing change notifications.
- **`lib/ui/`**:
  - `theme/`: Layout styling matching the light/dark palette of the original Compose app.
  - `components/`: Animated backgrounds, steppers, and timeframe select sheets.
  - `screens/`: Tab and popup views including the Alarm and Menu overlays.
