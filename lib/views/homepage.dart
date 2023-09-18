import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mz_flutter_07/controllers/dbcontroller.dart';
import 'package:mz_flutter_07/controllers/maincontroller.dart';
import 'package:mz_flutter_07/controllers/themecontroller.dart';
import 'package:mz_flutter_07/models/basicinfo.dart';
import 'package:mz_flutter_07/models/bottonicon.dart';
import 'package:mz_flutter_07/models/database.dart';
import 'package:mz_flutter_07/models/dialog01.dart';
import 'package:mz_flutter_07/models/lang_mode_theme.dart';
import 'package:mz_flutter_07/models/sharedpref.dart';
import 'package:mz_flutter_07/models/textfeild.dart';
import 'package:mz_flutter_07/models/tween.dart';
import 'package:mz_flutter_07/views/login.dart';
import 'package:mz_flutter_07/views/wait.dart';

ThemeController themeController = Get.find();

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  static List appbaractionlist = [
    {
      'name': 'mode',
      'icon': BasicInfo.selectedmode == 'Dark' ? Icons.sunny : Icons.dark_mode
    }
  ];

  static List draweractionlist = [
    {
      'name': ['تغيير كلمة المرور', 'change password'],
      'icon': Icons.password,
    },
    {
      'name': ['معلومات الحساب', 'Account Info'],
      'icon': Icons.settings_accessibility,
    },
    {
      'name': ['تسجيل خروج', 'log out'],
      'icon': Icons.logout,
    }
  ];

  static TextEditingController fullnamecontroller = TextEditingController();
  static TextEditingController mobilecontroller = TextEditingController();
  static TextEditingController emailcontroller = TextEditingController();
  static TextEditingController passwordcontroller = TextEditingController();
  static TextEditingController newpasswordcontroller = TextEditingController();
  static TextEditingController confirmnewpasswordcontroller =
      TextEditingController();

  static List<Map> dialogmainlabellist = [
    {
      'name': ['معلومات عامة', 'Basics'],
      'selected': true,
    },
    {
      'name': ['الصلاحيات', 'Privileges'],
      'selected': false,
    },
    {
      'name': ['الصلاحيات ضمن المكاتب', 'Privileges at office'],
      'selected': false,
    }
  ];
  static List dialogbodieslist = [
    [
      {
        'type': 'textf',
        'label': ['الاسم', 'fullname'],
        'controller': fullnamecontroller,
        'td': BasicInfo.lang()
      },
      {
        'type': 'textf',
        'label': ['موبايل', 'mobile'],
        'controller': mobilecontroller,
        'td': BasicInfo.lang()
      },
      {
        'type': 'textf',
        'label': ['بريد الكتروني', 'E-mail'],
        'controller': emailcontroller,
      }
    ],
  ];
  static List dialogactionlist = [
    {
      'index': 0,
      'type': 'do-it',
      'label': ['حفظ', 'save'],
      'visible': true,
      'elevate': 0.0
    },
    {
      'index': 1,
      'type': 'do-it',
      'label': ['رجوع', 'close'],
      'visible': true,
      'elevate': 0.0
    },
    {'index': 2, 'type': 'wait', 'visible': false},
  ];
  static IconData passwordvis = Icons.visibility;
  static bool waitchangepass = false;
  static List changepassword = [
    {
      'label': ['كلمة المرور القديمة', 'old password'],
      'controller': passwordcontroller,
      'v': true,
      'error': null
    },
    {
      'label': ['كلمة المرور الجديدة', 'new password'],
      'controller': newpasswordcontroller,
      'v': true,
      'error': null
    },
    {
      'label': ['تأكيد كلمة المرور الجديدة', 'confirm password'],
      'controller': confirmnewpasswordcontroller,
      'v': true,
      'error': null
    }
  ];
  static List langs = [
    ['Ar', 'عربي'],
    ['En', 'English']
  ];
  static String selectedLang =
      (SharedPreMz.getlang() == 'Ar' ? 'عربي' : 'English') ?? 'عربي';

  static List maincardslist = [
    {
      'index': 0,
      'label': ['المكاتب', 'Offices'],
      'icon': Icons.work,
      'visible': DB.userinfotable[0]['users_privileges'][0]['admin'] == '1'
          ? true
          : false,
      'action': () => Get.toNamed('/home/offices'),
      'color': Colors.transparent,
      'iconsize': 40.0
    },
    {
      'index': 1,
      'label': ['الحسابات', 'Accounts'],
      'icon': Icons.person_2,
      'visible': DB.userinfotable[0]['users_privileges'][0]['admin'] == '1'
          ? true
          : false,
      'action': () => Get.toNamed('/home/accounts'),
      'color': Colors.transparent,
      'iconsize': 40.0
    },
    {
      'index': 2,
      'label': ['النفقات', 'Costs'],
      'icon': Icons.money_rounded,
      'visible': DB.userinfotable[0]['users_privileges'][0]['admin'] == '1'
          ? true
          : false,
      'action': () => Get.toNamed('/home/costs'),
      'color': Colors.transparent,
      'iconsize': 40.0
    },
  ];
  @override
  Widget build(BuildContext context) {
    List actionappbar(e) => [() => themeController.changemode()];
    maincard({e}) {
      return GetBuilder<MainController>(
        init: mainController,
        builder: (_) => GestureDetector(
          onTap: e['action'],
          child: MouseRegion(
            onHover: (x) => mainController.onhover(
                list: maincardslist, index: e['index'], iconsize: 1, color: 1),
            onExit: (x) => mainController.onexit(
                list: maincardslist, index: e['index'], iconsize: 1, color: 1),
            cursor: SystemMouseCursors.click,
            child: Stack(
              children: [
                Card(
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: BasicInfo.selectedlang == 'Ar'
                              ? Radius.elliptical(500, 500)
                              : Radius.circular(0),
                          bottomRight: BasicInfo.selectedlang == 'En'
                              ? Radius.elliptical(500, 500)
                              : Radius.circular(0),
                        ),
                        gradient: LinearGradient(
                            colors: BasicInfo.selectedmode == 'Light'
                                ? BasicInfo.selectedlang == 'Ar'
                                    ? [e['color'], Colors.transparent]
                                    : [
                                        Colors.transparent,
                                        e['color'],
                                      ]
                                : BasicInfo.selectedlang == 'En'
                                    ? [
                                        Colors.transparent,
                                        e['color'],
                                      ]
                                    : [e['color'], Colors.transparent])),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    e['icon'],
                    size: e['iconsize'],
                    color: ThemeMz.iconbuttonmzbc(),
                    shadows: [
                      BoxShadow(
                          spreadRadius: 0.6,
                          blurRadius: 0.9,
                          offset: const Offset(1, 2),
                          color: Colors.black)
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: BasicInfo.selectedlang == 'Ar' ? 0 : null,
                  right: BasicInfo.selectedlang == 'Ar' ? null : 0,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      e['label'][BasicInfo.indexlang()],
                      textAlign: TextAlign.end,
                      style: ThemeMz.titlelargCairo(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    basicinfo() {
      fullnamecontroller.text = DB.userinfotable[0]['users'][0]['fullname'];
      mobilecontroller.text = DB.userinfotable[0]['users'][0]['mobile'] ?? '';
      emailcontroller.text = DB.userinfotable[0]['users'][0]['email'] ?? '';

      return Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "#_ ${DB.userinfotable[0]['users'][0]['user_id']} ${DB.userinfotable[0]['users'][0]['username']}",
                      style:
                          const TextStyle(fontFamily: 'Changa', fontSize: 20),
                    ),
                  ),
                ),
              ],
            ),
            ...dialogbodieslist[0].map((tf) => TextFieldMz(
                  td: tf['td'] ?? TextDirection.ltr,
                  onchange: (x) => null,
                  label: tf['label'],
                  controller: tf['controller'],
                ))
          ],
        ),
      );
    }

    privileges() {
      List privilegesm = [];
      Map words = {
        'admin': ['مسؤول', 'Admin'],
        'enable': ['الحساب فعال', 'Account is Enable'],
        'disable': ['الحساب معطل', 'Account is Disabled'],
        'mustchpass': ['يجب تغيير كلمة المرور', 'Password should be changed'],
        'pbx': ['وصول لتسجيلات المقسم', 'access to PBX records']
      };
      DB.userinfotable[0]['users_privileges'][0]['admin'] == '1'
          ? privilegesm.add(words['admin'][BasicInfo.indexlang()])
          : null;
      DB.userinfotable[0]['users_privileges'][0]['enable'] == '1'
          ? privilegesm.add(words['enable'][BasicInfo.indexlang()])
          : privilegesm.add(words['disable'][BasicInfo.indexlang()]);
      DB.userinfotable[0]['users_privileges'][0]['mustchgpass'] == '1'
          ? privilegesm.add(words['mustchgpass'][BasicInfo.indexlang()])
          : null;
      DB.userinfotable[0]['users_privileges'][0]['pbx'] == '1'
          ? privilegesm.add(words['pbx'][BasicInfo.indexlang()])
          : null;

      return Card(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...privilegesm.map((e) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("_ $e",
                    style: const TextStyle(fontFamily: 'Changa', fontSize: 15)),
              ))
        ],
      ));
    }

    privilegesatoofice() {
      List privilegeso = [];
      Map words = {
        'supervisor': ['مشرف', 'supervisor'],
        'employee': ['موظف', 'employee'],
        'addtask': ['إضافة مهمات', 'Add Tasks'],
        'showalltasks': [
          'مشاهدة جميع المهمات ضمن المكتب',
          'show all Tasks in office'
        ],
        'addtodo': ['إضافة إجرائية', 'Add Tdods'],
        'showalltodos': [
          'مشاهدة جميع الإجرائيات ضمن المكتب',
          'show all Todos in office'
        ],
        'addremind': ['إضافة تذكير', 'Add Reminds'],
        'showallreminds': [
          'مشاهدة جميع  التذكيرات ضمن المكتب',
          'show all Reminds in office'
        ],
        'addcost': ['إضافة طلب نفقات', 'Add cost request'],
        'acceptcosts': ['موافقة على طلبات النفقات', 'accept costs requests'],
        'showallcosts': [
          'مشاهدة جميع النفقات ضمن المكتب',
          'show all costs in office'
        ],
        'addping': ['إضافة بينغ', 'Add Ping'],
        'showallpings': [
          'مشاهدة جميع طلبات البينغ ضمن المكتب',
          'show all Pings in office'
        ],
        'addemailtest': ['إضافة تفحص إيميل', 'Add Email test'],
        'showallemailtests': [
          'مشاهدة جميع طلبات تفحص الايميل ضمن المكتب',
          'show all email tests in office'
        ],
        'addhyperlink': ['إضافة رابط خارجي', 'Add Hyper Link'],
        'showallhyperlinks': [
          'مشاهدة جميع الروابط الخارجية ضمن المكتب',
          'show all Hyper Links in office'
        ],
      };
      privilegeso.clear();
      for (var i in DB.userinfotable[0]['users_priv_office']) {
        privilegeso.add([]);
        privilegeso[DB.userinfotable[0]['users_priv_office'].indexOf(i)].add(
            DB.allofficeinfotable[0]['offices'][DB.allofficeinfotable[0]
                        ['offices']
                    .indexWhere((o) => o['office_id'] == i['upo_office_id'])]
                ['officename']);
        i['position'] == 'supervisor'
            ? privilegeso[DB.userinfotable[0]['users_priv_office'].indexOf(i)]
                .add(words['supervisor'][BasicInfo.indexlang()])
            : privilegeso[DB.userinfotable[0]['users_priv_office'].indexOf(i)]
                .add(words['employee'][BasicInfo.indexlang()]);
        i['addtask'] == '1'
            ? privilegeso[DB.userinfotable[0]['users_priv_office'].indexOf(i)]
                .add(words['addtask'][BasicInfo.indexlang()])
            : null;
        i['showalltasks'] == '1'
            ? privilegeso[DB.userinfotable[0]['users_priv_office'].indexOf(i)]
                .add(words['showalltasks'][BasicInfo.indexlang()])
            : null;
        i['addtodo'] == '1'
            ? privilegeso[DB.userinfotable[0]['users_priv_office'].indexOf(i)]
                .add(words['addtodo'][BasicInfo.indexlang()])
            : null;
        i['showalltodos'] == '1'
            ? privilegeso[DB.userinfotable[0]['users_priv_office'].indexOf(i)]
                .add(words['showalltodos'][BasicInfo.indexlang()])
            : null;
        i['addremind'] == '1'
            ? privilegeso[DB.userinfotable[0]['users_priv_office'].indexOf(i)]
                .add(words['addremind'][BasicInfo.indexlang()])
            : null;
        i['showallreminds'] == '1'
            ? privilegeso[DB.userinfotable[0]['users_priv_office'].indexOf(i)]
                .add(words['showallreminds'][BasicInfo.indexlang()])
            : null;
        i['addcost'] == '1'
            ? privilegeso[DB.userinfotable[0]['users_priv_office'].indexOf(i)]
                .add(words['addcost'][BasicInfo.indexlang()])
            : null;
        i['acceptcosts'] == '1'
            ? privilegeso[DB.userinfotable[0]['users_priv_office'].indexOf(i)]
                .add(words['acceptcosts'][BasicInfo.indexlang()])
            : null;
        i['showallcosts'] == '1'
            ? privilegeso[DB.userinfotable[0]['users_priv_office'].indexOf(i)]
                .add(words['showallcosts'][BasicInfo.indexlang()])
            : null;
        i['addping'] == '1'
            ? privilegeso[DB.userinfotable[0]['users_priv_office'].indexOf(i)]
                .add(words['addping'][BasicInfo.indexlang()])
            : null;
        i['showallpings'] == '1'
            ? privilegeso[DB.userinfotable[0]['users_priv_office'].indexOf(i)]
                .add(words['showallpings'][BasicInfo.indexlang()])
            : null;
        i['addemailtest'] == '1'
            ? privilegeso[DB.userinfotable[0]['users_priv_office'].indexOf(i)]
                .add(words['addemailtest'][BasicInfo.indexlang()])
            : null;
        i['showallemailtests'] == '1'
            ? privilegeso[DB.userinfotable[0]['users_priv_office'].indexOf(i)]
                .add(words['showallemailtests'][BasicInfo.indexlang()])
            : null;
        i['addhyperlink'] == '1'
            ? privilegeso[DB.userinfotable[0]['users_priv_office'].indexOf(i)]
                .add(words['addhyperlink'][BasicInfo.indexlang()])
            : null;
        i['showallhyperlinks'] == '1'
            ? privilegeso[DB.userinfotable[0]['users_priv_office'].indexOf(i)]
                .add(words['showallhyperlinks'][BasicInfo.indexlang()])
            : null;
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...privilegeso.map((i) => SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Card(
                  elevation: 6,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...i.map(
                          (ii) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("_ $ii",
                                style: const TextStyle(
                                    fontFamily: 'Changa', fontSize: 15)),
                          ),
                        )
                      ]),
                ),
              ))
        ],
      );
    }

    List dialogactionfun(e) => [
          (e) => mainController.updatepesonalinfo(
              fullname: fullnamecontroller.text,
              mobile: mobilecontroller.text,
              email: emailcontroller.text),
          (e) => Get.back()
        ];
    dialogaction() {
      return dialogactionlist
          .where((element) => element['visible'] == true)
          .map((e) {
        switch (e['type']) {
          case 'wait':
            return SizedBox(
                width: 100, child: WaitMz.waitmz0([1, 2, 3, 4], context));
          case 'do-it':
            return IconbuttonMz(
                backcolor: ThemeMz.iconbuttonmzbc(),
                width: 75,
                height: 50,
                buttonlist: dialogactionlist,
                elevate: e['elevate'],
                label: e['label'],
                index: e['index'],
                e: e,
                action: dialogactionfun(e)[dialogactionlist.indexOf(e)]);
          default:
            return const SizedBox();
        }
      });
    }

    List draweritemslist({ctx, e}) => [
          () => showDialog(
              context: ctx,
              builder: (_) {
                return alertchangpass(ctx: ctx, e: e);
              }),
          () => showDialog(
              context: ctx,
              builder: (_) {
                Lang.mainerrormsg = null;
                return DialogMz01(
                  title: draweractionlist[1]['name'],
                  mainlabels: dialogmainlabellist,
                  bodies: [basicinfo(), privileges(), privilegesatoofice()],
                  actionlist: GetBuilder<MainController>(
                      init: mainController,
                      builder: (_) => Row(children: [...dialogaction()])),
                );
              }),
          () => mainController.logout()
        ];
    drawerwidget() {
      return SizedBox(
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Column(
              children: [
                ...draweractionlist.map((y) => GetBuilder<MainController>(
                      init: mainController,
                      builder: (_) => GestureDetector(
                        onTap: draweritemslist(
                            e: y, ctx: context)[draweractionlist.indexOf(y)],
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: Card(
                            elevation: 6,
                            shape: BasicInfo.selectedlang == 'Ar'
                                ? const BeveledRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(25)))
                                : const BeveledRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(25))),
                            child: Row(
                              children: [
                                Icon(
                                  y['icon'],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    y['name'][BasicInfo.indexlang()],
                                    style: ThemeMz.titlemediumCairo(),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ))
              ],
            ),
          ),
        ),
      );
    }

    appbaractionwidget() {
      return GetBuilder<ThemeController>(
        init: themeController,
        builder: (_) => Row(
          children: [
            ...appbaractionlist.map((e) => IconButton(
                onPressed: actionappbar(e)[appbaractionlist.indexOf(e)],
                icon: Icon(e['icon'])))
          ],
        ),
      );
    }

    if (BasicInfo.LogInInfo != null) {
      return GetBuilder<ThemeController>(
          init: themeController,
          builder: (_) => Directionality(
              textDirection: BasicInfo.lang(),
              child: SafeArea(
                  child: Scaffold(
                      appBar: AppBar(
                        title: Directionality(
                          textDirection: TextDirection.ltr,
                          child: Text(
                            "  <all>Ne ",
                            textAlign: TextAlign.right,
                            style: ThemeMz.titlelargChanga(),
                          ),
                        ),
                        centerTitle: true,
                        actions: [appbaractionwidget()],
                      ),
                      drawer: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Drawer(
                          shape: ContinuousRectangleBorder(
                              borderRadius: BorderRadius.circular(35)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(child: drawerwidget()),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GetBuilder<ThemeController>(
                                  init: themeController,
                                  builder: (_) => Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          [
                                            'اختيار اللغة',
                                            'selected language'
                                          ][BasicInfo.indexlang()],
                                          style: const TextStyle(
                                              fontFamily: 'Cairo'),
                                        ),
                                      ),
                                      DropdownButton(
                                          value: selectedLang,
                                          items: langs
                                              .map((e) => DropdownMenuItem(
                                                  value: e[1],
                                                  child: Text("${e[1]}")))
                                              .toList(),
                                          onChanged: (x) =>
                                              themeController.changelang(x)),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      body: GridView(
                          gridDelegate:
                              SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 300, mainAxisExtent: 150),
                          children: [
                            ...maincardslist
                                .where((element) => element['visible'] == true)
                                .map((e) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: maincard(e: e),
                              );
                            })
                          ])))));
    } else {
      Future(() => Get.offAllNamed('/'));
      return const SizedBox();
    }
  }
}

alertchangpass({ctx, e}) {
  for (var i in HomePage.changepassword) {
    i['controller'].text = '';
    i['error'] = null;
    i['v'] = true;
  }
  HomePage.passwordvis = Icons.visibility;
  Lang.mainerrormsg = null;
  List passwordchangeactionlist = [
    {
      'index': 0,
      'type': 'do-it',
      'label': ['حفظ', 'save'],
      'visible': !HomePage.waitchangepass,
      'elevate': 0.0
    },
    {
      'index': 1,
      'type': 'do-it',
      'label': ['رجوع', 'close'],
      'visible': !HomePage.waitchangepass,
      'elevate': 0.0
    },
    {'index': 2, 'type': 'wait', 'visible': HomePage.waitchangepass}
  ];
  List passwordchangeactionfun(e) => [
        (e) => mainController.changepasswordpersonal(
              oldpassword: HomePage.passwordcontroller.text,
              newpass: HomePage.newpasswordcontroller.text,
              newpassconfirm: HomePage.confirmnewpasswordcontroller.text,
            ),
        (e) => Get.back(),
      ];
  passwordchangeaction({ctx}) {
    return passwordchangeactionlist
        .where((element) => element['visible'] == true)
        .map((y) {
      switch (y['type']) {
        case 'wait':
          return SizedBox(width: 100, child: WaitMz.waitmz0([1, 2, 3, 4], ctx));
        case 'do-it':
          return IconbuttonMz(
              backcolor: ThemeMz.iconbuttonmzbc(),
              width: 75,
              height: 50,
              buttonlist: passwordchangeactionlist,
              elevate: y['elevate'],
              label: y['label'],
              e: y,
              index: y['index'],
              action: passwordchangeactionfun(
                  y)[passwordchangeactionlist.indexOf(y)]);
        default:
          return const SizedBox();
      }
    });
  }

  return GetBuilder<MainController>(
    init: mainController,
    builder: (_) => Directionality(
      textDirection: BasicInfo.lang(),
      child: AlertDialog(
        scrollable: true,
        title: Text(
          ['تغيير كلمة المرور', 'Change PassWord'][BasicInfo.indexlang()],
          style: ThemeMz.titlemediumCairo(),
        ),
        content: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                    onPressed: () =>
                        mainController.showhidepasswordchangepass(),
                    icon: Icon(HomePage.passwordvis))
              ],
            ),
            ...HomePage.changepassword.map((p) => TextFieldMz(
                  td: e['td'] ?? TextDirection.ltr,
                  onchange: (x) => null,
                  label: p['label'],
                  controller: p['controller'],
                  obscureText: p['v'],
                  error: p['error'],
                )),
            Visibility(
              visible: Lang.mainerrormsg == null ? false : true,
              child: Text("${Lang.mainerrormsg}"),
            )
          ],
        ),
        actions: [...passwordchangeaction(ctx: ctx)],
      ),
    ),
  );
}
