import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sole_seekers_1_0/core/providers/query_provider.dart';

import 'core/providers/services_provider.dart';
import 'core/providers/theme_provider.dart';
import 'core/routes/routes.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('localStorage');
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => ServicesProvider()),
      ChangeNotifierProvider(create: (context) => QueryProvider()),
      ChangeNotifierProvider(create: (context) => ThemeProvider()),
    ],
    child: const MainApp(),
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    ServicesProvider().getCurrentUserDoc();
    ServicesProvider().loadData();
    return ScreenUtilInit(
      splitScreenMode: true,
      minTextAdapt: true,
      designSize: const Size(360, 800),
      builder: (context, child) => MaterialApp(
        title: 'SoleSeekers',
        debugShowCheckedModeBanner: false,
        onGenerateRoute: RouteGenerator.generateRoute,
        initialRoute: 'authChecker',
        // theme: lightMode,
        theme: Provider.of<ThemeProvider>(context).themeMode,
      ),
    );
  }
}
