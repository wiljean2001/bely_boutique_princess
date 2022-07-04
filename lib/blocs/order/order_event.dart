part of 'order_bloc.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object> get props => [];
}

class LoadAllOrder extends OrderEvent {}

class LoadOrderById extends OrderEvent {
  final String userId;

  const LoadOrderById({required this.userId});

  @override
  List<Object> get props => [userId];
}

class AddOrder extends OrderEvent {
  final Order order;

  const AddOrder({required this.order});

  @override
  List<Object> get props => [order];
}

class UpdateHome extends OrderEvent {
  final List<Order>? orders;
  final String? userId;

  const UpdateHome({required this.orders, required this.userId});

  @override
  List<Object> get props => [orders!, userId!];
}
//
class UpdateOrder extends OrderEvent {
  final Order order;

  const UpdateOrder({required this.order});

  @override
  List<Object> get props => [order];
}
