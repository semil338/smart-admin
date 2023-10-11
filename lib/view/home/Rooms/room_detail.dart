import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_admin/model/rooms.dart';
import 'package:smart_admin/services/database.dart';
import 'package:smart_admin/view/home/Rooms/edit_room.dart';
import 'package:smart_admin/widgets/widgets.dart';

class RoomDetails extends StatelessWidget {
  const RoomDetails({Key? key, required this.label, required this.path})
      : super(key: key);
  final String path;
  final String label;
  @override
  Widget build(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    return Scaffold(
      appBar: appBar(label),
      body: StreamBuilder<List<Room>?>(
        stream: database.getRooms(path),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return nothingToShow;
          } else if (snapshot.connectionState == ConnectionState.active) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    const Divider(),
                    Dismissible(
                      key: Key(snapshot.data![index].name),
                      direction: DismissDirection.endToStart,
                      background: Container(color: Colors.red),
                      confirmDismiss: (direction) async {
                        return await showAlertDialog(
                          context,
                          title: "Alert",
                          content: "Are you sure you want to delete?",
                          cancelActionText: "Cancel",
                        );
                      },
                      onDismissed: (direction) async {
                        try {
                          await database.deleteRoom(
                              snapshot.data![index], path);
                        } catch (e) {
                          debugPrint(e.toString());
                        }
                      },
                      child: ListTile(
                        title: Text(snapshot.data![index].name),
                        leading: SizedBox(
                          height: 50,
                          width: 50,
                          child: CachedNetworkImage(
                            imageUrl: snapshot.data![index].iconLink,
                          ),
                        ),
                        trailing: IconButton(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditRoom(
                                label: "Edit $label",
                                room: snapshot.data![index],
                                path: path,
                                fileSelected: false,
                              ),
                            ),
                          ),
                          icon: const Icon(Icons.edit),
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
