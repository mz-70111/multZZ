import 'dart:convert';
import 'package:get/get.dart';
import 'package:mz_flutter_07/models/basicinfo.dart';
import 'package:http/http.dart' as http;
import 'package:mz_flutter_07/models/database.dart';

class DBController extends GetxController {
  @override
  @override
  void onInit() async {
    super.onInit();
    // try {
    //   DB().createtables();
    // } catch (e) {}
  }

  requestpost({type, data}) async {
    BasicInfo.error = null;
    // ignore: prefer_typing_uninitialized_variables
    var result;
    var resp = await http.post(
        type == 'select'
            ? Uri.parse("${BasicInfo.host}${BasicInfo.selecttable}")
            : Uri.parse("${BasicInfo.host}${BasicInfo.curdtable}"),
        body: data);
    if (resp.statusCode == 200) {
      result = json.decode(resp.body);
    }
    try {
      if (result['status'] != 'done') {
        BasicInfo.error = result['status'];
      }
    } catch (e) {
      null;
    }
    return result;
  }

  gettableinfo({required List tablesname, required List infoqueries}) async {
    List clmnames = [];
    List result = [{}];
    for (var i in tablesname) {
      result[0].addAll({i: []});
      clmnames.add([]);
      List? resp =
          await requestpost(type: 'select', data: {'customquery': ' desc $i;'});
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

  checkconnect() async {
    return await requestpost(
        type: 'select', data: {'customquery': 'show databases;'});
  }

  changpass({userid, password}) async {
    await DBController().requestpost(type: "curd", data: {
      'customquery':
          "update users set password='$password' where user_id=$userid;"
    });
  }
}
