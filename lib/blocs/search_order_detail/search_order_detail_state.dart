part of 'search_order_detail_bloc.dart';

abstract class SearchOrderDetailState extends Equatable {
  const SearchOrderDetailState();

  @override
  List<Object> get props => [];
}

class SearchOrderDetailLoading extends SearchOrderDetailState {}

class SearchOrderDetailLoaded extends SearchOrderDetailState {
  final List<OrderDetails> orderDetails;
  final User user;
  final List<Product> products;

  const SearchOrderDetailLoaded({
    required this.orderDetails,
    required this.user,
    required this.products,
  });
  @override
  List<Object> get props => [orderDetails, products, user];
}
