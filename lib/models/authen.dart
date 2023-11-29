class Authen {
  String? name;
  String? pass;

  Authen({this.name, this.pass});

  Authen.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    pass = json['pass'];
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'pass': pass};
  }
}
