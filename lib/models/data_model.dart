import 'package:cloud_firestore/cloud_firestore.dart';
import './user_model.dart';

class Notify {
  final User ?sender;
  final Timestamp? time;
  final bool? isRead;

  Notify({
    this.sender,
    this.time,
    this.isRead,
  });
}
