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
  Future<void> updateOrder(Order order, String docId) async {
    await _firebaseFirestore.collection('orders').doc(docId).update(
          order.toMap(),
        );
  }
}
