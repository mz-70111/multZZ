import 'dart:convert';
import 'package:get/get.dart';
import 'package:mz_flutter_07/models/basicinfo.dart';
import 'package:http/http.dart' as http;
import 'package:mz_flutter_07/models/database.dart';
import 'package:mz_flutter_07/models/lang_mode_theme.dart';
import 'package:mz_flutter_07/views/login.dart';
import 'package:mz_flutter_07/views/repare.dart';

class DBController extends GetxController {
  @override
  void onInit() async {
    super.onInit();
    try {
      await DB().createtables();
    } catch (e) {}
    update();
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
    return await gettableinfo(
        tablesname: ['remind', 'reminddates'],
        infoqueries: ['select * from remind;', 'select * from reminddates;']);
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
