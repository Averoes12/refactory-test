class UserModel {
  int _id;
  String _username;
  String _email;
  String _password;
  int _counter;

  UserModel(this._username, this._email, this._password);

  UserModel.map(dynamic obj){
    this._id = obj['id'];
    this._username = obj['username'];
    this._email = obj['email'];
    this._password = obj['password'];
    this._counter = obj['counter'];
  }

  String get username => _username;
  String get email => _email;
  String get password => _password;
  int get counter => _counter;

  Map<String, dynamic> toMap(){
    var map = Map<String, dynamic>();

    map['username'] = _username;
    map['email']  = _email;
    map['password'] = _password;
    map['counter'] = _counter;

    return map;
  }

  void setUserData(int id){
    this._id = id;
  }
}