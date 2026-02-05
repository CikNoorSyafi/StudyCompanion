# 🧪 Complete Testing Guide - Student Module with Sample Data

## 📋 Pre-Test Checklist

Before running the app, verify:
- [ ] Android emulator is available (or physical device connected)
- [ ] Flutter SDK is installed and updated
- [ ] Project dependencies installed (`flutter pub get`)
- [ ] Project compiles without errors (`flutter analyze`)
- [ ] You have this guide open for reference

## 🚀 Phase 1: Launch & Basic Verification

### Step 1.1: Start the App
```bash
cd e:\Github\StudyCompanion
flutter run
```

**Expected Output:**
```
✓ Built build\app\outputs\flutter-apk\app-debug.apk
✓ Installing and launching...
✓ App launched successfully
```

### Step 1.2: Verify App Startup
- [ ] App launches without crashes
- [ ] No red error screens
- [ ] Login page displays with email/password fields
- [ ] "Masuk / Login" button is visible

### Step 1.3: Verify Console Output
In another terminal, check logs:
```bash
flutter logs
```

Should see similar messages:
```
✓ FCM Token: <some_token>
✓ Firebase Messaging initialized successfully
✓ Announcements loaded: 8 total
✓ Notifications loaded: 10 total
```

## 🔐 Phase 2: Authentication Testing

### Step 2.1: Login with Sample Account
**User:** Amir Abdullah  
**Email:** amir.abdullah@studentapp.local  
**Password:** password123

### Step 2.2: Verify StudentDashboard Loads
After successful login, check:
- [ ] App displays StudentDashboard (not error screen)
- [ ] Greeting shows "Hi, Amir" or similar
- [ ] No red error indicators
- [ ] All UI sections visible

**Dashboard Sections (Top to Bottom):**
1. AppBar with notification bell icon
2. "Overall Academic Progress" card
3. "Upcoming Reminders" carousel
4. "Latest Announcements" section (2 cards)
5. "Recent Notifications" section (3 items)
6. "Assigned Tasks" section (4 checkboxes)

## 📢 Phase 3: Announcements Testing

### Step 3.1: Dashboard Announcement Preview
- [ ] "Latest Announcements" section shows 2 announcement cards
- [ ] Each card displays: title, preview text, date, published badge
- [ ] Cards are tappable (color changes on touch)

**Visible Cards Should Be:**
- "School Sports Day - Feb 15"
- "Mid-Year Exam Schedule - Mar 1-20"

### Step 3.2: Navigate to Full Announcements
- [ ] Tap "View All Announcements" button (or "Latest Announcements" section)
- [ ] AnnouncementsPage loads
- [ ] Page title shows "Announcements"
- [ ] Loading spinner appears briefly then disappears

### Step 3.3: Verify All Announcements Load
Should see 8 announcement cards in list:
1. School Sports Day
2. Mid-Year Exam Schedule
3. Parent-Teacher Meeting
4. New Science Lab Equipment
5. Debate Club Registration
6. Mathematics Competition
7. Extended Library Hours
8. English Story Telling Competition

- [ ] All 8 announcements visible by scrolling
- [ ] Each card shows: title, preview (3 lines), date, "Published" badge
- [ ] Cards are sorted by date (newest first)

### Step 3.4: Test Announcement Details
- [ ] Tap any announcement card
- [ ] Modal dialog opens showing full announcement
- [ ] Dialog displays:
  - Full title
  - Full message/content
  - Creation date
  - Created by (Cikgu name or Admin)
  - Published status
- [ ] Tap outside modal to close
- [ ] Modal closes and returns to list

### Step 3.5: Test Pull-to-Refresh
- [ ] Scroll to top of announcement list
- [ ] Drag down to trigger refresh (pull-to-refresh indicator)
- [ ] Announcements reload (same 8 items)
- [ ] Refresh completes and indicator disappears

### Step 3.6: Test Date Formatting
- [ ] Today's announcements show "Today" (if any)
- [ ] Yesterday's announcements show "Yesterday" (if any)
- [ ] Older announcements show "DD/MM/YYYY" format
- [ ] All dates are readable and properly formatted

**Checkpoint:** ✅ All 8 announcements load, display, and interact correctly

## 🔔 Phase 4: Notifications Testing

### Step 4.1: Dashboard Notification Preview
Return to StudentDashboard:
- [ ] Notification bell icon visible in AppBar (top right)
- [ ] Red badge on bell shows unread count (if > 0)
- [ ] "Recent Notifications" section shows 3 items
- [ ] Each notification shows:
  - Type icon (orange/green/blue/red circle)
  - Title and message preview
  - Date (relative: "5 minutes ago", "Today", etc.)
  - Unread indicator (if unread)

### Step 4.2: Navigate to Full Notifications
- [ ] Tap notification bell icon OR "View All Notifications" button
- [ ] NotificationsPage loads
- [ ] Page title shows "Notifications"
- [ ] Unread badge count displays (if > 0)

### Step 4.3: Verify Notification Types
Should see all 4 types with correct colors:

| Type | Color | Icon | Count | Examples |
|------|-------|------|-------|----------|
| Task | 🟠 Orange | 📋 | 3 | Algebra reminder, English essay |
| Achievement | 🟢 Green | 🏆 | 2 | Task Master, Star Student |
| Announcement | 🔵 Blue | 📢 | 1 | Sports Day announcement |
| Alert | 🔴 Red | ⚠️ | 4 | Exam schedule, PE cancelled, overdue |

- [ ] All 10 notifications visible by scrolling
- [ ] Each type has distinctive color badge
- [ ] Icons match type correctly

### Step 4.4: Test Mark as Read
- [ ] Tap any unread notification (appears lighter/faded)
- [ ] Notification card refreshes
- [ ] Unread indicator disappears
- [ ] Unread count badge decreases by 1 (if it was > 0)
- [ ] Repeat for multiple notifications

### Step 4.5: Test Pull-to-Refresh
- [ ] Scroll to top of notifications
- [ ] Drag down to trigger refresh
- [ ] Notifications reload
- [ ] Unread count updates correctly

### Step 4.6: Test Notification Details
Some notifications might have additional details:
- [ ] Tap notification card to expand or view details
- [ ] Details display correctly
- [ ] Can tap again to collapse

**Checkpoint:** ✅ All 10 notifications load with correct types, colors, and interactions

## ✅ Phase 5: Task Completion Testing

### Step 5.1: View Assigned Tasks
Return to StudentDashboard:
- [ ] "Assigned Tasks" section displays (bottom of dashboard)
- [ ] 4 task checkboxes visible:
  1. Mathematics - Basic Algebra (Cikgu Ahmad)
  2. English - Essay Writing (Cikgu Suhana)
  3. Science - Lab Report (Cikgu Ravi)
  4. History - Research Project (Cikgu Mei Ling)

### Step 5.2: Mark Task as Complete
- [ ] All 4 checkboxes are unchecked initially
- [ ] Progress shows "0/4"
- [ ] Tap first checkbox
- [ ] Checkbox becomes checked (✓)
- [ ] Progress updates to "1/4"
- [ ] Tap second checkbox
- [ ] Progress updates to "2/4"
- [ ] Repeat until all 4 are checked
- [ ] Progress shows "4/4" (all complete)

### Step 5.3: Uncheck Task
- [ ] Tap a checked checkbox
- [ ] Checkbox becomes unchecked
- [ ] Progress decreases (e.g., "3/4")
- [ ] Can toggle multiple times

### Step 5.4: Verify Progress Bar
- [ ] Progress bar width corresponds to completion percentage
- [ ] Progress bar color changes as you complete tasks:
  - 0% = Red
  - 25% = Orange  
  - 50% = Yellow
  - 75% = Light Green
  - 100% = Dark Green

**Checkpoint:** ✅ Tasks toggle correctly and progress updates in real-time

## 🔄 Phase 6: Real-Time Updates Testing

### Step 6.1: Verify Updates Don't Require Refresh
- [ ] While on StudentDashboard, task completion updates immediately
- [ ] Checking a task shows progress change without page reload
- [ ] No need to pull-to-refresh or navigate away/back

### Step 6.2: Verify Dashboard Updates
- [ ] Unread notification badge updates when marks are read
- [ ] Latest announcements reflect new data if available
- [ ] No UI freezing or lag during updates

**Checkpoint:** ✅ Real-time updates work smoothly without manual refresh

## 🎯 Phase 7: Navigation Testing

### Step 7.1: Test Navigation Between Pages
- [ ] From StudentDashboard → Tap "View All Announcements" → Navigate to AnnouncementsPage
- [ ] From AnnouncementsPage → Tap back button → Return to StudentDashboard
- [ ] From StudentDashboard → Tap notification bell → Navigate to NotificationsPage
- [ ] From NotificationsPage → Tap back button → Return to StudentDashboard

### Step 7.2: Test Back Button Behavior
- [ ] Back button works from any page
- [ ] No navigation errors or blank screens
- [ ] Previous state is preserved (scroll position, selections)

**Checkpoint:** ✅ Navigation is smooth and back button works correctly

## 📊 Phase 8: Data Consistency Testing

### Step 8.1: Verify Sample Data Consistency
- [ ] Close app and reopen it
- [ ] Login again as Amir
- [ ] Same 8 announcements appear (exactly same data)
- [ ] Same 10 notifications appear (exactly same data)
- [ ] Same 4 tasks appear

### Step 8.2: Verify Data Types
- [ ] All notifications have proper types (task/achievement/announcement/alert)
- [ ] All announcements have proper published status
- [ ] All dates are reasonable (not in future, not too old)
- [ ] All titles and messages display correctly (no corruption)

**Checkpoint:** ✅ Data is consistent and properly typed

## 🐛 Phase 9: Error Handling Testing

### Step 9.1: Network Error Simulation
If possible, simulate network issues:
- [ ] Turn off WiFi/mobile data
- [ ] Try to refresh announcements (if using real Firebase)
- [ ] App falls back to sample data (doesn't crash)
- [ ] Error message displays clearly (if configured)

### Step 9.2: App State Testing
- [ ] Lock and unlock device
- [ ] Switch apps and return
- [ ] Rotate screen (landscape ↔ portrait)
- [ ] App doesn't crash in any scenario
- [ ] UI adapts to screen rotation

**Checkpoint:** ✅ App handles errors gracefully

## 📱 Phase 10: UI/UX Polish Testing

### Step 10.1: Visual Polish
- [ ] All text is readable (proper contrast)
- [ ] All buttons are tappable and responsive
- [ ] All images/icons display correctly
- [ ] No layout overflow or cutoff text
- [ ] Colors are consistent across app

### Step 10.2: Animation & Transitions
- [ ] Page transitions are smooth
- [ ] No jarring animation glitches
- [ ] Loading spinners animate smoothly
- [ ] Pull-to-refresh animation is clear

### Step 10.3: Touch Responsiveness
- [ ] All buttons have visual feedback (ripple/highlight)
- [ ] Taps register immediately (no lag)
- [ ] Double-tap doesn't cause issues
- [ ] Long-press doesn't cause issues

**Checkpoint:** ✅ UI is polished and responsive

## ✨ Phase 11: Complete Use Case Testing

### Test All 5 Student Use Cases in Sequence

#### Use Case 1: Login ✅
```
Student opens app
↓
StudentDashboard loads (proves authentication worked)
✓ Verified: User can login with Firebase Auth
```

#### Use Case 2: View Tasks ✅
```
Student views StudentDashboard
↓
"Assigned Tasks" section shows 4 tasks with Cikgu names
↓
Student taps task (if detail view exists)
✓ Verified: User can view assigned tasks with details
```

#### Use Case 3: Mark Task Complete ✅
```
Student sees 4 unchecked task checkboxes
↓
Student taps checkbox
↓
Checkbox becomes checked, progress updates
✓ Verified: User can mark task as complete with real-time progress
```

#### Use Case 4: View Announcements ✅
```
Student taps "View All Announcements"
↓
AnnouncementsPage loads 8 announcements
↓
Student taps announcement card
↓
Detail modal shows full announcement
✓ Verified: User can view all announcements with details
```

#### Use Case 5: Receive Notifications ✅
```
Student taps notification bell
↓
NotificationsPage loads 10 notifications
↓
Student taps notification to mark as read
↓
Unread count updates
✓ Verified: User can receive and manage notifications
```

**Checkpoint:** ✅ ALL 5 USE CASES WORKING

## 📝 Test Report Template

Use this to document your testing:

```
TEST REPORT - Student Module
Date: ___________
Tester: ___________

Phase 1 - Launch & Basic: [ ] PASS [ ] FAIL
Phase 2 - Authentication: [ ] PASS [ ] FAIL
Phase 3 - Announcements: [ ] PASS [ ] FAIL
Phase 4 - Notifications: [ ] PASS [ ] FAIL
Phase 5 - Tasks: [ ] PASS [ ] FAIL
Phase 6 - Real-Time: [ ] PASS [ ] FAIL
Phase 7 - Navigation: [ ] PASS [ ] FAIL
Phase 8 - Data Consistency: [ ] PASS [ ] FAIL
Phase 9 - Error Handling: [ ] PASS [ ] FAIL
Phase 10 - UI/UX: [ ] PASS [ ] FAIL
Phase 11 - Use Cases: [ ] PASS [ ] FAIL

Overall: [ ] ALL TESTS PASS [ ] NEEDS FIXES

Issues Found:
- Issue 1: ___________
- Issue 2: ___________

Next Steps:
___________
```

## 🎯 Success Criteria

**All tests PASS if:**
✅ App launches without crashes  
✅ All 8 announcements load and display  
✅ All 10 notifications load and display  
✅ All 4 task checkboxes work correctly  
✅ Progress bar updates in real-time  
✅ Unread badges update correctly  
✅ Navigation works smoothly  
✅ No errors in console logs  
✅ All 5 use cases functional  
✅ UI is responsive and polished  

## 🚨 Common Issues & Solutions

| Issue | Solution |
|-------|----------|
| App crashes on startup | Check `flutter logs` for errors |
| Announcements don't load | Verify `useSampleData = true` in service |
| Notifications empty | Check NotificationViewModel initialization |
| Progress doesn't update | Verify ChangeNotifier is being called |
| Dates look wrong | Check system date on device/emulator |
| Unread badge stuck | Verify mark-as-read is working |
| UI freezes | Check for long-running operations blocking UI |
| Back button doesn't work | Verify navigation stack is correct |

## 📞 Debugging Commands

```bash
# View logs in real-time
flutter logs

# Check available devices
flutter devices

# Run with verbose output
flutter run -v

# Force rebuild
flutter clean && flutter pub get && flutter run

# Analyze code
flutter analyze

# Check for warnings
dart analyze lib/
```

## 📞 Need Help?

1. Check `QUICK_TEST_REFERENCE.md` for quick answers
2. Check `SAMPLE_DATA_INTEGRATION_GUIDE.md` for integration details
3. Review console output in `flutter logs`
4. Check sample data files for expected content:
   - `lib/services/sample_announcement_data.dart`
   - `lib/services/sample_notification_data.dart`

---

## ✅ Final Checklist

Before declaring testing complete:

- [ ] Completed all 11 phases
- [ ] All 5 use cases verified working
- [ ] Test report filled out
- [ ] No blocking issues found
- [ ] App is stable and responsive
- [ ] Ready for next development phase

**Testing Status:** Ready to Begin! 🚀

---
**Last Updated:** January 2024  
**Framework:** Flutter 3.9.2  
**Test Data:** Malaysian School Context  
**Target User:** Student (Amir Abdullah, s1)
