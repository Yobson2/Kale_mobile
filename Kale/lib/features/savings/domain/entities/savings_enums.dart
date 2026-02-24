/// Status of a savings goal.
enum SavingsGoalStatus {
  /// Currently in progress.
  active,

  /// Fully funded and complete.
  completed,

  /// Temporarily paused.
  paused,

  /// Permanently cancelled.
  cancelled;

  /// Whether the goal is actively being saved toward.
  bool get isActive => this == SavingsGoalStatus.active;

  /// Whether the goal is completed.
  bool get isCompleted => this == SavingsGoalStatus.completed;
}

/// Source of a savings contribution.
enum ContributionSource {
  /// Manual deposit by user.
  manual,

  /// Automatic deduction.
  auto,

  /// Round-up from transactions.
  roundup;
}
