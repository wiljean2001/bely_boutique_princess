import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/size_model.dart';
import '../../repositories/size/size_product_repository.dart';

part 'size_product_event.dart';
part 'size_product_state.dart';

class SizeProductBloc extends Bloc<SizeProductEvent, SizeProductState> {
  final SizeProductRepository _sizeProductRepository;
  StreamSubscription? _sizeProductSubscription;

  SizeProductBloc({
    required SizeProductRepository sizeProductRepository,
  })  : _sizeProductRepository = sizeProductRepository,
        super(SizeProductLoading()) {
    on<LoadAllSizeProducts>(_onLoadAllSizeProducts);
    on<LoadSizeProducts>(_onLoadSizeProducts);
    on<UpdateSizeProducts>(_onUpdateSizeProducts);
    on<AddSizeProduct>(_onAddSizeProduct);
    on<UpdateSizeProduct>(_onUpdateSizeProduct);
    on<DeleteSizeProduct>(_onDeleteSizeProduct);
  }

  void _onLoadAllSizeProducts(
    LoadAllSizeProducts event,
    Emitter<SizeProductState> emit,
  ) {
    _sizeProductSubscription?.cancel();
    _sizeProductSubscription =
        _sizeProductRepository.getAllSizeProducts().listen(
              (typProducts) => add(
                UpdateSizeProducts(typProducts),
              ),
            );
  }

  void _onLoadSizeProducts(
    LoadSizeProducts event,
    Emitter<SizeProductState> emit,
  ) {
    _sizeProductSubscription?.cancel();
    _sizeProductSubscription =
        _sizeProductRepository.getSizeProducts(event.typeProductId!).listen(
              (typProducts) => add(
                UpdateSizeProducts(typProducts),
              ),
            );
  }

  void _onUpdateSizeProducts(
    UpdateSizeProducts event,
    Emitter<SizeProductState> emit,
  ) {
    emit(SizeProductsLoaded(sizeProducts: event.sizeProducts));
  }

  void _onAddSizeProduct(
    AddSizeProduct event,
    Emitter<SizeProductState> emit,
  ) async {
    final state = this.state;
    if (state is SizeProductsLoaded) {
      await _sizeProductRepository.createSizeProduct(event.sizeProduct);
    }
  }

  void _onUpdateSizeProduct(
    UpdateSizeProduct event,
    Emitter<SizeProductState> emit,
  ) async {
    final state = this.state;
    if (state is SizeProductsLoaded) {
      await _sizeProductRepository.updateSizeProduct(event.sizeProduct);
      add(const LoadSizeProducts(typeProductId: ''));
    }
  }

  void _onDeleteSizeProduct(
    DeleteSizeProduct event,
    Emitter<SizeProductState> emit,
  ) async {
    final state = this.state;
    if (state is SizeProductsLoaded) {
      await _sizeProductRepository.deleteSizeProduct(event.sizeProduct);
    }
  }

  @override
  Future<void> close() {
    _sizeProductSubscription?.cancel();
    return super.close();
  }
}
