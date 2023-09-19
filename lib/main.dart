// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mz_flutter_07/controllers/dbcontroller.dart';
import 'package:mz_flutter_07/controllers/maincontroller.dart';
import 'package:mz_flutter_07/controllers/themecontroller.dart';
import 'package:mz_flutter_07/models/basicinfo.dart';
import 'package:mz_flutter_07/views/accounts.dart';
import 'package:mz_flutter_07/views/costs.dart';
import 'package:mz_flutter_07/views/homepage.dart';
import 'package:mz_flutter_07/views/login.dart';
import 'package:mz_flutter_07/views/offices.dart';
import 'package:mz_flutter_07/views/remind.dart';
import 'package:mz_flutter_07/views/repare.dart';

main() => runApp(const MzMyApp());

class MzMyApp extends StatelessWidget {
  const MzMyApp({super.key});

  @override
  Widget build(BuildContext context) {
    MainController mainController = Get.put(MainController());
    DBController dbController = Get.put(DBController());
    ThemeController themeController = Get.put(ThemeController());

    return GetBuilder<ThemeController>(
      init: themeController,
      builder: (_) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          theme: BasicInfo().mode(),
          getPages: [
            GetPage(name: '/', page: () => const RepairPage()),
            GetPage(name: '/login', page: () => const LogIn()),
            GetPage(name: '/home', page: () => const HomePage()),
            GetPage(name: '/home/offices', page: () => const Offices()),
            GetPage(name: '/home/accounts', page: () => const Accounts()),
            GetPage(name: '/home/remind', page: () => const Remind()),
            GetPage(name: '/home/costs', page: () => const Costs())
          ],
          home: const RepairPage(),
        );
      },
    );
  }
}
