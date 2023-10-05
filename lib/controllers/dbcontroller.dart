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
import 'package:intl/intl.dart' as df;
import 'package:flutter/foundation.dart' as foundation;

class DBController extends GetxController {
  @override
  void onInit() async {
    super.onInit();

    try {
      // await DB().createtables();
      DB.allofficeinfotable = await getallofficeinfo();
      DB.allremindinfotable = await getallremindinfo();
    } catch (e) {}
    autosendreminddaily();
    sendalertremind();
    autoupdate();
    update();
  }

  static List remindinstream = [];

  autoupdate() {
    Stream stream = Stream.periodic(Duration(minutes: 30), (x) => x++);
    stream.listen((event) async {
      try {
        DB.allremindinfotable = await dbController.getallremindinfo();
      } catch (r) {}
      if (DB.allremindinfotable != null) {
        for (var i in DB.allremindinfotable![0]['remind']) {
          if (!remindinstream.contains(i['remind_id'])) {
            remindinstream.add(i['remind_id']);
            mainController.streamsessionforadd(i: i);
          }
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
        }
      }
    });
  }

  autosendreminddaily() async {
    if (DB.allremindinfotable != null) {
      Stream stream = Stream.periodic(Duration(minutes: 50), (x) => x++);
      stream.listen((event) async {
        for (var i in DB.allremindinfotable![0]['remind']) {
          List dateslist = [];
          if (i['type'] != 'auto') {
            dateslist.addAll(DB.allremindinfotable![0]['reminddates']
                .where((d) => d['remind_d_id'] == i['remind_id'])
                .toList()
                .map((t) => DateTime.parse(t['rdate']))
                .toList());
          }
          DateTime? dt = await mainController.setreminddate(
              type: i['type'], host: i['certsrc'], dateslist: dateslist);
          try {
            await requestpost(type: 'curd', data: {
              'customquery':
                  'update remind set reminddate="$dt",reminddategetdate="${DateTime.now()}" where remind_id=${i['remind_id']};'
            });
            var dtt = await requestpost(type: 'select', data: {
              'customquery':
                  'select reminddate,reminddategetdate from remind where remind_id=${i['remind_id']};'
            });

            i['reminddate'] = dtt[0][0];
            i['reminddategetdate'] = dtt[0][1];
          } catch (o) {
            print(o);
          }
        }
        if (DateTime.now().hour == 9) {
          if (DB.allremindinfotable![0]['dailysend'][0]['dailysend_remind'] ==
              '0') {
            for (var j in DB.allofficeinfotable![0]['offices']) {
              if (j['notifi'] == '1') {
                String notifiall = '';
                notifiall = '';
                notifiall = 'المهام المجدولة للتذكير';
                for (var i in DB.allremindinfotable![0]['remind']
                    .where((n) => n['remind_office_id'] == j['office_id'])) {
                  notifiall += '''\n
${i['remindname']}
${i['reminddetails']}
نوع تحديد تاريخ الانتهاء ${i['type']}
${i['type'] == 'auto' ? "مصدر الشهادة :${i['certsrc']}" : ''}
المدة المتبقية ${mainController.calcexpiredate(e: i)}
تاريخ الانتهاء : ${i['reminddate'] != null ? 'غير محدد' : '${i['reminddate']}'}
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
                } catch (y) {}
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
            String? token0 = "5106522483:AAEIa6Aw5c4VmZPmBCMX-eRknhMQak-45Xs";
            String? chatid0 = "-4007723865";
            String? username = (await Telegram(token0).getMe()).username;
            if (username != null) {
              await TeleDart(token0, Event('')).sendMessage(chatid0,
                  'a11 in 1 _> Still work ${df.DateFormat("yyyy-MM-dd HH:mm").format(DateTime.now())}');
            }
          } catch (t) {}
        }
      });
    }
  }

  sendalertremind() async {
    if (DB.allremindinfotable != null) {
      remindinstream.clear();
      for (var i in DB.allremindinfotable![0]['remind']) {
        remindinstream.add(i['remind_id']);
        Stream stream = Stream.periodic(
            Duration(minutes: int.parse(i['repeate'])), (x) => x++);
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
                  await requestpost(type: 'curd', data: {
                    'customquery':
                        'update remind set lastsend="${DateTime.now()}" where remind_id=${i['remind_id']};'
                  });
                  var t = await requestpost(type: 'select', data: {
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
                    String? testtoken = (await Telegram(DB
                                .allofficeinfotable![0]['offices']
                                .where((of) =>
                                    of['office_id'] == i['remind_office_id'])
                                .toList()[0]['apitoken'])
                            .getMe())
                        .username;
                    if (testtoken != null) {
                      String token = DB.allofficeinfotable![0]['offices']
                          .where(
                              (of) => of['office_id'] == i['remind_office_id'])
                          .toList()[0]['apitoken'];
                      String chatid = DB.allofficeinfotable![0]['offices']
                          .where(
                              (of) => of['office_id'] == i['remind_office_id'])
                          .toList()[0]['chatid'];
                      await TeleDart(token, Event('')).sendMessage(chatid, '''
${i['remindname']}
${i['reminddetails']}
نوع تحديد تاريخ الانتهاء ${i['type']}
${i['type'] == 'auto' ? "مصدر الشهادة :${i['certsrc']}" : ''}
المدة المتبقية ${mainController.calcexpiredate(e: i)}
تاريخ الانتهاء : ${i['reminddate'] != null ? 'غير محدد' : '${i['reminddate']}'}
ـــــــــــــــ
''');
                      await requestpost(type: 'curd', data: {
                        'customquery':
                            'update remind set lastsend="${DateTime.now()}" where remind_id=${i['remind_id']};'
                      });
                      var t = await requestpost(type: 'select', data: {
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
        print(result['status']);
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

  getallcostinfo() async {
    return await gettableinfo(tablesname: [
      'costs',
      'comments'
    ], infoqueries: [
      'select * from costs;',
      'select * from comments where t_type="costs";',
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
