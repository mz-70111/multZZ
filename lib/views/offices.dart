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
import 'package:mz_flutter_07/views/wait.dart';

class Offices extends StatelessWidget {
  const Offices({super.key});
  static List<Map> maintitlesdialogMz01 = [
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
  static TextEditingController apitokencontroller = TextEditingController();
  static double elevationcard = 0.0;
  static List bodieslistofadd = [
    {
      'notifi': false,
      'tf': [
        {
          'label': ['اسم المكتب', 'Office name'],
          'controller': officenamecontroller,
          'error': null
        },
        {
          'label': ['chat id', 'chat id'],
          'controller': chatidcontroller,
          'td': TextDirection.ltr,
        },
        {
          'label': ['api token for telegram', 'api token for telegram'],
          'controller': apitokencontroller,
          'td': TextDirection.ltr
        }
      ]
    }
  ];
  static List<Map> addemployeelist = [];
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
    basics() {
      return GetBuilder<MainController>(
        init: mainController,
        builder: (_) => Column(
          children: [
            ...bodieslistofadd[0]['tf'].map((w) => TextFieldMz(
                label: w['label'],
                error: w['error'],
                onchange: (x) => null,
                controller: w['controller'],
                td: w['td'] ?? BasicInfo.lang())),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Switch(
                    value: bodieslistofadd[0]['notifi'],
                    onChanged: (x) =>
                        mainController.switchbuttonnotifioffice(x)),
                Text("${bodieslistofadd[0]['notifi'] == true ? [
                    'تفعيل',
                    'enable'
                  ][BasicInfo.indexlang()] : [
                    'إيقاف',
                    'stop'
                  ][BasicInfo.indexlang()]} ${[
                  'الإشعارات',
                  'Notification'
                ][BasicInfo.indexlang()]} ")
              ],
            ),
          ],
        ),
      );
    }

    setpreivileges({ctx, index, type = 'add', ee}) {
      List actionlist = [
        {
          'index': 0,
          'visible': true,
          'label': type == 'add' ? ['إضافة', 'save'] : ['حفظ', 'save'],
          'elevate': 0.0
        },
        {
          'index': 1,
          'visible': true,
          'label': ['رجوع', 'close'],
          'elevate': 0.0
        },
        {
          'index': 2,
          'visible': type == 'add' ? false : true,
          'label': ['حذف', 'delete'],
          'elevate': 0.0
        },
      ];
      List actionfun(ee) => [
            (ee) => mainController.addremoveemployeetooffice(
                list: addemployeelist, y: ee, type: 'save'),
            (ee) => Get.back(),
            (ee) => mainController.addremoveemployeetooffice(
                list: addemployeelist, y: ee, type: 'edit'),
          ];
      return showDialog(
          context: ctx,
          builder: (_) {
            return Directionality(
              textDirection: BasicInfo.lang(),
              child: GetBuilder<MainController>(
                init: mainController,
                builder: (_) => AlertDialog(
                  scrollable: true,
                  title: Text([
                    'الصلاحيات ضمن المكتب',
                    'Privileges at office'
                  ][BasicInfo.indexlang()]),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ...addemployeelist
                          .where((element) =>
                              addemployeelist.indexOf(element) == index)
                          .map((m) => SizedBox(
                                width: MediaQuery.of(ctx).size.width > 500
                                    ? 500
                                    : MediaQuery.of(ctx).size.width,
                                height: 300,
                                child: GridView(
                                    gridDelegate:
                                        const SliverGridDelegateWithMaxCrossAxisExtent(
                                            maxCrossAxisExtent: 300,
                                            mainAxisExtent: 50),
                                    children: [
                                      ...m.keys
                                          .toList()
                                          .where((element) =>
                                              element.contains("Po-"))
                                          .map((e) {
                                        return Row(
                                          children: [
                                            Radio(
                                                value: m[e]
                                                    [BasicInfo.indexlang()],
                                                groupValue: m['position']
                                                    [BasicInfo.indexlang()],
                                                onChanged: (x) {
                                                  mainController
                                                      .changeradiopriv(
                                                          x: x,
                                                          list: Offices
                                                              .addemployeelist,
                                                          index: Offices
                                                              .addemployeelist
                                                              .indexOf(m));
                                                }),
                                            Text(m[e][BasicInfo.indexlang()])
                                          ],
                                        );
                                      }),
                                      ...m.keys
                                          .toList()
                                          .where((element) =>
                                              element.contains("P-"))
                                          .map((e) {
                                        return Row(
                                          children: [
                                            Checkbox(
                                                value: m[e][0],
                                                onChanged: (x) {
                                                  mainController.chackboxpriv(
                                                      x: x,
                                                      list: Offices
                                                          .addemployeelist,
                                                      index: Offices
                                                          .addemployeelist
                                                          .indexOf(m),
                                                      e: e);
                                                }),
                                            Expanded(
                                                child: Text(m[e][1]
                                                    [BasicInfo.indexlang()]))
                                          ],
                                        );
                                      }),
                                    ]),
                              )),
                    ],
                  ),
                  actions: [
                    ...actionlist
                        .where((element) => element['visible'] == true)
                        .map((r) => IconbuttonMz(
                            backcolor: ThemeMz.iconbuttonmzbc(),
                            width: 75,
                            height: 40,
                            index: r['index'],
                            buttonlist: actionlist,
                            elevate: r['elevate'],
                            e: ee,
                            action: actionfun(ee)[actionlist.indexOf(r)],
                            label: r['label']))
                  ],
                ),
              ),
            );
          });
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
                            .map((e) => GestureDetector(
                                  onTap: () => setpreivileges(
                                      type: 'edit',
                                      ee: e,
                                      ctx: context,
                                      index: addemployeelist.indexOf(e)),
                                  child: Card(
                                    elevation: 6,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        e['name'],
                                        style: const TextStyle(
                                            fontFamily: 'Changa', fontSize: 15),
                                      ),
                                    ),
                                  ),
                                ))
                      ],
                    ),
                  )
                ],
              ),
            ),
            const Divider(),
            Card(
              child: DropDownWithSearchMz(
                label: ['إضافة موظف', 'add employee'],
                items: addemployeelist,
                ontap: (it) {
                  return setpreivileges(
                      ee: it, ctx: context, index: addemployeelist.indexOf(it));
                },
              ),
            )
          ],
        ),
      );
    }

    initialofdialog({e}) async {
      addemployeelist.clear();
      maintitlesdialogMz01[0]['selected'] = true;
      maintitlesdialogMz01[1]['selected'] = false;
      DropDownWithSearchMz.visiblemain = false;
      if (e == null) {
        bodieslistofadd[0]['tf'][0]['error'] = null;
        officenamecontroller.text = '';
        chatidcontroller.text = '';
        apitokencontroller.text = '';
        bodieslistofadd[0]['notifi'] = false;
        for (var i in DB.allusersinfotable[0]['users']) {
          addemployeelist.add({});
          addemployeelist[DB.allusersinfotable[0]['users'].indexOf(i)].addAll({
            'user_id': i['user_id'],
            'name': i['fullname'],
            'visible': true,
            'visiblesearch': true,
            'position': ['موظف', 'employee'],
            'Po-employee': ['موظف', 'employee'],
            'Po-supervisor': ['مشرف', 'supervisor'],
            'P-addtask': [
              false,
              ['إضافة مهمة', 'Add task']
            ],
            'P-showalltasks': [
              false,
              ['مشاهدة جميع المهام', 'show all tasks']
            ],
            'P-addremind': [
              true,
              ['إضافة تذكير', 'Add remind']
            ],
            'P-showallreminds': [
              true,
              ['مشاهدة جميع التنبيهات ', 'show all reminds']
            ],
            'P-addtodo': [
              true,
              ['إضافة إجرائية', 'Add todo']
            ],
            'P-showalltodos': [
              true,
              ['مشاهدة جميع الإجرائيات ', 'show all todos']
            ],
            'P-addping': [
              true,
              ['Add ping', 'Add ping']
            ],
            'P-showallpings': [
              true,
              ['show all pings', 'show all pings']
            ],
            'P-addemailtest': [
              true,
              ['إضافة تفحص ايميل', 'Add Email test']
            ],
            'P-showallemailtests': [
              true,
              ['show all emailtests', 'show all emailtests']
            ],
            'P-addcost': [
              true,
              ['إضافة طلب سلفة', 'Add Cost']
            ],
            'P-showallcosts': [
              false,
              ['مشاهدة جميع السلف', 'show all costs']
            ],
            'P-acceptcosts': [
              false,
              ['موافقة على السلفة', 'Accept Cost']
            ],
            'P-addhyperlink': [
              false,
              ['إضافة رابط خارجي', 'Add HyperLink']
            ],
            'P-showallhyperlinks': [
              false,
              ['مشاهدة جميع الروابط', 'show all h-links']
            ],
          });
        }
      } else {
        bodieslistofadd[0]['tf'][0]['error'] = null;
        officenamecontroller.text = e['officename'];
        chatidcontroller.text = e['chatid'];
        apitokencontroller.text = e['apitoken'];
        bodieslistofadd[0]['notifi'] = e['notifi'] == '1' ? true : false;

        for (var i in DB.allofficeinfotable[0]['users_priv_office']
            .where((t) => t['upo_office_id'] == e['office_id'])) {
          addemployeelist.add({});
          addemployeelist[DB.allofficeinfotable[0]['users_priv_office']
                  .where((t) => t['upo_office_id'] == e['office_id'])
                  .toList()
                  .indexOf(i)]
              .addAll({
            'user_id': i['upo_user_id'],
            'name': DB.allusersinfotable[0]['users']
                .where((u) => u['user_id'] == i['upo_user_id'])
                .toList()[0]['fullname'],
            'visible': false,
            'visiblesearch': true,
            'position': i['position'] == 'employee'
                ? ['موظف', 'employee']
                : ['مشرف', 'supervisor'],
            'Po-employee': ['موظف', 'employee'],
            'Po-supervisor': ['مشرف', 'supervisor'],
            'P-addtask': [
              i['addtask'] == '1' ? true : false,
              ['إضافة مهمة', 'Add task']
            ],
            'P-showalltasks': [
              i['showalltasks'] == '1' ? true : false,
              ['مشاهدة جميع المهام', 'show all tasks']
            ],
            'P-addremind': [
              i['addremind'] == '1' ? true : false,
              ['إضافة تذكير', 'Add remind']
            ],
            'P-showallreminds': [
              i['showallreminds'] == '1' ? true : false,
              ['مشاهدة جميع التنبيهات ', 'show all reminds']
            ],
            'P-addtodo': [
              i['addtodo'] == '1' ? true : false,
              ['إضافة إجرائية', 'Add todo']
            ],
            'P-showalltodos': [
              i['showalltodos'] == '1' ? true : false,
              ['مشاهدة جميع الإجرائيات ', 'show all todos']
            ],
            'P-addping': [
              i['addping'] == '1' ? true : false,
              ['Add ping', 'Add ping']
            ],
            'P-showallpings': [
              i['showallpings'] == '1' ? true : false,
              ['show all pings', 'show all pings']
            ],
            'P-addemailtest': [
              i['addemailtest'] == '1' ? true : false,
              ['إضافة تفحص ايميل', 'Add Email test']
            ],
            'P-showallemailtests': [
              i['showallemailtests'] == '1' ? true : false,
              ['show all emailtests', 'show all emailtests']
            ],
            'P-addcost': [
              i['addcost'] == '1' ? true : false,
              ['إضافة طلب سلفة', 'Add Cost']
            ],
            'P-showallcosts': [
              i['showallcosts'] == '1' ? true : false,
              ['مشاهدة جميع السلف', 'show all costs']
            ],
            'P-acceptcosts': [
              i['acceptcosts'] == '1' ? true : false,
              ['موافقة على السلفة', 'Accept Cost']
            ],
            'P-addhyperlink': [
              i['addhyperlink'] == '1' ? true : false,
              ['إضافة رابط خارجي', 'Add HyperLink']
            ],
            'P-showallhyperlinks': [
              i['showallhyperlinks'] == '1' ? true : false,
              ['مشاهدة جميع الروابط', 'show all h-links']
            ],
          });
        }
        List usersin = [];
        usersin.clear();
        for (var j in addemployeelist) {
          usersin.add(j['user_id']);
        }

        for (var i in DB.allusersinfotable[0]['users']
            .where((uu) => !usersin.contains(uu['user_id']))) {
          addemployeelist.add({});
          addemployeelist[addemployeelist.length - 1].addAll({
            'user_id': i['user_id'],
            'name': i['fullname'],
            'visible': true,
            'visiblesearch': true,
            'position': ['موظف', 'employee'],
            'Po-employee': ['موظف', 'employee'],
            'Po-supervisor': ['مشرف', 'supervisor'],
            'P-addtask': [
              false,
              ['إضافة مهمة', 'Add task']
            ],
            'P-showalltasks': [
              false,
              ['مشاهدة جميع المهام', 'show all tasks']
            ],
            'P-addremind': [
              true,
              ['إضافة تذكير', 'Add remind']
            ],
            'P-showallreminds': [
              true,
              ['مشاهدة جميع التنبيهات ', 'show all reminds']
            ],
            'P-addtodo': [
              true,
              ['إضافة إجرائية', 'Add todo']
            ],
            'P-showalltodos': [
              true,
              ['مشاهدة جميع الإجرائيات ', 'show all todos']
            ],
            'P-addping': [
              true,
              ['Add ping', 'Add ping']
            ],
            'P-showallpings': [
              true,
              ['show all pings', 'show all pings']
            ],
            'P-addemailtest': [
              true,
              ['إضافة تفحص ايميل', 'Add Email test']
            ],
            'P-showallemailtests': [
              true,
              ['show all emailtests', 'show all emailtests']
            ],
            'P-addcost': [
              true,
              ['إضافة طلب سلفة', 'Add Cost']
            ],
            'P-showallcosts': [
              false,
              ['مشاهدة جميع السلف', 'show all costs']
            ],
            'P-acceptcosts': [
              false,
              ['موافقة على السلفة', 'Accept Cost']
            ],
            'P-addhyperlink': [
              false,
              ['إضافة رابط خارجي', 'Add HyperLink']
            ],
            'P-showallhyperlinks': [
              false,
              ['مشاهدة جميع الروابط', 'show all h-links']
            ],
          });
        }
      }
    }

    buildeasyeditlist() {
      easyeditlist.clear();
      for (var i in DB.allofficeinfotable[0]['offices']) {
        easyeditlist.add([]);
        easyeditlist[DB.allofficeinfotable[0]['offices'].indexOf(i)].addAll({
          {
            'index': 0,
            'visible': true,
            'type': 'do-it',
            'icon': Icons.delete_forever,
            'label': ['حذف', 'delete'],
            'elevate': 0.0,
            'backcolor': Colors.transparent
          },
          {'visible': false, 'type': 'wait'},
        });
      }
    }

    List<Function> listoffunctionforadd(e) => [
          (e) async => await mainController.addoffice(),
          (e) => Get.back(),
        ];
    List<Function> listoffunctionforedit(e) => [
          (e) async =>
              await mainController.updateoffice(officeid: e['office_id']),
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
                      (e) => mainController.removeoffice(
                          officeid: e['office_id'], list: actionlist),
                      (e) => Get.back()
                    ];
                return GetBuilder<MainController>(
                  init: mainController,
                  builder: (_) => AlertDialog(
                    title: Text([
                      'هل أنت متأكد من حذف${e['officename']}?',
                      'sure to delete ${e['officename']}?'
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
                );
              })
        ];

    GetBuilder<MainController> editactionaswidget({ctx, e}) {
      return GetBuilder<MainController>(
        init: mainController,
        builder: (_) =>
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
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
                    action: listoffunctionforedit(
                        u)[listofactionbuttonforedit.indexOf(u)],
                    label: u['label']);
              case 'wait':
                return WaitMz.waitmz0([1, 2, 3, 4, 5, 6, 7, 8], ctx);
              default:
                return SizedBox();
            }
          })
        ]),
      );
    }

    mainItem({e, ctx}) {
      return GestureDetector(
        onTap: () {
          Lang.mainerrormsg = null;
          initialofdialog(e: e);
          showDialog(
              context: ctx,
              builder: (_) {
                return DialogMz01(
                    title: ['تعديل', 'edit'],
                    mainlabels: maintitlesdialogMz01,
                    bodies: [basics(), addemployee()],
                    actionlist: editactionaswidget(ctx: ctx, e: e));
              });
        },
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text("# ${e['office_id']}_ "),
                  Expanded(
                      child: Text(
                    e['officename'],
                    style: ThemeMz.titlemediumChanga(),
                  )),
                  GetBuilder<MainController>(
                    init: mainController,
                    builder: (_) {
                      return Row(
                        children: [
                          ...easyeditlist[DB.allofficeinfotable[0]['offices']
                                  .indexOf(e)]
                              .where((b) => b['visible'] == true)
                              .map((b) => IconbuttonMz(
                                    e: e,
                                    action: listoffunctionforeasyeditpanel(
                                        ctx: ctx, e: e)[b['index']],
                                    elevate: b['elevate'],
                                    labelvisible:
                                        b['elevate'] == 3.0 ? true : false,
                                    label: b['label'],
                                    icon: b['icon'],
                                    buttonlist: easyeditlist[DB
                                        .allofficeinfotable[0]['offices']
                                        .indexOf(e)],
                                    index: b['index'],
                                    height: 35,
                                    width: b['elevate'] == 3.0 ? 80 : 40,
                                    backcolor: b['backcolor'],
                                  ))
                        ],
                      );
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      );
    }

    condition(x) => true;

    return GetBuilder<DBController>(
      init: dbController,
      builder: (_) => PageTamplate01(
        appbartitle: const ['المكاتب', 'Offices'],
        // searchwithdatevisible: false,
        searchrangelist: const ['officename'],
        // chooseofficevisible: false,
        // officechooselist: DB.allofficeinfotable[0]['offices'],
        // officenameclmname: 'officename',
        conditionofview: (x) => condition(x),
        table: DB.allofficeinfotable,
        tablename: 'offices',
        mainItem: (x) => mainItem(e: x, ctx: context),
        startdate: searchbydate[0],
        setstartdate: () => null,
        enddate: searchbydate[0],
        setenddate: () => null,
        addactionvisible: true,
        initialofadd: () => initialofdialog(),
        initial: () => buildeasyeditlist(),
        addactiontitle: const ['إضافة مكتب', 'Add Office'],
        addactionmainlabelsofpages: maintitlesdialogMz01,
        addactionpages: [basics(), addemployee()],
        listofactionbuttonforadd: listofactionbuttonforadd,
        listoffunctionforadd: (e) => listoffunctionforadd(e),
        floateactionbuttonlist: floatactionbuttonlist,
      ),
    );
  }
}
