import '../models/event_model.dart';

class CalendarService {
  static List<EventModel> events = [
    EventModel(
      title: "Math Assignment Due",
      description: "Chapter 4 Exercises",
      date: DateTime(2026, 2, 10),
      type: "assignment",
    ),
    EventModel(
      title: "Science Quiz",
      description: "Photosynthesis",
      date: DateTime(2026, 2, 12),
      type: "exam",
    ),
  ];
}
