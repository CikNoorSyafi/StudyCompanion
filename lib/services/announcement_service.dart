import 'package:studycompanion_app/models/announcement_model.dart';

class AnnouncementService {
  static Future<List<AnnouncementModel>> getPublishedAnnouncements() async {
    await Future.delayed(const Duration(seconds: 1)); // simulate API

    return [
      AnnouncementModel(
        id: "A1",
        title: "Science Fair Update",
        message: "Project submission due next Friday",
        createdBy: "Admin",
        date: DateTime.now(),
        isPublished: true,
      ),
      AnnouncementModel(
        id: "A2",
        title: "School Holiday Notice",
        message: "School closed on Monday",
        createdBy: "Principal",
        date: DateTime.now(),
        isPublished: true,
      ),
    ];
  }
}
