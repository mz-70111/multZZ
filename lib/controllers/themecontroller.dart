import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mz_flutter_07/models/basicinfo.dart';

import 'package:mz_flutter_07/models/sharedpref.dart';
import 'package:mz_flutter_07/views/homepage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends GetxController {
  @override
  void onInit() async {
    super.onInit();
    SharedPreMz.sharedpref = await SharedPreferences.getInstance();
    BasicInfo.selectedmode = SharedPreMz.getmode() ?? 'Light';
    BasicInfo.selectedlang = SharedPreMz.getlang() ?? 'Ar';
    BasicInfo.LogInInfo = SharedPreMz.getloginfo();
    update();
  }

  changemode() async {
    BasicInfo.selectedmode =
        BasicInfo.selectedmode == 'Light' ? 'Dark' : 'Light';
    HomePage.appbaractionlist[0]['icon'] =
        HomePage.appbaractionlist[0]['icon'] == Icons.sunny
            ? Icons.dark_mode
            : Icons.sunny;
    await SharedPreMz.setmode(mode: BasicInfo.selectedmode!);
    update();
  }

  changelang(x) async {
    BasicInfo.selectedlang = BasicInfo.selectedlang == 'Ar' ? 'En' : 'Ar';

    HomePage.selectedLang = x;
    await SharedPreMz.setlang(lang: BasicInfo.selectedlang!);
    update();
  }
}
