import '../../models/order_details_model.dart';
import '../../models/order_model.dart';

abstract class BaseOrderRepository {
  Stream<List<Order>> getAllOrders(); // get all orders
  Stream<List<Order>> getOrders(String userId); // get list order by userid
  Stream<Order> getOrder(String orderId); // get one order
  Future<void> createOrder(Order order); // create new order
  Stream<List<OrderDetails>> getAllDetailsOrder(); // get all orders detail
  Stream<List<OrderDetails>> getDetailsOrder(
      String userId); // get list order detail by userid
  Stream<OrderDetails> getDetailOrder(String orderDetailId); // get one order
  Future<void> createDetailOrder(
      OrderDetails orderDetail); // create new order detail
  Future<void> deleteOrderDetail(String orderDetailId); // update one order detail
  // Future<void> updateOrder(Order order, String docId); // update one order detail
}
