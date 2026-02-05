# System Users & Roles Guide

This document outlines all system users and their roles in the StudyCompanion application.

## User Roles Overview

| Role | Count | Purpose |
|------|-------|---------|
| Student | 12 | Learn and track tasks |
| Teacher | 6 | Create assignments and announcements |
| Parent | 11 | Monitor child's progress |
| Admin | 2 | System administration and oversight |
| System | 1 | Automated processes and logging |

---

## Detailed User Directory

### 👨‍🎓 STUDENTS (12)

| # | Name | Form | Gender | Status | Email |
|---|------|------|--------|--------|-------|
| 1 | Amir Abdullah | Form 1 | Boy | Active | amir.abdullah@school.edu.my |
| 2 | Muhammad Azhar | Form 1 | Boy | Active | azhar.muhammad@school.edu.my |
| 3 | Nur Azlina | Form 1 | Girl | Active | nur.azlina@school.edu.my |
| 4 | Siti Mariah | Form 1 | Girl | Active | siti.mariah@school.edu.my |
| 5 | Lim Wei Chen | Form 2 | Boy | Active | lim.weichen@school.edu.my |
| 6 | Raj Kumar | Form 2 | Boy | Active | raj.kumar@school.edu.my |
| 7 | Sophia Wong | Form 2 | Girl | Active | sophia.wong@school.edu.my |
| 8 | Priya Sharma | Form 2 | Girl | Active | priya.sharma@school.edu.my |
| 9 | Adnan Hassan | Form 3 | Boy | Active | adnan.hassan@school.edu.my |
| 10 | Tan Jun Wei | Form 3 | Boy | Active | tan.junwei@school.edu.my |
| 11 | Nurul Izzah | Form 3 | Girl | Active | nurul.izzah@school.edu.my |
| 12 | Davina Ooi | Form 3 | Girl | Active | davina.ooi@school.edu.my |

**Responsibilities:**
- View assigned tasks
- Mark tasks as completed
- View announcements
- Receive notifications
- Track progress

**Distribution:**
- Form 1: 4 students (2 boys, 2 girls)
- Form 2: 4 students (2 boys, 2 girls)
- Form 3: 4 students (2 boys, 2 girls)

**Location in Code:** `lib/services/student_service.dart`

---

### 👨‍🏫 TEACHERS (6)

| # | Name | Subject | Status | Email |
|---|------|---------|--------|-------|
| 1 | Cikgu Ahmad | Mathematics | Active | ahmad@school.edu.my |
| 2 | Cikgu Suhana | English | Active | suhana@school.edu.my |
| 3 | Cikgu Ravi | Science | Active | ravi@school.edu.my |
| 4 | Cikgu Mei Ling | History | Active | mei.ling@school.edu.my |
| 5 | Cikgu Farah | Bahasa Melayu | Active | farah@school.edu.my |
| 6 | Cikgu Zainul | Islamic Studies | Active | zainul@school.edu.my |

**Responsibilities:**
- Create and assign tasks to students
- Publish announcements
- Send messages to parents
- View student progress
- Grade submissions

**Location in Code:** `lib/services/teacher_service.dart`

---

### 👨‍👩‍👧 PARENTS (11)

| # | Parent ID | Name | Phone | Email | Children | Status |
|---|-----------|------|-------|-------|----------|--------|
| 1 | p1 | Abdullah Hassan | +6012-3456789 | abdullah.hassan@school.edu.my | Siti Mariah (s4, F1) | Active |
| 2 | p2 | Encik Karim Ahmad | +6012-1234567 | karim.ahmad@school.edu.my | Amir Abdullah (s1, F1) | Active |
| 3 | p3 | Puan Norhaida Mahmud | +6012-2345678 | norhaida.mahmud@school.edu.my | Muhammad Azhar (s2, F1) | Active |
| 4 | p4 | Encik Lim Chen Hao | +6012-3456701 | lim.chenhao@school.edu.my | Lim Wei Chen (s5, F2) | Active |
| 5 | p5 | Mr. Raj Nair Kumar | +6012-4567812 | raj.nair@school.edu.my | Raj Kumar (s6, F2) | Active |
| 6 | p6 | Encik Wong Tian Huat | +6012-5678923 | wong.tianhuat@school.edu.my | Sophia Wong (s7, F2) | Active |
| 7 | p7 | Mr. Viswanathan Sharma | +6012-6789034 | viswanathan.sharma@school.edu.my | Priya Sharma (s8, F2) | Active |
| 8 | p8 | Puan Siti Nur Azizah | +6012-7890145 | siti.azizah@school.edu.my | Nur Azlina (s3, F1), Nurul Izzah (s11, F3) | Active |
| 9 | p9 | Encik Ooi Seng Keat | +6012-8901256 | ooi.sengkeat@school.edu.my | Davina Ooi (s12, F3) | Active |
| 10 | p10 | Encik Tan Cheng Huat | +6012-9012367 | tan.chenhuat@school.edu.my | Tan Jun Wei (s10, F3) | Active |
| 11 | p11 | Encik Rashid Abdullah | +6012-0123478 | rashid.abdullah@school.edu.my | Adnan Hassan (s9, F3) | Active |

**Responsibilities:**
- Monitor child's task completion
- View child's performance
- Communicate with teachers
- Receive alerts about child's progress

**Coverage:**
- All 12 students have at least one parent assigned
- 1 parent has 2 children (Puan Siti Nur Azizah)
- 10 parents have 1 child each

**Location in Code:** `lib/services/parent_service.dart` → `getAllParents()`

---

### 👨‍💼 ADMINS (2)

| # | Name | Role | Status | Access Level |
|---|------|------|--------|---------------|
| 1 | Mohd Rizwan | Super Admin | Active | Full System Access |
| 2 | Siti Nurhaliza | Content Admin | Active | Announcements & Reports |

**Responsibilities:**
- Manage user accounts
- Configure system settings
- Publish system announcements
- Generate reports and analytics
- Manage activity logs

**Location in Code:** `lib/views/admin_dashboard.dart`

---

### ⚙️ SYSTEM USERS (1)

| # | Name | Type | Purpose |
|---|------|------|---------|
| 1 | System | Automated Process | Activity logging, notifications, background tasks |

**Responsibilities:**
- Log system activities
- Send automated notifications
- Process background jobs
- Maintain audit trails

**Location in Code:** Referenced in activity logs and notification systems

---

## Firebase Collections Structure

```
firestore/
├── users/
│   ├── {studentId}
│   ├── {teacherId}
│   ├── {parentId}
│   └── {adminId}
├── teachers/
│   ├── t1: Cikgu Ahmad
│   ├── t2: Cikgu Suhana
│   ├── t3: Cikgu Ravi
│   ├── t4: Cikgu Mei Ling
│   ├── t5: Cikgu Farah
│   └── t6: Cikgu Zainul
├── parents/
│   └── p1: Abdullah Hassan
├── children/
├── announcements/
├── messages/
└── activityLogs/ (System records)
```

---

## Adding New Users

### Via Firebase Console

1. Go to **Firestore Database**
2. Create/navigate to appropriate collection (`teachers`, `parents`, `users`, etc.)
3. Add new document with user data:
   ```json
   {
     "id": "unique_id",
     "name": "Malaysian Name",
     "role": "Teacher|Parent|Admin|Student",
     "email": "user@example.com",
     "status": "Active|Inactive",
     "createdAt": "ISO8601_date"
   }
   ```

### Via Code

Update the respective service file:
- Teachers: `lib/services/teacher_service.dart`
- Parents: `lib/services/parent_service.dart`
- Admins: `lib/views/admin_dashboard.dart`

---

## Authentication Notes

- **Students, Teachers, Parents, Admins:** Use Firebase Authentication (Email/Password or OAuth)
- **System User:** Uses system service account (no login required)

---

## Last Updated

- **Date:** February 5, 2026
- **Added Parents:** 10 additional parents (Encik Karim Ahmad, Puan Norhaida Mahmud, Encik Lim Chen Hao, Mr. Raj Nair Kumar, Encik Wong Tian Huat, Mr. Viswanathan Sharma, Puan Siti Nur Azizah, Encik Ooi Seng Keat, Encik Tan Cheng Huat, Encik Rashid Abdullah)
- **Total Users in System:** 43 (12 Students + 6 Teachers + 11 Parents + 2 Admins + 1 System)

---

## Related Documentation

- See [MALAYSIAN_NAMES_GUIDE.md](MALAYSIAN_NAMES_GUIDE.md) for naming conventions
- See [FIREBASE_SETUP.md](FIREBASE_SETUP.md) for database configuration
