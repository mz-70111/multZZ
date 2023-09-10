import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mz_flutter_07/controllers/dbcontroller.dart';
import 'package:mz_flutter_07/controllers/maincontroller.dart';
import 'package:mz_flutter_07/controllers/themecontroller.dart';
import 'package:mz_flutter_07/models/basicinfo.dart';
import 'package:mz_flutter_07/models/lang_mode_theme.dart';
import 'package:mz_flutter_07/views/accounts.dart';
import 'package:mz_flutter_07/views/costs.dart';
import 'package:mz_flutter_07/views/homepage.dart';
import 'package:mz_flutter_07/views/login.dart';
import 'package:mz_flutter_07/views/offices.dart';
import 'package:mz_flutter_07/views/repare.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/sharedpref.dart';

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
            GetPage(name: '/', page: () => RepairPage()),
            GetPage(name: '/login', page: () => LogIn()),
            GetPage(name: '/home', page: () => HomePage()),
            GetPage(name: '/home/offices', page: () => Offices()),
            GetPage(name: '/home/accounts', page: () => Accounts()),
            GetPage(name: '/home/costs', page: () => Costs())
          ],
          home: RepairPage(),
        );
      },
    );
  }
}
