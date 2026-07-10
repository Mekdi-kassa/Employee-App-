import 'package:employee_app/core/color/theme.dart';
import 'package:employee_app/core/constant/shared_prefs.dart';
import 'package:employee_app/features/access_page/presentation/access_page.dart';
import 'package:employee_app/features/login/presentation/login_page.dart';
import 'package:employee_app/features/login/provider/login_provider.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefs.init();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final AuthProvider _auth = AuthProvider();

  @override
  void initState() {
    super.initState();
    _auth.initializeSystemTheme(
      WidgetsBinding.instance.platformDispatcher.platformBrightness == Brightness.dark,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthScope(
      auth: _auth,
      child: AnimatedBuilder(
        animation: _auth,
        builder: (context, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Portal App',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: _auth.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            home: _auth.isLoggedIn ? const DashboardPage() : const LoginPage(),
          );
        },
      ),
    );
  }
}