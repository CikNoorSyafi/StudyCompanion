# 🎯 STUDENT MODULE - QUICK START TESTING

## 🚀 APP IS LAUNCHING NOW!

**Status**: APK installed and launching on Android emulator  
**ETA**: App should appear in 10-30 seconds  
**Build**: Success ✅

---

## 🔑 LOGIN CREDENTIALS

```
Email:    amir.abdullah@studentapp.local
Password: password123
Role:     Student
Name:     Amir Abdullah
ID:       s1
```

---

## 📋 THE 5 USE CASES TO TEST

### 1️⃣ **LOGIN**
```
Tap email field → Enter amir.abdullah@studentapp.local
Tap password field → Enter password123
Tap Masuk/Login button
✅ Should see StudentDashboard with "Hi, Amir"
```

### 2️⃣ **VIEW TASKS**
```
Scroll down to "Assigned Tasks" section
✅ Should see 4 items:
  • Mathematics - Basic Algebra (Cikgu Ahmad)
  • English - Essay Writing (Cikgu Suhana)
  • Science - Lab Report (Cikgu Ravi)
  • History - Research Project (Cikgu Mei Ling)
✅ Progress shows "0/4"
```

### 3️⃣ **MARK COMPLETE**
```
Tap 1st checkbox → Progress becomes "1/4" ✅
Tap 2nd checkbox → Progress becomes "2/4" ✅
Tap 3rd checkbox → Progress becomes "3/4" ✅
Tap 4th checkbox → Progress becomes "4/4" ✅
Tap 1st checkbox again → Progress becomes "3/4" ✅
(Real-time updates - no page reload needed)
```

### 4️⃣ **VIEW ANNOUNCEMENTS**
```
Tap "View All Announcements" button
✅ Should see 8 announcements:
  1. School Sports Day (Feb 15)
  2. Mid-Year Exam Schedule (Mar 1-20)
  3. Parent-Teacher Meeting (Feb 20)
  4. New Science Lab Equipment (Jan)
  5. Debate Club Registration (Jan)
  6. Mathematics Competition (Mar 15-17)
  7. Extended Library Hours (Feb+)
  8. English Story Telling (Feb 22)
✅ Tap announcement → Full details appear
✅ Tap outside modal → Close and return to list
```

### 5️⃣ **RECEIVE NOTIFICATIONS**
```
Tap notification bell icon (top-right, red badge)
✅ Should see 10 notifications:
  - 🟠 3 Task reminders (orange badges)
  - 🟢 2 Achievements (green badges)
  - 🔵 1 Announcement (blue badge)
  - 🔴 4 Alerts (red badges)
✅ Unread badge on bell disappears when all read
```

---

## ⚡ QUICK VERIFICATION

### Dashboard Should Show (Top to Bottom):
- [ ] AppBar with app title
- [ ] Notification bell icon with unread count
- [ ] "Hi, Amir" greeting
- [ ] Overall Academic Progress card
- [ ] Upcoming Reminders carousel
- [ ] Latest Announcements (2 cards)
- [ ] Recent Notifications (3 items)
- [ ] Assigned Tasks (4 checkboxes + progress)

### Sample Data Status:
- [ ] 8 Announcements ✅
- [ ] 10 Student Notifications ✅
- [ ] 5 Parent Notifications ✅
- [ ] 4 Sample Tasks ✅
- [ ] All Notification Types ✅

---

## 🎯 PASS/FAIL CRITERIA

### ✅ PASS If:
- App launches without crashes
- Login works with provided credentials
- All 8 announcements visible
- All 10 notifications visible
- All 4 tasks toggle correctly
- Progress updates in real-time
- No red error screens

### ❌ FAIL If:
- App crashes on startup
- Login doesn't work
- Missing announcements/notifications
- Tasks don't toggle
- Progress doesn't update
- Red error screens appear
- Data doesn't load

---

## 🔍 EXPECTED DATA

### Announcements (8 Total)
| # | Title | Date | Created By |
|---|-------|------|-----------|
| 1 | School Sports Day | Feb 15 | Siti Nurhaliza |
| 2 | Mid-Year Exam | Mar 1-20 | Siti Nurhaliza |
| 3 | Parent-Teacher Meeting | Feb 20 | Siti Nurhaliza |
| 4 | Lab Equipment | Jan | Siti Nurhaliza |
| 5 | Debate Club | Jan | Siti Nurhaliza |
| 6 | Math Competition | Mar 15-17 | Siti Nurhaliza |
| 7 | Library Hours | Feb+ | Siti Nurhaliza |
| 8 | Story Telling | Feb 22 | Siti Nurhaliza |

### Notifications (10 Student + 5 Parent)
| Type | Color | Count | Examples |
|------|-------|-------|----------|
| Task | 🟠 Orange | 3 | Reminders for work |
| Achievement | 🟢 Green | 2 | Badges earned |
| Announcement | 🔵 Blue | 1 | Important news |
| Alert | 🔴 Red | 4 | Warnings/updates |

### Tasks (4 Total)
| Subject | Task | Teacher |
|---------|------|---------|
| Mathematics | Basic Algebra | Cikgu Ahmad |
| English | Essay Writing | Cikgu Suhana |
| Science | Lab Report | Cikgu Ravi |
| History | Research Project | Cikgu Mei Ling |

---

## 🐛 COMMON ISSUES

| Problem | Solution |
|---------|----------|
| App is blank | Wait 20 seconds for emulator to fully boot |
| "File not found" error | Gradle/Flutter compilation issue - wait |
| Login fails | Double-check email spelling, try again |
| No data appears | Check internet connection or wait for fallback |
| Screen frozen | Close and reopen app via `r` key (hot reload) |

---

## ⌨️ USEFUL FLUTTER COMMANDS

While testing in terminal:
```
r          → Hot reload (refresh without restart)
R          → Full restart
q          → Quit app
d          → Detach from process
w          → Toggle widget inspector
```

---

## 📞 NEED HELP?

| Question | Answer |
|----------|--------|
| Where's the app? | On emulator - check if it appears in ~30 seconds |
| Won't login? | Try: `amir.abdullah@studentapp.local` / `password123` |
| No announcements? | Sample data loads automatically from `sample_announcement_data.dart` |
| App crashed? | Check terminal for error, restart with `flutter run` |
| Want to see logs? | Run `flutter logs` in another terminal |

---

## ✅ SIGN-OFF CHECKLIST

- [ ] App launched successfully
- [ ] Logged in with provided credentials
- [ ] All 5 use cases work
- [ ] Dashboard displays correctly
- [ ] Sample data loads (8 announcements, 10 notifications)
- [ ] Real-time updates work
- [ ] No crashes or errors
- [ ] UI is responsive

**Overall Status**: [ ] ✅ PASS [ ] ⚠️ NEEDS FIX [ ] ❌ FAIL

---

## 🎉 YOU'RE READY!

**The app is built and installing right now.**

1. ✅ Emulator launched
2. ✅ APK built successfully
3. ✅ APK installing...
4. ⏳ App will launch momentarily
5. 🎯 Follow the 5 use cases above

**Expected to see the app in 10-30 seconds!**

---

Last Updated: February 5, 2026  
Status: ✅ Ready to Test
