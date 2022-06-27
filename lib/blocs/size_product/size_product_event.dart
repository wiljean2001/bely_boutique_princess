part of 'size_product_bloc.dart';

abstract class SizeProductEvent extends Equatable {
  const SizeProductEvent();

  @override
  List<Object> get props => [];
}

class LoadAllSizeProducts extends SizeProductEvent {}

class LoadSizeProducts extends SizeProductEvent {
  final String? typeProductId;

  const LoadSizeProducts({
    this.typeProductId = '',
  });
  // required this.userId,

  @override
  List<Object> get props => [typeProductId!];
  // typroduct id from SizeProduct and typeproduct
}

class UpdateSizeProducts extends SizeProductEvent {
  final List<SizeProduct> sizeProducts;

  const UpdateSizeProducts(this.sizeProducts);

  @override
  List<Object> get props => [sizeProducts];
}

class AddSizeProduct extends SizeProductEvent {
  final SizeProduct sizeProduct;

  const AddSizeProduct({
    required this.sizeProduct,
  });

  @override
  List<Object> get props => [sizeProduct];
}

class UpdateSizeProduct extends SizeProductEvent {
  final SizeProduct sizeProduct;
  final String typeProductId;

  const UpdateSizeProduct({
    required this.sizeProduct,
    required this.typeProductId,
  });

  @override
  List<Object> get props => [sizeProduct, typeProductId];
}
