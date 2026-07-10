class UserProfile {
  const UserProfile({
    required this.id,
    required this.email,
    this.displayName,
    this.avatarUrl,
    required this.locale,
    required this.timezone,
    this.onboardingCompletedAt,
  });

  final String id;
  final String email;
  final String? displayName;
  final String? avatarUrl;
  final String locale;
  final String timezone;
  final DateTime? onboardingCompletedAt;

  String get displayNameOrFallback => displayName?.isNotEmpty == true
      ? displayName!
      : email.split('@').first;
}