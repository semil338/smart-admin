import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_admin/services/auth.dart';
import 'package:smart_admin/view/home/Category/edit_category.dart';
import 'package:smart_admin/view/home/Rooms/edit_room.dart';
import 'package:smart_admin/widgets/widgets.dart';

class Manage extends StatelessWidget {
  const Manage({Key? key}) : super(key: key);

  _signOut(BuildContext context) async {
    final auth = Provider.of<AuthBase>(context, listen: false);
    try {
      final val = await showAlertDialog(
        context,
        title: "Logout",
        content: "Are u sure u want to logout?",
        cancelActionText: "Cancel",
      );
      if (val) {
        auth.signOut();
      }
    } on FirebaseAuthException catch (e) {
      showAlertDialog(
        context,
        title: "Error",
        content: e.message.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        ListTile(
          leading: const Icon(Icons.add_circle),
          title: const Text("Add Category"),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const EditCategory(
                  label: "Add Category",
                  path: "category",
                ),
              ),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.add_circle),
          title: const Text("Add Rooms"),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const EditRoom(
                label: "Add Room",
                path: 'room',
                fileSelected: false,
              ),
            ),
          ),
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.logout),
          title: const Text("Log Out"),
          onTap: () => _signOut(context),
        ),
        const Divider(),
      ],
    );
  }
}
