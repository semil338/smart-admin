import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_admin/services/database.dart';
import 'package:smart_admin/view/home/Category/category_detail.dart';
import 'package:smart_admin/view/home/Rooms/room_detail.dart';
import 'package:smart_admin/view/home/User/user_detail.dart';
import 'package:smart_admin/widgets/widgets.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: GridView(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            children: const <Widget>[
              GridCards(
                icon: Icons.people_outline,
                label: "Users",
                text: "user",
                onTap: UserDetailPage(
                  label: "Users",
                  path: "user",
                ),
              ),
              GridCards(
                icon: Icons.people_outline,
                label: "Admin",
                text: "Admin",
                onTap: UserDetailPage(
                  label: "Admin",
                  path: "Admin",
                ),
              ),
              GridCards(
                icon: Icons.category,
                label: "Category",
                text: "category",
                onTap: CategoryDetails(
                  label: "Category",
                  path: "category",
                ),
              ),
              GridCards(
                icon: Icons.room_outlined,
                label: "Rooms",
                text: "room",
                onTap: RoomDetails(
                  label: "Rooms",
                  path: "room",
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class GridCards extends StatelessWidget {
  const GridCards({
    Key? key,
    required this.text,
    required this.icon,
    required this.label,
    required this.onTap,
  }) : super(key: key);
  final String text;
  final IconData icon;
  final String label;
  final Widget onTap;

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Card(
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>?>?>(
          stream: database.getNumberOfUsers(text),
          builder: (context, snapshot) {
            return InkWell(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => onTap,
              )),
              child: Column(
                children: [
                  const SizedBox(height: 5),
                  TextButton.icon(
                    onPressed: null,
                    icon: Icon(
                      icon,
                      color: notActive,
                    ),
                    label: Text(
                      label,
                      style: TextStyle(color: notActive),
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (snapshot.data != null)
                    Expanded(
                      child: Text(
                        snapshot.data!.size.toString(),
                        textAlign: TextAlign.center,
                        style:
                            const TextStyle(color: fontColor, fontSize: 40.0),
                      ),
                    )
                  else
                    const Text(
                      "0",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: fontColor, fontSize: 40.0),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
