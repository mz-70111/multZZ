import 'package:flutter/material.dart';
import 'package:mz_flutter_07/models/basicinfo.dart';

class ThemeMz {
  static ThemeData lightmode() => ThemeData(
      scaffoldBackgroundColor: Color.fromARGB(255, 238, 238, 241),
      cardColor: Color.fromARGB(255, 238, 238, 241),
      drawerTheme: DrawerThemeData(backgroundColor: Colors.white70),
      appBarTheme: AppBarTheme(backgroundColor: Colors.blue.shade700),
      colorScheme: const ColorScheme.light(),
      switchTheme: const SwitchThemeData(
        thumbColor: MaterialStatePropertyAll(Colors.blue),
      ),
      checkboxTheme: const CheckboxThemeData(
          fillColor: MaterialStatePropertyAll(Colors.blue)),
      radioTheme: const RadioThemeData(
          fillColor: MaterialStatePropertyAll(Colors.blue)),
      expansionTileTheme: ExpansionTileThemeData());
  static ThemeData darkmode() => ThemeData(
      scaffoldBackgroundColor: const Color.fromARGB(255, 22, 27, 26),
      cardColor: Color.fromARGB(255, 40, 49, 47),
      drawerTheme:
          DrawerThemeData(backgroundColor: Color.fromARGB(255, 22, 27, 26)),
      dialogTheme:
          DialogTheme(backgroundColor: Color.fromARGB(255, 22, 27, 26)),
      appBarTheme:
          AppBarTheme(backgroundColor: Color.fromARGB(220, 23, 126, 130)),
      switchTheme: const SwitchThemeData(
        thumbColor: MaterialStatePropertyAll(Color.fromARGB(220, 23, 126, 130)),
      ),
      checkboxTheme: const CheckboxThemeData(
          fillColor: MaterialStatePropertyAll(Colors.black54)),
      radioTheme: const RadioThemeData(
          fillColor: MaterialStatePropertyAll(Colors.black54)),
      colorScheme: const ColorScheme.dark(
        error: Colors.orangeAccent,
      ));
  static Color iconbuttonmzbc() => BasicInfo.selectedmode == 'Light'
      ? Colors.blue.shade700
      : Color.fromARGB(220, 23, 126, 130);
  static TextStyle titlemediumChanga() => BasicInfo.selectedmode == 'Light'
      ? const TextStyle(fontFamily: 'Changa', fontSize: 18)
      : const TextStyle(fontFamily: 'Changa', fontSize: 18);
  static TextStyle titlelargChanga() => BasicInfo.selectedmode == 'Light'
      ? const TextStyle(fontFamily: 'Changa', fontSize: 25)
      : const TextStyle(fontFamily: 'Changa', fontSize: 25);
  static TextStyle titlemediumCairo() => BasicInfo.selectedmode == 'Light'
      ? const TextStyle(fontFamily: 'Cairo', fontSize: 18)
      : const TextStyle(fontFamily: 'Cairo', fontSize: 18);
  static TextStyle titlemediumCairowhite() => BasicInfo.selectedmode == 'Light'
      ? const TextStyle(fontFamily: 'Cairo', fontSize: 18, color: Colors.white)
      : const TextStyle(fontFamily: 'Cairo', fontSize: 18, color: Colors.white);
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
    'emptycert-check': [
      'لا يمكن ان يكون حقل  مصدر الشهادة فارغا',
      'Cert url empty!!'
    ],
    'emptydays-check': [
      'قم بإضافة يوم واحد على الأقل',
      'add one day at least !!'
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
