import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/order_details_model.dart';
import '../../repositories/order/order_repository.dart';
import '../blocs.dart';

part 'order_detail_event.dart';
part 'order_detail_state.dart';

class OrderDetailBloc extends Bloc<OrderDetailEvent, OrderDetailState> {
  final AuthBloc _authBloc;
  final OrderRepository _orderRepository;
  StreamSubscription? _authSubscription;

  OrderDetailBloc({
    required AuthBloc authBloc,
    required OrderRepository orderRepository,
  })  : _authBloc = authBloc,
        _orderRepository = orderRepository,
        super(OrderDetailLoading()) {
    on<LoadOrderDetailById>(_onLoadOrderDetailById);
    on<LoadAllOrderDetails>(_onLoadAllOrderDetails);
    on<AddOrderDetail>(_onAddOrderDetail);
    on<DeleteOrderDetail>(_onDeleteOrderDetail);
    on<UpdateHomeOrderDetail>(_onUpdateHomeOrderDetail);
  }

  void _onLoadOrderDetailById(
    LoadOrderDetailById event,
    Emitter<OrderDetailState> emit,
  ) {
    _authSubscription = _orderRepository.getDetailsOrder(event.userId).listen(
      (orders) {
        add(
          UpdateHomeOrderDetail(orders: orders, userId: event.userId),
        );
      },
    );
  }
  void _onLoadAllOrderDetails(
    LoadAllOrderDetails event,
    Emitter<OrderDetailState> emit,
  ) {}

  void _onAddOrderDetail(
    AddOrderDetail event,
    Emitter<OrderDetailState> emit,
  ) async {
    final state = this.state;
    if (state is OrderDetailsLoaded) {
      await _orderRepository.createDetailOrder(
        event.order,
      ); // add order details
    }
  }

  void _onDeleteOrderDetail(
    DeleteOrderDetail event,
    Emitter<OrderDetailState> emit,
  ) async {
    final state = this.state;
    if (state is OrderDetailsLoaded) {
      await _orderRepository.deleteOrderDetail(
        event.orderId,
      ); // add order details
    }
  }

  void _onUpdateHomeOrderDetail(
    UpdateHomeOrderDetail event,
    Emitter<OrderDetailState> emit,
  ) {
    emit(OrderDetailsLoaded(orders: event.orders!));
  }

  @override
  Future<void> close() async {
    _authSubscription?.cancel();
    super.close();
  }
}
