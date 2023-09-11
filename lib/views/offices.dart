import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:mz_flutter_07/controllers/dbcontroller.dart';
import 'package:mz_flutter_07/controllers/maincontroller.dart';
import 'package:mz_flutter_07/models/basicinfo.dart';
import 'package:mz_flutter_07/models/bottonicon.dart';
import 'package:mz_flutter_07/models/database.dart';
import 'package:mz_flutter_07/models/dialog01.dart';
import 'package:mz_flutter_07/models/dropdowanwithsearch.dart';
import 'package:mz_flutter_07/models/page_tamplate01.dart';
import 'package:mz_flutter_07/models/textfeild.dart';
import 'package:mz_flutter_07/views/login.dart';
import 'package:mz_flutter_07/views/wait.dart';

class Offices extends StatelessWidget {
  const Offices({super.key});
  static List<Map> mainlabelsdialogmz = [
    {
      'name': ['معلومات عامة', 'Basics'],
      'selected': true,
    },
    {
      'name': ['إضافة موظف', 'Add Employee'],
      'selected': false,
    }
  ];
  static TextEditingController officenamecontroller = TextEditingController();
  static TextEditingController chatidcontroller = TextEditingController();
  static bool notifi = false;
  static double elevationcard = 0.0;
  static List bodieslist = [
    {
      'notifi': false,
      'tf': [
        {
          'label': ['اسم المكتب', 'Office name'],
          'controller': officenamecontroller
        },
        {
          'label': ['chat id', 'chat id'],
          'controller': officenamecontroller,
          'td': TextDirection.ltr
        }
      ]
    }
  ];
  static List<Map> addemployeelist = [];

  @override
  Widget build(BuildContext context) {
    basics() {
      return GetBuilder<MainController>(
        init: mainController,
        builder: (_) => Column(
          children: [
            ...bodieslist[0]['tf'].map((w) => TextFieldMz(
                label: w['label'],
                onchange: (x) => null,
                controller: w['controller'],
                td: w['td'] ?? BasicInfo.lang())),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Switch(
                    value: bodieslist[0]['notifi'],
                    onChanged: (x) =>
                        mainController.switchbuttonnotifioffice(x)),
                Text("${[
                  'الإشعارات',
                  'Notification'
                ][BasicInfo.indexlang()]} ${bodieslist[0]['notifi'] == true ? [
                    'مفعلة',
                    'enabled'
                  ][BasicInfo.indexlang()] : [
                    'موقفة',
                    'stoped'
                  ][BasicInfo.indexlang()]}"),
              ],
            ),
          ],
        ),
      );
    }

    addemployee() {
      return GetBuilder<MainController>(
        init: mainController,
        builder: (_) => Column(
          children: [
            Card(
              child: Column(
                children: [
                  Text([
                    'أعضاء المكتب',
                    'Office members'
                  ][BasicInfo.indexlang()]),
                  SizedBox(
                    height: (((addemployeelist
                                        .where((element) =>
                                            element['visible'] == false)
                                        .length *
                                    180) /
                                (MediaQuery.of(context).size.width).ceil()) *
                            100) +
                        100,
                    child: GridView(
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 180, mainAxisExtent: 50),
                      children: [
                        ...addemployeelist
                            .where((element) => element['visible'] == false)
                            .map((e) => Card(
                                  elevation: 6,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      e['name'],
                                      style: const TextStyle(
                                          fontFamily: 'Changa', fontSize: 15),
                                    ),
                                  ),
                                ))
                      ],
                    ),
                  )
                ],
              ),
            ),
            Divider(),
            Card(
              child: DropDownWithSearchMz(
                items: addemployeelist,
                ontap: (it) => mainController.addemployeetooffice(it),
              ),
            )
          ],
        ),
      );
    }

    return GetBuilder<DBController>(
      init: dbController,
      builder: (_) => PageTamplate01(
        futurefun: Future(() async {
          try {
            DB.allusersinfotable = await DBController().getallusersinfo();
            return DB.allofficeinfotable =
                await DBController().getallofficeinfo();
          } catch (e) {}
        }),
        table: DB.allofficeinfotable,
        // prepairfunction: Future(() async {
        //   try {
        //     return getemployees();
        //   } catch (e) {}
        // }),
        tablename: 'offices',
        appbartitle: ['المكاتب', 'Offices'],
        addtitle: ['إضافة مكتب', 'Add Office'],
        mainlebelsdialogmz: mainlabelsdialogmz,
        bodies: [basics(), addemployee()],
        actionlist: [SizedBox()],
        elevationcard: elevationcard,
        page: 'Offices',
      ),
    );
  }

  getemployees({e}) async {
    DB.allusersinfotable = await DBController().getallusersinfo();
    if (addemployeelist.isEmpty) {
      try {
        addemployeelist.clear();
        if (e == null) {
          for (var i in DB.allusersinfotable[0]['users']) {
            addemployeelist.add({});
            addemployeelist[DB.allusersinfotable[0]['users'].indexOf(i)]
                .addAll({
              'user_id': i['user_id'],
              'name': i['fullname'],
              'visible': true,
              'visiblesearch': true
            });
          }
        }
      } catch (e) {
        null;
      }
    }
  }
}
