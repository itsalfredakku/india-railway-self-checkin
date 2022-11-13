class Passenger {
  String? name;
  String? gender;
  int? age;
  String? status;

  Passenger(
      {this.name,
      this.gender,
      this.age,
      this.status});

  Passenger.fromMap(Map<String, dynamic> map)
      : name = map['name'],
        gender = map['gender'],
        age = map['age'],
        status = map['status'];

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'gender': gender,
      'age': age,
      'status': status,
    };
  }

  Passenger fromData(String data){
    List<String> lines = data.split('\n');
    return Passenger(
        name: lines.singleWhere((element) => element.trim().startsWith('Name')).split(':').last,
        gender: lines.singleWhere((element) => element.trim().startsWith('Gender')).split(':').last,
        age: int.parse(lines.singleWhere((element) => element.trim().startsWith('Age')).split(':').last),
        status:  lines.singleWhere((element) => element.trim().startsWith('Status')).split(':').last
    );
  }
}
