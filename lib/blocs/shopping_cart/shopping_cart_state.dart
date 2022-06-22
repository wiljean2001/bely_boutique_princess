part of 'shopping_cart_bloc.dart';

abstract class ShoppingCartState extends Equatable {
  const ShoppingCartState();
}

class ShoppingCartInitial extends ShoppingCartState {
  @override
  List<Object> get props => [];
}
