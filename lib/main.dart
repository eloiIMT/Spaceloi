import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:spaceloi/data/services/AppService.dart';
import 'package:spaceloi/ui/pages/home.page.dart';
import 'package:spaceloi/ui/widgets/onboarding.widget.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('fr_FR', null);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spaceloi',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0B3D91),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0B3D91),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF0B3D91),
          foregroundColor: Colors.white,
        ),
      ),
      home: const AppStartup(),
    );
  }
}

class AppStartup extends StatefulWidget {
  const AppStartup({super.key});

  @override
  State<AppStartup> createState() => _AppStartupState();
}

class _AppStartupState extends State<AppStartup> {
  bool? _hasCompletedOnboarding;

  @override
  void initState() {
    super.initState();
    _checkOnboarding();
  }

  Future<void> _checkOnboarding() async {
    final completed = await AppService.hasCompletedOnboarding();
    setState(() {
      _hasCompletedOnboarding = completed;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_hasCompletedOnboarding == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_hasCompletedOnboarding == false) {
      return OnboardingWidget(
        onComplete: () async {
          await AppService.setOnboardingCompleted();
          if (mounted) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const HomePage()),
            );
          }
        },
      );
    }

    return const HomePage();
  }
}
