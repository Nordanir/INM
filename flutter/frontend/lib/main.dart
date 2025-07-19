import 'package:flutter/material.dart';
import 'package:frontend/constants/app_dimension.dart';
import 'package:frontend/auth_provider.dart';
import 'package:frontend/superbase_config.dart';
import 'package:frontend/widgets/album_provider.dart';
import 'package:frontend/widgets/home_screen.dart';
import 'package:frontend/widgets/search_provider.dart';
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
        toolbarHeight: AppDimensions.appBarHeight(context),
      ),
      body: Center(child: HomeScreen()),
    );
  }
}

@override
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final supabaseConfig = await SupabaseConfig.initSupabase();
  final albumProvider = AlbumProvider();
  runApp(
    MultiProvider(
      providers: [
        Provider<SupabaseConfig>(create: (_) => supabaseConfig),
        ChangeNotifierProvider<AuthenticationProvider>(
          create: (_) => AuthenticationProvider(),
        ),
        ChangeNotifierProvider<AlbumProvider>(create: (_) => albumProvider),
        ChangeNotifierProvider<SearchProvider>(create: (_) => SearchProvider()),
      ],
      child: const MyApp(),
    ),
  );
}
