import 'package:shared_preferences/shared_preferences.dart';

class SharedPreMz {
  static late SharedPreferences sharedpref;

  static setloginfo({required List<String> login}) async {
    return await sharedpref.setStringList('login', login);
  }

  static getloginfo() {
    return sharedpref.getStringList('login');
  }

  static setlang({required String lang}) async {
    return await sharedpref.setString('lang', lang);
  }

  static getlang() {
    return sharedpref.getString('lang');
  }

  static setmode({required String mode}) async {
    return await sharedpref.setString('mode', mode);
  }

  static getmode() {
    return sharedpref.getString('mode');
  }
}
