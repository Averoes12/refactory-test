class HomeModel {
  String slogan;
  String corpDesc;
  List<CorpService> corpService;

  HomeModel({this.slogan, this.corpDesc, this.corpService});

  HomeModel.fromJson(Map<String, dynamic> json) {
    slogan = json['slogan'];
    corpDesc = json['corpDesc'];
    if (json['corpService'] != null) {
      corpService = new List<CorpService>();
      json['corpService'].forEach((v) {
        corpService.add(new CorpService.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['slogan'] = this.slogan;
    data['corpDesc'] = this.corpDesc;
    if (this.corpService != null) {
      data['corpService'] = this.corpService.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CorpService {
  String logo;
  String title;
  String desc;

  CorpService({this.logo, this.title, this.desc});

  CorpService.fromJson(Map<String, dynamic> json) {
    logo = json['logo'];
    title = json['title'];
    desc = json['desc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['logo'] = this.logo;
    data['title'] = this.title;
    data['desc'] = this.desc;
    return data;
  }
}
