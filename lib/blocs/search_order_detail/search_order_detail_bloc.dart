import 'dart:async';

import 'package:bely_boutique_princess/models/models.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../repositories/repositories.dart';

part 'search_order_detail_event.dart';
part 'search_order_detail_state.dart';

class SearchOrderDetailBloc
    extends Bloc<SearchOrderDetailEvent, SearchOrderDetailState> {
  final DatabaseRepository _databaseRepository; // all user
  final OrderRepository _orderRepository; // all order
  final ProductRepository _productRepository; // all products
  StreamSubscription? _orderDSubscription;
  StreamSubscription? _userSubscription;
  StreamSubscription? _productSubscription;
  SearchOrderDetailBloc({
    required DatabaseRepository databaseRepository,
    required OrderRepository orderRepository,
    required ProductRepository productRepository,
  })  : _databaseRepository = databaseRepository,
        _orderRepository = orderRepository,
        _productRepository = productRepository,
        super(SearchOrderDetailLoading()) {
    on<SearchOrderDetailByUserID>(_onSearchOrderDetailByUserID);
    on<LoadSearchOrderDetail>(_onLoadSearchOrderDetail);
    on<LoadingSearchOrderDetail>(_onLoadingSearchOrderDetail);
  }

  void _onSearchOrderDetailByUserID(
    SearchOrderDetailByUserID event,
    Emitter<SearchOrderDetailState> emit,
  ) async {
    if (event.userID.isEmpty) return;
    try {
      _orderDSubscription =
          _orderRepository.getDetailsOrder(event.userID).listen(
        (orders) {
          _userSubscription =
              _databaseRepository.getUser(event.userID).listen((user) {
            _productSubscription = _productRepository.getAllProducts().listen(
              (listProducts) {
                add(
                  LoadSearchOrderDetail(
                    orderDetails: orders,
                    product: listProducts,
                    user: user,
                  ),
                );
                return;
              },
            );
          });
        },
      );
    } catch (e) {
      print(e);
    }
  }

  void _onLoadSearchOrderDetail(
    LoadSearchOrderDetail event,
    Emitter<SearchOrderDetailState> emit,
  ) async {
    emit(SearchOrderDetailLoaded(
      orderDetails: event.orderDetails,
      user: event.user,
      products: event.product,
    ));
  }

  void _onLoadingSearchOrderDetail(
    LoadingSearchOrderDetail event,
    Emitter<SearchOrderDetailState> emit,
  ) async {
    emit(SearchOrderDetailLoading());
  }

  @override
  Future<void> close() async {
    _userSubscription?.cancel();
    _orderDSubscription?.cancel();
    _productSubscription?.cancel();
    super.close();
  }
}
