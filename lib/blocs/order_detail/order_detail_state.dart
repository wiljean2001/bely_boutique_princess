part of 'order_detail_bloc.dart';

abstract class OrderDetailState extends Equatable {
  const OrderDetailState();

  @override
  List<Object> get props => [];
}

class OrderDetailLoading extends OrderDetailState {}

class OrderDetailsLoaded extends OrderDetailState {
  final List<OrderDetails> orders;

  const OrderDetailsLoaded({required this.orders});

  @override
  List<Object> get props => [orders];
}

class OrderError extends OrderDetailState {}
