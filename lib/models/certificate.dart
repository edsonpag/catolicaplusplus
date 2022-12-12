class Certificate {
  String id;
  String title;
  double amountOfHours;
  String description;
  int status;
  String? filePath;
  String? userEmail;

  Certificate({
    this.id = '',
    required this.title,
    required this.amountOfHours,
    required this.description,
    required this.status,
    required this.filePath,
    required this.userEmail
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'amountOfHours': amountOfHours,
    'description': description,
    'status': status,
    'filePath': filePath,
    'userEmail': userEmail
  };

  static Certificate fromJson(Map<String, dynamic> json) => Certificate(
      id: json['id'],
      title: json['title'],
      amountOfHours: json['amountOfHours'],
      description: json['description'],
      status: json['status'],
      filePath: json['filePath'],
      userEmail: json['userEmail']
  );
}
