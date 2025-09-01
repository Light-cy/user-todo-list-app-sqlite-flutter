import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_database/databases/local/dbhelper.dart';
import 'package:user_database/screens/home_screen.dart';
import 'package:user_database/services/user_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final Dbhelper dbhelper = Dbhelper.instance;
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserProvider(dbhelper),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      routes: {'/': (context) => const HomeScreen()},
    );
  }
}
