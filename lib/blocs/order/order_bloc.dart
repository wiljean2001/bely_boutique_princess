import 'dart:async';

import 'package:bely_boutique_princess/models/order_model.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../repositories/repositories.dart';
import '../blocs.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final AuthBloc _authBloc;
  final OrderRepository _orderRepository;
  StreamSubscription? _authSubscription;

  OrderBloc({
    required AuthBloc authBloc,
    required OrderRepository orderRepository,
  })  : _authBloc = authBloc,
        _orderRepository = orderRepository,
        super(OrderLoading()) {
    on<LoadOrderById>(_onLoadOrderById);
    on<LoadAllOrder>(_onLoadAllOrders);
    on<UpdateOrder>(_onUpdateOrder);

    _authSubscription = _authBloc.stream.listen((state) {
      if (state.user is AuthUserChanged) {
        if (state.user != null) {
          add(LoadOrderById(userId: state.user!.uid));
        }
      }
    });
  }

  _onLoadOrderById(
    LoadOrderById event,
    Emitter<OrderState> emit,
  ) {}
  _onLoadAllOrders(
    LoadAllOrder event,
    Emitter<OrderState> emit,
  ) {}
  _onUpdateOrder(
    UpdateOrder event,
    Emitter<OrderState> emit,
  ) {}
}
