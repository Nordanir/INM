import 'package:flutter/material.dart';
import 'package:frontend/insert.dart';
import 'package:frontend/superbase_config.dart';
import 'package:frontend/widgets/login.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const Home(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("INM"),
      ),
      body: Center(child: Column(children: [Login()])),
    );
  }
}

@override
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initSupabase();
  runApp(const MyApp());
}
