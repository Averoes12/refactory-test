class ListCourseModel {
  int id;
  String photoUrl;
  String title;
  String shortDescription;
  String linkUrl;
  User user;

  ListCourseModel(
      {this.id,
        this.photoUrl,
        this.title,
        this.shortDescription,
        this.linkUrl,
        this.user});

  ListCourseModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    photoUrl = json['photo_url'];
    title = json['title'];
    shortDescription = json['short_description'];
    linkUrl = json['link_url'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['photo_url'] = this.photoUrl;
    data['title'] = this.title;
    data['short_description'] = this.shortDescription;
    data['link_url'] = this.linkUrl;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    return data;
  }
}

class User {
  int userId;
  String photoUrl;
  String name;

  User({this.userId, this.photoUrl, this.name});

  User.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    photoUrl = json['photo_url'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['photo_url'] = this.photoUrl;
    data['name'] = this.name;
    return data;
  }
}
