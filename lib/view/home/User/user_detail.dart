import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:smart_admin/model/users.dart';
import 'package:smart_admin/services/database.dart';
import 'package:smart_admin/view/home/User/switch_detail.dart';
import 'package:smart_admin/view/home/User/user_search.dart';
import 'package:smart_admin/widgets/widgets.dart';
import 'package:http/http.dart' as http;

class UserDetailPage extends StatelessWidget {
  final String label;
  final String path;
  const UserDetailPage({Key? key, required this.label, required this.path})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    return Scaffold(
      appBar: appBar(label),
      body: StreamBuilder<List<Users>?>(
        stream: database.getDataOfUsers(path),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return nothingToShow;
          } else if (snapshot.connectionState == ConnectionState.active &&
              snapshot.hasData) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: InkWell(
                    onTap: () async {
                      await showSearch(
                        context: context,
                        delegate: UserSearch(user: snapshot.data),
                      );
                    },
                    child: CupertinoSearchTextField(
                      enabled: false,
                      placeholder: "Search by email",
                      placeholderStyle: TextStyle(
                        fontFamily: GoogleFonts.montserrat().fontFamily,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      padding: const EdgeInsets.all(10),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SwitchDetail(
                                user: snapshot.data![index],
                              ),
                            ),
                          );
                        },
                        child: Column(
                          children: [
                            const Divider(),
                            Dismissible(
                              direction: DismissDirection.endToStart,
                              key: Key(snapshot.data![index].name),
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
                                  final res = await http.post(
                                    Uri.parse(
                                        "https://sdpadmin.herokuapp.com/deleteUser"),
                                    body: {
                                      "uid": snapshot.data![index].id,
                                    },
                                  );
                                  debugPrint(res.body.toString());
                                } catch (e) {
                                  debugPrint(e.toString());
                                }
                              },
                              child: ListTile(
                                title: Text(snapshot.data![index].name),
                                subtitle: Text(snapshot.data![index].email),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
