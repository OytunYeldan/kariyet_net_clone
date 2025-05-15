class JobModel {
  int? id;
  String title;
  String description;
  String skills;
  String companyId;
  String location;
  String salary;

  JobModel({
    this.id,
    required this.title,
    required this.description,
    required this.skills,
    required this.companyId,
    required this.location,
    required this.salary,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'skills': skills,
      'companyId': companyId,
      'location': location,
      'salary': salary,
    };
  }

  factory JobModel.fromMap(Map<String, dynamic> map) {
    return JobModel(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      skills: map['skills'],
      companyId: map['companyId'],
      location: map['location'],
      salary: map['salary'],
    );
  }
}
