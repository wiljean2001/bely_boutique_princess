part of 'category_bloc.dart';

abstract class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object> get props => [];
}

class LoadCategories extends CategoryEvent {}

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

  const UpdateCategory({
    required this.category,
  });

  @override
  List<Object> get props => [category];
}

// class DeleteCategory extends CategoryEvent {
//   final Category category;

//   const DeleteCategory({
//     required this.category,
//   });

//   @override
//   List<Object> get props => [category];
// }
