import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_admin/model/rooms.dart';
import 'package:smart_admin/model/users.dart';
import 'package:smart_admin/services/database.dart';
import 'package:smart_admin/services/realtime.dart';
import 'package:smart_admin/view/home/User/show_switch.dart';
import 'package:smart_admin/widgets/widgets.dart';
import 'package:http/http.dart' as http;

class SwitchDetail extends StatelessWidget {
  final Users user;

  const SwitchDetail({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    final db = Provider.of<Realtime>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: fontColor),
        title: const Text("User", style: TextStyle(color: fontColor)),
        actions: [
          IconButton(
            onPressed: () async {
              final value = await showAlertDialog(
                context,
                title: "Alert",
                content: "Are you sure you want to delete?",
                cancelActionText: "Cancel",
              );
              if (value) {
                try {
                  final res = await http.post(
                    Uri.parse("https://sdpadmin.herokuapp.com/deleteUser"),
                    body: {
                      "uid": user.id,
                    },
                  );
                  Navigator.pop(context);
                  debugPrint(res.body.toString());
                } catch (e) {
                  debugPrint(e.toString());
                }
              }
            },
            icon: const Icon(Icons.delete),
          ),
        ],
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Column(
              children: [
                const Divider(),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      const Text(
                        "Name : ",
                        style: TextStyle(fontSize: 16),
                      ),
                      Expanded(
                        child: Text(
                          user.name,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      const Text(
                        "Email : ",
                        style: TextStyle(fontSize: 16),
                      ),
                      Expanded(
                        child: Text(
                          user.email,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                const Text(
                  "Switches : ",
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
            Expanded(
              child: StreamBuilder<List<Room>?>(
                stream: database.getRooms("room"),
                builder: (context, snapshot) {
                  if (snapshot.data == null) {
                    return nothingToShow;
                  } else if (snapshot.connectionState ==
                      ConnectionState.active) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ShowSwitches(
                                  roomId: snapshot.data![index].id,
                                  uId: user.id,
                                ),
                              )),
                          child: Column(
                            children: [
                              const Divider(),
                              ListTile(
                                title: Text(snapshot.data![index].name),
                                subtitle: StreamBuilder<Event>(
                                  stream: db.number(
                                      user.id, snapshot.data![index].id),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    }
                                    if (snapshot.data!.snapshot.exists) {
                                      return Text(
                                          "${snapshot.data!.snapshot.value!.length} Switch");
                                    } else {
                                      return const Text("0 Switch");
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
