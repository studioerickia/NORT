import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app_routes.dart';

String? authRedirect(BuildContext context, GoRouterState state) {
  final isLoggedIn = Supabase.instance.client.auth.currentSession != null;
  final location = state.matchedLocation;

  final isAuthFlow = location == AppRoutes.splash ||
      location == AppRoutes.onboarding ||
      location == AppRoutes.login;

  if (!isLoggedIn && !isAuthFlow) {
    return AppRoutes.login;
  }

  if (isLoggedIn && (location == AppRoutes.login || location == AppRoutes.onboarding)) {
    return AppRoutes.home;
  }

  return null;
}