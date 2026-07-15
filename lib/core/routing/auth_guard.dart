import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app_routes.dart';

Future<String?> authRedirect(BuildContext context, GoRouterState state) async {
  final client = Supabase.instance.client;
  final isLoggedIn = client.auth.currentSession != null;
  final location = state.matchedLocation;

  if (!isLoggedIn) {
    final isAllowedLoggedOut =
        location == AppRoutes.onboarding || location == AppRoutes.login;
    return isAllowedLoggedOut ? null : AppRoutes.login;
  }

  final onboardingDone = await _hasCompletedOnboarding(client);

  if (!onboardingDone) {
    return location == AppRoutes.onboarding ? null : AppRoutes.onboarding;
  }

  final isStartFlow = location == AppRoutes.splash ||
      location == AppRoutes.onboarding ||
      location == AppRoutes.login;

  return isStartFlow ? AppRoutes.home : null;
}

Future<bool> _hasCompletedOnboarding(SupabaseClient client) async {
  final userId = client.auth.currentUser?.id;
  if (userId == null) return false;

  try {
    final row = await client
        .from('profiles')
        .select('onboarding_completed_at')
        .eq('id', userId)
        .maybeSingle();
    return row != null && row['onboarding_completed_at'] != null;
  } catch (_) {
    return false;
  }
}
