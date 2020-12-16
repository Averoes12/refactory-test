class DetailCourseModel {
  int id;
  String shortDescription;
  String quistion;
  String answer;
  String quistionPhoto;
  List<MateriCourse> materiCourse;

  DetailCourseModel(
      {this.id,
        this.shortDescription,
        this.quistion,
        this.answer,
        this.quistionPhoto,
        this.materiCourse});

  DetailCourseModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    shortDescription = json['short-description'];
    quistion = json['quistion'];
    answer = json['answer'];
    quistionPhoto = json['quistion-photo'];
    if (json['materi course'] != null) {
      materiCourse = new List<MateriCourse>();
      json['materi course'].forEach((v) {
        materiCourse.add(new MateriCourse.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['short-description'] = this.shortDescription;
    data['quistion'] = this.quistion;
    data['answer'] = this.answer;
    data['quistion-photo'] = this.quistionPhoto;
    if (this.materiCourse != null) {
      data['materi course'] = this.materiCourse.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MateriCourse {
  int id;
  String section;
  List<Data> data;

  MateriCourse({this.id, this.section, this.data});

  MateriCourse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    section = json['section'];
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['section'] = this.section;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int id;
  String title;
  String url;
  String timeIn;

  Data({this.id, this.title, this.url, this.timeIn});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    url = json['url'];
    timeIn = json['time-in'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['url'] = this.url;
    data['time-in'] = this.timeIn;
    return data;
  }
}
