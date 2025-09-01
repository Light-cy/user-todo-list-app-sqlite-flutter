import 'package:flutter/material.dart';
import 'package:user_database/databases/local/dbhelper.dart';
import 'package:user_database/models/user.dart';

class UserProvider extends ChangeNotifier {
  List<User> _users = [];
  bool isLoading = true;
  final Dbhelper? _dbhelper;

  List<User> get users => _users;

  UserProvider(this._dbhelper) {
    loadData();
  }
  Future<void> loadData() async {
    _users = await _dbhelper!.getUser();
    isLoading = false;

    notifyListeners();
  }

  Future<void> addUser(User user) async {
    await _dbhelper!.addUser(user);
    loadData();
  }

  Future<void> updateUser(User user, int id) async {
    await _dbhelper!.updateUser(user, id);
    // _users[_users.indexWhere((element) => element.id == id)] = user; we cannot do this because we are using id from assigned db and that id can inly be retreived using the get user function which make a user userlist and in that for each user assign their respectives id's beacuse if we only add user into list the id column will remain empty
    loadData();
    // notifyListeners();
  }

  Future<void> deleteUser(int id) async {
    await _dbhelper!.deleteUser(id);
    // _users.removeWhere((user) => user.id == id); same issue as above if the id is null of that user it can't be deleted you see
    loadData();
    // notifyListeners();
  }
}
