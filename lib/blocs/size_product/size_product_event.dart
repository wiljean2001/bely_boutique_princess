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
  final bool allSize;

  const UpdateSizeProducts(this.sizeProducts, this.allSize);

  @override
  List<Object> get props => [sizeProducts, allSize];
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

  const UpdateSizeProduct({
    required this.sizeProduct,
  });

  @override
  List<Object> get props => [sizeProduct];
}
class DeleteSizeProduct extends SizeProductEvent {
  final SizeProduct sizeProduct;

  const DeleteSizeProduct({
    required this.sizeProduct,
  });

  @override
  List<Object> get props => [sizeProduct];
}
