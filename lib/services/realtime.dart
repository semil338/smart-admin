import 'dart:async';
import 'package:firebase_database/firebase_database.dart';

abstract class Realtime {
  DatabaseReference getData(String uid, String roomId);
  Stream<Event> number(String uid, String roomId);
}

class RealtimeDatabase extends Realtime {
  final _databaseReference = FirebaseDatabase.instance.reference();

  @override
  Stream<Event> number(String uid, String roomId) {
    return _databaseReference
        .child("Switches")
        .child(uid)
        .child(roomId)
        .onValue;
  }

  @override
  DatabaseReference getData(String uid, String roomId) {
    return _databaseReference.child("Switches").child(uid).child(roomId);
  }
}
