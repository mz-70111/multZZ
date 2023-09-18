import 'package:flutter/material.dart';
import 'package:mz_flutter_07/models/basicinfo.dart';

class ThemeMz {
  static ThemeData lightmode() => ThemeData(
        scaffoldBackgroundColor: Colors.white70,
        cardColor: Colors.white60,
        drawerTheme: DrawerThemeData(backgroundColor: Colors.white70),
        appBarTheme: AppBarTheme(backgroundColor: Colors.blue.shade900),
        colorScheme: const ColorScheme.light(),
        switchTheme: const SwitchThemeData(
          thumbColor: MaterialStatePropertyAll(Colors.blue),
        ),
        checkboxTheme: const CheckboxThemeData(
            fillColor: MaterialStatePropertyAll(Colors.blue)),
        radioTheme: const RadioThemeData(
            fillColor: MaterialStatePropertyAll(Colors.blue)),
      );
  static ThemeData darkmode() => ThemeData(
      switchTheme: const SwitchThemeData(
        thumbColor: MaterialStatePropertyAll(Colors.deepPurple),
      ),
      checkboxTheme: const CheckboxThemeData(
          fillColor: MaterialStatePropertyAll(Colors.black)),
      radioTheme: const RadioThemeData(
          fillColor: MaterialStatePropertyAll(Colors.black)),
      colorScheme: const ColorScheme.dark(
        error: Colors.orangeAccent,
      ));
  static Color iconbuttonmzbc() => BasicInfo.selectedmode == 'Light'
      ? Colors.blue.shade900
      : Colors.deepPurple;
  static TextStyle titlemediumChanga() => BasicInfo.selectedmode == 'Light'
      ? const TextStyle(fontFamily: 'Changa', fontSize: 18)
      : const TextStyle(fontFamily: 'Changa', fontSize: 18);
  static TextStyle titlelargChanga() => BasicInfo.selectedmode == 'Light'
      ? const TextStyle(fontFamily: 'Changa', fontSize: 25)
      : const TextStyle(fontFamily: 'Changa', fontSize: 25);
  static TextStyle titlemediumCairo() => BasicInfo.selectedmode == 'Light'
      ? const TextStyle(fontFamily: 'Cairo', fontSize: 18)
      : const TextStyle(fontFamily: 'Cairo', fontSize: 18);
  static TextStyle titlelargCairo() => BasicInfo.selectedmode == 'Light'
      ? const TextStyle(fontFamily: 'Cairo', fontSize: 25)
      : const TextStyle(fontFamily: 'Cairo', fontSize: 25);
}

class Lang {
  static String? mainerrormsg;
  static Map errormsgs = {
    'server-error': [
      'لا يمكن الوصول للمخدم',
      'some thing error _cann\'t reach server_ try again'
    ],
    'emptyname-check': ['لا يمكن ان يكون حقل الاسم فارغا', 'username empty!!'],
    'emptypass-check': [
      'لا يمكن ان يكون حقل كلمة المرور فارغا',
      'password empty!!'
    ],
    'account-disable': ['حسابك غير مفعل', 'your account disabled'],
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

  static Map titles = {
    'login': ['تسجيل الدخول', 'Log In'],
  };
}
