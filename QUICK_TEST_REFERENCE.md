# Quick Test Reference - Student Module Sample Data

## 🎯 What's Ready to Test

### Sample Announcements (8 total)
| # | Title | Date | Details |
|----|-------|------|---------|
| 1 | School Sports Day | Feb 15 | Track events, team sports, awards |
| 2 | Mid-Year Exam Schedule | Mar 1-20 | All subjects, Form 1-3 |
| 3 | Parent-Teacher Meeting | Feb 20 | Evening session 5-8 PM |
| 4 | New Science Lab Equipment | Jan | Microscopes, digital probes |
| 5 | Debate Club Registration | Jan | Open to all students |
| 6 | Mathematics Competition | Mar 15-17 | Districts level |
| 7 | Extended Library Hours | Feb+ | Until 6 PM weekdays |
| 8 | English Story Telling | Feb 22 | Grades 7-9, RM500 prize |

### Sample Notifications (15 total)
**Student (10):**
- 🟠 3 Task Reminders (Algebra, English, History, Chemistry)
- 🟢 2 Achievements (Task Master, Star Student)
- 🔵 1 Announcement (Sports Day)
- 🔴 2 Alerts (Exam Schedule, PE Cancelled)
- 🟠 2 Additional Tasks

**Parent (5):**
- Progress updates (completion %age)
- Child achievements
- School announcements
- Overdue task alerts

## 📱 Testing Checklist

### Student Dashboard
- [ ] App launches without errors
- [ ] Greeting shows "Hi, Amir"
- [ ] Notification bell appears in AppBar
- [ ] Academic progress card displays
- [ ] Latest Announcements section (2 cards)
- [ ] Recent Notifications section (3 items)
- [ ] Unread badge on notification bell (if unread exist)

### Announcements
- [ ] "View All Announcements" button navigates to page
- [ ] All 8 announcements load
- [ ] Cards show: Title, preview, date, published badge
- [ ] Pull-to-refresh works
- [ ] Tap card shows full details
- [ ] Dates format correctly (Today/Yesterday/DD/MM/YYYY)

### Notifications
- [ ] "View All Notifications" button navigates to page
- [ ] All 10 student notifications load
- [ ] Color-coded badges display:
  - 🟠 Orange = Task
  - 🟢 Green = Achievement
  - 🔵 Blue = Announcement
  - 🔴 Red = Alert
- [ ] Tap notification marks as read
- [ ] Unread count badge updates
- [ ] Dates display correctly

## 🔧 Key Code Locations

| Feature | File | Class/Method |
|---------|------|--------------|
| Sample Announcements | `lib/services/sample_announcement_data.dart` | `SampleAnnouncementData` |
| Sample Notifications | `lib/services/sample_notification_data.dart` | `SampleNotificationData` |
| Announcement Loading | `lib/services/announcement_service.dart` | `getPublishedAnnouncements()` |
| Notification Loading | `lib/services/notification_service.dart` | `getStudentNotifications()` |
| Sample Toggle | Both services | `static bool useSampleData` |

## 🚀 Quick Commands

**Run app:**
```bash
flutter run
```

**Run with verbose output:**
```bash
flutter run -v
```

**Hot reload (while app running):**
```
Press 'r' in terminal
```

**Full restart:**
```
Press 'R' in terminal
```

## 🔀 Toggle Sample Data

In any service file:
```dart
// Use sample data (default)
AnnouncementService.useSampleData = true;
NotificationService.useSampleData = true;

// Use Firebase only
AnnouncementService.useSampleData = false;
NotificationService.useSampleData = false;
```

## 📊 Test Data Paths

**View Sample Announcements:**
```dart
import 'package:studycompanion_app/services/sample_announcement_data.dart';

final announcements = SampleAnnouncementData.generateSampleAnnouncements();
print('Total announcements: ${announcements.length}');
```

**View Sample Notifications:**
```dart
import 'package:studycompanion_app/services/sample_notification_data.dart';

final notifications = SampleNotificationData.generateSampleNotifications();
print('Total notifications: ${notifications.length}');
```

## ✅ Success Criteria

**Pass Criteria for Student Module:**
1. ✅ App launches and displays StudentDashboard
2. ✅ 8 announcements load in AnnouncementsPage
3. ✅ 10 notifications load in NotificationsPage
4. ✅ All notification types display with correct colors
5. ✅ Unread badges update correctly
6. ✅ No crashes or errors in console
7. ✅ All 5 use cases functional:
   - ✅ Login (Firebase Auth)
   - ✅ View Tasks (4 sample tasks)
   - ✅ Mark Task Complete (checkbox toggle)
   - ✅ View Announcements (8 samples)
   - ✅ Receive Notifications (10 samples)

## 📝 Test Notes

- Sample data generates fresh instances each time (no state persistence)
- All dates are relative to current date (makes testing easier)
- Notification unread status properly tracked (mix of read/unread)
- Malaysian naming conventions used throughout
- No Firebase credentials needed for sample data

## 🐛 Common Issues & Solutions

| Issue | Solution |
|-------|----------|
| "Too many positional arguments" error | Already fixed - use latest code |
| App crashes on startup | Check logs: `flutter logs` |
| Announcements not showing | Verify `useSampleData = true` |
| Notifications empty | Check `NotificationViewModel` initialization |
| Unread badge stuck | Tap notification to mark as read |
| Dates look wrong | Check system date on emulator |

## 📞 Support

For issues:
1. Check console output: `flutter logs`
2. Review SAMPLE_DATA_INTEGRATION_GUIDE.md
3. Check STUDENT_MODULE_TEST_GUIDE.md
4. Verify no compilation errors: `flutter pub get`

---
**Ready to Test!** 🎉  
All sample data generators integrated and ready to use.
