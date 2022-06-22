import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import '../../repositories/storage/storage_repository.dart';
import '/models/models.dart';
import '/repositories/category/category_repository.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryRepository _categoryRepository;
  final StorageRepository _storageRepository;
  StreamSubscription? _categorySubscription;

  CategoryBloc({
    required CategoryRepository categoryRepository,
    required StorageRepository storageRepository,
  })  : _categoryRepository = categoryRepository,
        _storageRepository = storageRepository,
        super(CategoryLoading()) {
    on<LoadCategories>(_onLoadCategories);
    on<UpdateCategories>(_onUpdateCategories);
    on<AddCategory>(_onAddCategory);
    on<UpdateCategory>(_onUpdateCategory);
    // on<DeleteCategory>(_onDeleteCategory);
  }

  void _onLoadCategories(
    LoadCategories event,
    Emitter<CategoryState> emit,
  ) {
    _categorySubscription?.cancel();
    _categorySubscription = _categoryRepository.getAllCategories().listen(
          (products) => add(
            UpdateCategories(products),
          ),
        );
  }

  void _onUpdateCategories(
    UpdateCategories event,
    Emitter<CategoryState> emit,
  ) {
    emit(
      CategoryLoaded(categories: event.categories),
    );
  }

  void _onAddCategory(
    AddCategory event,
    Emitter<CategoryState> emit,
  ) async {
    final state = this.state;
    if (state is CategoryLoaded) {
      await _categoryRepository.createCategory(event.category).then(
            (categoryId) async => await _storageRepository.uploadImageCategory(
              event.image,
              categoryId,
            ),
          );
    }
    add(LoadCategories());
  }

  // void _onDeleteCategory(
  //   DeleteCategory event,
  //   Emitter<CategoryState> emit,
  // ) {
  //   final state = this.state;
  //   if (state is CategoryLoaded) {
  //     //
  //   }
  // }

  void _onUpdateCategory(
    UpdateCategory event,
    Emitter<CategoryState> emit,
  ) async {
    final state = this.state;
    if (state is CategoryLoaded) {
      await _categoryRepository.updateCategory(event.category, '');
      add(LoadCategories());
    }
  }
}
