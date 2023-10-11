import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:smart_admin/services/realtime.dart';
import 'package:smart_admin/widgets/widgets.dart';

class ShowSwitches extends StatelessWidget {
  const ShowSwitches({Key? key, required this.uId, required this.roomId})
      : super(key: key);
  final String uId;
  final String roomId;

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<Realtime>(context, listen: false);

    return Scaffold(
      appBar: appBar("Switches"),
      body: FirebaseAnimatedList(
        query: db.getData(uId, roomId),
        itemBuilder: (context, snapshot, animation, index) {
          if (snapshot.value != null) {
            return Column(
              children: [
                const Divider(),
                ListTile(
                  title: Text(snapshot.value["name"]),
                  leading: Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                      ),
                    ),
                    child: SvgPicture.network(
                      snapshot.value["iconLink"],
                      color: kPrimaryColor,
                    ),
                  ),
                  subtitle: Text(snapshot.value["type"]),
                ),
              ],
            );
          } else {
            return nothingToShow;
          }
        },
      ),
    );
  }
}
