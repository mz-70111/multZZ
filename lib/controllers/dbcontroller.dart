import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mz_flutter_07/models/basicinfo.dart';
import 'package:http/http.dart' as http;
import 'package:mz_flutter_07/models/database.dart';
import 'package:mz_flutter_07/models/lang_mode_theme.dart';
import 'package:mz_flutter_07/views/login.dart';
import 'package:mz_flutter_07/views/repare.dart';
import 'package:teledart/teledart.dart';
import 'package:teledart/telegram.dart';
import 'package:teledart/util.dart';

class DBController extends GetxController {
  @override
  void onInit() async {
    super.onInit();

    try {
      await DB().createtables();
    } catch (e) {}

    autosendreminddaily();
    sendalertremind();
    update();
  }

  autosendreminddaily() async {
    Stream stream = Stream.periodic(Duration(seconds: 120), (x) => x++);

    DB.allremindinfotable = await getallremindinfo();
    for (var i in DB.allremindinfotable[0]['remind']) {
      List dateslist = [];
      if (i['type'] != 'auto') {
        dateslist.addAll(DB.allremindinfotable[0]['reminddates']
            .where((d) => d['remind_d_id'] == i['remind_id'])
            .toList()
            .map((t) => DateTime.parse(t['rdate']))
            .toList());
      }
      mainController.setreminddate(
          type: i['type'], host: i['certsrc'], dateslist: dateslist);
    }
    stream.listen((event) async {
      if (DateTime.now().hour == 13) {
        if (DB.allremindinfotable[0]['dailysend'][0]['dailysend_remind'] ==
            '0') {
          for (var j in DB.allofficeinfotable[0]['offices']) {
            if (j['notifi'] == '1') {
              String notifiall = '';
              notifiall = '';
              for (var i in DB.allremindinfotable[0]['remind']
                  .where((n) => n['remind_office_id'] == j['office_id'])) {
                notifiall += '''
${i['remindname']}
${i['reminddetails']}
المدة المتبقية لانتهاء المدة المحددة ${mainController.calcexpiredate(e: i)}
------------------------
''';
              }

              try {
                String? username =
                    (await Telegram(j['apitoken']).getMe()).username;
                if (username != null) {
                  await TeleDart(j['apitoken'], Event(''))
                      .sendMessage(j['chatid'], notifiall);
                }
              } catch (y) {
                print(y);
              }
            }
          }
          try {
            await requestpost(type: 'curd', data: {
              'customquery': 'update dailysend set dailysend_remind=1;'
            });
            DB.allremindinfotable = await getallremindinfo();
          } catch (o) {}
        }
      } else {
        try {
          await requestpost(type: 'curd', data: {
            'customquery': 'update dailysend set dailysend_remind=0;'
          });
        } catch (t) {}
      }
    });
  }

  sendalertremind() async {
    DB.allofficeinfotable = await getallofficeinfo();
    DB.allremindinfotable = await getallremindinfo();
    for (var k in DB.allremindinfotable[0]['remind']) {
      int? y = mainController.calcreminddateasint(e: k);
      if (y != null) {
        if (y <= int.parse(k['sendalertbefor'])) {
          Stream stream = Stream.periodic(
              Duration(seconds: int.parse(k['repeate'])), (x) => x++);
          stream.listen((event) async {
            DB.allofficeinfotable = await getallofficeinfo();
            DB.allremindinfotable = await getallremindinfo();
            if (k['notifi'] == '1' &&
                DB.allofficeinfotable[0]['offices']
                        .where((o) => o['office_id'] == k['remind_office_id'])
                        .toList()[0]['notifi'] ==
                    '1') {
              String token = DB.allofficeinfotable[0]['offices']
                  .where((o) => o['office_id'] == k['remind_office_id'])
                  .toList()[0]['apitoken'];
              String chat = DB.allofficeinfotable[0]['offices']
                  .where((o) => o['office_id'] == k['remind_office_id'])
                  .toList()[0]['chatid'];
              String alertmsg;
              alertmsg = '';
              alertmsg = '''
${k['remindname']}
${k['reminddetails']}
المدة المتبقية لانتهاء المدة المحددة ${mainController.calcexpiredate(e: k)}
${DateTime.now()}
''';
              try {
                String? username = (await Telegram(token).getMe()).username;
                if (username != null) {
                  await TeleDart(token, Event('')).sendMessage(chat, alertmsg);
                }
              } catch (y) {}
            }
          });
        }
      }
    }
  }

  requestpost({type, data}) async {
    Lang.mainerrormsg = null;
    // ignore: prefer_typing_uninitialized_variables
    var result;
    var resp;
    resp = await http.post(
        type == 'select'
            ? Uri.parse("${BasicInfo.host}${BasicInfo.selecttable}")
            : Uri.parse("${BasicInfo.host}${BasicInfo.curdtable}"),
        body: data);

    if (resp.statusCode == 200) {
      result = json.decode(resp.body);
    }
    try {
      if (result['status'] != 'done') {
        Lang.mainerrormsg = result['status'];
      }
    } catch (e) {
      null;
    }
    return result;
  }

  gettableinfo({required List tablesname, required List infoqueries}) async {
    List clmnames = [];
    List? result;
    List? testconnection = await requestpost(
        type: 'select', data: {'customquery': 'show tables;'});
    if (testconnection != null) {
      result = [{}];
      for (var i in tablesname) {
        result[0].addAll({i: []});
        clmnames.add([]);

        List? resp = await requestpost(
            type: 'select', data: {'customquery': ' desc $i;'});
        if (resp != null) {
          for (var j in resp) {
            clmnames[tablesname.indexOf(i)]!.add(j[0]);
          }
        }
      }
      for (var i in infoqueries) {
        List? resp = await requestpost(
            type: 'select',
            data: {'customquery': infoqueries[infoqueries.indexOf(i)]});
        if (resp != null) {
          for (var j in resp) {
            result[0][tablesname[infoqueries.indexOf(i)]].add({});
            for (var o = 0; o < j.length; o++) {
              result[0][tablesname[infoqueries.indexOf(i)]][resp.indexOf(j)]
                  .addAll({clmnames[infoqueries.indexOf(i)][o]: j[o]});
            }
          }
        }
      }
      for (var i = 0; i < result[0][tablesname[0]].length; i++) {
        result[0][tablesname[0]][i]
            .addAll({'visible': true, 'visiblesearch': true});
      }
    }
    return result;
  }

  getuserinfo({userid}) async {
    return await gettableinfo(tablesname: [
      'users',
      'users_privileges',
      'users_priv_office'
    ], infoqueries: [
      'select * from users where user_id=$userid;',
      'select * from users_privileges where up_user_id=$userid;',
      'select * from users_priv_office where upo_user_id=$userid;',
    ]);
  }

  getallusersinfo() async {
    return await gettableinfo(tablesname: [
      'users',
      'users_privileges',
      'users_priv_office'
    ], infoqueries: [
      'select * from users;',
      'select * from users_privileges;',
      'select * from users_priv_office;',
    ]);
  }

  getofficeinfo({officeid}) async {
    return await gettableinfo(tablesname: [
      'offices',
      'users_priv_office'
    ], infoqueries: [
      'select * from offices where office_id=$officeid;',
      'select * from users_priv_office where upo_office_id=$officeid;',
    ]);
  }

  getallofficeinfo() async {
    return await gettableinfo(tablesname: [
      'offices',
      'users_priv_office'
    ], infoqueries: [
      'select * from offices;',
      'select * from users_priv_office;',
    ]);
  }

  getallremindinfo() async {
    return await gettableinfo(tablesname: [
      'remind',
      'reminddates',
      'dailysend'
    ], infoqueries: [
      'select * from remind;',
      'select * from reminddates;',
      'select * from dailysend;'
    ]);
  }

  changpass({userid, password}) async {
    await DBController().requestpost(type: "curd", data: {
      'customquery':
          "update users set password='$password' where user_id=$userid;"
    });
  }

  getversion() async {
    List? version;
    version = await gettableinfo(
        tablesname: ['version'], infoqueries: ['select * from version;']);
    RepairPage.version = null;
    if (version != null) {
      RepairPage.version = [];
      RepairPage.version!.add(version[0]['version'][0]['version']);
      RepairPage.version!.add(version[0]['version'][0]['skip']);
    }
    // print("${} **");
    return version;
  }
}
