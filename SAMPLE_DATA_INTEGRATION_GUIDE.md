# Sample Data Integration Guide

## Overview
The StudyCompanion app now includes built-in sample data generators that provide realistic test data without requiring a fully configured Firebase project. This enables rapid testing and demonstration of the Student Module's all 5 use cases.

## Architecture

### Sample Data Services
Two new services provide sample data generation:

1. **SampleAnnouncementData** (`lib/services/sample_announcement_data.dart`)
   - Generates 8 realistic school announcements
   - Malaysian school context (Cikgu titles, Form structure)
   - Covers: Sports Day, Exams, Parent-Teacher Meeting, Lab Equipment, Clubs, Competitions, Library Hours

2. **SampleNotificationData** (`lib/services/sample_notification_data.dart`)
   - Generates 10 student notifications + 5 parent notifications
   - 4 notification types: Task (orange), Achievement (green), Announcement (blue), Alert (red)
   - Covers: Task reminders, achievements, announcements, alerts

### Integration with Services
The main services fallback to sample data in two scenarios:

**AnnouncementService** (`lib/services/announcement_service.dart`)
```dart
// Uses sample data by default for testing
static bool useSampleData = true;

// Methods now fallback to sample data on Firestore errors
getPublishedAnnouncements()
```

**NotificationService** (`lib/services/notification_service.dart`)
```dart
// Uses sample data by default for testing
static bool useSampleData = true;

// Methods now fallback to sample data:
getStudentNotifications(studentId)
getParentNotifications(parentId)
getRecentNotifications(userId, isStudent)
```

## Using Sample Data

### Toggle Sample Data On/Off
To enable/disable sample data across the app:

```dart
// In any service:
AnnouncementService.useSampleData = false;  // Use Firebase only
NotificationService.useSampleData = false;  // Use Firebase only

// Or use defaults (true = sample data enabled)
```

### Direct Access to Sample Data
For custom testing or UI development:

```dart
import 'package:studycompanion_app/services/sample_announcement_data.dart';
import 'package:studycompanion_app/services/sample_notification_data.dart';

// Get all sample announcements
List<AnnouncementModel> announcements = 
  SampleAnnouncementData.generateSampleAnnouncements();

// Get all student notifications
List<NotificationModel> notifications = 
  SampleNotificationData.generateSampleNotifications();

// Get recent announcements (last 5)
List<AnnouncementModel> recent = 
  SampleAnnouncementData.getRecentAnnouncements(limit: 5);

// Search announcements
List<AnnouncementModel> sports = 
  SampleAnnouncementData.searchAnnouncements('Sports');

// Get by creator
List<AnnouncementModel> byAdmin = 
  SampleAnnouncementData.getAnnouncementsByCreator('Siti Nurhaliza');

// Get notifications by type
List<NotificationModel> tasks = 
  SampleNotificationData.getNotificationsByType('task');
```

## Sample Data Content

### Sample Announcements (8 total)
1. **School Sports Day** - Feb 15, 2024
   - All students and teachers invited
   - Events: Track and field, team sports, awards ceremony

2. **Mid-Year Exam Schedule** - March 1-20, 2024
   - Form 1-3 students participating
   - Multiple subjects covered

3. **Parent-Teacher Meeting** - Feb 20, 2024
   - Parents invited to discuss student progress
   - Evening session (5:00 PM - 8:00 PM)

4. **New Science Lab Equipment** - January 2024
   - Advanced microscopes and digital probes
   - Lab orientation sessions scheduled

5. **Debate Club Registration** - January 2024
   - Open to all students
   - Register with your homeroom teacher

6. **Mathematics Competition** - March 15-17, 2024
   - Districts-level competition
   - Sign-up deadline: February 28

7. **Extended Library Hours** - February onwards
   - Now open until 6:00 PM on weekdays
   - Weekend hours available

8. **English Story Telling Competition** - February 22, 2024
   - Grades 7-9 eligible
   - Prize pool: RM 500

### Sample Notifications (15 total)

**Student Notifications (10):**
- Task Reminder: "Algebra Worksheet - Due Tomorrow"
- Task Reminder: "English Essay - Overdue!"
- Task Reminder: "History Project - Due in 3 Days"
- Achievement: "You've earned the 'Task Master' badge!"
- Achievement: "You've earned the 'Star Student' badge!"
- Announcement: "Don't forget - Sports Day is this Friday!"
- Alert: "Exam Schedule Released - Check Your Exam Dates"
- Alert: "PE Class Cancelled - New Time Tuesday"
- Task Reminder: "Chemistry Report - Due Next Week"
- Achievement: "Great Job! Check Your Progress"

**Parent Notifications (5):**
- Progress Update: "Amir has completed 3 out of 4 tasks this week"
- Achievement: "Amir has earned the 'Task Master' badge!"
- Announcement: "Parent-Teacher Meeting - February 20"
- Alert: "Amir has an overdue task: Chemistry Report"
- Progress Update: "Amir's overall progress is 75% for this month"

## Testing Workflow

### Phase 1: Verify Sample Data Loading
1. Run the app: `flutter run`
2. Navigate to StudentDashboard
3. Verify sections appear:
   - **Latest Announcements** (2 cards visible)
   - **Recent Notifications** (3 items visible)
   - Notification bell shows unread badge (if any unread)

### Phase 2: Test Announcements
1. Tap "View All Announcements" button
2. Verify 8 announcements load in list
3. Test features:
   - Scroll through list
   - Pull-to-refresh
   - Tap announcement card (should show detail modal)
   - Verify dates display correctly (Today/Yesterday/DD/MM/YYYY)

### Phase 3: Test Notifications
1. Tap notification bell icon in AppBar
2. Verify 10 student notifications load
3. Test features:
   - Scroll through list
   - Tap notification (mark as read)
   - Verify color-coded types display correctly:
     - Orange badge = Task
     - Green badge = Achievement
     - Blue badge = Announcement
     - Red badge = Alert
   - Verify unread count badge disappears after reading all

### Phase 4: Test Real-Time Updates
1. In code, add test notifications:
   ```dart
   // In student_dashboard.dart test code
   await NotificationService.sendTaskReminderNotification(
     studentId: 's1',
     taskTitle: 'Test Task',
     dueDate: 'Tomorrow',
   );
   ```
2. Verify new notification appears in real-time (if useSampleData=false)

### Phase 5: Test Firebase Integration
1. Set `useSampleData = false` in services
2. Configure real Firebase project (see FIREBASE_SETUP.md)
3. Verify real data loads from Firestore
4. Test CRUD operations (create/read/update notifications)

## Transition to Production

### When Ready to Use Real Firebase:
```dart
// In announcement_service.dart
static bool useSampleData = false;

// In notification_service.dart
static bool useSampleData = false;
```

Then ensure:
1. Firebase project is configured
2. Firestore collections exist (announcements, notifications)
3. Database rules allow read access
4. Real data exists in collections

### Graceful Degradation
If Firebase is unavailable or misconfigured, services automatically fallback to sample data:
- Users still see realistic data
- App doesn't crash
- UI remains functional
- Perfect for development/testing

## File Structure

```
lib/
├── services/
│   ├── announcement_service.dart (UPDATED - sample data fallback)
│   ├── notification_service.dart (UPDATED - sample data fallback)
│   ├── sample_announcement_data.dart (NEW)
│   └── sample_notification_data.dart (NEW)
├── viewmodels/
│   ├── announcement_viewmodel.dart
│   └── notification_viewmodel.dart
└── views/
    ├── announcements_page.dart
    └── notifications_page.dart
```

## Dependencies
- None additional! Sample data uses existing models:
  - `AnnouncementModel` (from models/announcement_model.dart)
  - `NotificationModel` (from models/notification_model.dart)

## Benefits of This Approach

✅ **No Firebase Setup Required** - Test immediately  
✅ **Realistic Malaysian School Context** - Authentic names, titles, subjects  
✅ **Covers All Scenarios** - All notification types and announcement topics  
✅ **Easy Toggle** - Switch between sample and real data with one line  
✅ **Graceful Fallback** - Always shows data, never crashes  
✅ **Developer-Friendly** - Modify sample data for custom testing  
✅ **Performance** - No network calls, instant data loading  
✅ **CI/CD Ready** - Tests can run without Firebase credentials  

## Next Steps

1. ✅ **Complete** - Sample data generators created and integrated
2. **Next** - Build and run app on Android emulator
3. **Then** - Test all 5 Student Module use cases with sample data
4. **Finally** - Integrate real Firebase when needed

---
**Last Updated:** January 2024  
**Status:** Ready for Testing
