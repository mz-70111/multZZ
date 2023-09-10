import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mz_flutter_07/controllers/dbcontroller.dart';
import 'package:mz_flutter_07/controllers/themecontroller.dart';
import 'package:mz_flutter_07/models/basicinfo.dart';
import 'package:mz_flutter_07/models/bottonicon.dart';
import 'package:mz_flutter_07/models/database.dart';
import 'package:mz_flutter_07/models/dropdowanwithsearch.dart';
import 'package:mz_flutter_07/models/lang_mode_theme.dart';
import 'package:mz_flutter_07/models/sharedpref.dart';
import 'package:mz_flutter_07/views/homepage.dart';
import 'package:mz_flutter_07/views/login.dart';
import 'package:mz_flutter_07/views/offices.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainController extends GetxController {
  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  codepassword({required String word}) {
    String code = 'muoaz153';
    String aftercoded = '';
    for (var i = 0; i < word.length; i++) {
      inloop:
      for (var j = 0; j < code.length; j++) {
        if (j == code.length - 1) break inloop;
        aftercoded +=
            String.fromCharCode(word.codeUnitAt(i) + code.codeUnitAt(j));
        if (i == word.length - 1) {
          break inloop;
        } else {
          i++;
        }
      }
    }
    return aftercoded;
  }

  showhidepasswordLogIn({index}) {
    LogIn.textfieldloginlist[index]['obscuretext'] =
        LogIn.textfieldloginlist[index]['obscuretext'] == true ? false : true;
    LogIn.textfieldloginlist[index]['icon'] =
        LogIn.textfieldloginlist[index]['obscuretext'] == true
            ? Icons.visibility
            : Icons.visibility_off;
    update();
  }

  checklogin({username, password}) async {
    if (username != null) {
      LogIn.usernamecontroller.text = username;
    }
    if (password != null) {
      LogIn.passwordcontroller.text = password;
    }

    for (var i in LogIn.textfieldloginlist) {
      i['error'] = null;
    }
    List? userinfo;
    BasicInfo.error = null;
    update();
    if (LogIn.usernamecontroller.text.isEmpty) {
      LogIn.textfieldloginlist[0]['error'] =
          BasicInfo.errorstype['emptyname-check'][BasicInfo.indexlang()];
    } else if (LogIn.passwordcontroller.text.isEmpty) {
      LogIn.textfieldloginlist[1]['error'] =
          BasicInfo.errorstype['emptypass-check'][BasicInfo.indexlang()];
    } else {
      LogIn.loginactionlist[0]['visible'] = false;
      LogIn.loginactionlist[1]['visible'] = true;
      update();
      try {
        userinfo = await DBController().gettableinfo(tablesname: [
          'users'
        ], infoqueries: [
          "select * from users where username='${username ?? LogIn.usernamecontroller.text.toLowerCase()}' and password='${MainController().codepassword(word: password ?? LogIn.passwordcontroller.text)}';"
        ]);
        if (userinfo![0]['users'].isNotEmpty) {
          List? accountstatus = await DBController().gettableinfo(tablesname: [
            'users_privileges'
          ], infoqueries: [
            "select * from users_privileges where up_user_id=${userinfo[0]['users'][0]['user_id']};"
          ]);
          if (accountstatus![0]['users_privileges'][0]['enable'] == '1') {
            if (accountstatus[0]['users_privileges'][0]['mustchgpass'] == '0') {
              await SharedPreMz.setloginfo(login: [
                userinfo[0]['users'][0]['user_id'],
                userinfo[0]['users'][0]['username'],
                LogIn.passwordcontroller.text,
              ]);
              BasicInfo.LogInInfo = SharedPreMz.getloginfo();
              DB.userinfotable = await dbController.getuserinfo(
                  userid: userinfo[0]['users'][0]['user_id']);
              Get.offNamed('/home');
            } else {
              BasicInfo.error = null;
              BasicInfo.LogInInfo = null;
              LogIn.loginactionlist[0]['index'] = 1;
              LogIn.textfieldloginlist[0]['readonly'] = true;
              LogIn.textfieldloginlist[1]['visible'] = false;
              LogIn.textfieldloginlist[2]['visible'] = true;
              LogIn.textfieldloginlist[3]['visible'] = true;
              LogIn.loginactionlist[2]['visible'] = true;
            }
          } else {
            BasicInfo.LogInInfo = null;
            BasicInfo.error =
                BasicInfo.errorstype['account-disable'][BasicInfo.indexlang()];
          }
        } else {
          BasicInfo.LogInInfo = null;
          BasicInfo.error = BasicInfo.errorstype['wrong-uesernameorpassword']
              [BasicInfo.indexlang()];
        }
      } catch (e) {
        BasicInfo.error =
            BasicInfo.errorstype['server-error'][BasicInfo.indexlang()];
      }
    }
    LogIn.loginactionlist[0]['visible'] = true;
    LogIn.loginactionlist[1]['visible'] = false;
    update();
  }

  mustchgpass() async {
    for (var i in LogIn.textfieldloginlist) {
      i['error'] = null;
    }
    BasicInfo.error = null;
    List? userinfo;
    update();
    if (LogIn.newpasswordcontroller.text.isEmpty) {
      LogIn.textfieldloginlist[2]['error'] =
          BasicInfo.errorstype['emptypass-check'][BasicInfo.indexlang()];
    } else if (LogIn.newpasswordcontroller.text !=
        LogIn.confirmnewpasswordcontroller.text) {
      BasicInfo.error =
          BasicInfo.errorstype['not-match'][BasicInfo.indexlang()];
    } else {
      LogIn.loginactionlist[0]['visible'] = false;
      LogIn.loginactionlist[2]['visible'] = false;

      LogIn.loginactionlist[1]['visible'] = true;
      update();
      try {
        userinfo = await DBController().gettableinfo(tablesname: [
          'users'
        ], infoqueries: [
          "select * from users where username='${LogIn.usernamecontroller.text.toLowerCase()}';"
        ]);
        await DBController().changpass(
            userid: userinfo![0]['users'][0]['user_id'],
            password: codepassword(word: LogIn.newpasswordcontroller.text));
        await SharedPreMz.setloginfo(login: [
          userinfo[0]['users'][0]['user_id'],
          userinfo[0]['users'][0]['username'],
          LogIn.newpasswordcontroller.text,
        ]);
        BasicInfo.LogInInfo = SharedPreMz.getloginfo();
        DB.userinfotable =
            await DBController().getuserinfo(userid: BasicInfo.LogInInfo![0]);
        await DBController().requestpost(type: "curd", data: {
          'customquery':
              "update users_privileges set mustchgpass=0 where up_user_id=${userinfo[0]['users'][0]['user_id']};"
        });
        await DBController().requestpost(type: "curd", data: {
          'customquery':
              "insert into logs set log='${BasicInfo.LogInInfo![1]} edit his password _forcly',logdate='${DateTime.now()}';"
        });
        Get.offNamed('/home');
        LogIn.loginactionlist[0]['index'] = 0;
        LogIn.textfieldloginlist[0]['readonly'] = false;
        LogIn.textfieldloginlist[1]['visible'] = true;
        LogIn.textfieldloginlist[2]['visible'] = false;
        LogIn.textfieldloginlist[3]['visible'] = false;
      } catch (e) {
        BasicInfo.error =
            BasicInfo.errorstype['server-error'][BasicInfo.indexlang()];
      }
    }
    LogIn.loginactionlist[0]['visible'] = true;
    LogIn.loginactionlist[1]['visible'] = false;
    LogIn.loginactionlist[2]['visible'] = true;

    update();
  }

  logout() async {
    await SharedPreMz.sharedpref.remove('login');
    BasicInfo.LogInInfo = null;
    BasicInfo.error = null;
    LogIn.usernamecontroller.text = LogIn.passwordcontroller.text = '';
    LogIn.newpasswordcontroller.text =
        LogIn.confirmnewpasswordcontroller.text = '';
    LogIn.loginactionlist[0]['index'] = 0;
    LogIn.loginactionlist[2]['visible'] = false;
    LogIn.textfieldloginlist[0]['readonly'] = false;
    LogIn.textfieldloginlist[1]['visible'] = true;
    LogIn.textfieldloginlist[2]['visible'] = false;
    LogIn.textfieldloginlist[3]['visible'] = false;
    Get.offNamed('/');
    update();
  }

  swapwidgetdialg({index, required list}) {
    for (var i in list) {
      i['selected'] = false;
    }
    list[index]['selected'] = true;
    update();
  }

  updatepesonalinfo({fullname, mobile, email}) async {
    BasicInfo.error = null;
    if (fullname.isEmpty) {
      BasicInfo.error =
          BasicInfo.errorstype['emptyname-check'][BasicInfo.indexlang()];
    } else {
      HomePage.dialogactionlist[0]['visible'] = false;
      HomePage.dialogactionlist[1]['visible'] = true;
      HomePage.dialogactionlist[2]['visible'] = true;
      update();
      try {
        await DBController().requestpost(type: 'curd', data: {
          'customquery':
              "update users set fullname='$fullname',mobile='$mobile',email='$email' where user_id=${DB.userinfotable[0]['users'][0]['user_id']};"
        });
        await DBController().requestpost(type: 'curd', data: {
          'customquery':
              "insert into logs set log='${BasicInfo.LogInInfo![1]} edit personal Info As fullname=$fullname,mobile=$mobile,email=$email',logdate='${DateTime.now()}';"
        });
        DB.userinfotable = await DBController()
            .getuserinfo(userid: DB.userinfotable[0]['users'][0]['user_id']);

        Get.back();
      } catch (e) {
        BasicInfo.error =
            BasicInfo.errorstype['server-error'][BasicInfo.indexlang()];
      }
    }

    HomePage.dialogactionlist[0]['visible'] = true;
    HomePage.dialogactionlist[1]['visible'] = true;
    HomePage.dialogactionlist[2]['visible'] = false;
    update();
  }

  showhidepasswordchangepass() {
    for (var i in HomePage.changepassword) {
      i['v'] = i['v'] == true ? false : true;
    }
    HomePage.passwordvis = HomePage.passwordvis == Icons.visibility
        ? Icons.visibility_off
        : Icons.visibility;
    update();
  }

  changepasswordpersonal(
      {required String oldpassword,
      required String newpass,
      required String newpassconfirm}) async {
    BasicInfo.error = null;
    for (var i in HomePage.changepassword) {
      i['error'] = null;
    }
    if (BasicInfo.LogInInfo![2] != oldpassword) {
      HomePage.changepassword[0]['error'] =
          ['كلمة المرور غير صحيحة', 'password wrong'][BasicInfo.indexlang()];
    } else if (newpass.isEmpty) {
      HomePage.changepassword[1]['error'] =
          ['كلمة المرور فارغة', 'password empty!!'][BasicInfo.indexlang()];
    } else if (newpass != newpassconfirm) {
      HomePage.changepassword[1]['error'] = HomePage.changepassword[2]
          ['error'] = [
        'كلمة المرور غير متطابقة',
        'password not match'
      ][BasicInfo.indexlang()];
    } else {
      try {
        HomePage.waitchangepass = true;
        await DBController().changpass(
            userid: DB.userinfotable[0]['users'][0]['user_id'],
            password: codepassword(word: newpass));
        await DBController().requestpost(type: 'curd', data: {
          'customquery':
              "update users_privileges set mustchgpass=0 where up_user_id=${DB.userinfotable[0]['users'][0]['user_id']};"
        });
        await DBController().requestpost(type: 'curd', data: {
          'customquery':
              "insert into logs set log='${BasicInfo.LogInInfo![1]} edit his password',logdate='${DateTime.now()}';"
        });
        HomePage.waitchangepass = false;
        Get.back();
        logout();
      } catch (e) {
        BasicInfo.error =
            BasicInfo.errorstype['server-error'][BasicInfo.indexlang()];
      }
    }

    update();
  }

  switchbuttonnotifioffice(x) {
    Offices.bodieslist[0]['notifi'] = x;
    update();
  }

  onhoverbutton({listbutton, indexbutton, page}) {
    if (listbutton != null) {
      listbutton[indexbutton]['elevetioncard'] = 3.0;
    } else {
      Offices.elevationcard = 3.0;
      switch (page) {
        case 'Offices':
          Offices.elevationcard = 3.0;
          break;
        default:
          null;
      }
    }
    update();
  }

  onexitbutton({listbutton, indexbutton, page}) {
    if (listbutton != null) {
      listbutton[indexbutton]['elevetioncard'] = 0.0;
    } else {
      switch (page) {
        case 'Offices':
          Offices.elevationcard = 0.0;
          break;
        default:
          null;
      }
    }

    update();
  }

  showdropwithsearchmz(list) {
    for (var i in list) {
      i['visiblesearch'] = true;
    }
    DropDownWithSearchMz.searchcontroller.text = '';
    DropDownWithSearchMz.visiblemain =
        DropDownWithSearchMz.visiblemain == true ? false : true;
    update();
  }

  search(
      {word,
      list,
      required List<String> range,
      firstdate,
      lastdate,
      datelist,
      columnname}) {
    for (var t in list) {
      t['visiblesearch'] = false;
    }
    for (var i in list) {
      for (var r in range) {
        if (i[r].toString().isCaseInsensitiveContains(word)) {
          i['visiblesearch'] = true;
          // if (datelist != null) {
          //   for (var i in datelist) {
          //     if ((DateTime.parse(firstdate)
          //                 .isBefore(DateTime.parse(i[columnname])) ||
          //             df.DateFormat('yyyy-MM-dd')
          //                     .format(DateTime.parse(firstdate)) ==
          //                 df.DateFormat('yyyy-MM-dd')
          //                     .format(DateTime.parse(i[columnname]))) &&
          //         (DateTime.parse(lastdate)
          //                 .isAfter(DateTime.parse(i[columnname])) ||
          //             df.DateFormat('yyyy-MM-dd')
          //                     .format(DateTime.parse(lastdate)) ==
          //                 df.DateFormat('yyyy-MM-dd')
          //                     .format(DateTime.parse(i[columnname])))) {
          //       i['visiblesearch'] = true;
          //     }
          //   }
          // } else {
          //   i['visiblesearch'] = true;
          // }
        }
      }
    }
    update();
  }

  addemployeetooffice(e) {
    Offices.addemployeelist[Offices.addemployeelist.indexOf(e)]['visible'] =
        false;
    update();
  }
}
