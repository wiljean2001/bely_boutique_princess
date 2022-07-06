import 'package:bely_boutique_princess/models/order_details_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/order_model.dart';
import '../repositories.dart';
import '/models/order_model.dart';

class OrderRepository extends BaseOrderRepository {
  final FirebaseFirestore _firebaseFirestore;

  OrderRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Stream<List<Order>> getAllOrders() {
    return _firebaseFirestore.collection('orders').snapshots().map(
      (snapshot) {
        return snapshot.docs.map((doc) => Order.fromSnapshot(doc)).toList();
      },
    );
  }

  @override
  Stream<List<Order>> getOrders(String userId) {
    return _firebaseFirestore
        .collection('orders')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snap) {
      return snap.docs.map((doc) => Order.fromSnapshot(doc)).toList();
    });
  }

  @override
  Stream<Order> getOrder(String orderId) {
    return _firebaseFirestore.collection('orders').doc(orderId).snapshots().map(
          (snap) => Order.fromSnapshot(snap),
        );
  }

  @override
  Future<void> createOrder(Order order) async {
    await _firebaseFirestore.collection('orders').doc().set(
          order.toMap(),
        );
  }

  @override
  Stream<List<OrderDetails>> getAllDetailsOrder() {
    return _firebaseFirestore.collection('orderDetails').snapshots().map(
      (snapshot) {
        return snapshot.docs
            .map((doc) => OrderDetails.fromSnapshot(doc))
            .toList();
      },
    );
  } // get all orders detail

  @override
  Stream<List<OrderDetails>> getDetailsOrder(String userId) {
    return _firebaseFirestore
        .collection('orderDetails')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snap) {
      return snap.docs.map((doc) => OrderDetails.fromSnapshot(doc)).toList();
    });
  } // get list order detail by userid

  @override
  Stream<OrderDetails> getDetailOrder(String orderDetailId) {
    return _firebaseFirestore
        .collection('orderDetails')
        .doc(orderDetailId)
        .snapshots()
        .map(
          (snap) => OrderDetails.fromSnapshot(snap),
        );
  } // get one order

  @override
  Future<void> createDetailOrder(OrderDetails orderDetail) async {
    await _firebaseFirestore.collection('orderDetails').doc().set(
          orderDetail.toMap(),
        );
  } // create new order detail

  @override
  Future<void> deleteOrderDetail(String orderDetailId) async {
    await _firebaseFirestore
        .collection('orderDetails')
        .doc(orderDetailId)
        .delete();
  } // update one order detail
  // @override
  // Future<void> updateOrder(Order order, String docId) async {
  //   await _firebaseFirestore.collection('orders').doc(docId).update(
  //         order.toMap(),
  //       );
  // }
}
