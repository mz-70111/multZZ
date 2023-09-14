import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mz_flutter_07/controllers/dbcontroller.dart';
import 'package:mz_flutter_07/models/basicinfo.dart';
import 'package:mz_flutter_07/models/database.dart';
import 'package:mz_flutter_07/models/dropdowanwithsearch.dart';
import 'package:mz_flutter_07/models/sharedpref.dart';
import 'package:mz_flutter_07/views/homepage.dart';
import 'package:mz_flutter_07/views/login.dart';
import 'package:mz_flutter_07/views/offices.dart';

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
    Offices.bodieslistofadd[0]['notifi'] = x;
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

  addremoveemployeetooffice({list, y, type = 'save'}) {
    if (type == 'save') {
      list[list.indexOf(y)]['visible'] = false;
    } else {
      list[list.indexOf(y)]['visible'] = true;
    }
    Get.back();
    update();
  }

  onhover({list, required index, color, iconsize, elevate}) {
    color != null
        ? list[index]['color'] = BasicInfo.selectedmode == 'Light'
            ? Colors.blueAccent.withOpacity(0.3)
            : Colors.greenAccent.withOpacity(0.3)
        : null;
    iconsize != null ? list[index]['iconsize'] = 50.0 : null;
    elevate != null ? list[index]['elevate'] = 3.0 : null;

    update();
  }

  onexit({list, required index, color, elevate, iconsize}) {
    color != null ? list[index]['color'] = Colors.transparent : null;
    iconsize != null ? list[index]['iconsize'] = 40.0 : null;
    elevate != null ? list[index]['elevate'] = 0.0 : null;
    update();
  }

  changeradiopriv({x, index}) {
    Offices.addemployeelist[index]['position'] = x == 'موظف' || x == 'employee'
        ? ['موظف', 'employee']
        : ['مشرف', 'supervisor'];
    if (x == 'مشرف' || x == 'supervisor') {
      Offices.addemployeelist[index]['P-addtask'][0] = true;
      Offices.addemployeelist[index]['P-showalltasks'][0] = true;
      Offices.addemployeelist[index]['P-addtodo'][0] = true;
      Offices.addemployeelist[index]['P-showalltodos'][0] = true;
      Offices.addemployeelist[index]['P-addping'][0] = true;
      Offices.addemployeelist[index]['P-showallpings'][0] = true;
      Offices.addemployeelist[index]['P-addemailtest'][0] = true;
      Offices.addemployeelist[index]['P-showallemailtests'][0] = true;
      Offices.addemployeelist[index]['P-addremind'][0] = true;
      Offices.addemployeelist[index]['P-showallreminds'][0] = true;
      Offices.addemployeelist[index]['P-addhyperlink'][0] = true;
      Offices.addemployeelist[index]['P-showallhyperlinks'][0] = true;
      Offices.addemployeelist[index]['P-addcost'][0] = true;
      Offices.addemployeelist[index]['P-acceptcosts'][0] = true;
      Offices.addemployeelist[index]['P-showallcosts'][0] = true;
    } else {
      Offices.addemployeelist[index]['P-addtask'][0] = false;
      Offices.addemployeelist[index]['P-showalltasks'][0] = false;
      Offices.addemployeelist[index]['P-addtodo'][0] = true;
      Offices.addemployeelist[index]['P-showalltodos'][0] = true;
      Offices.addemployeelist[index]['P-addping'][0] = true;
      Offices.addemployeelist[index]['P-showallpings'][0] = true;
      Offices.addemployeelist[index]['P-addemailtest'][0] = true;
      Offices.addemployeelist[index]['P-showallemailtests'][0] = true;
      Offices.addemployeelist[index]['P-addremind'][0] = true;
      Offices.addemployeelist[index]['P-showallreminds'][0] = true;
      Offices.addemployeelist[index]['P-addhyperlink'][0] = false;
      Offices.addemployeelist[index]['P-showallhyperlinks'][0] = false;
      Offices.addemployeelist[index]['P-addcost'][0] = true;
      Offices.addemployeelist[index]['P-acceptcosts'][0] = false;
      Offices.addemployeelist[index]['P-showallcosts'][0] = false;
    }
    update();
  }

  chackboxpriv({x, index, e}) {
    Offices.addemployeelist[index][e][0] = x;

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

  // setstartdatefor({ctx}) async {
  //   DateTime? dt = await showDatePicker(
  //       context: ctx,
  //       initialDate: Offices.startdate,
  //       firstDate: DateTime.parse("2023-08-01"),
  //       lastDate: DateTime.now());
  //   if (dt != null) {
  //     Offices.startdate = dt;
  //     dbController.update();
  //   }
  // }

  addoffice() async {
    BasicInfo.error = null;
    Offices.bodieslistofadd[0]['tf'][0]['error'] = null;
    List queries = [
      '''
insert into offices(officename,chatid,apitoken,notifi)values
('${Offices.officenamecontroller.text}',
'${Offices.chatidcontroller.text}',
'${Offices.apitokencontroller.text}',
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
    if (Offices.officenamecontroller.text.isEmpty) {
      Offices.bodieslistofadd[0]['tf'][0]['error'] =
          BasicInfo.errorstype['emptyname-check'][BasicInfo.indexlang()];
      for (var i in Offices.mainlabelsdialogmz) {
        i['selected'] = false;
      }
      Offices.mainlabelsdialogmz[0]['selected'] = true;
    } else {
      Offices.actionlistofadd[0]['visible'] = false;
      Offices.actionlistofadd[2]['visible'] = true;
      update();
      try {
        l:
        for (var q in queries) {
          await DBController()
              .requestpost(type: 'curd', data: {'customquery': '$q'});
          {
            if (BasicInfo.error != null) {
              if (BasicInfo.error!.contains("Duplicate")) {
                BasicInfo.error = Offices.bodieslistofadd[0]['tf'][0]['error'] =
                    "${Offices.officenamecontroller.text} ${BasicInfo.errorstype['duplicate'][BasicInfo.indexlang()]}";
                for (var i in Offices.mainlabelsdialogmz) {
                  i['selected'] = false;
                }
                Offices.mainlabelsdialogmz[0]['selected'] = true;
              } else {
                BasicInfo.error = BasicInfo.error;
              }
              break l;
            }
          }
        }
        if (BasicInfo.error == null) {
          Get.back();
          DB.allofficeinfotable = await DBController().getallofficeinfo();
          dbController.update();
        }
      } catch (e) {
        BasicInfo.error =
            BasicInfo.errorstype['server-error'][BasicInfo.indexlang()];
      }
    }
    Offices.actionlistofadd[0]['visible'] = true;
    Offices.actionlistofadd[2]['visible'] = false;
    update();
  }

//   updateoffice({officeid}) async {
//     DialogMz.errormsg = null;
//     List queries = [
//       '''
// update office set
// officename='${Office.officenamecontroller.text}',
// chatid='${Office.officechatidcontroller.text}',
// notifi=${Office.notifi == true ? 1 : 0} where office_id=$officeid;
// ''',
//       '''
// delete from users_priv_office where upo_office_id=$officeid;
// '''
//     ];

//     for (var i
//         in Office.offmem.where((element) => element['visible'] == false)) {
//       queries.add('''
//             insert into users_priv_office (upo_user_id,upo_office_id,position,addtask,addouttask,addremind,addtodo,addping,addemailtest)
//             values(
//             ${i['user_id']},
//             $officeid,
//             '${i['Position']}',
//             ${i['P-addtask'] == true ? 1 : 0},
//             ${i['P-addouttask'] == true ? 1 : 0},
//             ${i['P-addremind'] == true ? 1 : 0},
//             ${i['P-addtodo'] == true ? 1 : 0},
//             ${i['P-addping'] == true ? 1 : 0},
//             ${i['P-addemailtest'] == true ? 1 : 0}
//             );
//             ''');
//     }
//     queries.add('''
// insert into logs(log,logdate)values
// ("${LogIn.userinfo![0]} edit office info for office_id $officeid _name: Officename ${Office.officenamecontroller.text}",
// "${DateTime.now()}");
//       ''');
//     if (Office.officenamecontroller.text.isEmpty) {
//       DialogMz.errormsg =
//           Lang.lang['name-empty'][Lang.langlist.indexOf(Lang.selectlanguage)];
//       for (var i = 0; i < DialogMz.selectedlist.length; i++) {
//         DialogMz.selectedlist[i] = false;
//       }
//       DialogMz.selectedlist[0] = true;
//     } else {
//       DialogMz.wait = true;
//       update();
//       try {
//         l:
//         for (var q in queries) {
//           await DBController().requestpost(
//               url: "${InfoBasic.host}${InfoBasic.curdtable}",
//               data: {'customquery': '$q'});
//           {
//             if (InfoBasic.error != null) {
//               if (InfoBasic.error!.contains("Duplicate")) {
//                 DialogMz.errormsg = Lang.lang['duplicate']
//                     [Lang.langlist.indexOf(Lang.selectlanguage)];
//                 break l;
//               } else {
//                 DialogMz.errormsg = InfoBasic.error;
//               }
//             }
//           }
//         }
//         if (InfoBasic.error == null) {
//           Get.back();
//         }
//         DB.allofficeinfotable = await DBController().getallofficeinfotable();
//       } catch (e) {
//         DialogMz.errormsg = LogIn.mainloginerrormsg =
//             "${Lang.lang['server-error'][Lang.langlist.indexOf(Lang.selectlanguage)]}";
//       }
//     }
//     DialogMz.wait = false;
//     update();
//   }

  removeoffice({officeid, listse}) async {
    List queries = [
      '''
insert into logs(log,logdate)values
("${BasicInfo.LogInInfo![1]} delete office _Officename ${DB.allofficeinfotable[0]['offices'][DB.allofficeinfotable[0]['offices'].indexWhere((r) => r['office_id'] == officeid)]['officename']}",
"${DateTime.now()}");
      ''',
      '''
delete from users_priv_office where upo_office_id=$officeid;
''',
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
update cost set cost_office_id=null where cost_office_id=$officeid;
''',
      '''
delete from offices where office_id=$officeid;
''',
    ];

    try {
      for (var q in queries) {
        await DBController()
            .requestpost(type: 'curd', data: {'customquery': '$q'});
      }
      DB.allofficeinfotable = await DBController().getallofficeinfo();
      dbController.update();
    } catch (e) {
      print(e);
      null;
    }
    for (var l in listse) {
      for (var j in l) {
        j['elevate'] = 0.0;
      }
    }

    update();
  }
}
