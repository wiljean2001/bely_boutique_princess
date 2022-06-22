part of 'product_bloc.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object> get props => [];
}

class LoadProducts extends ProductEvent {}

class UpdateProducts extends ProductEvent {
  final List<Product> products;

  const UpdateProducts(this.products);

  @override
  List<Object> get props => [products];
}

class AddProduct extends ProductEvent {
  final Product product;
  final List<XFile> images;

  const AddProduct({
    required this.product,
    required this.images,
  });

  @override
  List<Object> get props => [product, images];
}

class UpdateProduct extends ProductEvent {
  final Product product;

  const UpdateProduct({
    required this.product,
  });

  @override
  List<Object> get props => [product];
}

class UpdateProductImages extends ProductEvent {
  final List<XFile> image;

  const UpdateProductImages({
    required this.image,
  });

  @override
  List<Object> get props => [image];
}
