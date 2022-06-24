part of 'size_product_bloc.dart';

abstract class SizeProductEvent extends Equatable {
  const SizeProductEvent();

  @override
  List<Object> get props => [];
}

class LoadSizeProducts extends SizeProductEvent {}

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

  const UpdateSizeProduct({
    required this.sizeProduct,
  });

  @override
  List<Object> get props => [sizeProduct];
}
