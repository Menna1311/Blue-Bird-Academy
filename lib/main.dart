import 'package:blue_bird/core/common/bloc_observer.dart';
import 'package:blue_bird/core/di/di.dart';
import 'package:blue_bird/core/providers/user_provider.dart';
import 'package:blue_bird/core/responsive_helper/size_provider.dart';
import 'package:blue_bird/core/router/app_routes.dart';
import 'package:blue_bird/core/router/router.dart';
import 'package:blue_bird/features/add_team/presentation/provider/add_team_form_provider.dart';
import 'package:blue_bird/firebase_options.dart';
import 'package:blue_bird/utils/color_manager.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  configureDependencies();
  Bloc.observer = SimpleBlocObserver();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => AddTeamFormProvider()),
      ],
      builder: (context, child) {
        return child!;
      },
      child: DevicePreview(
        enabled: true,
        builder: (context) => MyApp(),
      )));
}

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return SizeProvider(
      baseSize: const Size(375, 812),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      baseTextSize: 16,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        scaffoldMessengerKey: scaffoldMessengerKey,
        title: 'Blue Bird Academy',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: ColorManager.primary,
              primary: ColorManager.primary,
              onError: Colors.red,
              secondary: const Color(0xffA6A6A6)),
          useMaterial3: true,
        ),
        onGenerateRoute: manageRoutes,
        initialRoute: AppRoutes.splashScreen,
      ),
    );
  }
}
