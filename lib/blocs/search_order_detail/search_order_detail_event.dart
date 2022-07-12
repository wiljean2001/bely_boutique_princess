part of 'search_order_detail_bloc.dart';

abstract class SearchOrderDetailEvent extends Equatable {
  const SearchOrderDetailEvent();

  @override
  List<Object> get props => [];
}
class LoadingSearchOrderDetail extends SearchOrderDetailEvent {}

class SearchOrderDetailByUserID extends SearchOrderDetailEvent {
  final String userID;

  const SearchOrderDetailByUserID({
    required this.userID,
  });
  @override
  List<Object> get props => [userID];
}


class LoadSearchOrderDetail extends SearchOrderDetailEvent {
  final List<OrderDetails> orderDetails;
  final User user;
  final List<Product> product;

  const LoadSearchOrderDetail({
    required this.orderDetails,
    required this.user,
    required this.product,
  });
  @override
  List<Object> get props => [orderDetails, product, user];
}
