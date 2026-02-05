import 'package:flutter/foundation.dart';
import 'package:studycompanion_app/models/announcement_model.dart';
import 'package:studycompanion_app/services/announcement_service.dart';

class AnnouncementViewModel extends ChangeNotifier {
  List<AnnouncementModel> _announcements = [];
  bool _isLoading = false;
  String? _error;

  AnnouncementViewModel() {
    _initializeAnnouncements();
  }

  List<AnnouncementModel> get announcements => _announcements;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get announcementCount => _announcements.length;

  /// Initialize announcements from service
  Future<void> _initializeAnnouncements() async {
    _isLoading = true;
    notifyListeners();

    try {
      final data = await AnnouncementService.getPublishedAnnouncements();
      _announcements = data;
      _error = null;
    } catch (e) {
      _error = 'Failed to load announcements: $e';
      print('Error loading announcements: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Refresh announcements
  Future<void> refreshAnnouncements() async {
    await _initializeAnnouncements();
  }

  /// Stream announcements for real-time updates
  Stream<List<AnnouncementModel>> streamAnnouncements() {
    return AnnouncementService.streamPublishedAnnouncements();
  }

  /// Get announcements sorted by date (newest first)
  List<AnnouncementModel> get sortedAnnouncements {
    final sorted = List<AnnouncementModel>.from(_announcements);
    sorted.sort((a, b) => b.date.compareTo(a.date));
    return sorted;
  }

  /// Get announcement by ID
  AnnouncementModel? getAnnouncementById(String id) {
    try {
      return _announcements.firstWhere((ann) => ann.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get recent announcements (last 5)
  List<AnnouncementModel> get recentAnnouncements {
    final sorted = sortedAnnouncements;
    return sorted.take(5).toList();
  }
}
