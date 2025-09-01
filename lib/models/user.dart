import 'package:user_database/constants/strings.dart';

class User {
  int? id;
  String? name;
  String? email;
  String? age;
  String? phoneNo;
  String? address;
  User.empty();
  User({this.id, this.name, this.email, this.age, this.phoneNo, this.address});
  User.fromMap(Map<String, dynamic> res) {
    id = res[COLUMN_ID];
    name = res[COLUMN_NAME];
    email = res[COLUMN_EMAIL];
    age = res[COLUMN_AGE].toString();
    phoneNo = res[COLUMN_PHONE];
    address = res[COLUMN_ADDRESS];
  }
}
