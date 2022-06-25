part of 'order_bloc.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object> get props => [];
}

class LoadOrderById extends OrderEvent {
  final String userId;

  const LoadOrderById({required this.userId});

  @override
  List<Object> get props => [userId];
}

class LoadAllOrder extends OrderEvent {}

class UpdateOrder extends OrderEvent {
  final Order order;

  const UpdateOrder({required this.order});

  @override
  List<Object> get props => [order];
}
