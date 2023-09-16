import 'package:flutter/material.dart';
import 'package:mz_flutter_07/models/lang_mode_theme.dart';

class BasicInfo {
  static String host = "http://192.168.30.8";
  static String curdtable = "/mz_API/db01_curd_table.php";
  static String selecttable = "/mz_API/db01_select_table.php";
  static String version = 'v_1.0.1';
  static IconData passwordicon = Icons.visibility_off;

  // ignore: non_constant_identifier_names
  static List? LogInInfo;
  static TextDirection lang() =>
      selectedlang == 'Ar' ? TextDirection.rtl : TextDirection.ltr;
  ThemeData mode() =>
      selectedmode == 'Light' ? ThemeMz.lightmode() : ThemeMz.darkmode();
  static String? selectedmode, selectedlang;
  static int indexlang() => selectedlang == 'Ar' ? 0 : 1;
  static int actionindex = 0;
}
