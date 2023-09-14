import 'package:flutter/material.dart';

class BasicInfo {
  static String? error;
  static String host = "http://192.168.30.8";
  static String curdtable = "/mz_API/db01_curd_table.php";
  static String selecttable = "/mz_API/db01_select_table.php";
  static String version = 'v_1.0.1';
  static IconData passwordicon = Icons.visibility_off;
  static Map errorstype = {
    'login': [
      'تسجيل الدخول',
      'Log In',
    ],
    'server-error': [
      'لا يمكن الوصول للمخدم',
      'some thing error _cann\'t reach server_ try again',
    ],
    'emptyname-check': [
      'لا يمكن ان يكون حقل الاسم فارغا',
      'username empty!!',
    ],
    'emptypass-check': [
      'لا يمكن ان يكون حقل كلمة المرور فارغا',
      'password empty!!'
    ],
    'account-disable': [
      'حسابك غير مفعل',
      'your account disabled',
    ],
    'wrong-uesernameorpassword': [
      'اسم المستخدم او كلمة المرور غير صحيحة',
      'username or password wrong!!'
    ],
    'not-match': ['كلمة المرور غير متطابقة', 'not-match'],
    'duplicate': [
      'الاسم محجوز مسبقا  _اختر اسما آخر',
      'reserved name _choose another one'
    ]
  };
  // ignore: non_constant_identifier_names
  static List? LogInInfo;
  static TextDirection lang() =>
      selectedlang == 'Ar' ? TextDirection.rtl : TextDirection.ltr;
  ThemeData mode() =>
      selectedmode == 'Light' ? ThemeData.light() : ThemeData.dark();
  static String? selectedmode, selectedlang;
  static int indexlang() => selectedlang == 'Ar' ? 0 : 1;
}
