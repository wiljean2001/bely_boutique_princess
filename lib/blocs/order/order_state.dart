part of 'order_bloc.dart';

abstract class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object> get props => [];
}

class OrderLoading extends OrderState {}

class OrdersLoaded extends OrderState {
  final List<Order> order;

  const OrdersLoaded({required this.order});

  @override
  List<Object> get props => [order];
}

class OrderError extends OrderState {}
