import '../../models/order_model.dart';

abstract class BaseOrderRepository {
  Stream<List<Order>> getAllOrders(); // get all orders
  Stream<List<Order>> getOrders(String userId); // get list order by userid
  Stream<Order> getOrder(String orderId); // get one order
  Future<void> createOrder(Order order); // create new order
  Future<void> updateOrder(Order order, String docId); // update one order
}
