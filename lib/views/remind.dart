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

class Remind extends StatelessWidget {
  const Remind({super.key});
  static List<Map> maintitlesdialogMz01 = [
    {
      'name': ['معلومات أساسية', 'Basics'],
      'selected': true,
    },
    {
      'name': ['تفاصيل', 'Details'],
      'selected': false,
    }
  ];
  static TextEditingController remindnamecontroller = TextEditingController();
  static TextEditingController remindoptioncontroller = TextEditingController();

  static List bodieslistofadd = [
    {
      'selectedofficeindex': 0,
      'tf': [
        {
          'label': ['اسم التذكير', 'Remind name'],
          'controller': remindnamecontroller,
          'td': TextDirection.ltr,
          'error': null
        },
        {
          'label': ['خيارات التذكير', 'Remind Options'],
          'controller': remindoptioncontroller,
          'error': null
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
    basics() {
      List offices = [];
      offices.clear();
      // for (var i in DB.userinfotable[0]['users_priv_office']) {
      //   offices.add(DB.allofficeinfotable[0]['offices']
      //       .where((o) => o['office_id'] == i['upo_office_id'])
      //       .toList()[0]['officename']);
      // }
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
                      value: offices[bodieslistofadd[0]['selectedofficeindex']],
                      items: offices
                          .map((e) => DropdownMenuItem(child: Text(e)))
                          .toList(),
                      onChanged: (x) {}),
                )
              ],
            ),
            ...bodieslistofadd[0]['tf'].map((w) => TextFieldMz(
                label: w['label'],
                error: w['error'],
                obscureText: w['obscuretext'] ?? false,
                icon: w['icon'],
                onchange: (x) => null,
                hint: w['hint'],
                action: () => mainController.hideshowpass(
                    list: bodieslistofadd[0]['tf'], e: w),
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
          children: [
            Row(
              children: [
                // Radio(
                //     value: bodieslistofadd[1]['details'][0]['type'][1]['auto'],
                //     groupValue: bodieslistofadd[1]['details'][0]['type'][0]
                //         ['group'],
                //     onChanged: (x) {})
              ],
            ),
          ],
        ),
      );
    }

    // initialofdialog({e}) {
    //   addtoofficelist.clear();
    //   maintitlesdialogMz01[0]['selected'] = true;
    //   maintitlesdialogMz01[1]['selected'] = false;
    //   DropDownWithSearchMz.visiblemain = false;
    //   for (var i in bodieslistofadd[0]['tf']) {
    //     i['error'] = null;
    //     i['hint'] = null;
    //   }
    //   if (e == null) {
    //     usernamecontroller.text = '';
    //     fullnamecontroller.text = '';
    //     passwordcontroller.text = '';
    //     confirmpasswordcontroller.text = '';
    //     emailcontroller.text = '';
    //     mobilecontorller.text = '';
    //     bodieslistofadd[1]['bp'][0]['admin'] = false;
    //     bodieslistofadd[1]['bp'][0]['enable'] = true;
    //     bodieslistofadd[1]['bp'][0]['mustchgpass'] = true;
    //     bodieslistofadd[1]['bp'][0]['pbx'] = false;
    //     for (var i in DB.allofficeinfotable[0]['offices']) {
    //       addtoofficelist.add({});
    //       addtoofficelist[DB.allofficeinfotable[0]['offices'].indexOf(i)]
    //           .addAll({
    //         'office_id': i['office_id'],
    //         'name': i['officename'],
    //         'visible': true,
    //         'visiblesearch': true,
    //         'position': ['موظف', 'employee'],
    //         'Po-employee': ['موظف', 'employee'],
    //         'Po-supervisor': ['مشرف', 'supervisor'],
    //         'P-addtask': [
    //           false,
    //           ['إضافة مهمة', 'Add task']
    //         ],
    //         'P-showalltasks': [
    //           false,
    //           ['مشاهدة جميع المهام', 'show all tasks']
    //         ],
    //         'P-addremind': [
    //           true,
    //           ['إضافة تذكير', 'Add remind']
    //         ],
    //         'P-showallreminds': [
    //           true,
    //           ['مشاهدة جميع التنبيهات ', 'show all reminds']
    //         ],
    //         'P-addtodo': [
    //           true,
    //           ['إضافة إجرائية', 'Add todo']
    //         ],
    //         'P-showalltodos': [
    //           true,
    //           ['مشاهدة جميع الإجرائيات ', 'show all todos']
    //         ],
    //         'P-addping': [
    //           true,
    //           ['Add ping', 'Add ping']
    //         ],
    //         'P-showallpings': [
    //           true,
    //           ['show all pings', 'show all pings']
    //         ],
    //         'P-addemailtest': [
    //           true,
    //           ['إضافة تفحص ايميل', 'Add Email test']
    //         ],
    //         'P-showallemailtests': [
    //           true,
    //           ['show all emailtests', 'show all emailtests']
    //         ],
    //         'P-addcost': [
    //           true,
    //           ['إضافة طلب سلفة', 'Add Cost']
    //         ],
    //         'P-showallcosts': [
    //           false,
    //           ['مشاهدة جميع السلف', 'show all costs']
    //         ],
    //         'P-acceptcosts': [
    //           false,
    //           ['موافقة على السلفة', 'Accept Cost']
    //         ],
    //         'P-addhyperlink': [
    //           false,
    //           ['إضافة رابط خارجي', 'Add HyperLink']
    //         ],
    //         'P-showallhyperlinks': [
    //           false,
    //           ['مشاهدة جميع الروابط', 'show all h-links']
    //         ],
    //       });
    //     }
    //   } else {
    //     usernamecontroller.text = e['username'];
    //     fullnamecontroller.text = e['fullname'];
    //     passwordcontroller.text = '';
    //     confirmpasswordcontroller.text = '';
    //     bodieslistofadd[0]['tf'][2]['hint'] = bodieslistofadd[0]['tf'][3]
    //         ['hint'] = ['بدون تغيير', 'no change'][BasicInfo.indexlang()];
    //     emailcontroller.text = e['email'] ?? '';
    //     mobilecontorller.text = e['mobile'] ?? '';
    //     bodieslistofadd[1]['bp'][0]['admin'] = DB.allusersinfotable[0]
    //                     ['users_privileges']
    //                 .where((up) => up['up_user_id'] == e['user_id'])
    //                 .toList()[0]['admin'] ==
    //             '1'
    //         ? true
    //         : false;
    //     bodieslistofadd[1]['bp'][0]['enable'] = DB.allusersinfotable[0]
    //                     ['users_privileges']
    //                 .where((up) => up['up_user_id'] == e['user_id'])
    //                 .toList()[0]['enable'] ==
    //             '1'
    //         ? true
    //         : false;
    //     bodieslistofadd[1]['bp'][0]['mustchgpass'] = DB.allusersinfotable[0]
    //                     ['users_privileges']
    //                 .where((up) => up['up_user_id'] == e['user_id'])
    //                 .toList()[0]['mustchgpass'] ==
    //             '1'
    //         ? true
    //         : false;
    //     bodieslistofadd[1]['bp'][0]['pbx'] = DB.allusersinfotable[0]
    //                     ['users_privileges']
    //                 .where((up) => up['up_user_id'] == e['user_id'])
    //                 .toList()[0]['pbx'] ==
    //             '1'
    //         ? true
    //         : false;

    //     for (var i in DB.allusersinfotable[0]['users_priv_office']
    //         .where((uu) => uu['upo_user_id'] == e['user_id'])) {
    //       addtoofficelist.add({});
    //       addtoofficelist[DB.allusersinfotable[0]['users_priv_office']
    //               .where((uu) => uu['upo_user_id'] == e['user_id'])
    //               .toList()
    //               .indexOf(i)]
    //           .addAll({
    //         'office_id': i['upo_office_id'],
    //         'name': DB.allofficeinfotable[0]['offices'][DB.allofficeinfotable[0]
    //                     ['offices']
    //                 .indexWhere((u) => u['office_id'] == i['upo_office_id'])]
    //             ['officename'],
    //         'visible': false,
    //         'visiblesearch': true,
    //         'position': i['position'] == 'employee'
    //             ? ['موظف', 'employee']
    //             : ['مشرف', 'supervisor'],
    //         'Po-employee': ['موظف', 'employee'],
    //         'Po-supervisor': ['مشرف', 'supervisor'],
    //         'P-addtask': [
    //           i['addtask'] == '1' ? true : false,
    //           ['إضافة مهمة', 'Add task']
    //         ],
    //         'P-showalltasks': [
    //           i['showalltasks'] == '1' ? true : false,
    //           ['مشاهدة جميع المهام', 'show all tasks']
    //         ],
    //         'P-addremind': [
    //           i['addremind'] == '1' ? true : false,
    //           ['إضافة تذكير', 'Add remind']
    //         ],
    //         'P-showallreminds': [
    //           i['showallreminds'] == '1' ? true : false,
    //           ['مشاهدة جميع التنبيهات ', 'show all reminds']
    //         ],
    //         'P-addtodo': [
    //           i['addtodo'] == '1' ? true : false,
    //           ['إضافة إجرائية', 'Add todo']
    //         ],
    //         'P-showalltodos': [
    //           i['showalltodos'] == '1' ? true : false,
    //           ['مشاهدة جميع الإجرائيات ', 'show all todos']
    //         ],
    //         'P-addping': [
    //           i['addping'] == '1' ? true : false,
    //           ['Add ping', 'Add ping']
    //         ],
    //         'P-showallpings': [
    //           i['showallpings'] == '1' ? true : false,
    //           ['show all pings', 'show all pings']
    //         ],
    //         'P-addemailtest': [
    //           i['addemailtest'] == '1' ? true : false,
    //           ['إضافة تفحص ايميل', 'Add Email test']
    //         ],
    //         'P-showallemailtests': [
    //           i['showallemailtests'] == '1' ? true : false,
    //           ['show all emailtests', 'show all emailtests']
    //         ],
    //         'P-addcost': [
    //           i['addcost'] == '1' ? true : false,
    //           ['إضافة طلب سلفة', 'Add Cost']
    //         ],
    //         'P-showallcosts': [
    //           i['showallcosts'] == '1' ? true : false,
    //           ['مشاهدة جميع السلف', 'show all costs']
    //         ],
    //         'P-acceptcosts': [
    //           i['acceptcosts'] == '1' ? true : false,
    //           ['موافقة على السلفة', 'Accept Cost']
    //         ],
    //         'P-addhyperlink': [
    //           i['addhyperlink'] == '1' ? true : false,
    //           ['إضافة رابط خارجي', 'Add HyperLink']
    //         ],
    //         'P-showallhyperlinks': [
    //           i['showallhyperlinks'] == '1' ? true : false,
    //           ['مشاهدة جميع الروابط', 'show all h-links']
    //         ],
    //       });
    //     }
    //     List officein = [];
    //     officein.clear();
    //     for (var j in addtoofficelist) {
    //       officein.add(j['office_id']);
    //     }

    //     for (var i in DB.allofficeinfotable[0]['offices']
    //         .where((uu) => !officein.contains(uu['office_id']))) {
    //       addtoofficelist.add({});
    //       addtoofficelist[addtoofficelist.length - 1].addAll({
    //         'office_id': i['office_id'],
    //         'name': i['officename'],
    //         'visible': true,
    //         'visiblesearch': true,
    //         'position': ['موظف', 'employee'],
    //         'Po-employee': ['موظف', 'employee'],
    //         'Po-supervisor': ['مشرف', 'supervisor'],
    //         'P-addtask': [
    //           false,
    //           ['إضافة مهمة', 'Add task']
    //         ],
    //         'P-showalltasks': [
    //           false,
    //           ['مشاهدة جميع المهام', 'show all tasks']
    //         ],
    //         'P-addremind': [
    //           true,
    //           ['إضافة تذكير', 'Add remind']
    //         ],
    //         'P-showallreminds': [
    //           true,
    //           ['مشاهدة جميع التنبيهات ', 'show all reminds']
    //         ],
    //         'P-addtodo': [
    //           true,
    //           ['إضافة إجرائية', 'Add todo']
    //         ],
    //         'P-showalltodos': [
    //           true,
    //           ['مشاهدة جميع الإجرائيات ', 'show all todos']
    //         ],
    //         'P-addping': [
    //           true,
    //           ['Add ping', 'Add ping']
    //         ],
    //         'P-showallpings': [
    //           true,
    //           ['show all pings', 'show all pings']
    //         ],
    //         'P-addemailtest': [
    //           true,
    //           ['إضافة تفحص ايميل', 'Add Email test']
    //         ],
    //         'P-showallemailtests': [
    //           true,
    //           ['show all emailtests', 'show all emailtests']
    //         ],
    //         'P-addcost': [
    //           true,
    //           ['إضافة طلب سلفة', 'Add Cost']
    //         ],
    //         'P-showallcosts': [
    //           false,
    //           ['مشاهدة جميع السلف', 'show all costs']
    //         ],
    //         'P-acceptcosts': [
    //           false,
    //           ['موافقة على السلفة', 'Accept Cost']
    //         ],
    //         'P-addhyperlink': [
    //           false,
    //           ['إضافة رابط خارجي', 'Add HyperLink']
    //         ],
    //         'P-showallhyperlinks': [
    //           false,
    //           ['مشاهدة جميع الروابط', 'show all h-links']
    //         ],
    //       });
    //     }
    //   }
    // }

    // buildeasyeditlist() {
    //   easyeditlist.clear();
    //   for (var i in DB.allusersinfotable[0]['users']) {
    //     easyeditlist.add([]);
    //     easyeditlist[DB.allusersinfotable[0]['users'].indexOf(i)].addAll({
    //       {
    //         'index': 0,
    //         'visible0':
    //             BasicInfo.LogInInfo![0] == i['user_id'] || i['user_id'] == '1'
    //                 ? false
    //                 : true,
    //         'visible': true,
    //         'type': 'do-it',
    //         'icon': Icons.delete_forever,
    //         'label': ['حذف', 'delete'],
    //         'elevate': 0.0,
    //         'backcolor': Colors.transparent,
    //         'length': 80.0
    //       },
    //       {
    //         'index': 1,
    //         'visible0':
    //             BasicInfo.LogInInfo![0] == i['user_id'] || i['user_id'] == '1'
    //                 ? false
    //                 : true,
    //         'visible': true,
    //         'type': 'do-it',
    //         'icon': Icons.account_box,
    //         'label': DB.allusersinfotable[0]['users_privileges']
    //                     .where((y) => y['up_user_id'] == i['user_id'])
    //                     .toList()[0]['enable'] ==
    //                 '1'
    //             ? ['تعطيل الحساب', 'disable account']
    //             : ['تفعيل الحساب', 'enable account'],
    //         'elevate': 0.0,
    //         'backcolor': Colors.transparent,
    //         'length': 150.0
    //       },
    //       {
    //         'index': 2,
    //         'visible0': true,
    //         'visible': true,
    //         'type': 'do-it',
    //         'icon': Icons.password,
    //         'label': ['إعادة تعيين كلمة المرور', 'reset password'],
    //         'elevate': 0.0,
    //         'backcolor': Colors.transparent,
    //         'length': 190.0
    //       },
    //       {'visible0': true, 'visible': false, 'type': 'wait'},
    //     });
    //   }
    // }

    List<Function> listoffunctionforadd(e) => [
          (e) async => await mainController.addaccount(),
          (e) => Get.back(),
        ];
    List<Function> listoffunctionforedit(e) => [
          (e) async => await mainController.updateaccount(userid: e['user_id']),
          (e) => Get.back(),
        ];
    // listoffunctionforeasyeditpanel({e, ctx}) => [
    //       (e) => showDialog(
    //           context: ctx,
    //           builder: (_) {
    //             List actionlist = [
    //               {
    //                 'type': 'do-it',
    //                 'visible': true,
    //                 'label': ['حذف', 'delete'],
    //                 'elevate': 0.0,
    //                 'index': 0,
    //               },
    //               {
    //                 'type': 'do-it',
    //                 'visible': true,
    //                 'label': ['رجوع', 'close'],
    //                 'elevate': 0.0,
    //                 'index': 1,
    //               },
    //               {
    //                 'type': 'wait',
    //                 'visible': false,
    //               }
    //             ];
    //             List functionofaction(e) => [
    //                   (e) => mainController.removeaccount(
    //                       userid: e['user_id'], list: actionlist),
    //                   (e) => Get.back()
    //                 ];
    //             return GetBuilder<MainController>(
    //               init: mainController,
    //               builder: (_) => Directionality(
    //                 textDirection: BasicInfo.lang(),
    //                 child: AlertDialog(
    //                   scrollable: true,
    //                   title: Text([
    //                     'هل أنت متأكد من حذف${e['username']}?',
    //                     'sure to delete ${e['username']}?'
    //                   ][BasicInfo.indexlang()]),
    //                   actions: [
    //                     ...actionlist
    //                         .where((element) => element['visible'] == true)
    //                         .map((y) {
    //                       switch (y['type']) {
    //                         case 'do-it':
    //                           return IconbuttonMz(
    //                               e: e,
    //                               elevate: y['elevate'],
    //                               action: functionofaction(e)[y['index']],
    //                               label: y['label'],
    //                               buttonlist: actionlist,
    //                               index: y['index'],
    //                               height: 35,
    //                               width: 60,
    //                               backcolor: ThemeMz.iconbuttonmzbc());
    //                         case 'wait':
    //                           return WaitMz.waitmz0([1, 2, 3, 4], ctx);
    //                         default:
    //                           return SizedBox();
    //                       }
    //                     })
    //                   ],
    //                 ),
    //               ),
    //             );
    //           }),
    //       (e) => mainController.disableenableaccount(
    //           userid: e['user_id'],
    //           list: easyeditlist[DB.allusersinfotable[0]['users']
    //               .indexWhere((u) => u['user_id'] == e['user_id'])][1],
    //           listvisible: easyeditlist[DB.allusersinfotable[0]['users']
    //               .indexWhere((u) => u['user_id'] == e['user_id'])][3],
    //           val: 'visible'),
    //       (e) => showDialog(
    //           context: ctx,
    //           builder: (_) {
    //             TextEditingController newpass = TextEditingController();
    //             TextEditingController confnewpass = TextEditingController();

    //             List tf = [
    //               {
    //                 'label': ['كلمة المرور الجديدة', 'new passowrd'],
    //                 'obscuretext': true,
    //                 'error': null,
    //                 'icon': Icons.visibility,
    //                 'controller': newpass
    //               },
    //               {
    //                 'label': ['تأكيد كلمة المرور', 'Confirm passowrd'],
    //                 'obscuretext': true,
    //                 'error': null,
    //                 'icon': Icons.visibility,
    //                 'controller': confnewpass
    //               }
    //             ];

    //             List actionlist = [
    //               {
    //                 'type': 'do-it',
    //                 'visible': true,
    //                 'label': ['حفظ', 'save'],
    //                 'elevate': 0.0,
    //                 'index': 0,
    //               },
    //               {
    //                 'type': 'do-it',
    //                 'visible': true,
    //                 'label': ['رجوع', 'close'],
    //                 'elevate': 0.0,
    //                 'index': 1,
    //               },
    //               {
    //                 'type': 'wait',
    //                 'visible': false,
    //               }
    //             ];
    //             List functionofaction(e) => [
    //                   (e) => mainController.resetpassword(
    //                       userid: e['user_id'],
    //                       actionlist: actionlist,
    //                       tflist: tf,
    //                       newpassword: newpass,
    //                       confirmpassword: confnewpass),
    //                   (e) => Get.back()
    //                 ];
    //             return GetBuilder<MainController>(
    //               init: mainController,
    //               builder: (_) => Directionality(
    //                 textDirection: BasicInfo.lang(),
    //                 child: AlertDialog(
    //                   scrollable: true,
    //                   content: Column(children: [
    //                     ...tf.map((t) => TextFieldMz(
    //                         controller: t['controller'],
    //                         label: t['label'],
    //                         icon: t['icon'],
    //                         error: t['error'],
    //                         obscureText: t['obscuretext'],
    //                         onchange: (x) => null,
    //                         action: () =>
    //                             mainController.hideshowpass(list: tf, e: t),
    //                         td: TextDirection.ltr))
    //                   ]),
    //                   actions: [
    //                     ...actionlist
    //                         .where((element) => element['visible'] == true)
    //                         .map((y) {
    //                       switch (y['type']) {
    //                         case 'do-it':
    //                           return IconbuttonMz(
    //                               e: e,
    //                               elevate: y['elevate'],
    //                               action: functionofaction(e)[y['index']],
    //                               label: y['label'],
    //                               buttonlist: actionlist,
    //                               index: y['index'],
    //                               height: 35,
    //                               width: 60,
    //                               backcolor: ThemeMz.iconbuttonmzbc());
    //                         case 'wait':
    //                           return WaitMz.waitmz0([1, 2, 3, 4], ctx);
    //                         default:
    //                           return SizedBox();
    //                       }
    //                     })
    //                   ],
    //                 ),
    //               ),
    //             );
    //           }),
    //     ];

    // GetBuilder<MainController> editactionaswidget({ctx, e}) {
    //   return GetBuilder<MainController>(
    //     init: mainController,
    //     builder: (_) =>
    //         Row(mainAxisAlignment: MainAxisAlignment.end, children: [
    //       ...listofactionbuttonforedit
    //           .where((element) => element['visible'] == true)
    //           .map((u) {
    //         switch (u['type']) {
    //           case 'do-it':
    //             return IconbuttonMz(
    //                 backcolor: ThemeMz.iconbuttonmzbc(),
    //                 height: 40,
    //                 width: 75,
    //                 index: u['index'],
    //                 buttonlist: listofactionbuttonforedit,
    //                 elevate: u['elevate'],
    //                 e: e,
    //                 action: listoffunctionforedit(
    //                     u)[listofactionbuttonforedit.indexOf(u)],
    //                 label: u['label']);
    //           case 'wait':
    //             return WaitMz.waitmz0([1, 2, 3, 4, 5, 6, 7, 8], ctx);
    //           default:
    //             return SizedBox();
    //         }
    //       })
    //     ]),
    //   );
    // }

    // mainItem({e, ctx}) {
    //   return GestureDetector(
    //     onTap: () {
    //       Lang.mainerrormsg = null;
    //       initialofdialog(e: e);
    //       showDialog(
    //           context: ctx,
    //           builder: (_) {
    //             return DialogMz01(
    //                 title: ['تعديل', 'edit'],
    //                 mainlabels: maintitlesdialogMz01,
    //                 bodies: [basics(), basicpriv(), addtoOffice()],
    //                 actionlist: editactionaswidget(ctx: ctx, e: e));
    //           });
    //     },
    //     child: MouseRegion(
    //       cursor: SystemMouseCursors.click,
    //       child: Card(
    //         child: Container(
    //           decoration: BoxDecoration(
    //               gradient: LinearGradient(colors: [
    //             Colors.transparent,
    //             DB.allusersinfotable[0]['users_privileges']
    //                         .where((y) => y['up_user_id'] == e['user_id'])
    //                         .toList()[0]['enable'] ==
    //                     '1'
    //                 ? Colors.green.withOpacity(0.2)
    //                 : Colors.transparent,
    //           ])),
    //           child: Padding(
    //             padding: const EdgeInsets.all(8.0),
    //             child: Column(
    //               children: [
    //                 Row(
    //                   children: [
    //                     Text("# ${e['user_id']}_ "),
    //                     Expanded(
    //                         child: Row(
    //                       children: [
    //                         Text(
    //                           e['username'],
    //                           style: ThemeMz.titlemediumChanga(),
    //                         ),
    //                         Text(
    //                           " _> ${e['fullname']}",
    //                           style: ThemeMz.titlemediumChanga(),
    //                         )
    //                       ],
    //                     )),
    //                   ],
    //                 ),
    //                 GetBuilder<MainController>(
    //                   init: mainController,
    //                   builder: (_) {
    //                     return Row(
    //                       mainAxisAlignment: MainAxisAlignment.end,
    //                       children: [
    //                         ...easyeditlist[
    //                                 DB.allusersinfotable[0]['users'].indexOf(e)]
    //                             .where((b) =>
    //                                 b['visible'] == true &&
    //                                 b['visible0'] == true)
    //                             .map((b) {
    //                           switch (b['type']) {
    //                             case 'do-it':
    //                               return IconbuttonMz(
    //                                 e: e,
    //                                 action: listoffunctionforeasyeditpanel(
    //                                     ctx: ctx, e: e)[b['index']],
    //                                 elevate: b['elevate'],
    //                                 labelvisible:
    //                                     b['elevate'] == 3.0 ? true : false,
    //                                 label: b['label'],
    //                                 icon: b['icon'],
    //                                 buttonlist: easyeditlist[DB
    //                                     .allusersinfotable[0]['users']
    //                                     .indexOf(e)],
    //                                 index: b['index'],
    //                                 height: 35,
    //                                 width:
    //                                     b['elevate'] == 3.0 ? b['length'] : 40,
    //                                 backcolor: b['backcolor'],
    //                               );
    //                             case 'wait':
    //                               return WaitMz.waitmz0([1, 2, 3, 4], context);
    //                             default:
    //                               return SizedBox();
    //                           }
    //                         })
    //                       ],
    //                     );
    //                   },
    //                 )
    //               ],
    //             ),
    //           ),
    //         ),
    //       ),
    //     ),
    //   );
    // }

    conditionofview(x) {
      List officesthatuserinit = [], users = [];
      for (var i in DB.allofficeinfotable[0]['users_priv_office']
          .where((u) => u['upo_user_id'] == BasicInfo.LogInInfo![0])) {
        if (i['showalltasks'] == '1') {
          officesthatuserinit.clear();
          users.clear();
          for (var i in DB.allofficeinfotable[0]['users_priv_office'].where(
              (o) =>
                  BasicInfo.LogInInfo![0] == o['upo_user_id'] &&
                  o['showalltasks'] == '1')) {
            officesthatuserinit.add(i['upo_office_id']);
          }
          for (var i in DB.allusersinfotable[0]['users_priv_office']
              .where((t) => officesthatuserinit.contains(t['upo_office_id']))) {
            if (!users.contains(i['upo_user_id'])) {
              users.add(i['upo_user_id']);
            }
          }
          if (users.contains(x['user_id'])) return true;
        } else {
          if (x['user_id'] == BasicInfo.LogInInfo![0]) return true;
        }
      }
    }

    return GetBuilder<DBController>(
      init: dbController,
      builder: (_) => PageTamplate01(
        appbartitle: const ['التذكير', 'Remind'],
        // searchwithdatevisible: false,
        searchrangelist: const ['remindname', 'reminddetails'],
        // chooseofficevisible: true,
        // officechooselist: DB.allusersinfotable[0]['users'],
        // officenameclmname: 'upo_user_id',
        conditionofview: (x) => true,
        table: DB.allusersinfotable,
        tablename: 'users',
        mainItem: (x) => SizedBox(),
        startdate: searchbydate[0],
        setstartdate: () => null,
        enddate: searchbydate[0],
        setenddate: () => null,
        addactionvisible: true,
        initialofadd: () {},
        initial: () {},
        addactiontitle: const ['إضافة تذكير', 'Add Remind'],
        addactionmainlabelsofpages: maintitlesdialogMz01,
        addactionpages: [
          basics(),
          remindoptions(),
        ],
        listofactionbuttonforadd: listofactionbuttonforadd,
        listoffunctionforadd: (e) {},
        floateactionbuttonlist: floatactionbuttonlist,
      ),
    );
  }
}