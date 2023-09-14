// ignore_for_file: unused_local_variable, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mz_flutter_07/controllers/dbcontroller.dart';
import 'package:mz_flutter_07/controllers/maincontroller.dart';
import 'package:mz_flutter_07/models/basicinfo.dart';
import 'package:mz_flutter_07/models/bottonicon.dart';
import 'package:mz_flutter_07/models/database.dart';
import 'package:mz_flutter_07/views/homepage.dart';
import 'package:mz_flutter_07/views/login.dart';
import 'package:mz_flutter_07/views/wait.dart';

class RepairPage extends StatelessWidget {
  const RepairPage({super.key});
  static List? version;
  @override
  Widget build(BuildContext context) {
    MainController mainController = Get.find();

    DBController dbController = Get.find();
    return GetBuilder<DBController>(
      init: dbController,
      builder: (_) => Scaffold(
          body: FutureBuilder(
              future: Future.delayed(const Duration(seconds: 2), () async {
                try {
                  DB.allofficeinfotable =
                      await DBController().getallofficeinfo();
                  return await dbController.getversion();
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
                  if (version![0] == BasicInfo.version) {
                    return const LogIn();
                  } else {
                    List actionlist = [
                      {
                        'elevate': 0.0,
                        'label': ['تخطي', 'skip'],
                        'index': 0
                      }
                    ];
                    return Scaffold(
                      body: Center(
                        child: GetBuilder<MainController>(
                          init: mainController,
                          builder: (_) => Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text([
                                'يتوفر إصدار جديد',
                                'new version is availble'
                              ][BasicInfo.indexlang()]),
                              InkWell(
                                child: Text(
                                  "http://192.168.30.8",
                                  style: TextStyle(
                                      fontFamily: 'Changa', fontSize: 25),
                                ),
                                onTap: () {
                                  mainController.urllaunch(
                                      url: "http://192.168.30.8");
                                },
                              ),
                              ...actionlist.map((ibm) => IconbuttonMz(
                                  width: 80,
                                  height: 35,
                                  e: ibm,
                                  action: (ibm) {
                                    Future(() => Get.offNamed('/login'));
                                    return LogIn();
                                  },
                                  label: ibm['label'],
                                  buttonlist: actionlist,
                                  index: ibm['index']))
                            ],
                          ),
                        ),
                      ),
                    );
                  }
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
