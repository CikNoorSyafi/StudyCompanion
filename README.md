# StudyCompanion

AsalBoleh - StudyCompanion+ is a mobile application developed to improve communication and task management within schools. The app helps students keep track of their homework and deadlines, allows teachers to share announcements easily, and gives parents better visibility of their child's progress.
 
 ## Firebase setup

 Follow these steps to configure Firebase for this project (Android, iOS, Web):

 1) Create a Firebase project
 - Go to https://console.firebase.google.com and create a new project (or use the team's project).
 - Note the Android package name (applicationId) and iOS bundle id used by this app.

 2) Add Android
 - In Firebase Console → Project settings → Add Android app:
	 - Package name: use the app's package id (see `android/app/src/main/AndroidManifest.xml` or Gradle config).
	 - (Optional) Add SHA-1 if you use Google Sign-In.
 - Download `google-services.json` and place it at `android/app/google-services.json`.
 - Gradle plugin: ensure `com.google.gms:google-services` is applied in project/app Gradle files (already configured in this repo).

 3) Add iOS
 - In Firebase Console → Add iOS app with the bundle id.
 - Download `GoogleService-Info.plist` and add it to `ios/Runner/` (or macOS target if applicable).
 - In Xcode, ensure the plist is included in the Runner target.

 4) Add Web (if using web)
 - In Firebase Console → Add Web app → copy config and add to `web/index.html` or use the FlutterFire CLI to configure.

 5) Generate `firebase_options.dart` (recommended)
 - Install FlutterFire CLI (one-time):
 ```bash
 dart pub global activate flutterfire_cli
 ```
 - From the project root, run:
 ```bash
 flutterfire configure --project <FIREBASE_PROJECT_ID> --out=lib/firebase_options.dart
 ```
 - This creates/updates `lib/firebase_options.dart` used by the app.

 6) Initialize Firebase in the app
 - Ensure `main.dart` calls:
 ```dart
 WidgetsFlutterBinding.ensureInitialized();
 await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
 ```
 - The project already includes `lib/firebase_options.dart`; verify initialization is present.

 7) Security & CI notes
 - Avoid committing service account JSONs or private keys.
 - `google-services.json` and `GoogleService-Info.plist` are commonly committed for convenience in team projects, but you may store them securely and add to `.gitignore` if preferred.
 - For CI, provide Firebase config via environment variables or secure artifacts.

 8) Troubleshooting
 - Android: add SHA-1 for auth, run `flutter clean` on build errors.
 - iOS: run `pod install` in `ios/` after changing pods: `cd ios && pod install`.
 - Regenerate `firebase_options.dart` when platforms or Firebase config change.

