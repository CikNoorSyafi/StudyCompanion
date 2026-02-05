# Student Module Test Guide

## ✅ All 5 Use Cases - Testing Instructions

### 1. **LOGIN** ✅
- **Location:** `lib/views/login_viewmodel.dart` (Handled by existing LoginViewModel)
- **What to test:**
  - App loads with login screen
  - Firebase Authentication is initialized
  - User can proceed to Student Dashboard

### 2. **VIEW TASKS** ✅
- **Location:** `lib/views/student_dashboard.dart` → "Assigned Tasks" section
- **What to test:**
  - [ ] Dashboard shows 4 hardcoded tasks:
    - "Algebra Worksheet" - Due Today (Mathematics)
    - "Chapter 4 Reading" - Due Tomorrow (English)
    - "Lab Report Draft" - Due Friday (Science)
    - "History Essay Outline" - Next Week (History)
  - [ ] Each task displays title, due date, and subject
  - [ ] Tasks render correctly without errors

### 3. **MARK TASK COMPLETE** ✅
- **Location:** `lib/views/student_dashboard.dart` → TaskTile widget + StudentDashboardViewModel
- **What to test:**
  - [ ] Tap checkbox next to any task
  - [ ] Checkbox changes from empty to checked
  - [ ] Task title shows strikethrough when completed
  - [ ] Progress bar updates (shows X/4 tasks completed)
  - [ ] Overall progress percentage updates
  - [ ] Multiple tasks can be marked complete
  - [ ] Uncheck task to revert completion status

### 4. **VIEW ANNOUNCEMENTS** ✅
- **Location:** `lib/views/student_dashboard.dart` → "Latest Announcements" section
- **What to test:**
  - [ ] Dashboard shows up to 2 most recent announcements
  - [ ] Each announcement shows:
    - Title
    - Message preview (truncated)
    - Creation date ("Today at HH:MM", "Yesterday", or "DD/MM/YYYY")
  - [ ] "View All Announcements" button is clickable
  - [ ] Click "View All Announcements" navigates to full announcements page
  - [ ] Full announcements page shows:
    - List of all announcements
    - Each announcement card with full details
    - Pull-to-refresh functionality
    - Click announcement to see full details in modal

### 5. **RECEIVE NOTIFICATIONS** ✅
- **Location:** `lib/views/student_dashboard.dart` → Notification icon + "Recent Notifications" section
- **What to test:**
  - [ ] Notification bell icon appears in AppBar (top right)
  - [ ] Unread notification count badge shows on bell icon
  - [ ] Dashboard shows up to 3 most recent notifications
  - [ ] Each notification shows:
    - Icon (colored based on type)
    - Title and preview message
    - Notification type badge (task, achievement, announcement, alert)
  - [ ] Tap notification bell icon or "View All Notifications" button
  - [ ] Full notifications page shows:
    - List of all notifications sorted by date (newest first)
    - Unread count indicator
    - Color-coded notification types:
      - 🟠 Task = Orange (assignment)
      - 🟢 Achievement = Green (emoji_events)
      - 🔵 Announcement = Blue (notifications_active)
      - 🔴 Alert = Red (info)
    - Pull-to-refresh functionality
    - Tap notification to mark as read (badge disappears, color fades)

---

## 📊 Notification Types

| Type | Icon | Color | Use Case |
|------|------|-------|----------|
| task | 📋 | Orange | Task due date reminders |
| achievement | 🏆 | Green | Student milestones/achievements |
| announcement | 📢 | Blue | School announcements |
| alert | ℹ️ | Red | General alerts/warnings |

---

## 🔔 Firebase Messaging Features

- **FCM Token:** Generated automatically on first app launch
- **Foreground Notifications:** Handled by `FirebaseMessaging.onMessage`
- **Background Notifications:** Handled by `_firebaseMessagingBackgroundHandler`
- **App Opened from Notification:** Handled by `FirebaseMessaging.onMessageOpenedApp`
- **Permissions:** Requested automatically on app launch (alert, sound, badge, etc.)

---

## 📍 Key Files for Testing

| Feature | Files |
|---------|-------|
| Tasks | `student_dashboard_viewmodel.dart`, `task_model.dart`, `task_tile.dart` |
| Announcements | `announcement_viewmodel.dart`, `announcements_page.dart` |
| Notifications | `notification_viewmodel.dart`, `notifications_page.dart`, `notification_service.dart` |
| Firebase | `notification_service.dart` (FCM integration) |

---

## 🧪 Manual Test Cases

### Test Case 1: Complete Student Journey
1. [ ] App launches → StudentDashboard displays
2. [ ] See 4 tasks in "Assigned Tasks" section
3. [ ] See 2 announcements in "Latest Announcements" section
4. [ ] See 3 notifications in "Recent Notifications" section
5. [ ] Mark 2 tasks as complete → Progress bar updates to 50%
6. [ ] Click "View All Announcements" → Full page with all announcements
7. [ ] Click "View All Notifications" → Full page with all notifications
8. [ ] Mark a notification as read → Badge disappears

### Test Case 2: State Management
1. [ ] Mark task complete → Checkbox changes immediately
2. [ ] Progress recalculates in real-time
3. [ ] Mark task incomplete → Checkbox unchecks
4. [ ] Progress decreases

### Test Case 3: UI/UX
1. [ ] All text readable and properly formatted
2. [ ] No overflow errors or rendering issues
3. [ ] Colors match the design (blue for announcements, colored notifications)
4. [ ] Pull-to-refresh works on announcement and notification pages
5. [ ] All buttons clickable and responsive

---

## 📝 Expected Output

### StudentDashboard Layout (Top to Bottom)
1. AppBar with greeting ("Hi, Amir") and notification bell with badge
2. Overall Academic Progress card (shows percentage and progress bar)
3. Upcoming Reminders horizontal scroll (3 reminder cards)
4. Latest Announcements (2 preview cards + "View All" button)
5. Recent Notifications (3 preview cards + "View All" button)
6. Assigned Tasks (4 task tiles with checkboxes)

---

## ⚠️ Known Limitations (For Demo)

- Tasks and announcements are hardcoded (not from Firebase yet)
- Notifications are placeholders (manually trigger for testing via Firebase Console)
- No real Firebase project needed for basic testing
- FCM tokens generated but cannot receive remote notifications without real Firebase project

---

## 🚀 Next Steps (After Testing)

1. Connect to real Firebase project (firebaseproject-config)
2. Create sample announcements in Firestore
3. Trigger test notifications via Firebase Console
4. Implement Parent Module with shared use cases
5. Add remaining modules (Teacher, Admin)

---

## 📱 Testing Device

- **Device:** Android Emulator (Medium_Phone_API_36.1)
- **Resolution:** 1080x2400
- **Android Version:** API 36
- **Hot Reload:** Available (Ctrl+S or Cmd+S)

---

**Status:** All 5 Student Use Cases Implemented and Ready for Testing ✅
