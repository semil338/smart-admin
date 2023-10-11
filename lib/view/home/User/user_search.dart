import 'package:flutter/material.dart';
import 'package:smart_admin/model/users.dart';
import 'package:smart_admin/view/home/User/switch_detail.dart';

class UserSearch extends SearchDelegate<Users?> {
  final List<Users>? user;
  List<Users>? search;
  UserSearch({required this.user});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        tooltip: 'Clear',
        icon: const Icon(Icons.clear),
        onPressed: () => query = '',
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      tooltip: 'Back',
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Text(query);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // search = user;
    if (query.isNotEmpty) {
      search = user!
          .where((el) => el.email.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    return query.isNotEmpty
        ? ListView.builder(
            itemCount: search!.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SwitchDetail(
                        user: search![index],
                      ),
                    ),
                  );
                },
                child: ListTile(
                  title: Text(search![index].name),
                  subtitle: Text(search![index].email),
                ),
              );
            },
          )
        : const Text("");
  }
}
