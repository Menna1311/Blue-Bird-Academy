import 'package:blue_bird/core/router/app_routes.dart';
import 'package:blue_bird/core/router/route_not_found.dart';
import 'package:blue_bird/features/auth/login/presentation/views/login_view.dart';
import 'package:flutter/material.dart';

Route manageRoutes(RouteSettings settings) {
  switch (settings.name) {
    case AppRoutes.loginScreen:
      return MaterialPageRoute(
        builder: (context) => LoginView(),
      );
    default:
      return MaterialPageRoute(
        builder: (context) => const RouteNotFound(),
      );
  }
}
