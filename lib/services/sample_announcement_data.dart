import 'package:studycompanion_app/models/announcement_model.dart';

class SampleAnnouncementData {
  /// Generate sample announcements for testing
  static List<AnnouncementModel> generateSampleAnnouncements() {
    final now = DateTime.now();
    
    return [
      AnnouncementModel(
        id: 'ann_1',
        title: 'School Sports Day - February 15, 2026',
        message: 'Annual Sports Day will be held on February 15, 2026 at the school field. All students are required to participate in at least one event. Please register your participation with your Form Teacher by February 10.',
        createdBy: 'Cikgu Farah',
        date: now.subtract(const Duration(days: 2)),
        isPublished: true,
      ),
      AnnouncementModel(
        id: 'ann_2',
        title: 'Mid-Year Examination Schedule Released',
        message: 'The Mid-Year Examination schedule for Form 1-3 has been released. Examinations will begin on March 1, 2026 and end on March 20, 2026. Detailed timetable is available at the school notice board and on the school portal.',
        createdBy: 'Admin',
        date: now.subtract(const Duration(days: 1)),
        isPublished: true,
      ),
      AnnouncementModel(
        id: 'ann_3',
        title: 'Parent-Teacher Meeting - February 20, 2026',
        message: 'Annual Parent-Teacher Meeting will be held on February 20, 2026 from 2:00 PM to 5:00 PM. Parents are encouraged to meet with subject teachers to discuss their child\'s academic progress.',
        createdBy: 'Admin',
        date: now,
        isPublished: true,
      ),
      AnnouncementModel(
        id: 'ann_4',
        title: 'New Science Lab Equipment Available',
        message: 'The Science Department is pleased to announce the arrival of new laboratory equipment. All students will have the opportunity to use these equipment in their practical classes starting from next week.',
        createdBy: 'Cikgu Ravi',
        date: now.subtract(const Duration(days: 3)),
        isPublished: true,
      ),
      AnnouncementModel(
        id: 'ann_5',
        title: 'Debate Club Registration Open',
        message: 'Calling all interested students! Debate Club is now open for registration. Weekly meetings every Thursday at 3:30 PM in the Academic Block. No prior experience required. Come join us!',
        createdBy: 'Cikgu Suhana',
        date: now.subtract(const Duration(days: 5)),
        isPublished: true,
      ),
      AnnouncementModel(
        id: 'ann_6',
        title: 'Mathematics Competition - Registration Closes February 12',
        message: 'The National Mathematics Competition for secondary students is open for registration. Registration closes on February 12, 2026. Interested students should submit their names to Cikgu Ahmad immediately.',
        createdBy: 'Cikgu Ahmad',
        date: now.subtract(const Duration(days: 4)),
        isPublished: true,
      ),
      AnnouncementModel(
        id: 'ann_7',
        title: 'Library Extended Hours During Examination Period',
        message: 'During the examination period (March 1-20), the library will be open until 6:00 PM on weekdays to support student revision. Weekend hours remain unchanged.',
        createdBy: 'Admin',
        date: now.subtract(const Duration(days: 6)),
        isPublished: true,
      ),
      AnnouncementModel(
        id: 'ann_8',
        title: 'English Language Club - Story Telling Competition',
        message: 'English Language Club is organizing a Story Telling Competition for all Form 1-3 students. Cash prizes worth RM500 for winners. Preliminary round on February 28, 2026.',
        createdBy: 'Cikgu Suhana',
        date: now.subtract(const Duration(days: 7)),
        isPublished: true,
      ),
    ];
  }

  /// Get sample announcements for a specific student
  static List<AnnouncementModel> getSampleAnnouncementsForStudent(String studentId) {
    // All announcements are shown to all students for now
    return generateSampleAnnouncements();
  }

  /// Get recent announcements (last 5)
  static List<AnnouncementModel> getRecentAnnouncements({int limit = 5}) {
    final all = generateSampleAnnouncements();
    // Sort by date descending
    all.sort((a, b) => b.date.compareTo(a.date));
    return all.take(limit).toList();
  }

  /// Search announcements by keyword
  static List<AnnouncementModel> searchAnnouncements(String keyword) {
    final all = generateSampleAnnouncements();
    final lowerKeyword = keyword.toLowerCase();
    
    return all
        .where((ann) =>
            ann.title.toLowerCase().contains(lowerKeyword) ||
            ann.message.toLowerCase().contains(lowerKeyword) ||
            ann.createdBy.toLowerCase().contains(lowerKeyword))
        .toList();
  }

  /// Get announcements by creator
  static List<AnnouncementModel> getAnnouncementsByCreator(String creatorName) {
    final all = generateSampleAnnouncements();
    return all.where((ann) => ann.createdBy == creatorName).toList();
  }
}
