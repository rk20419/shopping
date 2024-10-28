import 'dart:math';

// For Generate random order id  you can also use uuid package

String generateOrderId() {
  DateTime now = DateTime.now();

  int randomNumbers = Random().nextInt(99999);
  String id = '${now.microsecondsSinceEpoch}_$randomNumbers';
  return id;
}
