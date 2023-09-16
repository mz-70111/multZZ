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
  static List<Map> floatactionbutton = [
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

    List<Function> listoffunctionforadd(e) => [
          (e) async => await mainController.addoffice(),
          (e) => Get.back(),
        ];

    buildeasyeditlist() {
      easyeditlist.clear();
      for (var i in DB.allofficeinfotable[0]['offices']) {
        easyeditlist.add([]);
        easyeditlist[DB.allofficeinfotable[0]['offices'].indexOf(i)].addAll({
          {
            'index': DB.allofficeinfotable[0]['offices'].indexOf(i),
            'actionindex': 0,
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

    easyeditactionlist(ibmf) => [
          (ibmf) => mainController.removeoffice(officeid: ibmf['office_id']),
        ];
    suffixprefix({m}) {
      return SizedBox();
    }

    color(me) {
      return me['notifi'] == '1' ? true : false;
    }

    return GetBuilder<DBController>(
      init: dbController,
      builder: (_) => PageTamplate01(
        appbartitle: const ['المكاتب', 'Offices'], //done
        mainItem: (x) => Text(x['officename']),

        listoffunctionforadd: (e) => listoffunctionforadd(e),
        prefixotherMainItems: (r) => suffixprefix(m: r),
        suffixotherMainItems: (r) => suffixprefix(m: r),
        listofactionbuttonforadd: listofactionbuttonforadd,
        mainrowcolor: (me) => color(me),
        floateactionbutton: floatactionbutton,
        ini: () => buildeasyeditlist(),
        preparefunctionfuture: () => getemployees0(),
        preparefunction: () => initial(),
        table: DB.allofficeinfotable,
        tablename: 'offices',
        mainItems: ['office_id', 'officename'],
        searchrangelist: ['officename'],
        searchwithdatevisible: false,
        startdate: searchbydate[0],
        setstartdate: () => null,
        enddate: searchbydate[1],
        setenddate: () => null,
        openitem: (o) => edititemWidget(e: o, ctx: context),
        easyeditlist: easyeditlist,
        easyeditaction: (m) => easyeditactionlist(m)[BasicInfo.actionindex],
        addtitle: const ['إضافة مكتب', 'Add Office'],
        maintitlesdialogMz01: maintitlesdialogMz01,
        lisofpagesforadd: [basics(), addemployee()],
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
      maintitlesdialogMz01[0]['selected'] = true;
      maintitlesdialogMz01[1]['selected'] = false;
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
    } else {
      bodieslistofadd[0]['tf'][0]['error'] = null;
      officenamecontroller.text = e['officename'];
      chatidcontroller.text = e['chatid'];
      apitokencontroller.text = e['apitoken'];
      bodieslistofadd[0]['notifi'] = false;
      maintitlesdialogMz01[0]['selected'] = true;
      maintitlesdialogMz01[1]['selected'] = false;
      DropDownWithSearchMz.visiblemain = false;
    }
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

  edititemWidget({e, ctx}) {
    return showDialog(
        context: ctx,
        builder: (_) {
          return FutureBuilder(future: Future(() async {
            try {
              return DB.allusersinfotable =
                  await DBController().getallusersinfo();
            } catch (e) {
              null;
            }
          }), builder: (_, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return WaitMz.waitmz0([1, 2, 3], ctx);
            } else if (snap.hasData) {
              initial(e: e);
              return DialogMz01(
                title: ['مكتب', 'Office'],
                mainlabels: maintitlesdialogMz01,
                bodies: [SizedBox()],
                actionlist: SizedBox(),
              );
            } else {
              Future(() => Get.back());
              return const SizedBox();
            }
          });
        });
  }
}
