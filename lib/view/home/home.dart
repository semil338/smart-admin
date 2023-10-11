import 'package:flutter/material.dart';
import 'package:smart_admin/view/home/Tabs/dashboard.dart';
import 'package:smart_admin/view/home/Tabs/manage.dart';
import 'package:smart_admin/widgets/widgets.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            labelPadding: EdgeInsets.all(10),
            labelColor: fontColor,
            indicatorColor: fontColor,
            indicatorWeight: 3,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Text(
                "Dashboard",
                textScaleFactor: 1.5,
              ),
              Text(
                "Manage",
                textScaleFactor: 1.5,
              )
            ],
          ),
          title: const Text(
            "Admin Home",
            style: TextStyle(
              color: fontColor,
            ),
          ),
          centerTitle: true,
          elevation: 0.0,
          backgroundColor: Colors.white,
        ),
        body: const TabBarView(
          children: [
            Dashboard(),
            Manage(),
          ],
        ),
      ),
    );
  }
}
