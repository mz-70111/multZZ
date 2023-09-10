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
      'type': 'do-it',
      'label': ['حفظ', 'save'],
      'visible': true,
      'elevetioncard': 0.0
    },
    {
      'type': 'do-it',
      'label': ['رجوع', 'close'],
      'visible': true,
      'elevetioncard': 0.0
    },
    {'type': 'wait', 'visible': false},
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
  static List lang = ['عربي', 'English'];
  static String selectedLang = SharedPreMz.getlang() == null
      ? 'عربي'
      : SharedPreMz.getlang() == 'Ar'
          ? 'عربي'
          : 'English';

  static List maincardslist = [
    {
      'label': ['المكاتب', 'Offices'],
      'icon': Icons.work,
      'visible': DB.userinfotable[0]['users_privileges'][0]['admin'] == '1'
          ? true
          : false,
      'action': () => Get.toNamed('/home/offices')
    },
    {
      'label': ['الحسابات', 'Accounts'],
      'icon': Icons.person_2,
      'visible': DB.userinfotable[0]['users_privileges'][0]['admin'] == '1'
          ? true
          : false,
      'action': () => Get.toNamed('/home/accounts')
    },
    {
      'label': ['النفقات', 'Costs'],
      'icon': Icons.money_rounded,
      'visible': DB.userinfotable[0]['users_privileges'][0]['admin'] == '1'
          ? true
          : false,
      'action': () => Get.toNamed('/home/costs')
    },
  ];
  @override
  Widget build(BuildContext context) {
    List actionappbar(e) => [() => themeController.changemode()];
    maincard({e}) {
      return GetBuilder<ThemeController>(
        init: themeController,
        builder: (_) => GestureDetector(
          onTap: e['action'],
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Stack(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width < 300 ? 250 : 500,
                ),
                Icon(
                  e['icon'],
                  size: MediaQuery.of(context).size.width < 300 ? 50 : 80,
                  color: BasicInfo.selectedmode == 'Light'
                      ? Colors.indigoAccent.withOpacity(0.6)
                      : Colors.deepPurpleAccent.withOpacity(0.6),
                  shadows: [
                    BoxShadow(
                      spreadRadius: 0.6,
                      blurRadius: 0.9,
                      offset: Offset(1, 2),
                      color: BasicInfo.selectedmode == 'Light'
                          ? Colors.black.withOpacity(0.6)
                          : Colors.white.withOpacity(0.6),
                    )
                  ],
                ),
                Positioned(
                  bottom: 0,
                  left: BasicInfo.lang() == 'Ar' ? null : 0,
                  right: BasicInfo.lang() == 'Ar' ? null : 0,
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.only(bottomLeft: Radius.circular(10)),
                        gradient: LinearGradient(
                            colors: BasicInfo.selectedmode == 'Light'
                                ? BasicInfo.selectedlang == 'Ar'
                                    ? [
                                        Colors.blueGrey.withOpacity(0.5),
                                        Colors.transparent
                                      ]
                                    : [
                                        Colors.transparent,
                                        Colors.blueGrey.withOpacity(0.5),
                                      ]
                                : BasicInfo.selectedlang == 'En'
                                    ? [
                                        Colors.transparent,
                                        Colors.grey.withOpacity(0.5),
                                      ]
                                    : [
                                        Colors.grey.withOpacity(0.5),
                                        Colors.transparent
                                      ])),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        e['label'][BasicInfo.indexlang()],
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 20,
                        ),
                      ),
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
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "#_ ${DB.userinfotable[0]['users'][0]['user_id']} ${DB.userinfotable[0]['users'][0]['username']}",
                      style: TextStyle(fontFamily: 'Changa', fontSize: 20),
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
                    style: TextStyle(fontFamily: 'Changa', fontSize: 15)),
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
                  shadowColor: Colors.deepOrange,
                  elevation: 6,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...i.map(
                          (ii) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("_ $ii",
                                style: TextStyle(
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
            return SizedBox(
              width: 75,
              child: IconbuttonMz(
                  elevetioncard: dialogactionlist[dialogactionlist.indexOf(e)]
                      ['elevetioncard'],
                  listbutton: dialogactionlist,
                  indexbutton: dialogactionlist.indexOf(e),
                  label: e['label'],
                  e: e,
                  action: dialogactionfun(e)[dialogactionlist.indexOf(e)]),
            );
          default:
            return SizedBox();
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
                return FutureBuilder(future: Future(() async {
                  try {
                    DB.allofficeinfotable =
                        await DBController().getallofficeinfo();
                    return DB.userinfotable = await DBController()
                        .getuserinfo(userid: BasicInfo.LogInInfo![0]);
                  } catch (e) {}
                }), builder: (_, snap) {
                  if (snap.connectionState == ConnectionState.waiting) {
                    return WaitMz.waitmz0([1, 2, 3, 4, 5], context);
                  } else if (snap.hasData) {
                    return GetBuilder<MainController>(
                      init: mainController,
                      builder: (_) => DialogMz01(
                        title: draweractionlist[0]['name'],
                        mainlabels: dialogmainlabellist,
                        bodies: [
                          basicinfo(),
                          privileges(),
                          privilegesatoofice()
                        ],
                        actionlist: [...dialogaction()],
                      ),
                    );
                  } else {
                    Future(() => Get.back());
                    return SizedBox();
                  }
                });
              }),
          () => mainController.logout()
        ];
    drawerwidget() {
      return SizedBox(
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
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
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Icon(
                                  y['icon'],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    y['name'][BasicInfo.indexlang()],
                                    style: TextStyle(
                                      fontFamily: 'Cairo',
                                      fontSize: 17,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ))
            ],
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
                        title: Text(
                          "MultiTool _Z",
                          style: TextStyle(fontFamily: 'Cairo'),
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
                                          style: TextStyle(fontFamily: 'Cairo'),
                                        ),
                                      ),
                                      DropdownButton(
                                          value: selectedLang,
                                          items: lang
                                              .map((e) => DropdownMenuItem(
                                                  value: e, child: Text("$e")))
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
                      body: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                                child: SingleChildScrollView(
                              child: Stack(
                                alignment: AlignmentDirectional.topCenter,
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    height:
                                        MediaQuery.of(context).size.width < 300
                                            ? maincardslist.length * 60.0
                                            : maincardslist.length * 110.0,
                                  ),
                                  ...maincardslist
                                      .where((element) =>
                                          element['visible'] == true)
                                      .map((e) {
                                    return TweenMz.translateYM(
                                        ctx: context,
                                        duration:
                                            maincardslist.indexOf(e) * 300,
                                        begin: 0.0,
                                        end: MediaQuery.of(context).size.width <
                                                300
                                            ? maincardslist.indexOf(e) * 60.0
                                            : maincardslist.indexOf(e) * 110.0,
                                        child: maincard(e: e));
                                  })
                                ],
                              ),
                            ))
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
  BasicInfo.error = null;
  List passwordchangeactionlist = [
    {
      'type': 'do-it',
      'label': ['حفظ', 'save'],
      'visible': !HomePage.waitchangepass,
      'elevetioncard': 0.0
    },
    {
      'type': 'do-it',
      'label': ['رجوع', 'close'],
      'visible': !HomePage.waitchangepass,
      'elevetioncard': 0.0
    },
    {'type': 'wait', 'visible': HomePage.waitchangepass}
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
          return SizedBox(
            width: 75,
            child: IconbuttonMz(
                elevetioncard: passwordchangeactionlist[
                    passwordchangeactionlist.indexOf(y)]['elevetioncard'],
                listbutton: passwordchangeactionlist,
                indexbutton: passwordchangeactionlist.indexOf(y),
                label: y['label'],
                e: y,
                action: passwordchangeactionfun(
                    y)[passwordchangeactionlist.indexOf(y)]),
          );
        default:
          return SizedBox();
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
          style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 17,
              decoration: TextDecoration.underline,
              decorationStyle: TextDecorationStyle.dotted),
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
              visible: BasicInfo.error == null ? false : true,
              child: Text("${BasicInfo.error}"),
            )
          ],
        ),
        actions: [...passwordchangeaction(ctx: ctx)],
      ),
    ),
  );
}
