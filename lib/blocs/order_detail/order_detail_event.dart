part of 'order_detail_bloc.dart';

abstract class OrderDetailEvent extends Equatable {
  const OrderDetailEvent();

  @override
  List<Object> get props => [];
}

class LoadAllOrderDetails extends OrderDetailEvent {}

class LoadOrderDetailById extends OrderDetailEvent {
  final String userId;

  const LoadOrderDetailById({required this.userId});

  @override
  List<Object> get props => [userId];
}

class UpdateHomeOrderDetail extends OrderDetailEvent {
  final List<OrderDetails>? orders;
  final String? userId;

  const UpdateHomeOrderDetail({required this.orders, required this.userId});

  @override
  List<Object> get props => [orders!, userId!];
}

class AddOrderDetail extends OrderDetailEvent {
  final OrderDetails order;

  const AddOrderDetail({required this.order});

  @override
  List<Object> get props => [order];
}
