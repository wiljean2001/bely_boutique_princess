import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/type_product_model.dart';
import '../../repositories/type_product/type_product_repository.dart';

part 'type_product_event.dart';
part 'type_product_state.dart';

class TypeProductBloc extends Bloc<TypeProductEvent, TypeProductState> {
  final TypeProductRepository _typeProductRepository;
  StreamSubscription? _typeProductSubscription;

  TypeProductBloc({
    required TypeProductRepository typeProductRepository,
  })  : _typeProductRepository = typeProductRepository,
        super(TypeProductLoading()) {
    on<LoadTypeProducts>(_onLoadTypeProducts);
    on<UpdateTypeProducts>(_onUpdateTypeProducts);
    on<AddTypeProduct>(_onAddTypeProduct);
    on<UpdateTypeProduct>(_onUpdateTypeProduct);
  }
  
  void _onLoadTypeProducts(
    LoadTypeProducts event,
    Emitter<TypeProductState> emit,
  ) {
    _typeProductSubscription?.cancel();
    _typeProductSubscription =
        _typeProductRepository.getAllTypeProducts().listen(
              (typProducts) => add(
                UpdateTypeProducts(typProducts),
              ),
            );
  }

  void _onUpdateTypeProducts(
    UpdateTypeProducts event,
    Emitter<TypeProductState> emit,
  ) {
    emit(TypeProductsLoaded(typeProducts: event.typeProducts));
  }

  void _onAddTypeProduct(
    AddTypeProduct event,
    Emitter<TypeProductState> emit,
  ) async {
    final state = this.state;
    if (state is TypeProductsLoaded) {
      await _typeProductRepository.createTypeProduct(event.typeProducts);
    }
  }

  void _onUpdateTypeProduct(
    UpdateTypeProduct event,
    Emitter<TypeProductState> emit,
  ) async {
    final state = this.state;
    if (state is TypeProductsLoaded) {
      await _typeProductRepository.updateTypeProduct(event.typeProducts, '');
      add(LoadTypeProducts());
    }
  }

  @override
  Future<void> close() {
    _typeProductSubscription?.cancel();
    return super.close();
  }
}
