# Firebase Setup Guide for StudyCompanion

## 🚀 Firebase Configuration Steps

### Step 1: Create Firebase Project
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Create a project"
3. Name it: `StudyCompanion` (or your preferred name)
4. Enable Google Analytics (optional)
5. Create project

### Step 2: Add Android App to Firebase
1. In Firebase Console, click "Add app" → Android
2. Package name: `com.example.studycompanion_app`
3. SHA-1 fingerprint: Run `flutter pub global activate flutterfire_cli` then `flutterfire configure`
4. Download `google-services.json`
5. Place in `android/app/` directory

### Step 3: Configure FlutterFire
```bash
# Install FlutterFire CLI
flutter pub global activate flutterfire_cli

# Run configuration (from project root)
flutterfire configure

# Select Firebase project when prompted
# This will automatically update google-services.json and firebase_options.dart
```

### Step 4: Update firebase_options.dart
The `lib/firebase_options.dart` file was auto-generated. Replace the demo keys with your actual Firebase config from Firebase Console:
- Project Settings → Your apps → Android
- Copy the configuration details

### Step 5: Create Firestore Collections

Go to Firebase Console → Firestore Database → Create Collection

#### Collection: `announcements`
```
Document Structure:
{
  id: (auto-generated)
  title: string
  message: string
  createdBy: string
  date: timestamp
  isPublished: boolean
}

Example:
{
  title: "Science Fair Update"
  message: "Project submission due next Friday"
  createdBy: "Admin"
  date: 2026-02-05
  isPublished: true
}
```

#### Collection: `messages`
```
Document Structure:
{
  id: (auto-generated)
  teacherName: string
  studentName: string
  lastMessage: string
  time: string
  unread: boolean
  messages: array of {
    sender: string
    text: string
    timestamp: timestamp
  }
}

Example:
{
  teacherName: "Cikgu Zainul"
  studentName: "Amir Abdullah"
  lastMessage: "Quiz tomorrow"
  time: "10:30 AM"
  unread: true
  messages: [
    {
      sender: "Teacher"
      text: "Hello parent, just updating progress."
      timestamp: 2026-02-05T10:30:00Z
    }
  ]
}
```

#### Collection: `children`
```
Document Structure:
{
  id: (auto-generated)
  parentId: string (optional, for filtering)
  name: string
  grade: string
  gpa: number
  homework: string
  quiz: string
  reminder: string
  attendance: number
  teacherRemark: string
  subjects: array (sub-collection)
}

Sub-collection: `children/{childId}/subjects`
{
  subjectName: string
  score: number
}

Example:
{
  parentId: "parent123"
  name: "Amir Abdullah"
  grade: "Form 1"
  gpa: 3.8
  homework: "Math Fractions Worksheet"
  quiz: "Science Chapter 5 • Tomorrow"
  reminder: "Bring calculator"
  attendance: 96
  teacherRemark: "Excellent performance"
}
```

## 🔐 Firebase Security Rules

Set up basic security rules in Firestore:

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Allow read for announcements
    match /announcements/{document=**} {
      allow read: if true;
      allow write: if request.auth != null;
    }
    
    // Allow read/write for messages
    match /messages/{document=**} {
      allow read, write: if request.auth != null;
    }
    
    // Allow read/write for children
    match /children/{document=**} {
      allow read, write: if request.auth != null;
    }
  }
}
```

## 📱 Testing

### Verify Firebase Connection
1. Run the app: `flutter run -d emulator-5554`
2. Check console for any Firebase initialization errors
3. If error occurs, check:
   - `firebase_options.dart` has correct credentials
   - `google-services.json` is in correct location
   - Firebase project exists and is active

### Test with Sample Data
1. Go to Firebase Console → Firestore
2. Add sample announcement:
   ```
   Collection: announcements
   {
     title: "Welcome to StudyCompanion"
     message: "Welcome to the app!"
     createdBy: "Admin"
     date: now
     isPublished: true
   }
   ```
3. Reload the app in emulator
4. Announcement should appear

## ⚠️ Common Issues

### Issue: `firebase_options.dart` not found
**Solution:** Run `flutterfire configure` to generate it

### Issue: "PERMISSION_DENIED: Missing or insufficient permissions"
**Solution:** Update Firestore security rules (see above)

### Issue: App crashes on Firebase initialization
**Solution:** Check that `google-services.json` is in `android/app/` and Firebase project is active

## 📚 Service Usage

### Get Announcements
```dart
final announcements = await AnnouncementService.getPublishedAnnouncements();
```

### Create Announcement
```dart
await AnnouncementService.createAnnouncement(
  title: "New Announcement",
  message: "This is important",
  createdBy: "Teacher Name",
);
```

### Stream Real-time Updates
```dart
AnnouncementService.streamPublishedAnnouncements().listen((announcements) {
  // Update UI with announcements
});
```

### Get Messages
```dart
final messages = await MessageService.getMessages();
```

### Add Message to Chat
```dart
await MessageService.addMessageToChat(
  'chatId123',
  ChatMessage(sender: "Parent", text: "Hello!"),
);
```

## 🔗 Useful Resources
- [Firebase Console](https://console.firebase.google.com/)
- [FlutterFire Documentation](https://firebase.flutter.dev/)
- [Cloud Firestore Documentation](https://cloud.google.com/firestore/docs)
- [Firebase Security Rules](https://firebase.google.com/docs/rules)

---

**Last Updated:** February 5, 2026
**Status:** Firebase integration complete - Ready for production
