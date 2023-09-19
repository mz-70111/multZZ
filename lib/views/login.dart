import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mz_flutter_07/controllers/dbcontroller.dart';
import 'package:mz_flutter_07/controllers/maincontroller.dart';
import 'package:mz_flutter_07/models/basicinfo.dart';
import 'package:mz_flutter_07/models/bottonicon.dart';
import 'package:mz_flutter_07/models/lang_mode_theme.dart';
import 'package:mz_flutter_07/models/textfeild.dart';
import 'package:mz_flutter_07/views/homepage.dart';
import 'package:mz_flutter_07/views/wait.dart';

MainController mainController = Get.find();
DBController dbController = Get.find();

class LogIn extends StatelessWidget {
  const LogIn({super.key});
  static TextEditingController usernamecontroller = TextEditingController();
  static TextEditingController passwordcontroller = TextEditingController();
  static TextEditingController newpasswordcontroller = TextEditingController();
  static TextEditingController confirmnewpasswordcontroller =
      TextEditingController();
  static List textfieldloginlist = [
    {
      'label': ['اسم المستخدم', 'username'],
      'controller': usernamecontroller,
      'readonly': false,
      'textdirection': BasicInfo.lang(),
      'error': null,
      'icon': Icons.person,
      'visible': true,
    },
    {
      'label': ['كلمة المرور', 'password'],
      'controller': passwordcontroller,
      'readonly': false,
      'textdirection': BasicInfo.lang(),
      'error': null,
      'icon': Icons.visibility,
      'obscuretext': true,
      'action': () => mainController.showhidepasswordLogIn(index: 1),
      'visible': true,
    },
    {
      'label': ['كلمة المرور الجديدة', 'new password'],
      'controller': newpasswordcontroller,
      'readonly': false,
      'textdirection': BasicInfo.lang(),
      'error': null,
      'icon': Icons.visibility,
      'obscuretext': true,
      'action': () => mainController.showhidepasswordLogIn(index: 2),
      'visible': false,
    },
    {
      'label': ['تأكيد', 'confirm'],
      'controller': confirmnewpasswordcontroller,
      'readonly': false,
      'textdirection': BasicInfo.lang(),
      'error': null,
      'icon': Icons.visibility,
      'obscuretext': true,
      'action': () => mainController.showhidepasswordLogIn(index: 3),
      'visible': false,
    }
  ];
  static List loginactionlist = [
    {
      'type': 'action',
      'visible': true,
      'name': ['دخول', 'login'],
      'index': 0,
      'elevateindex': 0,
      'elevate': 0.0,
      'action': [
        (x) => mainController.checklogin(),
        (x) => mainController.mustchgpass()
      ]
    },
    {
      'visible': false,
      'type': 'wait',
    },
    {
      'type': 'action',
      'visible': false,
      'name': ['دخول بحساب مختلف', 'login with other account'],
      'elevateindex': 1,
      'elevate': 0.0,
      'index': 0,
      'action': [
        (x) => mainController.logout(),
      ]
    },
  ];

  static bool changepassvis = false;
  @override
  Widget build(BuildContext context) {
    MainController mainController = Get.find();

    textfieldlogin() {
      return Column(
        children: [
          ...textfieldloginlist
              .where((element) => element['visible'] == true)
              .map((e) {
            return TextFieldMz(
              td: e['td'] ?? TextDirection.ltr,
              readOnly: e['readonly'],
              obscureText: e['obscuretext'] ?? false,
              controller: e['controller'],
              error: e['error'],
              icon: e['icon'],
              action: e['action'],
              onchange: (x) => null,
              label: e['label'],
            );
          }),
        ],
      );
    }

    loginaction() {
      return GetBuilder<MainController>(
        init: mainController,
        builder: (_) {
          return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            ...loginactionlist
                .where((element) => element['visible'] == true)
                .map((e) {
              switch (e['type']) {
                case 'action':
                  return IconbuttonMz(
                      backcolor: ThemeMz.iconbuttonmzbc(),
                      e: e,
                      action: e['action'][e['index']],
                      label: e['name'],
                      buttonlist: loginactionlist,
                      index: e['elevateindex'],
                      elevate: e['elevate'],
                      height: 50,
                      width: e['elevateindex'] == 0 ? 100 : 200);

                case 'wait':
                  return WaitMz.waitmz0([1, 2, 3, 4, 5, 6, 7], context);
                default:
                  return const SizedBox();
              }
            })
          ]);
        },
      );
    }

    return FutureBuilder(
      future: Future(() async {
        Lang.mainerrormsg = null;
        if (BasicInfo.LogInInfo != null) {
          await mainController.checklogin(
              username: BasicInfo.LogInInfo![1],
              password: BasicInfo.LogInInfo![2]);
        }
      }),
      builder: (_, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const WaitMz();
        }
        if (BasicInfo.LogInInfo == null) {
          return SafeArea(
              child: Directionality(
                  textDirection: BasicInfo.lang(),
                  child: Scaffold(
                      body: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                        const Expanded(child: SizedBox()),
                        Expanded(
                          flex: 3,
                          child: SingleChildScrollView(
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width < 500
                                  ? MediaQuery.of(context).size.width
                                  : 500,
                              child: GetBuilder<MainController>(
                                init: mainController,
                                builder: (_) => Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                                Lang.titles['login']
                                                    [BasicInfo.indexlang()],
                                                style:
                                                    ThemeMz.titlelargCairo()),
                                          ],
                                        ),
                                        textfieldlogin(),
                                        GetBuilder<MainController>(
                                            init: mainController,
                                            builder: (_) => loginaction()),
                                        Visibility(
                                            visible: Lang.mainerrormsg != null,
                                            child:
                                                Text("${Lang.mainerrormsg}")),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const Divider(),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Directionality(
                              textDirection: TextDirection.ltr,
                              child: Text(
                                " by:  مـ عـ ا ذ",
                                style: TextStyle(
                                    fontFamily: 'Vibes',
                                    fontWeight: FontWeight.w900,
                                    wordSpacing: 2,
                                    fontSize: 20),
                              ),
                            ),
                          ],
                        )
                      ]))));
        } else {
          return const HomePage();
        }
      },
    );
  }
}
