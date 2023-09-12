import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mz_flutter_07/controllers/dbcontroller.dart';
import 'package:mz_flutter_07/controllers/maincontroller.dart';
import 'package:mz_flutter_07/models/basicinfo.dart';
import 'package:mz_flutter_07/models/bottonicon.dart';
import 'package:mz_flutter_07/models/database.dart';
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
  static List actionlistofadd = [
    {
      'visible': true,
      'type': 'do-it',
      'label': ['إضافة', 'Add'],
    },
    {
      'visible': true,
      'type': 'do-it',
      'label': ['رجوع', 'close'],
    },
    {
      'visible': false,
      'type': 'wait',
    }
  ];
  static DateTime startdate = DateTime.now().add(Duration(days: -30));
  static DateTime enddate = DateTime.now();
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

    actionfunlistofadd(e) => [
          (e) async => await mainController.addoffice(),
          (e) => Get.back(),
        ];

    actionoffaddWidget() {
      return GetBuilder<MainController>(
        init: mainController,
        builder: (_) =>
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          ...actionlistofadd
              .where((element) => element['visible'] == true)
              .map((u) {
            switch (u['type']) {
              case 'do-it':
                return SizedBox(
                  width: 100,
                  child: IconbuttonMz(
                      e: null,
                      action:
                          actionfunlistofadd(null)[actionlistofadd.indexOf(u)],
                      label: u['label']),
                );
              case 'wait':
                return WaitMz.waitmz0([1, 2, 3, 4, 5, 6, 7, 8], context);
              default:
                return SizedBox();
            }
          })
        ]),
      );
    }

    buildeasyeditlist() {
      easyeditlist.clear();
      for (var i in DB.allofficeinfotable[0]['offices']) {
        easyeditlist.add([]);
        easyeditlist[DB.allofficeinfotable[0]['offices'].indexOf(i)].addAll({
          {'visible': false, 'type': 'wait'},
          {
            'visible': true,
            'type': 'do-it',
            'icon': Icons.delete_forever,
            'label': ['حذف', 'delete'],
            'elevate': 0.0,
            'i': 1
          },
        });
      }
    }

    List easyeditactionlist(e) => [
          (e) => null,
          (e) => mainController.removeoffice(officeid: e['office_id'])
        ];

    return GetBuilder<DBController>(
      init: dbController,
      builder: (_) => PageTamplate01(
        ini: () => buildeasyeditlist(),
        futurefun: Future(() async {
          try {
            return DB.allofficeinfotable =
                await DBController().getallofficeinfo();
          } catch (e) {
            null;
          }
        }),
        preparefunctionfuture: () => getemployees0(),
        preparefunction: () => initial(),
        table: DB.allofficeinfotable,
        tablename: 'offices',
        mainItems: ['office_id', 'officename'],
        searchrangelist: ['officename'],
        searchwithdatevisible: false,
        startdate: startdate,
        setstartdate: () => null,
        enddate: enddate,
        setenddate: () => null,
        openitem: (o) => null,
        easyeditlist: easyeditlist,
        easyeditaction: (me, se) {
          if (se['elevate'] == 0.0) {
            return mainController.easyeditaction(
                me: me,
                se: se,
                listme: DB.allofficeinfotable[0]['offices'],
                listse: easyeditlist,
                colmuname: 'office_id');
          } else {
            return mainController.removeoffice(
                officeid: me['office_id'], listse: easyeditlist);
          }
        },
        appbartitle: const ['المكاتب', 'Offices'],
        addtitle: const ['إضافة مكتب', 'Add Office'],
        mainlebelsdialogmz: mainlabelsdialogmz,
        bodiesofadd: [basics(), addemployee()],
        actionlist: [actionoffaddWidget()],
        elevationcard: elevationcard,
        page: 'Offices',
      ),
    );
  }

  getemployees0() async {
    return DB.allusersinfotable = await DBController().getallusersinfo();
  }

  initial({e}) {
    addemployeelist.clear();
    if (e == null) {
      bodieslistofadd[0]['tf'][0]['error'] = null;
      officenamecontroller.text = '';
      chatidcontroller.text = '';
      apitokencontroller.text = '';
      bodieslistofadd[0]['notifi'] = false;
      mainlabelsdialogmz[0]['selected'] = true;
      mainlabelsdialogmz[1]['selected'] = false;
      DropDownWithSearchMz.visiblemain = false;
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
    }
  }

  setpreivileges({ctx, index, type = 'add', ee}) {
    List actionlist = [
      {
        'visible': true,
        'label': type == 'add' ? ['إضافة', 'save'] : ['حفظ', 'save'],
        'elavation': 0.0
      },
      {
        'visible': true,
        'label': ['رجوع', 'close'],
        'elavation': 0.0
      },
      {
        'visible': type == 'add' ? false : true,
        'label': ['حذف', 'delete'],
        'elavation': 0.0
      },
    ];
    List actionfun(e) => [
          (e) => mainController.addremoveemployeetooffice(e: e, type: 'save'),
          (e) => Get.back(),
          (e) => mainController.addremoveemployeetooffice(e: e, type: 'edit'),
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
                                                mainController.changeradiopriv(
                                                    x: x,
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
                                        .where(
                                            (element) => element.contains("P-"))
                                        .map((e) {
                                      return Row(
                                        children: [
                                          Checkbox(
                                              value: m[e][0],
                                              onChanged: (x) {
                                                mainController.chackboxpriv(
                                                    x: x,
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
                      .map((r) => SizedBox(
                            width: 100,
                            child: IconbuttonMz(
                                elevetioncard: r['elavation'],
                                listbutton: actionlist,
                                indexbutton: actionlist.indexOf(r),
                                e: ee,
                                action: actionfun(ee)[actionlist.indexOf(r)],
                                label: r['label']),
                          ))
                ],
              ),
            ),
          );
        });
  }
}
