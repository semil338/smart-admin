import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_admin/model/admin.dart';
import 'package:smart_admin/model/category.dart';
import 'package:smart_admin/model/devices.dart';
import 'package:smart_admin/model/rooms.dart';
import 'package:smart_admin/model/users.dart';
import 'package:uuid/uuid.dart';

String documentIdFromCurrentDate() => DateTime.now().toIso8601String();
String uuid() => const Uuid().v1().toString();

abstract class Database {
  Future<List<Admin>?> readAdminData();
  Stream<QuerySnapshot<Map<String, dynamic>?>?> getNumberOfUsers(String path);
  Stream<List<Devices>?> getDevices(String path);
  Stream<List<Users>?> getDataOfUsers(String path);
  Stream<List<Category>?> getCategory(String path);
  Stream<List<Room>?> getRooms(String path);
  Future<void> addDevices(Devices devices, String path);
  Future<void> addCategory(Category category, String path);
  Future<void> addRoom(Room room, String path);
  Future<void> deleteCategory(Category category, String path);
  Future<void> deleteRoom(Room room, String path);
  Future<void> deleteData(Devices device, String path);
}

class FirestoreDatabase implements Database {
  final firestore = FirebaseFirestore.instance;
  @override
  Future<List<Admin>?> readAdminData() async {
    final query = firestore.collection("Admin").get();
    return await query.then((snapshot) {
      if (snapshot.size != 0) {
        final result =
            snapshot.docs.map((e) => Admin.fromMap(e.data(), e.id)).toList();
        return result;
      }
    });
  }

  @override
  Stream<QuerySnapshot<Map<String, dynamic>?>?> getNumberOfUsers(String path) {
    return firestore.collection(path).snapshots();
  }

  @override
  Future<void> deleteData(Devices device, String path) async {
    await firestore.doc("$path/${device.id}/").delete();
  }

  @override
  Future<void> deleteCategory(Category category, String path) async {
    await firestore.doc("$path/${category.id}/").delete();
  }

  @override
  Future<void> deleteRoom(Room room, String path) async {
    await firestore.doc("$path/${room.id}/").delete();
  }

  @override
  Future<void> addDevices(Devices devices, String path) async {
    await firestore.doc("$path/${devices.id}/").set(devices.toMap());
  }

  @override
  Future<void> addCategory(Category category, String path) async {
    await firestore.doc("$path/${category.id}").set(category.toMap());
  }

  @override
  Future<void> addRoom(Room room, String path) async {
    await firestore.doc("$path/${room.id}").set(room.toMap());
  }

  @override
  Stream<List<Users>?> getDataOfUsers(String path) {
    final query = firestore.collection(path).snapshots();

    return query.map((snapshot) {
      if (snapshot.size != 0) {
        final result = snapshot.docs
            .map((snapshots) => Users.fromMap(snapshots.data(), snapshots.id))
            .toList();
        return result;
      } else {
        return null;
      }
    });
  }

  @override
  Stream<List<Devices>?> getDevices(String path) {
    final query = firestore.collection(path).snapshots();

    return query.map((snapshot) {
      if (snapshot.size != 0) {
        final result = snapshot.docs
            .map((snapshots) => Devices.fromMap(snapshots.data(), snapshots.id))
            .toList();
        return result;
      } else {
        return null;
      }
    });
  }

  @override
  Stream<List<Category>?> getCategory(String path) {
    final query = firestore.collection(path).snapshots();

    return query.map((snapshot) {
      if (snapshot.size != 0) {
        final result = snapshot.docs
            .map(
                (snapshots) => Category.fromMap(snapshots.data(), snapshots.id))
            .toList();
        return result;
      } else {
        return null;
      }
    });
  }

  @override
  Stream<List<Room>?> getRooms(String path) {
    final query = firestore.collection(path).snapshots();

    return query.map((snapshot) {
      if (snapshot.size != 0) {
        final result = snapshot.docs
            .map((snapshots) => Room.fromMap(snapshots.data(), snapshots.id))
            .toList();
        return result;
      } else {
        return null;
      }
    });
  }
}
