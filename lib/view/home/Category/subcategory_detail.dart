import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_admin/model/devices.dart';
import 'package:smart_admin/services/database.dart';
import 'package:smart_admin/view/home/Category/edit_subcategory.dart';
import 'package:smart_admin/widgets/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SubCategoryDetail extends StatelessWidget {
  const SubCategoryDetail({Key? key, required this.label, required this.path})
      : super(key: key);
  final String path;
  final String label;

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: fontColor),
        title: Text(label, style: const TextStyle(color: fontColor)),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
              onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => EditSubCategory(
                        label: "Add $label",
                        database: database,
                        path: path,
                        fileSelected: false,
                      ),
                    ),
                  ),
              icon: const Icon(Icons.add)),
        ],
      ),
      body: StreamBuilder<List<Devices>?>(
        stream: database.getDevices(path),
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
                    InkWell(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditSubCategory(
                              label: "Edit $label",
                              database: database,
                              devices: snapshot.data![index],
                              path: path,
                              fileSelected: false,
                            ),
                          )),
                      child: Dismissible(
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
                            await database.deleteData(
                                snapshot.data![index], path);
                          } catch (e) {
                            debugPrint(e.toString());
                          }
                        },
                        child: ListTile(
                          title: Text(snapshot.data![index].name),
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
                              snapshot.data![index].iconLink,
                              color: kPrimaryColor,
                            ),
                          ),
                          subtitle: Text(snapshot.data![index].type),
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
