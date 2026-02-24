/// Type of financial transaction.
enum TransactionType {
  /// Money coming in.
  income,

  /// Money going out.
  expense,

  /// Money moved between accounts.
  transfer;

  /// Whether this is an income transaction.
  bool get isIncome => this == TransactionType.income;

  /// Whether this is an expense transaction.
  bool get isExpense => this == TransactionType.expense;
}

/// Payment method used for a transaction.
enum PaymentMethod {
  /// Physical cash.
  cash,

  /// Mobile money (M-Pesa, Orange Money, MTN MoMo, etc.).
  mobileMoney,

  /// Bank transfer or account.
  bank,

  /// Debit or credit card.
  card;
}

/// Category type for filtering.
enum CategoryType {
  /// Income-only category.
  income,

  /// Expense-only category.
  expense,

  /// Category used for both income and expense.
  both;
}

/// Mobile money providers available in Africa.
enum MobileMoneyProvider {
  mPesa('M-Pesa'),
  orangeMoney('Orange Money'),
  mtnMomo('MTN MoMo'),
  airtelMoney('Airtel Money'),
  wave('Wave'),
  moovMoney('Moov Money'),
  other('Other');

  const MobileMoneyProvider(this.displayName);

  /// Human-readable name.
  final String displayName;
}
