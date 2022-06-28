part of 'category_bloc.dart';

abstract class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object> get props => [];
}

class LoadCategories extends CategoryEvent {
  final String? typeProductId;

  const LoadCategories({this.typeProductId = ''});

  @override
  List<Object> get props => [typeProductId!];
}

class UpdateCategories extends CategoryEvent {
  final List<Category> categories;

  const UpdateCategories(this.categories);

  @override
  List<Object> get props => [categories];
}

class AddCategory extends CategoryEvent {
  final Category category;
  final XFile image;

  const AddCategory({required this.category, required this.image});

  @override
  List<Object> get props => [category, image];
}

class UpdateCategory extends CategoryEvent {
  final Category category;
  final String? historyTypeProductId;
  final XFile? image;

  const UpdateCategory({
    required this.category,
    required this.historyTypeProductId,
    this.image,
  });

  @override
  List<Object> get props => [category, historyTypeProductId!];
}

class DeleteCategory extends CategoryEvent {
  final Category category;

  const DeleteCategory({
    required this.category,
  });

  @override
  List<Object> get props => [category];
}
