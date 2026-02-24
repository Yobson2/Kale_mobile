/// Static API endpoint path constants.
///
/// Centralizes all API routes in one place to avoid
/// hardcoded strings throughout the data layer.
class ApiEndpoints {
  const ApiEndpoints._();

  // -- Auth --
  /// POST: Login with email and password.
  static const String login = '/auth/login';

  /// POST: Register a new user.
  static const String register = '/auth/register';

  /// POST: Send registration OTP code.
  static const String sendRegistrationOtp = '/auth/send-registration-otp';

  /// POST: Request password reset email.
  static const String forgotPassword = '/auth/forgot-password';

  /// POST: Verify OTP code.
  static const String verifyOtp = '/auth/verify-otp';

  /// POST: Refresh the access token.
  static const String refreshToken = '/auth/refresh-token';

  /// POST: Logout and invalidate tokens.
  static const String logout = '/auth/logout';

  /// GET: Fetch the current user profile.
  static const String me = '/auth/me';

  // -- Transactions --
  /// CRUD: Transactions resource.
  static const String transactions = '/transactions';

  // -- Categories --
  /// CRUD: Categories resource.
  static const String categories = '/categories';

  // -- Budgets --
  /// CRUD: Budgets resource.
  static const String budgets = '/budgets';

  // -- Savings Goals --
  /// CRUD: Savings goals resource.
  static const String savingsGoals = '/savings-goals';

  // -- Savings Contributions --
  /// CRUD: Savings contributions resource.
  static const String savingsContributions = '/savings-contributions';
}
