part of 'transactions_screen_cubit.dart';

class TransactionsScreenState {
  final bool isLoading;
  List<Transaction> transactions;
  UserEntity? user;

  TransactionsScreenState({
    required this.isLoading,
    required this.transactions,
    this.user,
  });

  factory TransactionsScreenState.initial() => TransactionsScreenState(
        isLoading: false,
        transactions: [],
      );

  TransactionsScreenState copyWith({
    bool? isLoading,
    List<Transaction>? transactions,
    UserEntity? user,
  }) {
    return TransactionsScreenState(
      isLoading: isLoading ?? this.isLoading,
      transactions: transactions ?? this.transactions,
      user: user ?? this.user,
    );
  }
}
