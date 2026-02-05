class SubjectPerformance {
  final String subjectName;
  final int score;

  SubjectPerformance({
    required this.subjectName,
    required this.score,
  });

  factory SubjectPerformance.fromJson(Map<String, dynamic> json) {
    return SubjectPerformance(
      subjectName: json['subjectName'] ?? '',
      score: json['score'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subjectName': subjectName,
      'score': score,
    };
  }

  @override
  String toString() => 'SubjectPerformance(subject: $subjectName, score: $score)';
}
