import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/di/injection.dart';
import 'core/theme/app_theme.dart';
import 'features/card_home/presentation/pages/card_home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Force portrait orientation (landscape handled via LayoutBuilder inside)
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  // Transparent status + navigation bars for edge-to-edge feel
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  setupDependencies();

  runApp(const RblCardHomeApp());
}

class RblCardHomeApp extends StatelessWidget {
  const RblCardHomeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RBL Card Home',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      home: const CardHomePage(),
    );
  }
}
