part of 'type_product_bloc.dart';

abstract class TypeProductState extends Equatable {
  const TypeProductState();

  @override
  List<Object> get props => [];
}

class TypeProductLoading extends TypeProductState {}

class TypeProductsLoaded extends TypeProductState {
  final List<TypeProduct> typeProducts;

  const TypeProductsLoaded({this.typeProducts = const <TypeProduct>[]});

  @override
  List<Object> get props => [typeProducts];
}

class TypeProductLoaded extends TypeProductState {
  final TypeProduct typeProducts;

  const TypeProductLoaded({required this.typeProducts});

  @override
  List<Object> get props => [typeProducts];
}
