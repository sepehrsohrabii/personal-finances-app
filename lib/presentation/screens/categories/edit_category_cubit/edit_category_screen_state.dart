part of 'edit_category_screen_cubit.dart';

class EditCategoryScreenState {
  final Category? category;
  final List<SubCategory>? subCategories;
  final bool isLoading;
  final bool isEditMode;

  EditCategoryScreenState({
    this.category,
    this.subCategories,
    required this.isLoading,
    required this.isEditMode,
  });

  factory EditCategoryScreenState.initial() => EditCategoryScreenState(
        isLoading: false,
        isEditMode: true,
      );

  EditCategoryScreenState copyWith({
    Category? category,
    List<SubCategory>? subCategories,
    bool? isLoading,
    bool? isEditMode,
  }) {
    return EditCategoryScreenState(
      category: category ?? this.category,
      subCategories: subCategories ?? this.subCategories,
      isLoading: isLoading ?? this.isLoading,
      isEditMode: isEditMode ?? this.isEditMode,
    );
  }
}
