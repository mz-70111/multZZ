import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:mz_flutter_07/controllers/dbcontroller.dart';
import 'package:mz_flutter_07/models/basicinfo.dart';
import 'package:mz_flutter_07/models/database.dart';
import 'package:mz_flutter_07/models/dropdowanwithsearch.dart';
import 'package:mz_flutter_07/models/lang_mode_theme.dart';
import 'package:mz_flutter_07/models/page_tamplate01.dart';
import 'package:mz_flutter_07/models/sharedpref.dart';
import 'package:mz_flutter_07/views/accounts.dart';
import 'package:mz_flutter_07/views/costs.dart';
import 'package:mz_flutter_07/views/homepage.dart';
import 'package:mz_flutter_07/views/login.dart';
import 'package:mz_flutter_07/views/offices.dart';
import 'package:mz_flutter_07/views/remind.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart' as df;
import 'package:teledart/teledart.dart';
import 'package:teledart/telegram.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' as foundation;
// import 'dart:io' as io;

import 'package:teledart/teledart.dart';
import 'package:teledart/telegram.dart';
import 'package:teledart/model.dart';

class MainController extends GetxController {
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
    Lang.mainerrormsg = null;
    update();
    if (LogIn.usernamecontroller.text.isEmpty) {
      LogIn.textfieldloginlist[0]['error'] =
          Lang.errormsgs['emptyname-check'][BasicInfo.indexlang()];
    } else if (LogIn.passwordcontroller.text.isEmpty) {
      LogIn.textfieldloginlist[1]['error'] =
          Lang.errormsgs['emptypass-check'][BasicInfo.indexlang()];
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
              Lang.mainerrormsg = null;
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
            Lang.mainerrormsg =
                Lang.errormsgs['account-disable'][BasicInfo.indexlang()];
          }
        } else {
          BasicInfo.LogInInfo = null;
          Lang.mainerrormsg = Lang.errormsgs['wrong-uesernameorpassword']
              [BasicInfo.indexlang()];
        }
      } catch (e) {
        print(e);
        Lang.mainerrormsg =
            Lang.errormsgs['server-error'][BasicInfo.indexlang()];
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
    Lang.mainerrormsg = null;
    List? userinfo;
    update();
    if (LogIn.newpasswordcontroller.text.isEmpty) {
      LogIn.textfieldloginlist[2]['error'] =
          Lang.errormsgs['emptypass-check'][BasicInfo.indexlang()];
    } else if (LogIn.newpasswordcontroller.text !=
        LogIn.confirmnewpasswordcontroller.text) {
      Lang.mainerrormsg = Lang.errormsgs['not-match'][BasicInfo.indexlang()];
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
        Lang.mainerrormsg =
            Lang.errormsgs['server-error'][BasicInfo.indexlang()];
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
    Lang.mainerrormsg = null;
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
    Lang.mainerrormsg = null;
    if (fullname.isEmpty) {
      Lang.mainerrormsg =
          Lang.errormsgs['emptyname-check'][BasicInfo.indexlang()];
    } else {
      HomePage.dialogactionlist[0]['visible'] = false;
      HomePage.dialogactionlist[1]['visible'] = true;
      HomePage.dialogactionlist[2]['visible'] = true;
      update();
      if (DB.userinfotable != null) {
        try {
          await DBController().requestpost(type: 'curd', data: {
            'customquery':
                "update users set fullname='$fullname',mobile='$mobile',email='$email' where user_id=${DB.userinfotable![0]['users'][0]['user_id']};"
          });
          await DBController().requestpost(type: 'curd', data: {
            'customquery':
                "insert into logs set log='${BasicInfo.LogInInfo![1]} edit personal Info As fullname=$fullname,mobile=$mobile,email=$email',logdate='${DateTime.now()}';"
          });
          DB.userinfotable = await DBController()
              .getuserinfo(userid: DB.userinfotable![0]['users'][0]['user_id']);

          Get.back();
        } catch (e) {
          Lang.mainerrormsg =
              Lang.errormsgs['server-error'][BasicInfo.indexlang()];
        }
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
    Lang.mainerrormsg = null;
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
            userid: DB.userinfotable![0]['users'][0]['user_id'],
            password: codepassword(word: newpass));
        await DBController().requestpost(type: 'curd', data: {
          'customquery':
              "update users_privileges set mustchgpass=0 where up_user_id=${DB.userinfotable![0]['users'][0]['user_id']};"
        });
        await DBController().requestpost(type: 'curd', data: {
          'customquery':
              "insert into logs set log='${BasicInfo.LogInInfo![1]} edit his password',logdate='${DateTime.now()}';"
        });
        HomePage.waitchangepass = false;
        Get.back();
        logout();
      } catch (e) {
        Lang.mainerrormsg =
            Lang.errormsgs['server-error'][BasicInfo.indexlang()];
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

  dropdaownchhositem({list, val, x}) {
    list[val] = x;
    update();
  }

  search({word, list, required List<String> range, datecolumnname}) {
    for (var t in list) {
      t['visiblesearch'] = false;
    }
    for (var i in list) {
      for (var r in range) {
        if (i[r].toString().isCaseInsensitiveContains(word)) {
          i['visiblesearch'] = true;
        }
      }
    }
    update();
  }

  adddaytoalert({ctx, required List<DateTime> list}) async {
    var d = await showDatePicker(
        context: ctx,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime.parse("2024-01-01"));
    if (d != null) {
      if (!list.contains(df.DateFormat("yyyy-MM-dd").format(d))) {
        list.add(d);
      }
    }

    update();
  }

  checkifcontentint({x, list, index, error, defaultv}) {
    bool st = false;
    try {
      int.parse(x);
      st = true;
    } catch (e) {
      st = false;
    }
    if (list[index]['controller'].text.isEmpty) {
      list[index]['controller'].text = defaultv;
    } else if (st == false) {
      list[index]['error'] = [
        'أدخل قيمة عددية صحيحة',
        'enter vaild integer value'
      ][BasicInfo.indexlang()];
    } else {
      list[index]['error'] = null;
    }
    update();
  }

  removedayforalerts({list, x}) {
    list.removeAt(list.indexOf(x));
    update();
  }

  chooseoffice({list, list2, officenameclm, officenameclm2, x, accounts}) {
    PageTamplate01.selectedoffice = x;

    for (var i in list) {
      i['visible'] = false;
    }

    if (x == "all") {
      for (var i in list) {
        i['visible'] = true;
      }
    } else {
      List elementatoffice = [];
      elementatoffice.clear();
      if (DB.allofficeinfotable != null) {
        if (accounts == null) {
          for (var j in list.where((u) =>
              u[officenameclm] ==
              DB.allofficeinfotable![0]['offices']
                  .where((element) => element['officename'] == x)
                  .toList()[0]['office_id'])) {
            elementatoffice.add(j[officenameclm]);
          }
        } else {
          for (var i in DB.allusersinfotable![0]['users_priv_office'].where(
              (y) =>
                  y['upo_office_id'] ==
                  DB.allofficeinfotable![0]['offices']
                      .where((element) => element['officename'] == x)
                      .toList()[0]['office_id'])) {
            elementatoffice.add(i[officenameclm]);
          }
        }

        if (accounts != null) {
          for (var i in list) {
            if (elementatoffice.contains(i['user_id'])) {
              i['visible'] = true;
            }
          }
        } else {
          for (var i in list) {
            if (elementatoffice.contains(i[officenameclm])) {
              i['visible'] = true;
            }
          }
        }
      }
    }

    try {
      update();
    } catch (e) {}
  }

  addremoveemployeetooffice({list, y, type = 'save'}) {
    if (type == 'save') {
      list[list.indexOf(y)]['visible'] = false;
    } else {
      list[list.indexOf(y)]['visible'] = true;
    }
    Get.back();
    update();
  }

  onhover({list, required index, color, iconsize, elevate, backcolor}) {
    color != null
        ? list[index]['color'] = BasicInfo.selectedmode == 'Light'
            ? Colors.blueAccent.withOpacity(0.3)
            : Color.fromARGB(61, 23, 126, 130)
        : null;
    iconsize != null ? list[index]['iconsize'] = 50.0 : null;
    elevate != null ? list[index]['elevate'] = 3.0 : null;
    try {
      backcolor != null
          ? list[index]['backcolor'] = BasicInfo.selectedmode == 'Light'
              ? Colors.blueAccent
              : Color.fromARGB(153, 23, 126, 130)
          : null;
    } catch (r) {}
    update();
  }

  onexit({list, required index, color, elevate, iconsize, backcolor}) {
    color != null ? list[index]['color'] = Colors.transparent : null;
    iconsize != null ? list[index]['iconsize'] = 40.0 : null;
    elevate != null ? list[index]['elevate'] = 0.0 : null;
    try {
      list[index]['backcolor'] = Colors.transparent;
    } catch (e) {}

    update();
  }

  urllaunch({url}) async {
    try {
      if (!await launchUrl(Uri.parse(url),
          mode: LaunchMode.externalNonBrowserApplication)) {
        throw Exception('لا يمكن الوصول للموقع $url');
      }
    } catch (e) {
      null;
    }
  }

  changeradiopriv({x, index, required list}) {
    list[index]['position'] = x == 'موظف' || x == 'employee'
        ? ['موظف', 'employee']
        : ['مشرف', 'supervisor'];
    if (x == 'مشرف' || x == 'supervisor') {
      list[index]['P-addtask'][0] = true;
      list[index]['P-showalltasks'][0] = true;
      list[index]['P-addtodo'][0] = true;
      list[index]['P-showalltodos'][0] = true;
      list[index]['P-addping'][0] = true;
      list[index]['P-showallpings'][0] = true;
      list[index]['P-addemailtest'][0] = true;
      list[index]['P-showallemailtests'][0] = true;
      list[index]['P-addremind'][0] = true;
      list[index]['P-showallreminds'][0] = true;
      list[index]['P-addhyperlink'][0] = true;
      list[index]['P-showallhyperlinks'][0] = true;
      list[index]['P-addcost'][0] = true;
      list[index]['P-acceptcosts'][0] = true;
      list[index]['P-showallcosts'][0] = true;
    } else {
      list[index]['P-addtask'][0] = false;
      list[index]['P-showalltasks'][0] = false;
      list[index]['P-addtodo'][0] = true;
      list[index]['P-showalltodos'][0] = true;
      list[index]['P-addping'][0] = true;
      list[index]['P-showallpings'][0] = true;
      list[index]['P-addemailtest'][0] = true;
      list[index]['P-showallemailtests'][0] = true;
      list[index]['P-addremind'][0] = true;
      list[index]['P-showallreminds'][0] = true;
      list[index]['P-addhyperlink'][0] = false;
      list[index]['P-showallhyperlinks'][0] = false;
      list[index]['P-addcost'][0] = true;
      list[index]['P-acceptcosts'][0] = false;
      list[index]['P-showallcosts'][0] = false;
    }
    update();
  }

  changeradioacceptcost({list, index, x, clmname, costid}) async {
    list[index][clmname] = x == 'موافق' || x == 'accept'
        ? ['موافق', 'accept']
        : ['مرفوض', 'reject'];
    int? st;
    st = x == 'موافق' || x == 'accept' ? 1 : 0;
    try {
      list[2]['visible'] = true;
      list[0]['visible'] = false;
      update();
      clmname == 'beginaccept'
          ? {
              await dbController.requestpost(type: 'crud', data: {
                'customquery':
                    'update costs set begin_acceptcost=$st,begin_acceptcost_user=${BasicInfo.LogInInfo![0]},begin_acceptcost_date="${DateTime.now()}" where cost_id=$costid;'
              }),
              st == 0
                  ? await dbController.requestpost(type: 'crud', data: {
                      'customquery':
                          'update costs set final_acceptcost=null,final_acceptcost_user=null,final_acceptcost_date=null where cost_id=$costid;'
                    })
                  : null,
            }
          : await dbController.requestpost(type: 'crud', data: {
              'customquery':
                  'update costs set final_acceptcost=$st,final_acceptcost_user=${BasicInfo.LogInInfo![0]},final_acceptcost_date="${DateTime.now()}" where cost_id=$costid;'
            });
      DB.allcostsinfotable = await dbController.getallcostinfo();
    } catch (e) {}
    list[2]['visible'] = false;
    list[0]['visible'] = true;

    dbController.update();
    update();
  }

  chackboxpriv({x, required list, index, e}) {
    list[index][e][0] = x;
    update();
  }

  changeradio({list, val, x}) {
    list[val][BasicInfo.indexlang()] = x;
    update();
  }

  easyeditaction({listse, listme, colmuname, me, se}) {
    for (var l in listse) {
      for (var j in l) {
        j['elevate'] = 0.0;
      }
    }

    listse[listme.indexWhere((i) => i[colmuname] == me[colmuname])][se['i']]
        ['elevate'] = 3.0;
    update();
  }

  setstartdatefor({ctx, list, index, date, searchlist}) async {
    DateTime? dt = await showDatePicker(
        context: ctx,
        initialDate: list[index][date],
        firstDate: list[1][date].add(Duration(days: -90)),
        lastDate: list[1][date].add(Duration(days: -1)));
    if (dt != null) {
      list[index][date] = dt;
      if (searchlist != null) {
        for (var i in searchlist) {
          i['visiblesearch'] = false;
        }
        for (var i in searchlist) {
          if (i['costdate'] != null) {
            if (DateTime.parse(i['costdate']).isAfter(dt) ||
                df.DateFormat("yyyy-MM-dd")
                        .format(DateTime.parse(i['costdate'])) ==
                    df.DateFormat("yyyy-MM-dd").format(dt)) {
              i['visiblesearch'] = true;
            }
          }
        }
      }
    }

    update();
  }

  setrnddatefor({ctx, list, index, date, searchlist}) async {
    DateTime? dt = await showDatePicker(
        context: ctx,
        initialDate: list[index][date],
        firstDate: list[0][date].add(Duration(days: 1)),
        lastDate: list[0][date].add(Duration(days: 90)));
    if (dt != null) {
      list[index][date] = dt;
      if (searchlist != null) {
        for (var i in searchlist) {
          i['visiblesearch'] = false;
        }
        for (var i in searchlist) {
          if (i['costdate'] != null) {
            if (DateTime.parse(i['costdate']).isBefore(dt) ||
                df.DateFormat("yyyy-MM-dd")
                        .format(DateTime.parse(i['costdate'])) ==
                    df.DateFormat("yyyy-MM-dd").format(dt)) {
              i['visiblesearch'] = true;
            }
          }
        }
      }
    }

    update();
  }

  changeswitchvalue({list, val, x}) {
    list[val] = x;
    update();
  }

  addoffice() async {
    Lang.mainerrormsg = null;
    Offices.bodieslistofadd[0]['tf'][0]['error'] = null;
    List queries = [
      '''
insert into offices(officename,chatid,apitoken,notifi)values
('${Offices.officenamecontroller.text.trim()}',
'${Offices.chatidcontroller.text.trim()}',
'${Offices.apitokencontroller.text.trim()}',
${Offices.bodieslistofadd[0]['notifi'] == true ? 1 : 0});
''',
    ];
    for (var i in Offices.addemployeelist
        .where((element) => element['visible'] == false)) {
      queries.add('''
            insert into users_priv_office 
            (upo_user_id,upo_office_id,position,
            addtask,showalltasks,
            addping,showallpings,
            addcost,showallcosts,acceptcosts,
            addtodo,showalltodos,
            addremind,showallreminds,
            addemailtest,showallemailtests,
            addhyperlink,showallhyperlinks)
            values(
            ${i['user_id']},
            (select max(office_id) from offices),
            '${i['position'][1]}',
            ${i['P-addtask'][0] == true ? 1 : 0},${i['P-showalltasks'][0] == true ? 1 : 0},
            ${i['P-addping'][0] == true ? 1 : 0},${i['P-showallpings'][0] == true ? 1 : 0},
            ${i['P-addcost'][0] == true ? 1 : 0},${i['P-showallcosts'][0] == true ? 1 : 0},${i['P-acceptcosts'][0] == true ? 1 : 0},
            ${i['P-addtodo'][0] == true ? 1 : 0},${i['P-showalltodos'][0] == true ? 1 : 0},
            ${i['P-addremind'][0] == true ? 1 : 0},${i['P-showallreminds'][0] == true ? 1 : 0},
            ${i['P-addemailtest'][0] == true ? 1 : 0},${i['P-showallemailtests'][0] == true ? 1 : 0},
            ${i['P-addhyperlink'][0] == true ? 1 : 0},${i['P-showallhyperlinks'][0] == true ? 1 : 0}
            );
            ''');
    }
    queries.add('''
insert into logs(log,logdate)values
("${BasicInfo.LogInInfo![1]} add a new office _name: Officename ${Offices.officenamecontroller.text}",
"${DateTime.now()}");
      ''');
    if (Offices.officenamecontroller.text.trim().isEmpty) {
      Offices.bodieslistofadd[0]['tf'][0]['error'] =
          Lang.errormsgs['emptyname-check'][BasicInfo.indexlang()];
      for (var i in Offices.maintitlesdialogMz01) {
        i['selected'] = false;
      }
      Offices.maintitlesdialogMz01[0]['selected'] = true;
    } else {
      Offices.listofactionbuttonforadd[0]['visible'] = false;
      Offices.listofactionbuttonforadd[2]['visible'] = true;
      update();
      try {
        l:
        for (var q in queries) {
          await DBController()
              .requestpost(type: 'curd', data: {'customquery': '$q'});
          {
            if (Lang.mainerrormsg != null) {
              if (Lang.mainerrormsg!.contains("Duplicate")) {
                Lang.mainerrormsg = Offices.bodieslistofadd[0]['tf'][0]
                        ['error'] =
                    "${Offices.officenamecontroller.text} ${Lang.errormsgs['duplicate'][BasicInfo.indexlang()]}";
                for (var i in Offices.maintitlesdialogMz01) {
                  i['selected'] = false;
                }
                Offices.maintitlesdialogMz01[0]['selected'] = true;
              } else {
                Lang.mainerrormsg = Lang.mainerrormsg;
              }
              break l;
            }
          }
        }
        if (Lang.mainerrormsg == null) {
          DB.allofficeinfotable = await DBController().getallofficeinfo();
          DB.userinfotable =
              await DBController().getuserinfo(userid: BasicInfo.LogInInfo![0]);
          DB.allusersinfotable = await DBController().getallusersinfo();
          dbController.update();
          Get.back();
        }
      } catch (e) {
        Lang.mainerrormsg =
            Lang.errormsgs['server-error'][BasicInfo.indexlang()];
      }
    }
    Offices.listofactionbuttonforadd[0]['visible'] = true;
    Offices.listofactionbuttonforadd[2]['visible'] = false;
    update();
  }

  updateoffice({officeid}) async {
    Lang.mainerrormsg = null;
    Offices.bodieslistofadd[0]['tf'][0]['error'] = null;
    List queries = [
      '''
update offices set
officename='${Offices.officenamecontroller.text.trim()}',
chatid='${Offices.chatidcontroller.text.trim()}',
apitoken='${Offices.apitokencontroller.text.trim()}',
notifi=${Offices.bodieslistofadd[0]['notifi'] == true ? 1 : 0} where office_id=$officeid;
''',
      '''
delete from users_priv_office where upo_office_id=$officeid;
'''
    ];

    for (var i in Offices.addemployeelist
        .where((element) => element['visible'] == false)) {
      queries.add('''
           insert into users_priv_office 
            (upo_user_id,upo_office_id,position,
            addtask,showalltasks,
            addping,showallpings,
            addcost,showallcosts,acceptcosts,
            addtodo,showalltodos,
            addremind,showallreminds,
            addemailtest,showallemailtests,
            addhyperlink,showallhyperlinks)
            values(
            ${i['user_id']},
            $officeid,
            '${i['position'][1]}',
            ${i['P-addtask'][0] == true ? 1 : 0},${i['P-showalltasks'][0] == true ? 1 : 0},
            ${i['P-addping'][0] == true ? 1 : 0},${i['P-showallpings'][0] == true ? 1 : 0},
            ${i['P-addcost'][0] == true ? 1 : 0},${i['P-showallcosts'][0] == true ? 1 : 0},${i['P-acceptcosts'][0] == true ? 1 : 0},
            ${i['P-addtodo'][0] == true ? 1 : 0},${i['P-showalltodos'][0] == true ? 1 : 0},
            ${i['P-addremind'][0] == true ? 1 : 0},${i['P-showallreminds'][0] == true ? 1 : 0},
            ${i['P-addemailtest'][0] == true ? 1 : 0},${i['P-showallemailtests'][0] == true ? 1 : 0},
            ${i['P-addhyperlink'][0] == true ? 1 : 0},${i['P-showallhyperlinks'][0] == true ? 1 : 0}
            );
            ''');
    }
    queries.add('''
insert into logs(log,logdate)values
("${BasicInfo.LogInInfo![0]} edit office info for office_id $officeid _name: Officename ${Offices.officenamecontroller.text}",
"${DateTime.now()}");
      ''');
    if (Offices.officenamecontroller.text.trim().isEmpty) {
      Offices.bodieslistofadd[0]['tf'][0]['error'] =
          Lang.errormsgs['emptyname-check'][BasicInfo.indexlang()];
      for (var i in Offices.maintitlesdialogMz01) {
        i['selected'] = false;
      }
      Offices.maintitlesdialogMz01[0]['selected'] = true;
    } else {
      Offices.listofactionbuttonforedit[0]['visible'] = false;
      Offices.listofactionbuttonforedit[2]['visible'] = true;
      update();
      try {
        l:
        for (var q in queries) {
          await DBController()
              .requestpost(type: 'curd', data: {'customquery': '$q'});
          {
            if (Lang.mainerrormsg != null) {
              if (Lang.mainerrormsg!.contains("Duplicate")) {
                Lang.mainerrormsg = Offices.bodieslistofadd[0]['tf'][0]
                        ['error'] =
                    "${Offices.officenamecontroller.text} ${Lang.errormsgs['duplicate'][BasicInfo.indexlang()]}";
                for (var i in Offices.maintitlesdialogMz01) {
                  i['selected'] = false;
                }
                Offices.maintitlesdialogMz01[0]['selected'] = true;
              } else {
                Lang.mainerrormsg = Lang.mainerrormsg;
              }
              break l;
            }
          }
        }
        if (Lang.mainerrormsg == null) {
          DB.allofficeinfotable = await DBController().getallofficeinfo();
          DB.userinfotable =
              await DBController().getuserinfo(userid: BasicInfo.LogInInfo![0]);
          DB.allusersinfotable = await DBController().getallusersinfo();
          dbController.update();
          Get.back();
        }
      } catch (e) {
        Lang.mainerrormsg =
            Lang.errormsgs['server-error'][BasicInfo.indexlang()];
      }
    }
    Offices.listofactionbuttonforedit[0]['visible'] = true;
    Offices.listofactionbuttonforedit[2]['visible'] = false;

    update();
  }

  removeoffice({officeid, list}) async {
    String officename = DB.allofficeinfotable![0]['offices'][DB
        .allofficeinfotable![0]['offices']
        .indexWhere((r) => r['office_id'] == officeid)]['officename'];
    List queries = [
      '''
update tasks set task_office_id=null where task_office_id=$officeid;
''',
      '''
update remind set remind_office_id=null where remind_office_id=$officeid;
''',
      '''
update todo set todo_office_id=null where todo_office_id=$officeid;
''',
      '''
update costs set cost_office_id=null where cost_office_id=$officeid;
''',
      '''
delete from users_priv_office where upo_office_id=$officeid;
''',
      '''
delete from offices where office_id=$officeid;
''',
      '''
insert into logs(log,logdate)values
("${BasicInfo.LogInInfo![1]} delete office _Officename $officename",
"${DateTime.now()}");
      ''',
    ];
    list[0]['visible'] = false;
    list[2]['visible'] = true;
    update();
    try {
      for (var q in queries) {
        await DBController()
            .requestpost(type: 'curd', data: {'customquery': '$q'});
      }
      list[0]['visible'] = true;
      list[2]['visible'] = false;
      DB.allofficeinfotable = await DBController().getallofficeinfo();
      DB.userinfotable =
          await DBController().getuserinfo(userid: BasicInfo.LogInInfo![0]);
      DB.allusersinfotable = await DBController().getallusersinfo();
      dbController.update();
      Get.back();
    } catch (e) {
      print(e);
      null;
    }

    update();
  }

  addremind(
      {inerlist,
      required List<DateTime> dateslist,
      officeslistandindex}) async {
    inerlist[0]['error'] = null;
    inerlist[1]['error'] = null;
    inerlist[2]['error'] = null;
    DateTime? reminddate;
    Lang.mainerrormsg = null;
    Remind.bodieslistofadd[0]['tf'][0]['error'] = null;
    List queries = [];

    if (Remind.remindnamecontroller.text.trim().isEmpty) {
      Remind.bodieslistofadd[0]['tf'][0]['error'] =
          Lang.errormsgs['emptyname-check'][BasicInfo.indexlang()];
      for (var i in Remind.maintitlesdialogMz01) {
        i['selected'] = false;
      }
      Remind.maintitlesdialogMz01[0]['selected'] = true;
    } else if ((Remind.bodieslistofadd[1]['details'][0]['type']['group']
                    [BasicInfo.indexlang()] ==
                'auto' ||
            Remind.bodieslistofadd[1]['details'][0]['type']['group'][BasicInfo.indexlang()] ==
                'تلقائي') &&
        inerlist[0]['controller'].text.isEmpty) {
      inerlist[0]['error'] =
          Lang.errormsgs['emptycert-check'][BasicInfo.indexlang()];
      for (var i in Remind.maintitlesdialogMz01) {
        i['selected'] = false;
      }
      Remind.maintitlesdialogMz01[1]['selected'] = true;
    } else if ((Remind.bodieslistofadd[1]['details'][0]['type']['group']
                    [BasicInfo.indexlang()] ==
                'auto' ||
            Remind.bodieslistofadd[1]['details'][0]['type']['group']
                    [BasicInfo.indexlang()] ==
                'تلقائي') &&
        !inerlist[0]['controller'].text.toString().startsWith("https://")) {
      inerlist[0]['controller'].text =
          'https://${inerlist[0]['controller'].text}';
    } else if ((Remind.bodieslistofadd[1]['details'][0]['type']['group']
                    [BasicInfo.indexlang()] ==
                'manual' ||
            Remind.bodieslistofadd[1]['details'][0]['type']['group']
                    [BasicInfo.indexlang()] ==
                'يدوي') &&
        dateslist.isEmpty) {
      Lang.mainerrormsg =
          Lang.errormsgs['emptydays-check'][BasicInfo.indexlang()];
      for (var i in Remind.maintitlesdialogMz01) {
        i['selected'] = false;
      }
      Remind.maintitlesdialogMz01[1]['selected'] = true;
    } else if (inerlist[1]['error'] != null) {
      Lang.mainerrormsg = inerlist[1]['error'];
    } else {
      Remind.listofactionbuttonforadd[0]['visible'] = false;
      Remind.listofactionbuttonforadd[2]['visible'] = true;
      update();

      if (Remind.bodieslistofadd[1]['details'][0]['type']['group']
                  [BasicInfo.indexlang()] ==
              'auto' ||
          Remind.bodieslistofadd[1]['details'][0]['type']['group']
                  [BasicInfo.indexlang()] ==
              'تلقائي') {
        reminddate = !foundation.kIsWeb
            ? await setreminddate(
                type: 'auto', host: inerlist[0]['controller'].text)
            : null;
      } else {
        reminddate = await setreminddate(type: 'manual', dateslist: dateslist);
      }

      queries.add(reminddate == null
          ? '''
insert into remind(
remindname,
reminddetails,
remind_office_id,
notifi,
type,certsrc,sendalertbefor,repeate,reminddate,createby_id,createdate)values
('${Remind.remindnamecontroller.text.trim()}',
'${Remind.reminddetailscontroller.text.trim()}',
'${DB.allofficeinfotable![0]['offices'].where((element) => element['officename'] == officeslistandindex).toList()[0]['office_id']}',
"${Remind.bodieslistofadd[0]['notifi'] == true ? '1' : '0'}",
'${Remind.bodieslistofadd[1]['details'][0]['type']['group'][BasicInfo.indexlang()] == 'auto' || Remind.bodieslistofadd[1]['details'][0]['type']['group'][BasicInfo.indexlang()] == 'تلقائي' ? 'auto' : 'manual'}',
'${Remind.bodieslistofadd[1]['details'][0]['type']['group'][BasicInfo.indexlang()] == 'auto' || Remind.bodieslistofadd[1]['details'][0]['type']['group'][BasicInfo.indexlang()] == 'تلقائي' ? inerlist[0]['controller'].text : 'null'}',
'${inerlist[1]['controller'].text}',
'${inerlist[2]['controller'].text}',
null,
${BasicInfo.LogInInfo![0]},
'${(DateTime.now())}'
);
'''
          : '''
insert into remind(
remindname,
reminddetails,
remind_office_id,
notifi,
type,certsrc,sendalertbefor,repeate,reminddate,reminddategetdate,createby_id,createdate)values
('${Remind.remindnamecontroller.text.trim()}',
'${Remind.reminddetailscontroller.text.trim()}',
'${DB.allofficeinfotable![0]['offices'].where((element) => element['officename'] == officeslistandindex).toList()[0]['office_id']}',
"${Remind.bodieslistofadd[0]['notifi'] == true ? '1' : '0'}",
'${Remind.bodieslistofadd[1]['details'][0]['type']['group'][BasicInfo.indexlang()] == 'auto' || Remind.bodieslistofadd[1]['details'][0]['type']['group'][BasicInfo.indexlang()] == 'تلقائي' ? 'auto' : 'manual'}',
'${Remind.bodieslistofadd[1]['details'][0]['type']['group'][BasicInfo.indexlang()] == 'auto' || Remind.bodieslistofadd[1]['details'][0]['type']['group'][BasicInfo.indexlang()] == 'تلقائي' ? inerlist[0]['controller'].text : 'null'}',
'${inerlist[1]['controller'].text}',
'${inerlist[2]['controller'].text}',
'$reminddate',
'${DateTime.now()}',
${BasicInfo.LogInInfo![0]},
'${(DateTime.now())}'
);
''');
      if (Remind.bodieslistofadd[1]['details'][0]['type']['group']
                  [BasicInfo.indexlang()] ==
              'manual' ||
          Remind.bodieslistofadd[1]['details'][0]['type']['group']
                  [BasicInfo.indexlang()] ==
              'يدوي') {
        dateslist.sort((a, b) => a.toString().compareTo(b.toString()));
        for (var i in dateslist) {
          queries.add('''
insert into reminddates(remind_d_id,rdate)values
 ((select max(remind_id) from remind),
 '$i'
);
''');
        }
      }
      queries.add('''
insert into logs(log,logdate)values
("${BasicInfo.LogInInfo![1]} add a new Remind _name: remindname ${Remind.remindnamecontroller.text}",
"${DateTime.now()}");
      ''');
      try {
        l:
        for (var q in queries) {
          await DBController()
              .requestpost(type: 'curd', data: {'customquery': '$q'});
          {
            if (Lang.mainerrormsg != null) {
              if (Lang.mainerrormsg!.contains("Duplicate")) {
                Lang.mainerrormsg = Remind.bodieslistofadd[0]['tf'][0]
                        ['error'] =
                    "${Remind.remindnamecontroller.text} ${Lang.errormsgs['duplicate'][BasicInfo.indexlang()]}";
                for (var i in Remind.maintitlesdialogMz01) {
                  i['selected'] = false;
                }
                Remind.maintitlesdialogMz01[0]['selected'] = true;
              } else {
                Lang.mainerrormsg = Lang.mainerrormsg;
              }
              break l;
            }
          }
        }
        if (Lang.mainerrormsg == null) {
          DB.allremindinfotable = await DBController().getallremindinfo();
          DB.allusersinfotable = await DBController().getallusersinfo();
          DB.allofficeinfotable = await DBController().getallofficeinfo();
          dbController.update();
          Get.back();
        }
      } catch (e) {
        Lang.mainerrormsg =
            Lang.errormsgs['server-error'][BasicInfo.indexlang()];
      }
    }
    Remind.listofactionbuttonforadd[0]['visible'] = true;
    Remind.listofactionbuttonforadd[2]['visible'] = false;

    update();
  }

  updateremind(
      {inerlist,
      remindid,
      required List<DateTime> dateslist,
      officeslistandindex}) async {
    inerlist[0]['error'] = null;
    inerlist[1]['error'] = null;
    inerlist[2]['error'] = null;
    DateTime? reminddate;
    Lang.mainerrormsg = null;
    Remind.bodieslistofadd[0]['tf'][0]['error'] = null;
    List queries = [];

    if (Remind.remindnamecontroller.text.trim().isEmpty) {
      Remind.bodieslistofadd[0]['tf'][0]['error'] =
          Lang.errormsgs['emptyname-check'][BasicInfo.indexlang()];
      for (var i in Remind.maintitlesdialogMz01) {
        i['selected'] = false;
      }
      Remind.maintitlesdialogMz01[0]['selected'] = true;
    } else if ((Remind.bodieslistofadd[1]['details'][0]['type']['group']
                    [BasicInfo.indexlang()] ==
                'auto' ||
            Remind.bodieslistofadd[1]['details'][0]['type']['group'][BasicInfo.indexlang()] ==
                'تلقائي') &&
        inerlist[0]['controller'].text.isEmpty) {
      inerlist[0]['error'] =
          Lang.errormsgs['emptycert-check'][BasicInfo.indexlang()];
      for (var i in Remind.maintitlesdialogMz01) {
        i['selected'] = false;
      }
      Remind.maintitlesdialogMz01[1]['selected'] = true;
    } else if ((Remind.bodieslistofadd[1]['details'][0]['type']['group']
                    [BasicInfo.indexlang()] ==
                'auto' ||
            Remind.bodieslistofadd[1]['details'][0]['type']['group']
                    [BasicInfo.indexlang()] ==
                'تلقائي') &&
        !inerlist[0]['controller'].text.toString().startsWith("https://")) {
      inerlist[0]['controller'].text =
          'https://${inerlist[0]['controller'].text}';
    } else if ((Remind.bodieslistofadd[1]['details'][0]['type']['group']
                    [BasicInfo.indexlang()] ==
                'manual' ||
            Remind.bodieslistofadd[1]['details'][0]['type']['group']
                    [BasicInfo.indexlang()] ==
                'يدوي') &&
        dateslist.isEmpty) {
      Lang.mainerrormsg =
          Lang.errormsgs['emptydays-check'][BasicInfo.indexlang()];
      for (var i in Remind.maintitlesdialogMz01) {
        i['selected'] = false;
      }
      Remind.maintitlesdialogMz01[1]['selected'] = true;
    } else if (inerlist[1]['error'] != null) {
      Lang.mainerrormsg = inerlist[1]['error'];
    } else {
      Remind.listofactionbuttonforedit[0]['visible'] = false;
      Remind.listofactionbuttonforedit[2]['visible'] = true;
      update();

      if (Remind.bodieslistofadd[1]['details'][0]['type']['group']
                  [BasicInfo.indexlang()] ==
              'auto' ||
          Remind.bodieslistofadd[1]['details'][0]['type']['group']
                  [BasicInfo.indexlang()] ==
              'تلقائي') {
        if (!foundation.kIsWeb) {
          reminddate = await setreminddate(
              type: 'auto', host: inerlist[0]['controller'].text);
        }
      } else {
        reminddate = await setreminddate(type: 'manual', dateslist: dateslist);
      }

      queries.add(reminddate == null
          ? '''
update remind set
remindname='${Remind.remindnamecontroller.text.trim()}',
reminddetails='${Remind.reminddetailscontroller.text.trim()}',
remind_office_id='${DB.allofficeinfotable![0]['offices'].where((element) => element['officename'] == officeslistandindex).toList()[0]['office_id']}',
notifi="${Remind.bodieslistofadd[0]['notifi'] == true ? '1' : '0'}",
type='${Remind.bodieslistofadd[1]['details'][0]['type']['group'][BasicInfo.indexlang()] == 'auto' || Remind.bodieslistofadd[1]['details'][0]['type']['group'][BasicInfo.indexlang()] == 'تلقائي' ? 'auto' : 'manual'}',
certsrc='${Remind.bodieslistofadd[1]['details'][0]['type']['group'][BasicInfo.indexlang()] == 'auto' || Remind.bodieslistofadd[1]['details'][0]['type']['group'][BasicInfo.indexlang()] == 'تلقائي' ? inerlist[0]['controller'].text : 'null'}',
sendalertbefor='${inerlist[1]['controller'].text}',
repeate='${inerlist[2]['controller'].text}',
reminddate=null,
editby_id=${BasicInfo.LogInInfo![0]},
editdate='${(DateTime.now())}'
where remind_id=$remindid;
'''
          : '''
update remind set
remindname='${Remind.remindnamecontroller.text.trim()}',
reminddetails='${Remind.reminddetailscontroller.text.trim()}',
remind_office_id='${DB.allofficeinfotable![0]['offices'].where((element) => element['officename'] == officeslistandindex).toList()[0]['office_id']}',
notifi="${Remind.bodieslistofadd[0]['notifi'] == true ? '1' : '0'}",
type='${Remind.bodieslistofadd[1]['details'][0]['type']['group'][BasicInfo.indexlang()] == 'auto' || Remind.bodieslistofadd[1]['details'][0]['type']['group'][BasicInfo.indexlang()] == 'تلقائي' ? 'auto' : 'manual'}',
certsrc='${Remind.bodieslistofadd[1]['details'][0]['type']['group'][BasicInfo.indexlang()] == 'auto' || Remind.bodieslistofadd[1]['details'][0]['type']['group'][BasicInfo.indexlang()] == 'تلقائي' ? inerlist[0]['controller'].text : 'null'}',
sendalertbefor='${inerlist[1]['controller'].text}',
repeate='${inerlist[2]['controller'].text}',
reminddate='$reminddate',
reminddategetdate='${DateTime.now()}',
editby_id=${BasicInfo.LogInInfo![0]},
editdate='${(DateTime.now())}'
where remind_id=$remindid;
''');
      queries.add('''
delete from reminddates where remind_d_id=$remindid;
''');
      if (Remind.bodieslistofadd[1]['details'][0]['type']['group']
                  [BasicInfo.indexlang()] ==
              'manual' ||
          Remind.bodieslistofadd[1]['details'][0]['type']['group']
                  [BasicInfo.indexlang()] ==
              'يدوي') {
        dateslist.sort((a, b) => a.toString().compareTo(b.toString()));
        for (var i in dateslist) {
          queries.add('''
insert into reminddates(remind_d_id,rdate)values
 ($remindid,
 '$i'
);
''');
        }
      }
      queries.add('''
insert into logs(log,logdate)values
("${BasicInfo.LogInInfo![1]} add a new Remind _name: remindname ${Remind.remindnamecontroller.text}",
"${DateTime.now()}");
      ''');
      try {
        l:
        for (var q in queries) {
          await DBController()
              .requestpost(type: 'curd', data: {'customquery': '$q'});
          {
            if (Lang.mainerrormsg != null) {
              if (Lang.mainerrormsg!.contains("Duplicate")) {
                Lang.mainerrormsg = Remind.bodieslistofadd[0]['tf'][0]
                        ['error'] =
                    "${Remind.remindnamecontroller.text} ${Lang.errormsgs['duplicate'][BasicInfo.indexlang()]}";
                for (var i in Remind.maintitlesdialogMz01) {
                  i['selected'] = false;
                }
                Remind.maintitlesdialogMz01[0]['selected'] = true;
              } else {
                Lang.mainerrormsg = Lang.mainerrormsg;
              }
              break l;
            }
          }
        }
        if (Lang.mainerrormsg == null) {
          DB.allusersinfotable = await DBController().getallusersinfo();
          DB.allofficeinfotable = await DBController().getallofficeinfo();
          DB.allremindinfotable = await DBController().getallremindinfo();
          dbController.update();
          Get.back();
        }
      } catch (e) {
        Lang.mainerrormsg =
            Lang.errormsgs['server-error'][BasicInfo.indexlang()];
      }
    }
    Remind.listofactionbuttonforedit[0]['visible'] = true;
    Remind.listofactionbuttonforedit[2]['visible'] = false;
    update();
  }

  disableenablenotifiremind({remindid, list, listvisible, val}) async {
    String status = DB.allremindinfotable![0]['remind']
        .where((u) => u['remind_id'] == remindid)
        .toList()[0]['notifi'];
    String remindname = DB.allremindinfotable![0]['remind']
        .where((u) => u['remind_id'] == remindid)
        .toList()[0]['remindname'];
    List queries = [
      status == '1'
          ? '''
update remind set notifi=0 where remind_id=$remindid;
'''
          : '''
update remind set notifi=1 where remind_id=$remindid;
''',
      '''
insert into logs(log,logdate)values
("${BasicInfo.LogInInfo![1]} ${status == '1' ? "disable notifi of remind remindname $remindname" : "enable notifi of remind remindname $remindname"}",
"${DateTime.now()}");
'''
    ];
    list[val] = false;
    listvisible[val] = true;
    update();
    try {
      for (var q in queries) {
        await DBController()
            .requestpost(type: 'curd', data: {'customquery': '$q'});
      }
      DB.allusersinfotable = await DBController().getallusersinfo();
      DB.allofficeinfotable = await DBController().getallofficeinfo();
      DB.allremindinfotable = await DBController().getallremindinfo();
      dbController.update();
    } catch (e) {
      print(e);
    }
    list[val] = true;
    listvisible[val] = false;

    update();
  }

  removeremind({remindid, list}) async {
    String remindname = DB.allremindinfotable![0]['remind'][DB
        .allremindinfotable![0]['remind']
        .indexWhere((r) => r['remind_id'] == remindid)]['remindname'];
    List queries = [
      '''
delete from reminddates where remind_d_id=$remindid;
''',
      '''
delete from remind where remind_id=$remindid;
''',
      '''
insert into logs(log,logdate)values
("${BasicInfo.LogInInfo![1]} delete remind _remindname $remindname",
"${DateTime.now()}");
      ''',
    ];
    list[0]['visible'] = false;
    list[2]['visible'] = true;
    update();
    try {
      for (var q in queries) {
        await DBController()
            .requestpost(type: 'curd', data: {'customquery': '$q'});
      }
      list[0]['visible'] = true;
      list[2]['visible'] = false;
      DB.allremindinfotable = await DBController().getallremindinfo();
      dbController.update();
      Get.back();
    } catch (e) {
      null;
    }

    update();
  }

  addaccount() async {
    Lang.mainerrormsg = null;
    for (var i in Accounts.bodieslistofadd[0]['tf']) {
      i['error'] = null;
    }

    List queries = [
      '''
insert into users(username,fullname,password,mobile,email)values
('${Accounts.usernamecontroller.text.trim()}',
'${Accounts.fullnamecontroller.text.trim()}',
'${codepassword(word: Accounts.passwordcontroller.text)}',
'${Accounts.mobilecontorller.text}',
'${Accounts.emailcontroller.text}'
);
''',
      '''
insert into users_privileges(up_user_id,admin,enable,mustchgpass,pbx)values
(
  (select max(user_id) from users),
  ${Accounts.bodieslistofadd[1]['bp'][0]['admin']},
  ${Accounts.bodieslistofadd[1]['bp'][0]['enable']},
  ${Accounts.bodieslistofadd[1]['bp'][0]['mustchgpass']},
  ${Accounts.bodieslistofadd[1]['bp'][0]['pbx']}
);
'''
    ];
    for (var i in Accounts.addtoofficelist
        .where((element) => element['visible'] == false)) {
      queries.add('''
            insert into users_priv_office 
            (upo_user_id,upo_office_id,position,
            addtask,showalltasks,
            addping,showallpings,
            addcost,showallcosts,acceptcosts,
            addtodo,showalltodos,
            addremind,showallreminds,
            addemailtest,showallemailtests,
            addhyperlink,showallhyperlinks)
            values(
            (select max(user_id) from users),
            ${i['office_id']},
            '${i['position'][1]}',
            ${i['P-addtask'][0] == true ? 1 : 0},${i['P-showalltasks'][0] == true ? 1 : 0},
            ${i['P-addping'][0] == true ? 1 : 0},${i['P-showallpings'][0] == true ? 1 : 0},
            ${i['P-addcost'][0] == true ? 1 : 0},${i['P-showallcosts'][0] == true ? 1 : 0},${i['P-acceptcosts'][0] == true ? 1 : 0},
            ${i['P-addtodo'][0] == true ? 1 : 0},${i['P-showalltodos'][0] == true ? 1 : 0},
            ${i['P-addremind'][0] == true ? 1 : 0},${i['P-showallreminds'][0] == true ? 1 : 0},
            ${i['P-addemailtest'][0] == true ? 1 : 0},${i['P-showallemailtests'][0] == true ? 1 : 0},
            ${i['P-addhyperlink'][0] == true ? 1 : 0},${i['P-showallhyperlinks'][0] == true ? 1 : 0}
            );
            ''');
    }
    queries.add('''
insert into logs(log,logdate)values
("${BasicInfo.LogInInfo![1]} add a new user _name: username ${Accounts.usernamecontroller.text}",
"${DateTime.now()}");
      ''');
    if (Accounts.usernamecontroller.text.trim().isEmpty) {
      Accounts.bodieslistofadd[0]['tf'][0]['error'] =
          Lang.errormsgs['emptyname-check'][BasicInfo.indexlang()];
      for (var i in Accounts.maintitlesdialogMz01) {
        i['selected'] = false;
      }
      Accounts.maintitlesdialogMz01[0]['selected'] = true;
    } else if (Accounts.fullnamecontroller.text.trim().isEmpty) {
      Accounts.bodieslistofadd[0]['tf'][1]['error'] =
          Lang.errormsgs['emptyname-check'][BasicInfo.indexlang()];
      for (var i in Accounts.maintitlesdialogMz01) {
        i['selected'] = false;
      }
      Accounts.maintitlesdialogMz01[0]['selected'] = true;
    } else if (Accounts.passwordcontroller.text.isEmpty) {
      Accounts.bodieslistofadd[0]['tf'][2]['error'] =
          Lang.errormsgs['emptypass-check'][BasicInfo.indexlang()];
      for (var i in Accounts.maintitlesdialogMz01) {
        i['selected'] = false;
      }
      Accounts.maintitlesdialogMz01[0]['selected'] = true;
    } else if (Accounts.passwordcontroller.text !=
        Accounts.confirmpasswordcontroller.text) {
      Accounts.bodieslistofadd[0]['tf'][3]['error'] =
          Lang.errormsgs['not-match'][BasicInfo.indexlang()];
      for (var i in Accounts.maintitlesdialogMz01) {
        i['selected'] = false;
      }
      Accounts.maintitlesdialogMz01[0]['selected'] = true;
    } else {
      Accounts.listofactionbuttonforadd[0]['visible'] = false;
      Accounts.listofactionbuttonforadd[2]['visible'] = true;
      update();
      try {
        l:
        for (var q in queries) {
          await DBController()
              .requestpost(type: 'curd', data: {'customquery': '$q'});
          {
            if (Lang.mainerrormsg != null) {
              if (Lang.mainerrormsg!.contains("Duplicate")) {
                if (Lang.mainerrormsg!.contains('users.username')) {
                  Lang.mainerrormsg = Accounts.bodieslistofadd[0]['tf'][0]
                          ['error'] =
                      "${Accounts.usernamecontroller.text} ${Lang.errormsgs['duplicate'][BasicInfo.indexlang()]}";
                } else if (Lang.mainerrormsg!.contains('users.fullname')) {
                  Lang.mainerrormsg = Accounts.bodieslistofadd[0]['tf'][1]
                          ['error'] =
                      "${Accounts.usernamecontroller.text} ${Lang.errormsgs['duplicate'][BasicInfo.indexlang()]}";
                } else {
                  Lang.mainerrormsg = Lang.mainerrormsg;
                }

                for (var i in Accounts.maintitlesdialogMz01) {
                  i['selected'] = false;
                }
                Accounts.maintitlesdialogMz01[0]['selected'] = true;
              } else {
                Lang.mainerrormsg = Lang.mainerrormsg;
              }
              break l;
            }
          }
        }
        if (Lang.mainerrormsg == null) {
          DB.allofficeinfotable = await DBController().getallofficeinfo();
          DB.userinfotable =
              await DBController().getuserinfo(userid: BasicInfo.LogInInfo![0]);
          DB.allusersinfotable = await DBController().getallusersinfo();
          dbController.update();
          Get.back();
        }
      } catch (e) {
        Lang.mainerrormsg =
            Lang.errormsgs['server-error'][BasicInfo.indexlang()];
      }
    }
    Accounts.listofactionbuttonforadd[0]['visible'] = true;
    Accounts.listofactionbuttonforadd[2]['visible'] = false;
    update();
  }

  removecost({costid, list}) async {
    String costname = DB.allcostsinfotable![0]['costs'][DB.allcostsinfotable![0]
            ['costs']
        .indexWhere((r) => r['cost_id'] == costid)]['costname'];
    List queries = [
      '''
delete from costs where cost_id=$costid;
''',
      '''
insert into logs(log,logdate)values
("${BasicInfo.LogInInfo![1]} delete cost _costname $costname",
"${DateTime.now()}");
      ''',
    ];
    list[0]['visible'] = false;
    list[2]['visible'] = true;
    update();
    try {
      for (var q in queries) {
        await DBController()
            .requestpost(type: 'curd', data: {'customquery': '$q'});
      }
      list[0]['visible'] = true;
      list[2]['visible'] = false;
      DB.allofficeinfotable = await DBController().getallofficeinfo();
      DB.allusersinfotable = await DBController().getallusersinfo();
      DB.allcostsinfotable = await DBController().getallcostinfo();
      dbController.update();
      Get.back();
    } catch (e) {
      null;
    }

    update();
  }

  updatecost({costid, officeid}) async {
    Lang.mainerrormsg = null;
    Offices.bodieslistofadd[0]['tf'][0]['error'] = null;
    List queries = [
      '''
update costs set
costname='${Costs.labelcontroller.text.trim()}',
costdetails='${Costs.notescontroller.text.trim()}',
cost_project='${Costs.projectcontroller.text.trim()}',
cost='${Costs.costcontroller.text.trim()}',
costdate='${Costs.bodieslistofadd[0]['date']}',
cost_office_id='$officeid'
where cost_id=$costid;
'''
    ];

    queries.add('''
insert into logs(log,logdate)values
("${BasicInfo.LogInInfo![0]} edit costs info for cost_id $costid _name: costname ${Costs.labelcontroller.text.trim()}",
"${DateTime.now()}");
      ''');
    if (Costs.labelcontroller.text.trim().isEmpty) {
      Costs.bodieslistofadd[0]['tf'][0]['error'] =
          Lang.errormsgs['emptyname-check'][BasicInfo.indexlang()];
      for (var i in Costs.maintitlesdialogMz01) {
        i['selected'] = false;
      }
      Costs.maintitlesdialogMz01[0]['selected'] = true;
    } else {
      Costs.listofactionbuttonforedit[0]['visible'] = false;
      Costs.listofactionbuttonforedit[2]['visible'] = true;
      update();
      try {
        l:
        for (var q in queries) {
          await DBController()
              .requestpost(type: 'curd', data: {'customquery': '$q'});
          {
            if (Lang.mainerrormsg != null) {
              if (Lang.mainerrormsg!.contains("Duplicate")) {
                Lang.mainerrormsg = Costs.bodieslistofadd[0]['tf'][0]['error'] =
                    "${Costs.labelcontroller.text} ${Lang.errormsgs['duplicate'][BasicInfo.indexlang()]}";
                for (var i in Costs.maintitlesdialogMz01) {
                  i['selected'] = false;
                }
                Costs.maintitlesdialogMz01[0]['selected'] = true;
              } else {
                Lang.mainerrormsg = Lang.mainerrormsg;
              }
              break l;
            }
          }
        }
        if (Lang.mainerrormsg == null) {
          DB.allofficeinfotable = await DBController().getallofficeinfo();
          DB.userinfotable =
              await DBController().getuserinfo(userid: BasicInfo.LogInInfo![0]);
          DB.allusersinfotable = await DBController().getallusersinfo();
          DB.allcostsinfotable = await DBController().getallcostinfo();
          dbController.update();
          Get.back();
        }
      } catch (e) {
        Lang.mainerrormsg =
            Lang.errormsgs['server-error'][BasicInfo.indexlang()];
      }
    }
    Costs.listofactionbuttonforedit[0]['visible'] = true;
    Costs.listofactionbuttonforedit[2]['visible'] = false;

    update();
  }

  disableenableaccount({userid, list, listvisible, val}) async {
    String status = DB.allusersinfotable![0]['users_privileges']
        .where((u) => u['up_user_id'] == userid)
        .toList()[0]['enable'];
    String username = DB.allusersinfotable![0]['users']
        .where((u) => u['user_id'] == userid)
        .toList()[0]['username'];
    List queries = [
      status == '1'
          ? '''
update users_privileges set enable=0 where up_user_id=$userid;
'''
          : '''
update users_privileges set enable=1 where up_user_id=$userid;
''',
      '''
insert into logs(log,logdate)values
("${BasicInfo.LogInInfo![1]} ${status == '1' ? "disable account _username $username" : "enable account _username $username"}",
"${DateTime.now()}");
'''
    ];
    list[val] = false;
    listvisible[val] = true;
    update();
    try {
      for (var q in queries) {
        await DBController()
            .requestpost(type: 'curd', data: {'customquery': '$q'});
      }
      DB.allofficeinfotable = await DBController().getallofficeinfo();
      DB.userinfotable =
          await DBController().getuserinfo(userid: BasicInfo.LogInInfo![0]);
      DB.allusersinfotable = await DBController().getallusersinfo();
    } catch (e) {}
    list[val] = true;
    listvisible[val] = false;
    dbController.update();
    update();
  }

  hideshowpass({list, e}) {
    list[list.indexOf(e)]['obscuretext'] =
        list[list.indexOf(e)]['obscuretext'] == true ? false : true;
    list[list.indexOf(e)]['icon'] =
        list[list.indexOf(e)]['icon'] == Icons.visibility
            ? Icons.visibility_off
            : Icons.visibility;
    update();
  }

  resetpassword(
      {userid, newpassword, confirmpassword, actionlist, tflist}) async {
    String username = DB.allusersinfotable![0]['users'][DB.allusersinfotable![0]
            ['users']
        .indexWhere((r) => r['user_id'] == userid)]['user_id'];
    List queries = [
      '''
update users set password="${codepassword(word:newpassword.text)}" where user_id=$userid;
''',
      '''
insert into logs(log,logdate)values
("${BasicInfo.LogInInfo![1]} reset password for account _username $username",
"${DateTime.now()}");
      ''',
    ];
    if (newpassword.text.isEmpty) {
      tflist[0]['error'] =
          Lang.errormsgs['emptypass-check'][BasicInfo.indexlang()];
    } else if (newpassword.text != confirmpassword.text) {
      tflist[1]['error'] = Lang.errormsgs['not-match'][BasicInfo.indexlang()];
    } else {
      actionlist[0]['visible'] = false;
      actionlist[2]['visible'] = true;
      update();
      try {
        for (var q in queries) {
          await DBController()
              .requestpost(type: 'curd', data: {'customquery': '$q'});
        }
        actionlist[0]['visible'] = true;
        actionlist[2]['visible'] = false;
        DB.allofficeinfotable = await DBController().getallofficeinfo();
        DB.userinfotable =
            await DBController().getuserinfo(userid: BasicInfo.LogInInfo![0]);
        DB.allusersinfotable = await DBController().getallusersinfo();
        dbController.update();
        Get.back();
      } catch (e) {
        null;
      }
    }

    update();
  }

  updateaccount({userid}) async {
    Lang.mainerrormsg = null;
    for (var i in Accounts.bodieslistofadd[0]['tf']) {
      i['error'] = null;
    }

    List queries = [
      '''
${Accounts.passwordcontroller.text.isNotEmpty ? '''
update users
set username='${Accounts.usernamecontroller.text.trim()}',
fullname='${Accounts.fullnamecontroller.text.trim()}',
password='${codepassword(word: Accounts.passwordcontroller.text)}',
mobile='${Accounts.mobilecontorller.text}',
email='${Accounts.emailcontroller.text}'
where user_id=$userid;
''' : '''
update users
set username='${Accounts.usernamecontroller.text.trim()}',
fullname='${Accounts.fullnamecontroller.text.trim()}',
mobile='${Accounts.mobilecontorller.text}',
email='${Accounts.emailcontroller.text}'
where user_id=$userid;
'''}

''',
      '''
update users_privileges
set up_user_id=$userid,
admin=${Accounts.bodieslistofadd[1]['bp'][0]['admin']},
enable=${Accounts.bodieslistofadd[1]['bp'][0]['enable']},
mustchgpass=${Accounts.bodieslistofadd[1]['bp'][0]['mustchgpass']},
pbx=${Accounts.bodieslistofadd[1]['bp'][0]['pbx']}
where up_user_id=$userid;  
''',
      '''
delete from users_priv_office where upo_user_id=$userid;
'''
    ];
    for (var i in Accounts.addtoofficelist
        .where((element) => element['visible'] == false)) {
      queries.add('''
            insert into users_priv_office 
            (upo_user_id,upo_office_id,position,
            addtask,showalltasks,
            addping,showallpings,
            addcost,showallcosts,acceptcosts,
            addtodo,showalltodos,
            addremind,showallreminds,
            addemailtest,showallemailtests,
            addhyperlink,showallhyperlinks)
            values(
            $userid,
            ${i['office_id']},
            '${i['position'][1]}',
            ${i['P-addtask'][0] == true ? 1 : 0},${i['P-showalltasks'][0] == true ? 1 : 0},
            ${i['P-addping'][0] == true ? 1 : 0},${i['P-showallpings'][0] == true ? 1 : 0},
            ${i['P-addcost'][0] == true ? 1 : 0},${i['P-showallcosts'][0] == true ? 1 : 0},${i['P-acceptcosts'][0] == true ? 1 : 0},
            ${i['P-addtodo'][0] == true ? 1 : 0},${i['P-showalltodos'][0] == true ? 1 : 0},
            ${i['P-addremind'][0] == true ? 1 : 0},${i['P-showallreminds'][0] == true ? 1 : 0},
            ${i['P-addemailtest'][0] == true ? 1 : 0},${i['P-showallemailtests'][0] == true ? 1 : 0},
            ${i['P-addhyperlink'][0] == true ? 1 : 0},${i['P-showallhyperlinks'][0] == true ? 1 : 0}
            );
            ''');
    }
    queries.add('''
insert into logs(log,logdate)values
("${BasicInfo.LogInInfo![1]} update  userinfo _name: username ${Accounts.usernamecontroller.text}",
"${DateTime.now()}");
      ''');
    if (Accounts.usernamecontroller.text.trim().isEmpty) {
      Accounts.bodieslistofadd[0]['tf'][0]['error'] =
          Lang.errormsgs['emptyname-check'][BasicInfo.indexlang()];
      for (var i in Offices.maintitlesdialogMz01) {
        i['selected'] = false;
      }
      Offices.maintitlesdialogMz01[0]['selected'] = true;
    } else if (Accounts.fullnamecontroller.text.trim().isEmpty) {
      Accounts.bodieslistofadd[0]['tf'][1]['error'] =
          Lang.errormsgs['emptyname-check'][BasicInfo.indexlang()];
      for (var i in Accounts.maintitlesdialogMz01) {
        i['selected'] = false;
      }
      Accounts.maintitlesdialogMz01[0]['selected'] = true;
    } else if (Accounts.passwordcontroller.text !=
        Accounts.confirmpasswordcontroller.text) {
      Accounts.bodieslistofadd[0]['tf'][3]['error'] =
          Lang.errormsgs['not-match'][BasicInfo.indexlang()];
      for (var i in Accounts.maintitlesdialogMz01) {
        i['selected'] = false;
      }
      Accounts.maintitlesdialogMz01[0]['selected'] = true;
    } else {
      Accounts.listofactionbuttonforedit[0]['visible'] = false;
      Accounts.listofactionbuttonforedit[2]['visible'] = true;
      update();
      try {
        l:
        for (var q in queries) {
          await DBController()
              .requestpost(type: 'curd', data: {'customquery': '$q'});
          {
            if (Lang.mainerrormsg != null) {
              if (Lang.mainerrormsg!.contains("Duplicate")) {
                if (Lang.mainerrormsg!.contains('users.username')) {
                  Lang.mainerrormsg = Accounts.bodieslistofadd[0]['tf'][0]
                          ['error'] =
                      "${Accounts.usernamecontroller.text} ${Lang.errormsgs['duplicate'][BasicInfo.indexlang()]}";
                } else if (Lang.mainerrormsg!.contains('users.fullname')) {
                  Lang.mainerrormsg = Accounts.bodieslistofadd[0]['tf'][1]
                          ['error'] =
                      "${Accounts.usernamecontroller.text} ${Lang.errormsgs['duplicate'][BasicInfo.indexlang()]}";
                } else {
                  Lang.mainerrormsg = Lang.mainerrormsg;
                }

                for (var i in Accounts.maintitlesdialogMz01) {
                  i['selected'] = false;
                }
                Accounts.maintitlesdialogMz01[0]['selected'] = true;
              } else {
                Lang.mainerrormsg = Lang.mainerrormsg;
              }
              break l;
            }
          }
        }
        if (Lang.mainerrormsg == null) {
          DB.allofficeinfotable = await DBController().getallofficeinfo();
          DB.userinfotable =
              await DBController().getuserinfo(userid: BasicInfo.LogInInfo![0]);
          DB.allusersinfotable = await DBController().getallusersinfo();
          dbController.update();
          Get.back();
        }
      } catch (e) {
        Lang.mainerrormsg =
            Lang.errormsgs['server-error'][BasicInfo.indexlang()];
      }
    }
    Accounts.listofactionbuttonforedit[0]['visible'] = true;
    Accounts.listofactionbuttonforedit[2]['visible'] = false;
    update();
  }

  removeaccount({userid, list}) async {
    String username = DB.allusersinfotable![0]['users'][DB.allusersinfotable![0]
            ['users']
        .indexWhere((r) => r['user_id'] == userid)]['username'];
    List queries = [
      '''
update tasks set createby_id=null where createby_id=$userid;
''',
      '''
update tasks set editby_id=null where editby_id=$userid;
''',
      '''
update users_tasks set ut_user_id=null where ut_user_id=$userid;
''',
      '''
update remind set createby_id=null where createby_id=$userid;
''',
      '''
update remind set editby_id=null where editby_id=$userid;
''',
      '''
update todo set createby_id=null where createby_id=$userid;
''',
      '''
update todo set editby_id=null where editby_id=$userid;
''',
      '''
update costs set cost_user_id=null where cost_user_id=$userid;
''',
      '''
update comments set uc_user_id=null where uc_user_id=$userid;
''',
      '''
update chat set sender_id=null where sender_id=$userid;
''',
      '''
update chat set reciever_id=null where reciever_id=$userid;
''',
      '''
delete from users_privileges where up_user_id=$userid;
''',
      '''
delete from users_priv_office where upo_user_id=$userid;
''',
      '''
delete from users where user_id=$userid;
''',
      '''
insert into logs(log,logdate)values
("${BasicInfo.LogInInfo![1]} delete account _username $username",
"${DateTime.now()}");
      ''',
    ];
    list[0]['visible'] = false;
    list[2]['visible'] = true;
    update();
    try {
      for (var q in queries) {
        await DBController()
            .requestpost(type: 'curd', data: {'customquery': '$q'});
      }
      list[0]['visible'] = true;
      list[2]['visible'] = false;
      DB.allofficeinfotable = await DBController().getallofficeinfo();
      DB.userinfotable =
          await DBController().getuserinfo(userid: BasicInfo.LogInInfo![0]);
      DB.allusersinfotable = await DBController().getallusersinfo();
      dbController.update();
      Get.back();
    } catch (e) {
      null;
    }

    update();
  }

  getCert({required String host}) async {
    if (foundation.kIsWeb == true) {
      return null;
    } else {
      var getExpiredate;
      try {
        await Process.run('Powershell.exe', [
          '''
    Set-ItemProperty -Path "HKCU:\\Control Panel\\International" -Name sShortDate -Value "yyyy/MM/dd";
    '''
        ]);

        getExpiredate = await Process.run('Powershell.exe', [
          '''
# Ignore SSL Warning
[Net.ServicePointManager]::ServerCertificateValidationCallback = { \$true }
# Create Web Http request to URI
\$webRequest = [Net.HttpWebRequest]::Create("$host")
# Retrieve the Information for URI
\$webRequest.GetResponse() | Out-NULL
# Get SSL Certificate Expiration Date
\$webRequest.ServicePoint.Certificate.GetExpirationDateString()
'''
        ]);
      } catch (e) {}
      DateTime? result;
      String? r;
      try {
        r = getExpiredate.stdout;
        r = r!.substring(0, r.indexOf(' '));
        r = r.replaceAll('/', '-');
        result = DateTime.parse(r);
      } catch (r) {
        return null;
      }
      return result;
    }
  }

  setreminddate({type, host, dateslist}) async {
    DateTime? reminddate;
    if (type == 'auto') {
      if (foundation.kIsWeb) {
        reminddate = null;
      }
      reminddate = await getCert(host: host);
    } else {
      dateslist.sort((a, b) => a.toString().compareTo(b.toString()));
      l:
      for (var i in dateslist) {
        reminddate = i;
        if (i.difference(DateTime.now()).inDays >= 0) {
          reminddate = i;
          break l;
        }
      }
    }

    return reminddate;
  }

  calcreminddateasint({e}) {
    int? result;
    if (e['reminddate'] == null) {
      result = null;
    } else {
      try {
        result = (DateTime.parse(e['reminddate']).difference(DateTime.now()
                .add(Duration(days: int.parse(e['sendalertbefor'])))))
            .inDays;
      } catch (e) {}
    }
    return result;
  }

  calcexpiredateasint({e}) {
    int? result;
    if (e['reminddate'] == null) {
      result = null;
    } else {
      result =
          (DateTime.parse(e['reminddate']).difference(DateTime.now())).inDays;
    }
    return result;
  }

  calcreminddate({e}) {
    String? result;
    if (e['reminddate'] == null) {
      result = ['غير محدد', 'not defined'][BasicInfo.indexlang()];
    } else {
      int days = (DateTime.parse(e['reminddate']).difference(DateTime.now()
              .add(Duration(days: int.parse(e['sendalertbefor'])))))
          .inDays;
      if (days > 0) {
        result = ['$days يوم', '$days days'][BasicInfo.indexlang()];
      } else if (days == 0) {
        int hours = 24 +
            ((DateTime.parse(e['reminddate']).difference(DateTime.now()
                    .add(Duration(days: int.parse(e['sendalertbefor'])))))
                .inHours);
        result = ['$hours ساعة', '$hours hour'][BasicInfo.indexlang()];
      } else {
        result = [
          'منتهية منذ $days يوم',
          'expire from $days days'
        ][BasicInfo.indexlang()];
      }
    }
    return result;
  }

  calcexpiredate({e}) {
    String? result;
    if (e['reminddate'] == null) {
      result = ['غير محدد', 'not defined'][BasicInfo.indexlang()];
    } else {
      int days =
          (DateTime.parse(e['reminddate']).difference(DateTime.now())).inDays;
      if (days > 0) {
        result = ['$days يوم', '$days days'][BasicInfo.indexlang()];
      } else if (days == 0) {
        int hours = 24 +
            ((DateTime.parse(e['reminddate']).difference(DateTime.now()))
                .inHours);
        result = ['$hours ساعة', '$hours hour'][BasicInfo.indexlang()];
      } else {
        result = [
          'منتهية منذ $days يوم',
          'expire from $days days'
        ][BasicInfo.indexlang()];
      }
    }
    return result;
  }

  addcost({officeid}) async {
    Lang.mainerrormsg = null;
    for (var i in Accounts.bodieslistofadd[0]['tf']) {
      i['error'] = null;
    }

    List queries = [
      '''
insert into costs(costname,costdetails,cost_project,costdate,cost_user_id,cost_office_id)values
('${Costs.labelcontroller.text.trim()}',
'${Costs.notescontroller.text.trim()}',
'${Costs.projectcontroller.text.trim()}',
'${Costs.bodieslistofadd[0]['date']}',
'${BasicInfo.LogInInfo![0]}',
$officeid
);
''',
    ];

    queries.add('''
insert into logs(log,logdate)values
("${BasicInfo.LogInInfo![1]} add a new cost request _name: costname ${Costs.labelcontroller.text.trim()}",
"${DateTime.now()}");
      ''');
    if (Costs.labelcontroller.text.trim().isEmpty) {
      Costs.bodieslistofadd[0]['tf'][0]['error'] =
          Lang.errormsgs['emptyname-check'][BasicInfo.indexlang()];
      for (var i in Costs.maintitlesdialogMz01) {
        i['selected'] = false;
      }
      Costs.maintitlesdialogMz01[0]['selected'] = true;
    } else {
      Costs.listofactionbuttonforadd[0]['visible'] = false;
      Costs.listofactionbuttonforadd[2]['visible'] = true;
      update();
      try {
        l:
        for (var q in queries) {
          await DBController()
              .requestpost(type: 'curd', data: {'customquery': '$q'});
          {
            if (Lang.mainerrormsg != null) {
              if (Lang.mainerrormsg!.contains("Duplicate")) {
                Lang.mainerrormsg = Accounts.bodieslistofadd[0]['tf'][0]
                        ['error'] =
                    "${Costs.labelcontroller.text} ${Lang.errormsgs['duplicate'][BasicInfo.indexlang()]}";
                for (var i in Costs.maintitlesdialogMz01) {
                  i['selected'] = false;
                }
                Accounts.maintitlesdialogMz01[0]['selected'] = true;
              } else {
                Lang.mainerrormsg = Lang.mainerrormsg;
              }
              break l;
            }
          }
        }
        if (Lang.mainerrormsg == null) {
          DB.allcostsinfotable = await DBController().getallcostinfo();
          dbController.update();
          Get.back();
        }
      } catch (e) {
        Lang.mainerrormsg =
            Lang.errormsgs['server-error'][BasicInfo.indexlang()];
      }
    }
    Costs.listofactionbuttonforadd[0]['visible'] = true;
    Costs.listofactionbuttonforadd[2]['visible'] = false;
    update();
  }

  setdate({ctx, date}) async {
    DateTime? t = await showDatePicker(
        context: ctx,
        initialDate: DateTime.now(),
        firstDate: DateTime.parse("2023-09-01"),
        lastDate: DateTime.now());
    if (t != null) {
      date[0]['date'] = t;
    }
    update();
  }

  streamsessionforadd({i}) {
    for (var o in DB.allremindinfotable![0]['remind']) {
      i = o;
    }
    Stream stream =
        Stream.periodic(Duration(minutes: int.parse(i['repeate'])), (x) => x++);
    stream.listen((event) async {
      try {
        i['remind_id'] = DB.allremindinfotable![0]['remind']
            .where((u) => u['remind_id'] == i['remind_id'])
            .toList()[0]['remind_id'];

        i['remindname'] = DB.allremindinfotable![0]['remind']
            .where((u) => u['remind_id'] == i['remind_id'])
            .toList()[0]['remindname'];
        i['reminddetails'] = DB.allremindinfotable![0]['remind']
            .where((u) => u['remind_id'] == i['remind_id'])
            .toList()[0]['reminddetails'];
        i['repeate'] = DB.allremindinfotable![0]['remind']
            .where((u) => u['remind_id'] == i['remind_id'])
            .toList()[0]['repeate'];
        i['lastsend'] = DB.allremindinfotable![0]['remind']
            .where((u) => u['remind_id'] == i['remind_id'])
            .toList()[0]['lastsend'];
        i['notifi'] = DB.allremindinfotable![0]['remind']
            .where((u) => u['remind_id'] == i['remind_id'])
            .toList()[0]['notifi'];
        i['reminddate'] = DB.allremindinfotable![0]['remind']
            .where((u) => u['remind_id'] == i['remind_id'])
            .toList()[0]['reminddate'];
        i['remind_office_id'] = DB.allremindinfotable![0]['remind']
            .where((u) => u['remind_id'] == i['remind_id'])
            .toList()[0]['remind_office_id'];
      } catch (r) {
        i['remind_id'] = null;
      }
      if (DB.allofficeinfotable![0]['offices']
              .where((of) => of['office_id'] == i['remind_office_id'])
              .toList()[0]['notifi'] ==
          '1') {
        if (i['remind_id'] != null && i['notifi'] == '1') {
          if (i['lastsend'] == null) {
            try {
              await dbController.requestpost(type: 'curd', data: {
                'customquery':
                    'update remind set lastsend="${DateTime.now()}" where remind_id=${i['remind_id']};'
              });
              var t = await dbController.requestpost(type: 'select', data: {
                'customquery':
                    'select lastsend from remind where remind_id=${i['remind_id']};'
              });
              i['lastsend'] = t[0][0];
            } catch (e) {}
          }

          if (DateTime.now()
                      .difference(DateTime.parse(i['lastsend']))
                      .inMinutes +
                  1 >=
              int.parse(i['repeate'])) {
            try {
              if (mainController.calcreminddateasint(e: i) <= 0) {
                String? testtoken = (await Telegram(DB.allofficeinfotable![0]
                                ['offices']
                            .where((of) =>
                                of['office_id'] == i['remind_office_id'])
                            .toList()[0]['apitoken'])
                        .getMe())
                    .username;
                if (testtoken != null) {
                  String token = DB.allofficeinfotable![0]['offices']
                      .where((of) => of['office_id'] == i['remind_office_id'])
                      .toList()[0]['apitoken'];
                  String chatid = DB.allofficeinfotable![0]['offices']
                      .where((of) => of['office_id'] == i['remind_office_id'])
                      .toList()[0]['chatid'];
                  await TeleDart(token, Event('')).sendMessage(chatid, '''
${i['remindname']}
${i['reminddetails']}
المدة المتبقية ${mainController.calcexpiredate(e: i)}
ـــــــــــــــ
''');
                  await dbController.requestpost(type: 'curd', data: {
                    'customquery':
                        'update remind set lastsend="${DateTime.now()}" where remind_id=${i['remind_id']};'
                  });
                  var t = await dbController.requestpost(type: 'select', data: {
                    'customquery':
                        'select lastsend from remind where remind_id=${i['remind_id']};'
                  });
                  i['lastsend'] = t[0][0];
                }
              }
            } catch (i) {
              print(i);
            }
          }
        }
      }
    });
  }
}
