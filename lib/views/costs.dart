import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mz_flutter_07/controllers/dbcontroller.dart';
import 'package:mz_flutter_07/controllers/maincontroller.dart';
import 'package:mz_flutter_07/models/basicinfo.dart';
import 'package:mz_flutter_07/models/bottonicon.dart';
import 'package:mz_flutter_07/models/database.dart';
import 'package:mz_flutter_07/models/dialog01.dart';
import 'package:mz_flutter_07/models/lang_mode_theme.dart';
import 'package:mz_flutter_07/models/page_tamplate01.dart';
import 'package:mz_flutter_07/models/textfeild.dart';
import 'package:mz_flutter_07/views/login.dart';
import 'package:mz_flutter_07/views/wait.dart';
import 'package:intl/intl.dart' as df;
import 'package:url_launcher/url_launcher.dart';

class Costs extends StatelessWidget {
  const Costs({super.key});
  static List<Map> maintitlesdialogMz01 = [
    {
      'name': ['معلومات أساسية', 'Basics'],
      'selected': true,
    },
    {
      'name': ['المرفقات والتكاليف', 'attachment and costs'],
      'selected': false,
    }
  ];
  static TextEditingController labelcontroller = TextEditingController();
  static TextEditingController notescontroller = TextEditingController();
  static TextEditingController projectcontroller = TextEditingController();
  static TextEditingController costcontroller = TextEditingController();

  static List bodieslistofadd = [
    {
      'selectedofficeindex': 0,
      'date': DateTime.now(),
      'tf': [
        {
          'label': ['البيان', 'label'],
          'controller': labelcontroller,
          'error': null,
          'readonly': false
        },
        {
          'label': ['الملاحظات', 'Notes'],
          'controller': notescontroller,
          'error': null,
          'readonly': false,
          'lines': 2
        },
        {
          'label': ['العائدية', 'project'],
          'controller': projectcontroller,
          'error': null,
          'readonly': false,
          'lines': 1
        },
      ]
    },
    {
      'attachment': '',
      'tf': [
        {
          'label': ['الكلفة', 'cost'],
          'controller': costcontroller,
          'error': null,
          'readonly': false
        },
      ],
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

  static List easyeditlist = [], exportfunctionlist = [], acceptlist = [];
  @override
  Widget build(BuildContext context) {
    List offices = [];
    offices.clear();
    for (var i in DB.userinfotable![0]['users_priv_office']) {
      offices.add({});
      if (DB.allofficeinfotable != null) {
        offices[DB.userinfotable![0]['users_priv_office'].indexOf(i)].addAll({
          'office': DB.allofficeinfotable![0]['offices']
              .where((o) => o['office_id'] == i['upo_office_id'])
              .toList()[0]['officename']
        });
      }
    }
    List officesforadd = [];
    basics({e}) {
      officesforadd.clear();
      for (var i in DB.userinfotable![0]['users_priv_office']
          .where((u) => u['addcost'] == '1')) {
        officesforadd.add({});
        officesforadd[DB.userinfotable![0]['users_priv_office']
                .where((u) => u['addcost'] == '1')
                .toList()
                .indexOf(i)]
            .addAll({
          'office': DB.allofficeinfotable![0]['offices']
              .where((o) => o['office_id'] == i['upo_office_id'])
              .toList()[0]['officename']
        });
      }
      return GetBuilder<MainController>(
        init: mainController,
        builder: (_) => Column(
          children: [
            officesforadd.isNotEmpty
                ? Row(
                    children: [
                      Text(['المكتب', 'office'][BasicInfo.indexlang()]),
                      e != null && e['begin_acceptcost'] == '1'
                          ? Text(
                              " ${e['cost_office_id'] != null ? DB.allofficeinfotable![0]['offices'].where((o) => o['office_id'] == e['cost_office_id']).toList()[0]['officename'] : 'مكتب محذوف'}")
                          : Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: DropdownButton(
                                  value: officesforadd[bodieslistofadd[0]
                                      ['selectedofficeindex']]['office'],
                                  items: officesforadd
                                      .map((e) => DropdownMenuItem(
                                          value: e['office'],
                                          child: Text(e['office'])))
                                      .toList(),
                                  onChanged: (x) =>
                                      mainController.dropdaownchhositem(
                                          list: bodieslistofadd[0],
                                          val: 'selectedofficeindex',
                                          x: officesforadd.indexWhere(
                                              (element) =>
                                                  element['office'] == x))),
                            )
                    ],
                  )
                : SizedBox(),
            ...bodieslistofadd[0]['tf'].map((w) => TextFieldMz(
                label: w['label'],
                error: w['error'],
                lines: w['lines'] ?? 1,
                readOnly: w['readonly'],
                onchange: (x) => null,
                controller: w['controller'],
                td: w['td'] ?? BasicInfo.lang())),
            Row(
              children: [
                TextButton(
                    onPressed: e != null && e['begin_acceptcost'] == '1'
                        ? () {
                            null;
                          }
                        : () => mainController.setdate(
                            ctx: context, date: bodieslistofadd),
                    child: Text(
                        "التاريخ _ ${df.DateFormat("yyyy-MM-dd").format(bodieslistofadd[0]['date'])}"))
              ],
            ),
            Divider(),
          ],
        ),
      );
    }

    attachmentandcost({e}) {
      if (e == null) {
        return Text("بانتظار موافقة المشرف");
      } else if (e['begin_acceptcost'] != '1') {
        return Text("بانتظار موافقة المشرف");
      } else {
        return Column(
          children: [
            Row(
              children: [
                TextButton(
                    onPressed: () async => await mainController.addattachtocost(
                        list: bodieslistofadd),
                    child: Text("إضافة مرفق")),
                GetBuilder<MainController>(
                    init: mainController,
                    builder: (_) {
                      try {
                        return GestureDetector(
                          onTap: () async {
                            bodieslistofadd[1]['attachment']
                                        .path
                                        .contains('jpg') ||
                                    bodieslistofadd[1]['attachment']
                                        .path
                                        .contains('png') ||
                                    bodieslistofadd[1]['attachment']
                                        .path
                                        .contains('jpeg')
                                ? showDialog(
                                    context: context,
                                    builder: (_) {
                                      return AlertDialog(
                                        content: Image.file(
                                          bodieslistofadd[1]['attachment'],
                                        ),
                                      );
                                    })
                                : await launchUrl(Uri.file(
                                    bodieslistofadd[1]['attachment'].path));
                          },
                          child: bodieslistofadd[1]['attachment']
                                  .path
                                  .contains('pdf')
                              ? Icon(Icons.picture_as_pdf)
                              : Image.file(
                                  bodieslistofadd[1]['attachment'],
                                  width: 25,
                                  height: 25,
                                ),
                        );
                      } catch (x) {
                        return SizedBox();
                      }
                    }),
              ],
            ),
            ...bodieslistofadd[1]['tf'].map((w) => TextFieldMz(
                label: w['label'],
                error: w['error'],
                lines: w['lines'] ?? 1,
                readOnly: w['readonly'],
                onchange: (x) => null,
                controller: w['controller'],
                td: w['td'] ?? BasicInfo.lang())),
          ],
        );
      }
    }

    initialofdialog({e}) {
      maintitlesdialogMz01[0]['selected'] = true;
      maintitlesdialogMz01[1]['selected'] = false;
      if (e != null && e['begin_acceptcost'] == '1') {
        maintitlesdialogMz01[0]['selected'] = false;
        maintitlesdialogMz01[1]['selected'] = true;
      }
      for (var i in bodieslistofadd[0]['tf']) {
        i['error'] = null;
        i['hint'] = null;
        i['readonly'] = false;
      }
      for (var i in bodieslistofadd[1]['tf']) {
        i['error'] = null;
        i['hint'] = null;
        i['readonly'] = false;
      }
      if (e == null) {
        labelcontroller.text = '';
        notescontroller.text = '';
        costcontroller.text = '';
        projectcontroller.text = '';
        bodieslistofadd[0]['date'] = DateTime.now();
        bodieslistofadd[0]['beginaccept'] = ['', ''];
        bodieslistofadd[1]['finalaccept'] = ['', ''];
      } else {
        e['cost_office_id'] != null
            ? bodieslistofadd[0]['selectedofficeindex'] =
                officesforadd.indexWhere((element) =>
                    element['office'] ==
                    DB.allofficeinfotable![0]['offices']
                        .where((o) => o['office_id'] == e['cost_office_id'])
                        .toList()[0]['officename'])
            : null;

        if (e['begin_acceptcost'] == '1') {
          for (var i in bodieslistofadd[0]['tf']) {
            i['readonly'] = true;
          }
        }
        if (e['final_acceptcost'] == '1') {
          for (var i in bodieslistofadd[1]['tf']) {
            i['readonly'] = true;
          }
        }

        labelcontroller.text = e['costname'];
        notescontroller.text = e['costdetails'];
        projectcontroller.text = e['cost_project'];
        costcontroller.text = e['cost'] ?? '';
        bodieslistofadd[0]['date'] = DateTime.parse(e['costdate']);
      }
    }

    buildexport() {
      exportfunctionlist.clear();
      for (var i in DB.allusersinfotable![0]['users']) {
        exportfunctionlist.add([]);
        exportfunctionlist[DB.allusersinfotable![0]['users'].indexOf(i)]
            .addAll({
          {
            'index': 0,
            'visible0': true,
            'visible': true,
            'type': 'do-it',
            'icon': Icons.save_as,
            'label': ['تصدير الى اكسل', 'export csv'],
            'elevate': 0.0,
            'backcolor': Colors.transparent,
            'length': 140.0,
          },
          {'visible0': true, 'visible': false, 'type': 'wait'},
        });
      }
      return exportfunctionlist;
    }

    buildacceptlist() {
      acceptlist.clear();
      for (var i in DB.allcostsinfotable![0]['costs']) {
        acceptlist.add([]);
        acceptlist[DB.allcostsinfotable![0]['costs'].indexOf(i)].addAll({
          {
            'index': 0,
            'visible0': true,
            'visible': true,
            'beginaccept': i['begin_acceptcost'] == null
                ? ['', '']
                : i['begin_acceptcost'] == '1'
                    ? ['موافق', 'accept']
                    : ['مرفوض', 'reject'],
            'baccept': ['موافق', 'accept'],
            'breject': ['مرفوض', 'reject'],
            'type': 'do-it'
          },
          {
            'index': 1,
            'visible0': true,
            'visible': i['begin_acceptcost'] == '1' ? true : false,
            'finalaccept': i['final_acceptcost'] == null
                ? ['', '']
                : i['final_acceptcost'] == '1'
                    ? ['موافق', 'accept']
                    : ['مرفوض', 'reject'],
            'faccept': ['موافق', 'accept'],
            'freject': ['مرفوض', 'reject'],
            'type': 'do-it'
          },
          {'index': 2, 'visible0': true, 'visible': false, 'type': 'wait'},
        });
      }
    }

    buildeasyeditlist() {
      easyeditlist.clear();
      for (var i in DB.allcostsinfotable![0]['costs']) {
        easyeditlist.add([]);
        easyeditlist[DB.allcostsinfotable![0]['costs'].indexOf(i)].addAll({
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
            'icon': Icons.edit,
            'label': ['تعديل', 'edit'],
            'elevate': 0.0,
            'backcolor': Colors.transparent,
            'length': 80.0
          },
          {'visible0': true, 'visible': false, 'type': 'wait'},
        });
      }
      return easyeditlist;
    }

    List<Function> listoffunctionforadd(e) => [
          (e) => mainController.addcost(
              officeid:
                  '${DB.allofficeinfotable![0]['offices'].where((element) => element['officename'] == offices[bodieslistofadd[0]['selectedofficeindex']]['office']).toList()[0]['office_id']}'),
          (e) => Get.back(),
        ];
    List<Function> listoffunctionforedit(e) => [
          (e) {
            mainController.updatecost(
                costid: e['cost_id'],
                officeid:
                    '${DB.allofficeinfotable![0]['offices'].where((element) => element['officename'] == offices[bodieslistofadd[0]['selectedofficeindex']]['office']).toList()[0]['office_id']}');
          },
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
                      (e) {
                        mainController.removecost(
                            costid: e['cost_id'], list: actionlist);
                      },
                      (e) => Get.back()
                    ];
                return GetBuilder<MainController>(
                  init: mainController,
                  builder: (_) => Directionality(
                    textDirection: BasicInfo.lang(),
                    child: AlertDialog(
                      scrollable: true,
                      title: Text([
                        'هل أنت متأكد من حذف${e['costname']}?',
                        'sure to delete ${e['costname']}?'
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
            Lang.mainerrormsg = null;
            initialofdialog(e: e);
            return showDialog(
                context: context,
                builder: (_) => DialogMz01(
                    title: ['تعديل', 'edit'],
                    mainlabels: maintitlesdialogMz01,
                    bodies: [basics(e: e), attachmentandcost(e: e)],
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
    listoffunctionforexpot({e, ctx}) => [(e) {}];
    mainItem({e, ctx}) {
      bool ak = true;

      for (var i in DB.allcostsinfotable![0]['costs']
          .where((c) =>
              c['cost_user_id'] != null && c['cost_user_id'] == e['user_id'])
          .toList()) {
        if (i['begin_acceptcost'] != null) {
          ak = true;
        } else {
          ak = false;
        }
      }

      return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
              child: ExpansionTile(
            title: Column(
              children: [
                Row(children: [
                  Container(
                      width: 10,
                      height: 15,
                      color: ak == false ? Colors.red : Colors.transparent),
                  Text("  # ${e['user_id']}_ "),
                  Expanded(
                      child: Text(
                    e['fullname'],
                    style: ThemeMz.titlemediumChanga(),
                  )),
                ]),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ...exportfunctionlist[DB.allusersinfotable![0]['users']
                            .indexWhere((r) => r['user_id'] == e['user_id'])]
                        .where((b) =>
                            b['visible'] == true && b['visible0'] == true)
                        .map((b) {
                      switch (b['type']) {
                        case 'do-it':
                          return IconbuttonMz(
                            e: e,
                            action: listoffunctionforexpot(
                                ctx: ctx, e: e)[b['index']],
                            elevate: b['elevate'],
                            labelvisible: b['elevate'] == 3.0 ? true : false,
                            label: b['label'],
                            icon: b['icon'],
                            buttonlist: exportfunctionlist[
                                DB.allusersinfotable![0]['users'].indexWhere(
                                    (r) => r['user_id'] == e['user_id'])],
                            index: b['index'],
                            height: 35,
                            width: b['elevate'] == 3.0 ? b['length'] : 40,
                            backcolor: b['backcolor'],
                          );
                      }
                    })
                  ],
                )
              ],
            ),
            children: [
              ...DB.allcostsinfotable![0]['costs']
                  .where((c) =>
                      c['cost_user_id'] != null &&
                      c['cost_user_id'] == e['user_id'] &&
                      c['visiblesearch'] == true)
                  .map((c) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 30, right: 30),
                      child: Card(
                        child: ExpansionTile(
                          title: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 10,
                                    height: 20,
                                    color: c['begin_acceptcost'] != null
                                        ? Colors.transparent
                                        : Colors.redAccent,
                                  ),
                                  Text("#_ ${c['cost_id']} ${c['costname']}"),
                                ],
                              ),
                              Visibility(
                                visible:
                                    c['cost_user_id'] == BasicInfo.LogInInfo![0]
                                        ? true
                                        : false,
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      ...easyeditlist[DB.allcostsinfotable![0]
                                                  ['costs']
                                              .indexOf(c)]
                                          .where((b) =>
                                              b['visible'] == true &&
                                              b['visible0'] == true)
                                          .map((b) {
                                        switch (b['type']) {
                                          case 'do-it':
                                            return IconbuttonMz(
                                              e: c,
                                              action:
                                                  listoffunctionforeasyeditpanel(
                                                      ctx: ctx,
                                                      e: e)[b['index']],
                                              elevate: b['elevate'],
                                              labelvisible: b['elevate'] == 3.0
                                                  ? true
                                                  : false,
                                              label: b['label'],
                                              icon: b['icon'],
                                              buttonlist: easyeditlist[DB
                                                  .allcostsinfotable![0]
                                                      ['costs']
                                                  .indexOf(c)],
                                              index: b['index'],
                                              height: 35,
                                              width: b['elevate'] == 3.0
                                                  ? b['length']
                                                  : 40,
                                              backcolor: b['backcolor'],
                                            );
                                          case 'wait':
                                            return WaitMz.waitmz0(
                                                [1, 2, 3, 4], context);
                                          default:
                                            return SizedBox();
                                        }
                                      })
                                    ]),
                              )
                            ],
                          ),
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  flex: 5,
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                              " ${c['cost_project']} _ ${c['cost_office_id'] == null ? '' : DB.allofficeinfotable![0]['offices'].where((o) => o['office_id'] == c['cost_office_id']).toList()[0]['officename']}"),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                              child:
                                                  Text(" ${c['costdetails']}")),
                                        ],
                                      ),
                                      c['cost'] != null && c['cost'].isNotEmpty
                                          ? Row(
                                              children: [
                                                Expanded(
                                                    child: Text(
                                                        "التكلفة: ${c['cost']}")),
                                              ],
                                            )
                                          : const SizedBox(),
                                      Row(
                                        children: [
                                          Expanded(
                                              child: Text(
                                                  "تاريخ الطلب ${c['costdate']}")),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        DB.allusersinfotable![0]
                                                        ['users_priv_office']
                                                    .where((us) =>
                                                        us['upo_user_id'] ==
                                                            BasicInfo.LogInInfo![
                                                                0] &&
                                                        us['upo_office_id'] ==
                                                            c['cost_office_id'])
                                                    .toList()
                                                    .isNotEmpty &&
                                                DB.allusersinfotable![0][
                                                            'users_priv_office']
                                                        .where((us) =>
                                                            us['upo_user_id'] ==
                                                                BasicInfo
                                                                        .LogInInfo![
                                                                    0] &&
                                                            us['upo_office_id'] ==
                                                                c['cost_office_id'])
                                                        .toList()[0]['acceptcosts'] ==
                                                    '1'
                                            ? Column(
                                                children: [
                                                  Card(
                                                    child: GetBuilder<
                                                        MainController>(
                                                      builder: (_) => Column(
                                                        children: [
                                                          ...acceptlist[DB
                                                                  .allcostsinfotable![
                                                                      0]
                                                                      ['costs']
                                                                  .indexOf(c)]
                                                              .where((b) =>
                                                                  b['visible'] == true &&
                                                                  b['visible0'] ==
                                                                      true &&
                                                                  (b['index'] ==
                                                                          0 ||
                                                                      b['index'] ==
                                                                          2))
                                                              .map((b) {
                                                            switch (b['type']) {
                                                              case 'do-it':
                                                                return Column(
                                                                  children: [
                                                                    Row(
                                                                      children: [
                                                                        const Text(
                                                                            'حالة الطلب'),
                                                                        Radio(
                                                                            value:
                                                                                b['baccept'][BasicInfo.indexlang()],
                                                                            groupValue: acceptlist[DB.allcostsinfotable![0]['costs'].indexOf(c)][0]['beginaccept'][BasicInfo.indexlang()],
                                                                            onChanged: (x) {
                                                                              mainController.changeradioacceptcost(x: x, list: acceptlist[DB.allcostsinfotable![0]['costs'].indexOf(c)], index: 0, costid: c['cost_id'], clmname: 'beginaccept');
                                                                            }),
                                                                        Text(acceptlist[DB
                                                                            .allcostsinfotable![0][
                                                                                'costs']
                                                                            .indexOf(
                                                                                c)][0]['baccept'][BasicInfo
                                                                            .indexlang()]),
                                                                        Radio(
                                                                            value:
                                                                                b['breject'][BasicInfo.indexlang()],
                                                                            groupValue: acceptlist[DB.allcostsinfotable![0]['costs'].indexOf(c)][0]['beginaccept'][BasicInfo.indexlang()],
                                                                            onChanged: (x) {
                                                                              mainController.changeradioacceptcost(x: x, costid: c['cost_id'], list: acceptlist[DB.allcostsinfotable![0]['costs'].indexOf(c)], index: 0, clmname: 'beginaccept');
                                                                            }),
                                                                        Text(acceptlist[DB
                                                                            .allcostsinfotable![0][
                                                                                'costs']
                                                                            .indexOf(
                                                                                c)][0]['breject'][BasicInfo
                                                                            .indexlang()])
                                                                      ],
                                                                    ),
                                                                    Visibility(
                                                                        visible: c['begin_acceptcost'] !=
                                                                                null
                                                                            ? true
                                                                            : false,
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            Text("${c['begin_acceptcost_user'] != null ? c['begin_acceptcost'] != null ? '${DB.allusersinfotable![0]['users'].where((u) => u['user_id'] == c['begin_acceptcost_user']).toList()[0]['fullname']}' : '' : 'حساب محذوف'}"),
                                                                            Directionality(
                                                                              textDirection: TextDirection.ltr,
                                                                              child: Text("${c['begin_acceptcost'] != null ? c['begin_acceptcost_date'] : ''}"),
                                                                            )
                                                                          ],
                                                                        )),
                                                                  ],
                                                                );
                                                              case 'wait':
                                                                return WaitMz
                                                                    .waitmz0([
                                                                  1,
                                                                  2,
                                                                  3
                                                                ], context);
                                                            }
                                                          }),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  //pp
                                                  Card(
                                                    child: GetBuilder<
                                                        MainController>(
                                                      builder: (_) => Column(
                                                        children: [
                                                          ...acceptlist[DB
                                                                  .allcostsinfotable![
                                                                      0]
                                                                      ['costs']
                                                                  .indexOf(c)]
                                                              .where((b) =>
                                                                  b['visible'] == true &&
                                                                  b['visible0'] ==
                                                                      true &&
                                                                  (b['index'] ==
                                                                          1 ||
                                                                      b['index'] ==
                                                                          2))
                                                              .map((b) {
                                                            switch (b['type']) {
                                                              case 'do-it':
                                                                return Column(
                                                                  children: [
                                                                    Row(
                                                                      children: [
                                                                        Text(
                                                                            'الموافقة النهائية'),
                                                                        Radio(
                                                                            value:
                                                                                b['faccept'][BasicInfo.indexlang()],
                                                                            groupValue: acceptlist[DB.allcostsinfotable![0]['costs'].indexOf(c)][1]['finalaccept'][BasicInfo.indexlang()],
                                                                            onChanged: (x) {
                                                                              mainController.changeradioacceptcost(x: x, list: acceptlist[DB.allcostsinfotable![0]['costs'].indexOf(c)], index: 1, costid: c['cost_id'], clmname: 'finalaccept');
                                                                            }),
                                                                        Text(acceptlist[DB
                                                                            .allcostsinfotable![0][
                                                                                'costs']
                                                                            .indexOf(
                                                                                c)][1]['faccept'][BasicInfo
                                                                            .indexlang()]),
                                                                        Radio(
                                                                            value:
                                                                                b['freject'][BasicInfo.indexlang()],
                                                                            groupValue: acceptlist[DB.allcostsinfotable![0]['costs'].indexOf(c)][1]['finalaccept'][BasicInfo.indexlang()],
                                                                            onChanged: (x) {
                                                                              mainController.changeradioacceptcost(x: x, costid: c['cost_id'], list: acceptlist[DB.allcostsinfotable![0]['costs'].indexOf(c)], index: 1, clmname: 'finalaccept');
                                                                            }),
                                                                        Text(acceptlist[DB
                                                                            .allcostsinfotable![0][
                                                                                'costs']
                                                                            .indexOf(
                                                                                c)][1]['freject'][BasicInfo
                                                                            .indexlang()])
                                                                      ],
                                                                    ),
                                                                    Visibility(
                                                                        visible: c['final_acceptcost'] !=
                                                                                null
                                                                            ? true
                                                                            : false,
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            Text("${c['final_acceptcost'] != null ? '${DB.allusersinfotable![0]['users'].where((u) => u['user_id'] == c['final_acceptcost_user']).toList()[0]['fullname']}' : ''}"),
                                                                            Directionality(
                                                                              textDirection: TextDirection.ltr,
                                                                              child: Text("${c['final_acceptcost'] != null ? c['final_acceptcost_date'] : ''}"),
                                                                            )
                                                                          ],
                                                                        )),
                                                                  ],
                                                                );
                                                              case 'wait':
                                                                return WaitMz
                                                                    .waitmz0([
                                                                  1,
                                                                  2,
                                                                  3
                                                                ], context);
                                                            }
                                                          }),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(c['begin_acceptcost'] ==
                                                          null
                                                      ? 'حالة الطلب _ غير محدد'
                                                      : """حالة الطلب _ ${acceptlist[DB.allcostsinfotable![0]['costs'].indexOf(c)][0]['beginaccept'][BasicInfo.indexlang()]}
${c['begin_acceptcost_user'] != null ? DB.allusersinfotable![0]['users'].where((u) => u['user_id'] == c['begin_acceptcost_user']).toList()[0]['fullname'] : 'حساب محذوف'}
${c['begin_acceptcost_date']}"""),
                                                  Visibility(
                                                    visible:
                                                        c['begin_acceptcost'] ==
                                                                '1'
                                                            ? true
                                                            : false,
                                                    child: Text(c[
                                                                'final_acceptcost'] ==
                                                            null
                                                        ? 'الموافقة النهائية _ غير محدد'
                                                        : """الموافقة النهائية _ ${acceptlist[DB.allcostsinfotable![0]['costs'].indexOf(c)][1]['finalaccept'][BasicInfo.indexlang()]}
${c['final_acceptcost_user'] != null ? DB.allusersinfotable![0]['users'].where((u) => u['user_id'] == c['final_acceptcost_user']).toList()[0]['fullname'] : 'حساب محذوف'}
${c['final_acceptcost_date']}"""),
                                                  ),
                                                ],
                                              )
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              })
            ],
          )));
    }

    conditionofview(x) {
      List officesii = [];
      for (var y in DB.userinfotable![0]['users_priv_office']) {
        if (y['upo_user_id'] == BasicInfo.LogInInfo![0] &&
            y['showallcosts'] == '1') {
          officesii.add(y['upo_office_id']);
        }
      }
      for (var i in DB.allusersinfotable![0]['users_priv_office']
          .where((u) => u['upo_user_id'] == x['user_id'])
          .toList()) {
        if (i['upo_user_id'] != null) {
          if (officesii.contains(i['upo_office_id'])) {
            return true;
          }
        }
      }

      if (x['user_id'] == BasicInfo.LogInInfo![0]) {
        return true;
      } else {
        return false;
      }
    }

    bool addactionvisible() {
      int st = 0;
      if (DB.userinfotable![0]['users_priv_office'].isNotEmpty) {
        l:
        for (var i in offices) {
          if (DB.userinfotable![0]['users_priv_office'][offices.indexOf(i)]
                  ['addcost'] ==
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

    updatetable() async {
      try {
        DB.allusersinfotable = await DBController().getallusersinfo();
        DB.allcostsinfotable = await DBController().getallcostinfo();

        buildeasyeditlist();
        buildacceptlist();
        buildexport();
      } catch (e) {}
      return {DB.allusersinfotable, DB.allcostsinfotable};
    }

    return FutureBuilder(
        future: Future(() async => await updatetable()),
        builder: (_, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Center(
                child: WaitMz.waitmz0([1, 2, 3, 4, 5], context),
              ),
            );
          } else if (snap.hasData) {
            if (DB.allusersinfotable != null) {
              for (var i in DB.allusersinfotable![0]['users']) {
                i['visiblesearch'] = true;
              }
            }
            PageTamplate01.searchcontroller.text = '';
            return GetBuilder<DBController>(
              init: dbController,
              builder: (_) {
                buildeasyeditlist();
                buildexport();
                buildacceptlist();
                return PageTamplate01(
                    updatetable: () async => await updatetable(),
                    appbartitle: const ['النفقات', 'Costs'],
                    searchrangelist: const ['username', 'fullname'],
                    chooseofficevisible: true,
                    officechooselist: DB.allusersinfotable![0]['users'],
                    officenameclm: 'upo_user_id',
                    searchlist: DB.allcostsinfotable![0]['costs'],
                    accountssearch: 'notnull',
                    conditionofview: (x) => conditionofview(x),
                    searchwithdatevisible: true,
                    tablename: 'users',
                    tableofsearch: DB.allusersinfotable![0]['users'],
                    table: DB.allusersinfotable != null
                        ? DB.allusersinfotable![0]['users']
                        : [],
                    mainItem: (x) => mainItem(e: x, ctx: context),
                    addactionvisible: addactionvisible(),
                    initialofadd: () => initialofdialog(),
                    addactiontitle: const ['إضافة طلب', 'Add request'],
                    addactionmainlabelsofpages: maintitlesdialogMz01,
                    addactionpages: [basics(), attachmentandcost()],
                    listofactionbuttonforadd: listofactionbuttonforadd,
                    listoffunctionforadd: (e) => listoffunctionforadd(e),
                    floateactionbuttonlist: floatactionbuttonlist);
              },
            );
          } else {
            Future(() => Get.toNamed('/'));
            return Scaffold(
              body: Center(
                child: SizedBox(),
              ),
            );
          }
        });
  }
}
