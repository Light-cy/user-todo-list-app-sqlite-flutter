import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_database/databases/local/dbhelper.dart';
import 'package:user_database/models/user.dart';
import 'package:user_database/screens/add_user.dart';
import 'package:user_database/services/user_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Dbhelper? dbhelper;
  List<User> users = [];
  @override
  void initState() {
    super.initState();
    dbhelper = Dbhelper.instance;
    _fecthData();
  }

  void _fecthData() async {
    users = await dbhelper!.getUser();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("User Database")),
      body: Consumer<UserProvider>(
        builder: (ctx, userProvider, child) {
          var users = userProvider.users;
          if (userProvider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }
          return users.isEmpty
              ? Center(child: Text("No Data Found"))
              : ListView.builder(
                itemCount: users.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    elevation: 1,
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 10,
                      ),
                      leading: CircleAvatar(
                        child: Text((index + 1).toString()),
                      ),
                      title: Text(
                        users[index].name!,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        "${users[index].email!}\n${users[index].phoneNo!}",
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              userProvider.deleteUser(users[index].id!);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('user deleted successfully'),
                                  backgroundColor: Colors.red,
                                  behavior: SnackBarBehavior.floating,
                                  clipBehavior: Clip.antiAlias,
                                  showCloseIcon: true,
                                  dismissDirection: DismissDirection.down,
                                  duration: Duration(milliseconds: 500),
                                ),
                              );
                            },
                            icon: const Icon(Icons.delete, color: Colors.red),
                          ),
                          IconButton(
                            onPressed: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return AddUser(
                                      user: users[index],
                                      index: users[index].id!,
                                      isupdate: true,
                                    );
                                  },
                                ),
                              );
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('user updated successfully'),
                                    backgroundColor: Colors.green,
                                    behavior: SnackBarBehavior.floating,
                                    clipBehavior: Clip.antiAlias,
                                    showCloseIcon: true,
                                    dismissDirection: DismissDirection.down,
                                    duration: Duration(milliseconds: 500),
                                  ),
                                );
                              }

                              _fecthData();
                            },
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.greenAccent,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return AddUser();
              },
            ),
          );
          _fecthData();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
