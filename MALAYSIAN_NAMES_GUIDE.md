# Malaysian Names Reference Guide

## Overview
This document outlines the Malaysian names used throughout the StudyCompanion application. All sample data uses authentic Malaysian names from various ethnic backgrounds (Malay, Chinese, Indian communities) to ensure cultural relevance and appropriateness for the Malaysian education system.

## Names Used in the Application

### Students
- **Amir Abdullah** - Primary student example (Male, Malay)
- Other student names to be added from Firestore data

### Teachers  
- **Cikgu Ahmad** - Math teacher (Male, Malay) - "Cikgu" means teacher in Malay
- **Cikgu Suhana** - English teacher (Female, Malay)
- **Cikgu Ravi** - Science teacher (Male, Indian)
- **Cikgu Mei Ling** - History teacher (Female, Chinese)

### Admin & System Users
- **Mohd Rizwan** - Administrator (Male, Malay)
- **Siti Nurhaliza** - System user (Female, Malay)

## Malaysian Cultural Conventions

### Teacher Titles
- **Cikgu** - Formal Malay term for teacher (used before first name)
- Used for all teachers regardless of ethnicity
- Example: "Cikgu Ahmad", "Cikgu Suhana"

### Student Grades
- **Form 1-5** - Secondary school (instead of "Grade")
- **Primary 1-6** - Primary school
- Example: "Form 1" instead of "Grade 5"

### Common Malaysian Names by Ethnicity

#### Malay Names
- Males: Ahmad, Amir, Zainul, Mohd, Rizwan, Fadhil
- Females: Suhana, Farah, Siti, Nur, Leila, Anita

#### Chinese Names
- Males: Wei Ming, Ravi, Chong, Tian
- Females: Mei Ling, Ying, Hui, Li Na

#### Indian Names
- Males: Ravi, Kumar, Arun, Vikram
- Females: Priya, Shanti, Lakshmi, Asha

## Implementation Guidelines

When adding new sample data or examples:
1. Use authentic Malaysian names from one of the three main communities
2. Use "Cikgu" for all teacher references
3. Use "Form X" for secondary school levels
4. Use "Primary X" for primary school levels
5. Maintain ethnic diversity in sample data
6. Update this reference guide when adding new names

## Firestore Sample Data Format

```json
{
  "students": {
    "name": "Amir Abdullah",
    "grade": "Form 1",
    "parentName": "Abdullah Hassan"
  },
  "teachers": {
    "name": "Cikgu Ahmad",
    "subject": "Mathematics"
  },
  "announcements": {
    "createdBy": "Cikgu Suhana",
    "title": "Important Announcement"
  }
}
```

## References
- [Malaysian Education System](https://en.wikipedia.org/wiki/Education_in_Malaysia)
- [Malaysian Name Conventions](https://en.wikipedia.org/wiki/Malaysian_name)
- Common Malaysian Names Database

---

**Last Updated:** February 5, 2026
**Project:** StudyCompanion
**Status:** All names localized for Malaysian context
