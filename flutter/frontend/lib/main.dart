import 'package:flutter/material.dart';
import 'package:frontend/providers.dart';
import 'package:frontend/superbase_config.dart';
import 'package:frontend/widgets/auth.dart';
import 'package:provider/provider.dart';

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
      body: Center(child: Column(children: [Authenticate()])),
    );
  }
}

@override
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final supabaseConfig = await SupabaseConfig.initSupabase();
  runApp(
    MultiProvider(
      providers: [
        Provider<SupabaseConfig>(create: (_) => supabaseConfig),
        ChangeNotifierProvider<AuthenticationProvider>(
          create: (_) => AuthenticationProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}
