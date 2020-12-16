class ReviewModel {
  int id;
  User user;
  int star;
  String title;
  String description;

  ReviewModel({this.id, this.user, this.star, this.title, this.description});

  ReviewModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    star = json['star'];
    title = json['title'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    data['star'] = this.star;
    data['title'] = this.title;
    data['description'] = this.description;
    return data;
  }
}

class User {
  int userId;
  String photoUrl;
  String name;
  String from;

  User({this.userId, this.photoUrl, this.name, this.from});

  User.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    photoUrl = json['photo_url'];
    name = json['name'];
    from = json['from'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['photo_url'] = this.photoUrl;
    data['name'] = this.name;
    data['from'] = this.from;
    return data;
  }
}
