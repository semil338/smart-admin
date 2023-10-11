import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_admin/model/category.dart';
import 'package:smart_admin/services/database.dart';
import 'package:smart_admin/view/home/Category/subcategory_detail.dart';
import 'package:smart_admin/view/home/Category/edit_category.dart';
import 'package:smart_admin/widgets/widgets.dart';

class CategoryDetails extends StatelessWidget {
  const CategoryDetails({Key? key, required this.label, required this.path})
      : super(key: key);
  final String path;
  final String label;

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    return Scaffold(
      appBar: appBar(label),
      body: StreamBuilder<List<Category>?>(
        stream: database.getCategory(path),
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
                          builder: (context) => SubCategoryDetail(
                            label: snapshot.data![index].name,
                            path:
                                "category/${snapshot.data![index].id}/subCategory",
                          ),
                        ),
                      ),
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
                            await database.deleteCategory(
                                snapshot.data![index], path);
                          } catch (e) {
                            debugPrint(e.toString());
                          }
                        },
                        child: ListTile(
                          title: Text(snapshot.data![index].name),
                          subtitle: StreamBuilder<
                              QuerySnapshot<Map<String, dynamic>?>?>(
                            stream: database.getNumberOfUsers(
                                "category/${snapshot.data![index].id}/subCategory"),
                            builder: (context, snapshot) {
                              if (snapshot.data != null) {
                                return Text(
                                  "${snapshot.data!.size.toString()} Subcategory",
                                );
                              } else {
                                return const Text(
                                  "0",
                                );
                              }
                            },
                          ),
                          trailing: IconButton(
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditCategory(
                                  label: "Edit $label",
                                  category: snapshot.data![index],
                                  path: path,
                                ),
                              ),
                            ),
                            icon: const Icon(Icons.edit),
                          ),
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
