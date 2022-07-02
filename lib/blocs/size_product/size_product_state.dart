part of 'size_product_bloc.dart';

abstract class SizeProductState extends Equatable {
  const SizeProductState();

  @override
  List<Object> get props => [];
}

class SizeProductLoading extends SizeProductState {}

class SizeProductsLoaded extends SizeProductState {
  final List<SizeProduct> sizeProducts;

  const SizeProductsLoaded({
    this.sizeProducts = const <SizeProduct>[],
  });

  @override
  List<Object> get props => [sizeProducts];
}

class SizeAllProductsLoaded extends SizeProductState {
  final List<SizeProduct> sizeProducts;

  const SizeAllProductsLoaded({this.sizeProducts = const <SizeProduct>[]});

  @override
  List<Object> get props => [sizeProducts];
}

class SizeProductLoaded extends SizeProductState {
  final SizeProduct sizeProduct;

  const SizeProductLoaded({required this.sizeProduct});

  @override
  List<Object> get props => [sizeProduct];
}
