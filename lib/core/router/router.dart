import 'package:blue_bird/core/router/app_routes.dart';
import 'package:blue_bird/core/router/route_not_found.dart';
import 'package:blue_bird/features/add_team/presentation/views/add_team_view.dart';
import 'package:blue_bird/features/auth/login/presentation/views/login_view.dart';
import 'package:blue_bird/features/auth/register/presentation/views/register_view.dart';
import 'package:blue_bird/features/home/presentation/views/home_view.dart';
import 'package:flutter/material.dart';

Route manageRoutes(RouteSettings settings) {
  switch (settings.name) {
    case AppRoutes.loginScreen:
      return MaterialPageRoute(
        builder: (context) => LoginView(),
      );
    case AppRoutes.homeScreen:
      return MaterialPageRoute(
        builder: (context) => HomeScreen(),
      );
    case AppRoutes.addTeamScreen:
      return MaterialPageRoute(
        builder: (context) => AddTeamView(),
      );
    case AppRoutes.registerScreen:
      return MaterialPageRoute(builder: (context) => RegisterView());
    default:
      return MaterialPageRoute(
        builder: (context) => const RouteNotFound(),
      );
  }
}
