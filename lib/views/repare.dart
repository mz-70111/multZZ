import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mz_flutter_07/controllers/dbcontroller.dart';
import 'package:mz_flutter_07/controllers/maincontroller.dart';
import 'package:mz_flutter_07/models/basicinfo.dart';
import 'package:mz_flutter_07/models/database.dart';
import 'package:mz_flutter_07/models/sharedpref.dart';
import 'package:mz_flutter_07/views/login.dart';
import 'package:mz_flutter_07/views/wait.dart';

class RepairPage extends StatelessWidget {
  const RepairPage({super.key});

  @override
  Widget build(BuildContext context) {
    MainController mainController = Get.find();
    var test;
    DBController dbController = Get.find();
    return GetBuilder<DBController>(
      init: dbController,
      builder: (_) => Scaffold(
          body: FutureBuilder(
              future: Future.delayed(const Duration(seconds: 2), () async {
                try {
                  DB.allofficeinfotable =
                      await DBController().getallofficeinfo();
                  return test = await dbController.checkconnect();
                } catch (e) {
                  null;
                }
              }),
              builder: (_, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return const WaitMz();
                } else if (!snap.hasData) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text("لا يمكن الوصول للمخدم"),
                        IconButton(
                            onPressed: () {
                              dbController.update();
                            },
                            icon: const Icon(Icons.refresh)),
                      ],
                    ),
                  );
                } else {
                  return const LogIn();
                }
              })),
    );
  }
}
/*
            for web platform
    1. step- go to flutter\bin\cache and remove a file named: flutter_tools.stamp.
    2. step- go to flutter\packages\flutter_tools\lib\src\web and open the file chrome.dart.
    3. step- find '--disable-extensions' remove and add 4.step.
    4. step- add '--disable-web-security'
            */
