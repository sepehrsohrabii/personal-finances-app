import 'package:bloc/bloc.dart';
import 'package:budgets/core/accounts/domain.dart';
import 'package:budgets/core/budgets/domain.dart';
import 'package:budgets/core/categories/application.dart';
import 'package:budgets/core/categories/domain.dart';
import 'package:budgets/core/transactions/domain.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/transactions/application.dart';
import '../../../../core/transactions/domain.dart';
import '../../../../core/user/application.dart';

part 'edit_transaction_screen_state.dart';

@injectable
class EditTransactionScreenCubit extends Cubit<EditTransactionScreenState> {
  UpdateTransaction updateTransaction;
  DeleteTransaction deleteTransaction;
  GetProfileInfo getProfileInfo;
  AddTransaction addTransaction;
  SaveCategories saveCategories;
  GetSubCategories getSubCategories;
  SaveSubCategories saveSubCategories;

  EditTransactionScreenCubit(
    this.updateTransaction,
    this.deleteTransaction,
    this.getProfileInfo,
    this.addTransaction,
    this.saveCategories,
    this.getSubCategories,
    this.saveSubCategories,
  ) : super(EditTransactionScreenState.initial());

  void init(Transaction? transaction) {
    emit(state.copyWith(transaction: transaction ?? Expense.empty()));
  }

  Future<void> getUserSubCategories() async {
    state.category.fold(
      () => null,
      (stateCategory) {
        final isDefaultCategory = Category.defaultCategories
            .any((category) => category.id.value == stateCategory.id.value);
        getSubCategories(stateCategory.id).then(
          (optionSubCategories) => optionSubCategories.fold(
            () => isDefaultCategory
                ? _setDefaultSubCategories()
                : emit(state.copyWith(subCategories: [])),
            (subCategories) =>
                emit(state.copyWith(subCategories: subCategories)),
          ),
        );
      },
    );
  }

  Future<void> _setDefaultSubCategories() async {
    final subCategories = SubCategory.allSubCategories;
    await saveSubCategories(subCategories: subCategories);
    emit(state.copyWith(subCategories: subCategories));
  }

  Future<void> onTransactionDeleted() async {
    await deleteTransaction(state.transaction!.id);
  }

  Future<void> onTransactionSaved({bool isNewTransaction = false}) async {
    getProfileInfo().then(
      (optionUser) => optionUser.fold(
        () => null,
        (user) async {
          if (isNewTransaction) {
            await addTransaction(
              amount: state.transaction!.amount,
              date: state.transaction!.date,
              note: state.transaction!.note,
              txAccountId: state.transaction!.txAccountId!,
              txBudgetId: (state.transaction! as Expense).txBudgetId!,
              txCategoryId: state.transaction!.txCategoryId!,
              txType: TransactionType.values[1],
              txUserId: TransactionUserId(user.id.value),
              incomeType: IncomeType.values[1],
            );
          } else {
            await updateTransaction(
              transactionId: state.transaction!.id,
              amount: state.transaction!.amount,
              date: state.transaction!.date,
              note: state.transaction!.note,
              txAccountId: state.transaction!.txAccountId!,
              txBudgetId: (state.transaction! as Expense).txBudgetId!,
              txCategoryId: state.transaction!.txCategoryId!,
              userId: TransactionUserId(user.id.value),
              incomeType: IncomeType.values[1],
            );
          }
        },
      ),
    );
  }

  void onTransactionTypeChanged(int? index) {
    emit(
      state.copyWith(
        transaction: state.transaction!
          ..changeType(TransactionType.values[index!]),
      ),
    );
  }

  Future<void> onAmountUpdated(double newAmount) async {
    emit(
      state.copyWith(transaction: state.transaction!..updateAmount(newAmount)),
    );
  }

  void onAccountSelected(Account account) {
    emit(state.copyWith(account: some(account)));
  }

  Future<void> onCategorySelected(Category category) async {
    await getSubCategories(category.id).then(
      (option) => option.fold(
        () {},
        (subCategories) => emit(state.copyWith(subCategories: subCategories)),
      ),
    );
  }

  void onSubCategorySelected(SubCategory subCategory) {
    emit(state.copyWith(subCategory: some(subCategory)));
  }

  void onBudgetSelected(Budget budget) {
    emit(state.copyWith(budget: some(budget)));
  }

  void onDateUpdated(DateTime? newDate) {
    emit(state.copyWith(transaction: state.transaction!..updateDate(newDate!)));
  }

  void onNoteUpdated(String? newNote) {
    emit(state.copyWith(transaction: state.transaction!..updateNote(newNote!)));
  }
}
