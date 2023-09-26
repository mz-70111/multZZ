import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mz_flutter_07/controllers/dbcontroller.dart';
import 'package:mz_flutter_07/controllers/maincontroller.dart';
import 'package:mz_flutter_07/models/basicinfo.dart';
import 'package:mz_flutter_07/models/bottonicon.dart';
import 'package:mz_flutter_07/models/database.dart';
import 'package:mz_flutter_07/models/dialog01.dart';
import 'package:mz_flutter_07/models/dropdowanwithsearch.dart';
import 'package:mz_flutter_07/models/lang_mode_theme.dart';
import 'package:mz_flutter_07/models/page_tamplate01.dart';
import 'package:mz_flutter_07/models/textfeild.dart';
import 'package:mz_flutter_07/views/login.dart';
import 'package:mz_flutter_07/views/offices.dart';
import 'package:mz_flutter_07/views/wait.dart';
import 'package:intl/intl.dart' as df;

class Remind extends StatelessWidget {
  const Remind({super.key});
  static List<Map> maintitlesdialogMz01 = [
    {
      'name': ['معلومات أساسية', 'Basics'],
      'selected': true,
    },
    {
      'name': ['خيارات التذكير', 'Remind Options'],
      'selected': false,
    }
  ];
  static TextEditingController remindnamecontroller = TextEditingController();
  static TextEditingController reminddetailscontroller =
      TextEditingController();

  static List bodieslistofadd = [
    {
      'selectedofficeindex': 0,
      'notifi': true,
      'tf': [
        {
          'label': ['اسم التذكير', 'Remind name'],
          'controller': remindnamecontroller,
          'error': null
        },
        {
          'label': ['التفاصيل', 'Details'],
          'controller': reminddetailscontroller,
          'error': null,
          'lines': 5
        },
      ]
    },
    {
      'details': [
        {
          'type': {
            'group': ['تلقائي', 'auto'],
            'auto': ['تلقائي', 'auto'],
            'manual': ['يدوي', 'manual']
          },
          'remindbefor': 10,
          'repeate': 60,
        },
      ]
    }
  ];
  static List<Map> floatactionbuttonlist = [
    {'index': 0, 'elevate': 0.0}
  ];
  static List<Map> listofactionbuttonforadd = [
    {
      'index': 0,
      'visible': true,
      'type': 'do-it',
      'label': ['إضافة', 'Add'],
      'elevate': 0.0
    },
    {
      'index': 1,
      'visible': true,
      'type': 'do-it',
      'label': ['رجوع', 'close'],
      'elevate': 0.0
    },
    {'index': 0, 'visible': false, 'type': 'wait', 'elevate': 0.0}
  ];

  static List<Map> listofactionbuttonforedit = [
    {
      'index': 0,
      'visible': true,
      'type': 'do-it',
      'label': ['حفظ', 'save'],
      'elevate': 0.0
    },
    {
      'index': 1,
      'visible': true,
      'type': 'do-it',
      'label': ['رجوع', 'close'],
      'elevate': 0.0
    },
    {'index': 0, 'visible': false, 'type': 'wait', 'elevate': 0.0}
  ];
  static List<DateTime> searchbydate = [
    DateTime.now().add(Duration(days: -30)),
    DateTime.now()
  ];
  static List easyeditlist = [];
  @override
  Widget build(BuildContext context) {
    TextEditingController certsrccontroller = TextEditingController();
    TextEditingController remindrepeateeverycontroller =
        TextEditingController(text: '60');
    TextEditingController remindbeforcontroller =
        TextEditingController(text: '10');
    List<DateTime> daysofalert = [];
    List tf = [
      {
        'label': ['مصدر الشهادة', 'Certificate src'],
        'controller': certsrccontroller,
        'error': null,
      },
      {
        'label': ['أيام_ تذكير قبل', 'rememper bafor _days'],
        'controller': remindbeforcontroller,
        'error': null,
        'defaultv': "10"
      },
      {
        'label': ['دقيقة_ تكرار التذكير كل', 'repeate alert every _minutes'],
        'controller': remindrepeateeverycontroller,
        'error': null,
        'defaultv': "60"
      }
    ];
    List offices = [];
    offices.clear();
    for (var i in DB.userinfotable[0]['users_priv_office']) {
      offices.add({});
      offices[DB.userinfotable[0]['users_priv_office'].indexOf(i)].addAll({
        'office': DB.allofficeinfotable[0]['offices']
            .where((o) => o['office_id'] == i['upo_office_id'])
            .toList()[0]['officename']
      });
    }
    List officesforadd = [];
    basics() {
      officesforadd.clear();

      for (var i in DB.userinfotable[0]['users_priv_office']
          .where((u) => u['addremind'] == '1')) {
        officesforadd.add({});
        officesforadd[DB.userinfotable[0]['users_priv_office']
                .where((u) => u['addremind'] == '1')
                .toList()
                .indexOf(i)]
            .addAll({
          'office': DB.allofficeinfotable[0]['offices']
              .where((o) => o['office_id'] == i['upo_office_id'])
              .toList()[0]['officename']
        });
      }
      return GetBuilder<MainController>(
        init: mainController,
        builder: (_) => Column(
          children: [
            Row(
              children: [
                Text(['المكتب', 'office'][BasicInfo.indexlang()]),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButton(
                      value: officesforadd[bodieslistofadd[0]
                          ['selectedofficeindex']]['office'],
                      items: officesforadd
                          .map((e) => DropdownMenuItem(
                              value: e['office'], child: Text(e['office'])))
                          .toList(),
                      onChanged: (x) => mainController.dropdaownchhositem(
                          list: bodieslistofadd[0],
                          val: 'selectedofficeindex',
                          x: officesforadd.indexWhere(
                              (element) => element['office'] == x))),
                )
              ],
            ),
            Row(
              children: [
                Switch(
                    value: bodieslistofadd[0]['notifi'],
                    onChanged: (x) => mainController.changeswitchvalue(
                        list: bodieslistofadd[0], val: 'notifi', x: x)),
                Text(bodieslistofadd[0]['notifi'] == true
                    ? ['تفعيل الاشعار', 'enable notifi'][BasicInfo.indexlang()]
                    : [
                        'إيقاف الاشعار',
                        'disable notifi'
                      ][BasicInfo.indexlang()])
              ],
            ),
            ...bodieslistofadd[0]['tf'].map((w) => TextFieldMz(
                label: w['label'],
                error: w['error'],
                lines: w['lines'] ?? 1,
                onchange: (x) => null,
                controller: w['controller'],
                td: w['td'] ?? BasicInfo.lang())),
          ],
        ),
      );
    }

    remindoptions() {
      return GetBuilder<MainController>(
        init: mainController,
        builder: (_) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Row(
                  children: [
                    Radio(
                        value: bodieslistofadd[1]['details'][0]['type']['auto']
                            [BasicInfo.indexlang()],
                        groupValue: bodieslistofadd[1]['details'][0]['type']
                            ['group'][BasicInfo.indexlang()],
                        onChanged: (x) => mainController.changeradio(
                            x: x,
                            list: bodieslistofadd[1]['details'][0]['type'],
                            val: 'group')),
                    Text(bodieslistofadd[1]['details'][0]['type']['auto']
                        [BasicInfo.indexlang()])
                  ],
                ),
                Row(
                  children: [
                    Radio(
                        value: bodieslistofadd[1]['details'][0]['type']
                            ['manual'][BasicInfo.indexlang()],
                        groupValue: bodieslistofadd[1]['details'][0]['type']
                            ['group'][BasicInfo.indexlang()],
                        onChanged: (x) => mainController.changeradio(
                            x: x,
                            list: bodieslistofadd[1]['details'][0]['type'],
                            val: 'group')),
                    Text(bodieslistofadd[1]['details'][0]['type']['manual']
                        [BasicInfo.indexlang()])
                  ],
                ),
              ],
            ),
            bodieslistofadd[1]['details'][0]['type']['group']
                            [BasicInfo.indexlang()] ==
                        'تلقائي' ||
                    bodieslistofadd[1]['details'][0]['type']['group']
                            [BasicInfo.indexlang()] ==
                        'auto'
                ? Column(children: [
                    ...tf.where((element) => tf.indexOf(element) == 0).map(
                        (t) => TextFieldMz(
                            controller: t['controller'],
                            label: t['label'],
                            error: t['error'],
                            onchange: (x) => null,
                            td: TextDirection.ltr))
                  ])
                : Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextButton(
                          onPressed: () => mainController.adddaytoalert(
                              ctx: context, list: daysofalert),
                          child: Text("${[
                            'إضافة يوم',
                            'add day'
                          ][BasicInfo.indexlang()]} +")),
                      ...daysofalert.map((d) => Row(
                            children: [
                              Text(df.DateFormat("yyyy-MM-dd").format(d)),
                              IconButton(
                                  onPressed: () =>
                                      mainController.removedayforalerts(
                                          list: daysofalert, x: d),
                                  icon: Icon(Icons.remove))
                            ],
                          ))
                    ],
                  ),
            Divider(),
            ...tf.where((element) => tf.indexOf(element) > 0).map((t) =>
                TextFieldMz(
                    controller: t['controller'],
                    error: t['error'],
                    label: t['label'],
                    onchange: (x) => mainController.checkifcontentint(
                        x: x,
                        list: tf,
                        index: tf.indexOf(t),
                        defaultv: t['defaultv']),
                    td: BasicInfo.lang()))
          ],
        ),
      );
    }

    initialofdialog({e}) {
      tf[0]['error'] = null;
      tf[1]['error'] = null;
      tf[2]['error'] = null;
      daysofalert.clear();
      maintitlesdialogMz01[0]['selected'] = true;
      maintitlesdialogMz01[1]['selected'] = false;
      for (var i in bodieslistofadd[0]['tf']) {
        i['error'] = null;
        i['hint'] = null;
      }
      if (e == null) {
        remindnamecontroller.text = '';
        reminddetailscontroller.text = '';
        remindbeforcontroller.text = '10';
        remindrepeateeverycontroller.text = '60';
        certsrccontroller.text = '';
        bodieslistofadd[0]['notifi'] = true;
        bodieslistofadd[1]['details'][0]['type']['group'] = ['تلقائي', 'auto'];
      } else {
        bodieslistofadd[0]['selectedofficeindex'] = officesforadd.indexWhere(
            (element) =>
                element['office'] ==
                DB.allofficeinfotable[0]['offices']
                    .where((element) =>
                        element['office_id'] == e['remind_office_id'])
                    .toList()[0]['officename']);
        remindnamecontroller.text = e['remindname'];
        reminddetailscontroller.text = e['reminddetails'];
        remindbeforcontroller.text = e['sendalertbefor'];
        remindrepeateeverycontroller.text = e['repeate'];
        certsrccontroller.text = e['certsrc'];
        bodieslistofadd[0]['notifi'] = e['notifi'] == '1' ? true : false;
        bodieslistofadd[1]['details'][0]['type']['group'] =
            e['type'] == 'auto' ? ['تلقائي', 'auto'] : ['يدوي', 'manual'];
        if (e['type'] != 'auto') {
          certsrccontroller.text = '';
          for (var i in DB.allremindinfotable[0]['reminddates']
              .where((r) => r['remind_d_id'] == e['remind_id'])
              .toList()) {
            daysofalert.add(DateTime.parse(i['rdate']));
          }
        }
      }
    }

    buildeasyeditlist() {
      easyeditlist.clear();
      for (var i in DB.allremindinfotable[0]['remind']) {
        easyeditlist.add([]);
        easyeditlist[DB.allremindinfotable[0]['remind'].indexOf(i)].addAll({
          {
            'index': 0,
            'visible0': true,
            'visible': true,
            'type': 'do-it',
            'icon': Icons.delete_forever,
            'label': ['حذف', 'delete'],
            'elevate': 0.0,
            'backcolor': Colors.transparent,
            'length': 80.0
          },
          {
            'index': 1,
            'visible0': true,
            'visible': true,
            'type': 'do-it',
            'icon': i['notifi'] == '1'
                ? Icons.notifications
                : Icons.notifications_off,
            'label': DB.allremindinfotable[0]['remind']
                        .where((y) => y['remind_id'] == i['remind_id'])
                        .toList()[0]['notifi'] ==
                    '1'
                ? ['تعطيل الاشعارات', 'disable notifi']
                : ['تفعيل الاشعارات', 'enable notifi'],
            'elevate': 0.0,
            'backcolor': Colors.transparent,
            'length': 150.0
          },
          {
            'index': 2,
            'visible0': true,
            'visible': true,
            'type': 'do-it',
            'icon': Icons.edit,
            'label': ['تعديل', 'edit'],
            'elevate': 0.0,
            'backcolor': Colors.transparent,
            'length': 80.0
          },
          {'visible0': true, 'visible': false, 'type': 'wait'},
        });
      }
    }

    List<Function> listoffunctionforadd(e) => [
          (e) async => await mainController.addremind(
              officeslistandindex:
                  offices[bodieslistofadd[0]['selectedofficeindex']]['office'],
              inerlist: tf,
              dateslist: daysofalert),
          (e) => Get.back(),
        ];
    List<Function> listoffunctionforedit(e) => [
          (e) async => await mainController.updateremind(
                remindid: e['remind_id'],
                dateslist: daysofalert,
                officeslistandindex:
                    offices[bodieslistofadd[0]['selectedofficeindex']]
                        ['office'],
                inerlist: tf,
              ),
          (e) => Get.back(),
        ];
    listoffunctionforeasyeditpanel({e, ctx}) => [
          (e) => showDialog(
              context: ctx,
              builder: (_) {
                List actionlist = [
                  {
                    'type': 'do-it',
                    'visible': true,
                    'label': ['حذف', 'delete'],
                    'elevate': 0.0,
                    'index': 0,
                  },
                  {
                    'type': 'do-it',
                    'visible': true,
                    'label': ['رجوع', 'close'],
                    'elevate': 0.0,
                    'index': 1,
                  },
                  {
                    'type': 'wait',
                    'visible': false,
                  }
                ];
                List functionofaction(e) => [
                      (e) => mainController.removeremind(
                          remindid: e['remind_id'], list: actionlist),
                      (e) => Get.back()
                    ];
                return GetBuilder<MainController>(
                  init: mainController,
                  builder: (_) => Directionality(
                    textDirection: BasicInfo.lang(),
                    child: AlertDialog(
                      scrollable: true,
                      title: Text([
                        'هل أنت متأكد من حذف${e['remindname']}?',
                        'sure to delete ${e['remindname']}?'
                      ][BasicInfo.indexlang()]),
                      actions: [
                        ...actionlist
                            .where((element) => element['visible'] == true)
                            .map((y) {
                          switch (y['type']) {
                            case 'do-it':
                              return IconbuttonMz(
                                  e: e,
                                  elevate: y['elevate'],
                                  action: functionofaction(e)[y['index']],
                                  label: y['label'],
                                  buttonlist: actionlist,
                                  index: y['index'],
                                  height: 35,
                                  width: 60,
                                  backcolor: ThemeMz.iconbuttonmzbc());
                            case 'wait':
                              return WaitMz.waitmz0([1, 2, 3, 4], ctx);
                            default:
                              return SizedBox();
                          }
                        })
                      ],
                    ),
                  ),
                );
              }),
          (e) {
            return mainController.disableenablenotifiremind(
                remindid: e['remind_id'],
                list: easyeditlist[DB.allremindinfotable[0]['remind']
                    .indexWhere((u) => u['remind_id'] == e['remind_id'])][1],
                listvisible: easyeditlist[DB.allremindinfotable[0]['remind']
                    .indexWhere((u) => u['remind_id'] == e['remind_id'])][3],
                val: 'visible');
          },
          (e) {
            Lang.mainerrormsg = null;
            initialofdialog(e: e);
            showDialog(
                context: context,
                builder: (_) => DialogMz01(
                    title: ['تعديل', 'edit'],
                    mainlabels: maintitlesdialogMz01,
                    bodies: [basics(), remindoptions()],
                    actionlist: GetBuilder<MainController>(
                      init: mainController,
                      builder: (_) => Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ...listofactionbuttonforedit
                                .where((element) => element['visible'] == true)
                                .map((u) {
                              switch (u['type']) {
                                case 'do-it':
                                  return IconbuttonMz(
                                      backcolor: ThemeMz.iconbuttonmzbc(),
                                      height: 40,
                                      width: 75,
                                      index: u['index'],
                                      buttonlist: listofactionbuttonforedit,
                                      elevate: u['elevate'],
                                      e: e,
                                      action: listoffunctionforedit(u)[
                                          listofactionbuttonforedit.indexOf(u)],
                                      label: u['label']);
                                case 'wait':
                                  return WaitMz.waitmz0(
                                      [1, 2, 3, 4, 5, 6, 7, 8], ctx);
                                default:
                                  return SizedBox();
                              }
                            })
                          ]),
                    )));
          }
        ];

    mainItem({e, ctx}) {
      try {
        return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: ExpansionTile(
                title: Column(
                  children: [
                    Row(children: [
                      Container(
                        width: 10,
                        height: 50,
                        color: mainController.calcexpiredateasint(e: e) == null
                            ? Colors.grey
                            : mainController.calcexpiredateasint(e: e) <= 0
                                ? Colors.red
                                : mainController.calcreminddateasint(e: e) <= 0
                                    ? Colors.deepOrangeAccent
                                    : Colors.green,
                      ),
                      Text("# ${e['remind_id']}_ "),
                      Expanded(
                          child: Text(
                        e['remindname'],
                        style: ThemeMz.titlemediumChanga(),
                      )),
                    ]),
                    Visibility(
                      visible: DB.userinfotable[0]['users_priv_office']
                                  .where((o) =>
                                      o['upo_office_id'] ==
                                      e['remind_office_id'])
                                  .toList()[0]['addremind'] ==
                              '1'
                          ? true
                          : false,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ...easyeditlist[
                                  DB.allremindinfotable[0]['remind'].indexOf(e)]
                              .where((b) =>
                                  b['visible'] == true && b['visible0'] == true)
                              .map((b) {
                            switch (b['type']) {
                              case 'do-it':
                                return IconbuttonMz(
                                  e: e,
                                  action: listoffunctionforeasyeditpanel(
                                      ctx: ctx, e: e)[b['index']],
                                  elevate: b['elevate'],
                                  labelvisible:
                                      b['elevate'] == 3.0 ? true : false,
                                  label: b['label'],
                                  icon: b['icon'],
                                  buttonlist: easyeditlist[DB
                                      .allremindinfotable[0]['remind']
                                      .indexOf(e)],
                                  index: b['index'],
                                  height: 35,
                                  width: b['elevate'] == 3.0 ? b['length'] : 40,
                                  backcolor: b['backcolor'],
                                );
                              case 'wait':
                                return WaitMz.waitmz0([1, 2, 3, 4], context);
                              default:
                                return SizedBox();
                            }
                          })
                        ],
                      ),
                    )
                  ],
                ),
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(e['remind_office_id'] != null
                            ? DB.allofficeinfotable[0]['offices']
                                .where((u) =>
                                    u['office_id'] == e['remind_office_id'])
                                .toList()[0]['officename']
                            : "مكتب محذوف"),
                      ),
                    ],
                  ),
                  Visibility(
                    visible: e['reminddetails'] == '' ? false : true,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(e['reminddetails']),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                            "${['الاشعارات', 'Notifi'][BasicInfo.indexlang()]}"
                            " ${e['notifi'] == '1' ? [
                                'مفعلة',
                                'enabled'
                              ][BasicInfo.indexlang()] : [
                                'ملغاة',
                                'disabled'
                              ][BasicInfo.indexlang()]}"),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(e['reminddate'] == null
                            ? "لم يتم تحديد مدة الانتهاء"
                            : "تاريخ الانتهاء ${df.DateFormat("yyyy-MM-dd").format(DateTime.parse(e['reminddate']))}"),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("${[
                            'تم جلب تاريخ الانتهاء آخر مرة بتاريخ',
                            'end date got last time at'
                          ][BasicInfo.indexlang()]} ${e['reminddategetdate']}")),
                    ],
                  ),
                  Visibility(
                    visible: e['reminddate'] == null ? false : true,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("${[
                            'المدة المتبقية للتنبيه',
                            'Duration to alert'
                          ][BasicInfo.indexlang()]}"
                              " ${mainController.calcreminddate(e: e)}"),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: e['reminddate'] == null ? false : true,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("${[
                            'المدة المتبقية لانتهاء المدة',
                            'Duration to Expire'
                          ][BasicInfo.indexlang()]}"
                              " ${mainController.calcexpiredate(e: e)}"),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("${[
                            'تم إنشاءها بواسطة',
                            'created by'
                          ][BasicInfo.indexlang()]} ${e['createby_id'] != null ? DB.allusersinfotable[0]['users'].where((u) => u['user_id'] == e['createby_id']).toList()[0]['fullname'] : "حساب محذوف"} _${e['createdate']}")),
                    ],
                  ),
                  Visibility(
                    visible: e['editdate'] != null ? true : false,
                    child: Row(
                      children: [
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("${[
                              'تم تعديلها آخر مرة بواسطة',
                              'last edit by'
                            ][BasicInfo.indexlang()]} ${e['editby_id'] != null ? DB.allusersinfotable[0]['users'].where((u) => u['user_id'] == e['editby_id']).toList()[0]['fullname'] : "حساب محذوف"} _${e['editdate']}")),
                      ],
                    ),
                  ),
                  Divider(),
                ],
              ),
            ));
      } catch (t) {
        return SizedBox();
      }
    }

    conditionofview(x) {
      List offices = [];
      offices.clear();
      for (var i in DB.userinfotable[0]['users_priv_office']) {
        offices.add(i['upo_office_id']);
      }
      if (x['createby_id'] == BasicInfo.LogInInfo![0] &&
          offices.contains(x['remind_office_id'])) {
        return true;
      } else if (offices.contains(x['remind_office_id']) &&
          DB.allofficeinfotable[0]['users_priv_office']
                  .where((o) => o['upo_office_id'] == x['remind_office_id'])
                  .toList()[0]['showallreminds'] ==
              '1') {
        return true;
      } else {
        return false;
      }
    }

    bool addactionvisible() {
      int st = 0;
      if (DB.userinfotable[0]['users_priv_office'].isNotEmpty) {
        l:
        for (var i in offices) {
          if (DB.userinfotable[0]['users_priv_office'][offices.indexOf(i)]
                  ['addremind'] ==
              '1') {
            st = 1;
            break l;
          }
        }
      }
      if (st == 1) {
        return true;
      } else {
        return false;
      }
    }

    return GetBuilder<DBController>(
      init: dbController,
      builder: (_) {
        for (var i in DB.allremindinfotable[0]['remind']) {
          i['visiblesearch'] = true;
        }
        PageTamplate01.searchcontroller.text = '';
        PageTamplate01.selectedoffice = 'all';
        for (var i in DB.allremindinfotable[0]['remind']) {
          i['visible'] = true;
        }
        return PageTamplate01(
          appbartitle: const ['التذكير', 'Remind'],
          // searchwithdatevisible: false,
          searchrangelist: const ['remindname', 'reminddetails'],
          chooseofficevisible: true,
          officechooselist: DB.allremindinfotable[0]['remind'],
          officenameclm: 'remind_office_id',
          itemnameclm: 'remind_id',
          conditionofview: (x) => conditionofview(x),
          table: DB.allremindinfotable,
          tablename: 'remind',
          mainItem: (x) => mainItem(ctx: context, e: x),
          startdate: searchbydate[0],
          setstartdate: () => null,
          enddate: searchbydate[0],
          setenddate: () => null,
          addactionvisible: addactionvisible(),
          initialofadd: () => initialofdialog(),
          initial: () => buildeasyeditlist(),
          addactiontitle: const ['إضافة تذكير', 'Add Remind'],
          addactionmainlabelsofpages: maintitlesdialogMz01,
          addactionpages: [
            basics(),
            remindoptions(),
          ],
          listofactionbuttonforadd: listofactionbuttonforadd,
          listoffunctionforadd: (e) => listoffunctionforadd(e),
          floateactionbuttonlist: floatactionbuttonlist,
        );
      },
    );
  }
}
