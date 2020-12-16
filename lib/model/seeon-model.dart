class SeeOnModel {
  int id;
  String photoUrl;
  String linkUrl;
  String name;

  SeeOnModel({this.id, this.photoUrl, this.linkUrl, this.name});

  SeeOnModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    photoUrl = json['photo_url'];
    linkUrl = json['link_url'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['photo_url'] = this.photoUrl;
    data['link_url'] = this.linkUrl;
    data['name'] = this.name;
    return data;
  }
}
