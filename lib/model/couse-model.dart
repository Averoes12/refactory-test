class CourseModel {
  String slogan;
  String desc;
  String titleDesc;
  String descCourse;

  CourseModel({this.slogan, this.desc, this.titleDesc, this.descCourse});

  CourseModel.fromJson(Map<String, dynamic> json) {
    slogan = json['slogan'];
    desc = json['desc'];
    titleDesc = json['titleDesc'];
    descCourse = json['descCourse'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['slogan'] = this.slogan;
    data['desc'] = this.desc;
    data['titleDesc'] = this.titleDesc;
    data['descCourse'] = this.descCourse;
    return data;
  }
}
