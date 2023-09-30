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
      'beginaccept': {
        'group': ['', ''],
        'accept': ['موافق', 'accept'],
        'reject': ['مرفوض', 'reject']
      },
      'tf': [
        {
          'label': ['البيان', 'label'],
          'controller': labelcontroller,
          'error': null
        },
        {
          'label': ['الملاحظات', 'Notes'],
          'controller': notescontroller,
          'error': null,
          'lines': 2
        },
        {
          'label': ['العائدية', 'project'],
          'controller': projectcontroller,
          'error': null,
          'lines': 1
        },
      ]
    },
    {
      'finalaccept': {
        'group': ['', ''],
        'accept': ['موافق', 'accept'],
        'reject': ['مرفوض', 'reject']
      },
      'attachment': [],
      'cost': [
        {
          'label': ['الكلفة', 'cost'],
          'controller': costcontroller,
          'error': null
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
  static List<DateTime> searchbydate = [
    DateTime.now().add(Duration(days: -30)),
    DateTime.now()
  ];
  static List easyeditlist = [], exportfunctionlist = [];
  @override
  Widget build(BuildContext context) {
    List table = DB.allusersinfotable[0]['users'];
    List table2 = DB.allcostsinfotable[0]['costs'];
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
    basics() {
      List officesforadd = [];
      officesforadd.clear();

      for (var i in DB.userinfotable[0]['users_priv_office']
          .where((u) => u['addcost'] == '1')) {
        officesforadd.add({});
        officesforadd[DB.userinfotable[0]['users_priv_office']
                .where((u) => u['addcost'] == '1')
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
            ...bodieslistofadd[0]['tf'].map((w) => TextFieldMz(
                label: w['label'],
                error: w['error'],
                lines: w['lines'] ?? 1,
                onchange: (x) => null,
                controller: w['controller'],
                td: w['td'] ?? BasicInfo.lang())),
            Row(
              children: [
                TextButton(
                    onPressed: () => mainController.setdate(
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
      } else {
        return SizedBox();
      }
    }

    initialofdialog({e}) {
      maintitlesdialogMz01[0]['selected'] = true;
      maintitlesdialogMz01[1]['selected'] = false;
      for (var i in bodieslistofadd[0]['tf']) {
        i['error'] = null;
        i['hint'] = null;
      }
      if (e == null) {
        labelcontroller.text = '';
        notescontroller.text = '';
        costcontroller.text = '';
        bodieslistofadd[0]['date'] = DateTime.now();
        bodieslistofadd[0]['beginaccept']['group'] = ['', ''];
        bodieslistofadd[1]['finalaccept']['group'] = ['', ''];
      } else {
        labelcontroller.text = e['costname'];
        notescontroller.text = e['costdetails'];
        costcontroller.text = e['cost'];
      }
    }

    buildexport() {
      exportfunctionlist.clear();
      for (var i in DB.allusersinfotable[0]['users']) {
        exportfunctionlist.add([]);
        exportfunctionlist[DB.allusersinfotable[0]['users'].indexOf(i)].addAll({
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

    buildeasyeditlist() {
      easyeditlist.clear();
      for (var i in DB.allcostsinfotable[0]['costs']) {
        easyeditlist.add([]);
        easyeditlist[DB.allcostsinfotable[0]['costs'].indexOf(i)].addAll({
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
                  '${DB.allofficeinfotable[0]['offices'].where((element) => element['officename'] == offices[bodieslistofadd[0]['selectedofficeindex']]['office']).toList()[0]['office_id']}'),
          (e) => Get.back(),
        ];
    List<Function> listoffunctionforedit(e) => [
          (e) {},
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
                List functionofaction(e) => [(e) {}, (e) => Get.back()];
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
                    bodies: [basics(), attachmentandcost()],
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
      for (var i in DB.allcostsinfotable[0]['costs']
          .where((c) => c['cost_user_id'] == e['user_id'])
          .toList()) {
        if (i['final_acceptcost'] != '1') {
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
                    ...exportfunctionlist[table.indexOf(e)]
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
                            buttonlist: exportfunctionlist[table.indexOf(e)],
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
                )
              ],
            ),
            children: [
              ...DB.allcostsinfotable[0]['costs']
                  .where((c) => c['cost_user_id'] == e['user_id'])
                  .map((c) {
                print(DB.allcostsinfotable[0]['costs'].indexOf(c));

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
                                    color: c['final_acceptcost'] != '1'
                                        ? Colors.red
                                        : Colors.green,
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
                                      ...easyeditlist[DB.allcostsinfotable[0]
                                                  ['costs']
                                              .indexOf(c)]
                                          .where((b) =>
                                              b['visible'] == true &&
                                              b['visible0'] == true)
                                          .map((b) {
                                        switch (b['type']) {
                                          case 'do-it':
                                            return IconbuttonMz(
                                              e: e,
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
                                                  .allcostsinfotable[0]['costs']
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
                                Text(
                                    " ${c['cost_project']} _ ${DB.allofficeinfotable[0]['offices'].where((o) => o['office_id'] == c['cost_office_id']).toList()[0]['officename']}"),
                              ],
                            ),
                            Row(
                              children: [
                                Text(" ${c['costdetails']}"),
                              ],
                            ),
                            Row(
                              children: [
                                Directionality(
                                    textDirection: TextDirection.ltr,
                                    child: Text('''
                                        الرأي المبدأي: ${c['begin_acceptcost'] == '1' ? 'مقبول' : c['begin_acceptcost'] == '0' ? 'مرفوض' : 'غير محدد'}
                                        ${c['begin_acceptcost'] == '1' || c['begin_acceptcost'] == '0' ? 'بواسطة ${DB.allusersinfotable[0]['users'].where((u) => u['user_id'] == c['begin_acceptcost_user']).toList()[0]['fullname']}' : ''}
                                        ''')),
                              ],
                            ),
                            Row(
                              children: [
                                Directionality(
                                    textDirection: TextDirection.ltr,
                                    child: Text(" ${c['costdate']}")),
                              ],
                            )
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
      for (var y in DB.userinfotable[0]['users_priv_office']) {
        if (y['upo_user_id'] == BasicInfo.LogInInfo![0] &&
            y['showallcosts'] == '1') {
          officesii.add(y['upo_office_id']);
        }
      }
      for (var i in DB.allusersinfotable[0]['users_priv_office']
          .where((u) => u['upo_user_id'] == x['user_id'])
          .toList()) {
        if (x['user_id'] == BasicInfo.LogInInfo![0] ||
            officesii.contains(i['upo_office_id'])) {
          return true;
        } else {
          return false;
        }
      }
    }

    bool addactionvisible() {
      int st = 0;
      if (DB.userinfotable[0]['users_priv_office'].isNotEmpty) {
        l:
        for (var i in offices) {
          if (DB.userinfotable[0]['users_priv_office'][offices.indexOf(i)]
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
      DB.allcostsinfotable = await DBController().getallcostinfo();
      DB.allusersinfotable = await DBController().getallusersinfo();
      buildeasyeditlist();
      buildexport();
      return DB.allusersinfotable;
    }

    return GetBuilder<DBController>(
      init: dbController,
      builder: (_) {
        table = DB.allusersinfotable[0]['users'];
        table2 = DB.allcostsinfotable[0]['costs'];
        for (var i in DB.allusersinfotable[0]['users']) {
          i['visiblesearch'] = true;
        }
        PageTamplate01.searchcontroller.text = '';
        PageTamplate01.selectedoffice = 'all';
        for (var i in DB.allusersinfotable[0]['users']) {
          i['visible'] = true;
        }
        return PageTamplate01(
            updatetable: Future(() async => await updatetable()),
            appbartitle: const ['النفقات', 'Costs'],
            searchrangelist: const ['username', 'fullname'],
            chooseofficevisible: true,
            officechooselist: DB.allusersinfotable[0]['users'],
            officenameclm: 'upo_user_id',
            accountssearch: 'notnull',
            conditionofview: (x) => conditionofview(x),
            table: table,
            mainItem: (x) => mainItem(e: x, ctx: context),
            startdate: searchbydate[0],
            setstartdate: () => null,
            enddate: searchbydate[0],
            setenddate: () => null,
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
  }
}
