class ApplicationModel {
  int? id;
  int jobId;
  int userId;

  ApplicationModel({this.id, required this.jobId, required this.userId});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'jobId': jobId,
      'userId': userId,
    };
  }

  factory ApplicationModel.fromMap(Map<String, dynamic> map) {
    return ApplicationModel(
      id: map['id'],
      jobId: map['jobId'],
      userId: map['userId'],
    );
  }
}
