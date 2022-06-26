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
    on<UpdateHome>(_onUpdateHome);
    on<UpdateOrder>(_onUpdateOrder);

    _authSubscription = _authBloc.stream.listen((state) {
      if (state.user is AuthUserChanged) {
        if (state.user != null) {
          add(LoadOrderById(userId: state.user!.uid));
        }
      }
    });
  }

  void _onLoadOrderById(
    LoadOrderById event,
    Emitter<OrderState> emit,
  ) {
    _authSubscription = _orderRepository.getOrders(event.userId).listen(
      (orders) {
        //event.userId,
        print('ORDER');
        print('$orders');
        add(
          UpdateHome(orders: orders, userId: event.userId),
        );
      },
    );
  }

  void _onLoadAllOrders(
    LoadAllOrder event,
    Emitter<OrderState> emit,
  ) {}

  void _onUpdateHome(
    UpdateHome event,
    Emitter<OrderState> emit,
  ) {
    if (event.orders != null) {
      emit(OrdersLoaded(order: event.orders!));
    } else {
      emit(OrderError());
    }
  }

  void _onUpdateOrder(
    UpdateOrder event,
    Emitter<OrderState> emit,
  ) {}
}
