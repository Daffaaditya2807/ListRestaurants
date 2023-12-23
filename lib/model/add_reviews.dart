class Addreviews {
  String? error;
  String? message;

  Addreviews({this.error, this.message});

  factory Addreviews.fromJson(Map<String, dynamic> json) =>
      Addreviews(error: json['error'].toString(), message: json['message']);
}
