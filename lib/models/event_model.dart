class EventModel {
  final String title;
  final String description;
  final DateTime date;
  final String type; // assignment, exam, event, reminder

  EventModel({
    required this.title,
    required this.description,
    required this.date,
    required this.type,
  });
}
