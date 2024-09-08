import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final subscribeChannelProvider = Provider((ref) => Subscribe(firestore: FirebaseFirestore.instance));

class Subscribe {
  final FirebaseFirestore firestore;

  Subscribe({required this.firestore});

  Future<void> subscribeChannel({
    required String userId,
    required String currentUserId,
    required List<String> subscriptions,
  }) async {
    try {
      if (subscriptions.contains(currentUserId)) {
        // User is already subscribed; remove subscription
        await firestore.collection("users").doc(userId).update({
          "subscription": FieldValue.arrayRemove([currentUserId]),
        });
      } else {
        // User is not subscribed; add subscription
        await firestore.collection("users").doc(userId).update({
          "subscription": FieldValue.arrayUnion([currentUserId]),
        });
      }
    } catch (e) {
      print('Error updating subscriptions: $e');
    }
  }
}
