import 'package:flutter/material.dart';
import 'package:frontend/dimensions/app_dimension.dart';
import 'package:frontend/providers/selection_provider.dart';
import 'package:frontend/providers/superbase_config.dart';
import 'package:frontend/providers/album_provider.dart';
import 'package:frontend/widgets/home_screen.dart';
import 'package:frontend/providers/search_provider.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'INM',

      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

@override
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await windowManager.ensureInitialized();

  WindowOptions windowOptions = WindowOptions(
    size: AppDimensions.minWindowSize(),
    minimumSize: AppDimensions.minWindowSize(),
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.normal,
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  final supabaseConfig = await SupabaseConfig.initSupabase();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<SelectionProvider>(
          create: (_) => SelectionProvider(),
        ),
        ChangeNotifierProvider<SupabaseConfig>(create: (_) => supabaseConfig),
        ChangeNotifierProvider<AlbumProvider>(create: (_) => AlbumProvider()),
        ChangeNotifierProvider<SearchProvider>(create: (_) => SearchProvider()),
      ],
      child: const MyApp(),
    ),
  );
}
