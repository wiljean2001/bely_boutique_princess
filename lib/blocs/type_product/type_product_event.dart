part of 'type_product_bloc.dart';

abstract class TypeProductEvent extends Equatable {
  const TypeProductEvent();

  @override
  List<Object> get props => [];
}

class LoadTypeProducts extends TypeProductEvent {}

class UpdateTypeProducts extends TypeProductEvent {
  final List<TypeProduct> typeProducts;

  const UpdateTypeProducts(this.typeProducts);

  @override
  List<Object> get props => [typeProducts];
}

class AddTypeProduct extends TypeProductEvent {
  final TypeProduct typeProducts;

  const AddTypeProduct({
    required this.typeProducts,
  });

  @override
  List<Object> get props => [typeProducts];
}

class UpdateTypeProduct extends TypeProductEvent {
  final TypeProduct typeProduct;

  const UpdateTypeProduct({
    required this.typeProduct,
  });

  @override
  List<Object> get props => [typeProduct];
}
class DeleteTypeProduct extends TypeProductEvent {
  final TypeProduct typeProducts;

  const DeleteTypeProduct({
    required this.typeProducts,
  });

  @override
  List<Object> get props => [typeProducts];
}
