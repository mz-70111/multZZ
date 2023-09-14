// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mz_flutter_07/controllers/dbcontroller.dart';
import 'package:mz_flutter_07/controllers/maincontroller.dart';
import 'package:mz_flutter_07/models/basicinfo.dart';
import 'package:mz_flutter_07/models/bottonicon.dart';
import 'package:mz_flutter_07/models/database.dart';
import 'package:mz_flutter_07/models/dialog01.dart';
import 'package:mz_flutter_07/models/textfeild.dart';
import 'package:mz_flutter_07/views/homepage.dart';
import 'package:mz_flutter_07/views/login.dart';
import 'package:mz_flutter_07/views/wait.dart';
import 'package:intl/intl.dart' as df;

class PageTamplate01 extends StatelessWidget {
  const PageTamplate01(
      {super.key,
      required this.appbartitle,
      required this.addtitle,
      required this.mainlebelsdialogmz,
      required this.actionlist,
      required this.bodiesofadd,
      this.elevationcard = 0.0,
      this.page,
      this.futurefun,
      required this.table,
      required this.tablename,
      required this.preparefunction,
      required this.preparefunctionfuture,
      required this.mainItems,
      required this.searchrangelist,
      this.searchwithdatevisible = false,
      required this.startdate,
      required this.enddate,
      required this.setstartdate,
      required this.setenddate,
      required this.openitem,
      required this.easyeditlist,
      required this.easyeditaction,
      required this.ini,
      required this.floateactionbutton,
      required this.prefixotherMainItems,
      required this.suffixotherMainItems,
      required this.mainrowcolor});
  final List<String> appbartitle, addtitle, searchrangelist;
  final List<Map> mainlebelsdialogmz;
  final List<Widget> bodiesofadd, actionlist;

  final String? page;
  final double elevationcard;
  final futurefun;
  final List table, easyeditlist;
  final String tablename;
  final Function preparefunction,
      easyeditaction,
      openitem,
      preparefunctionfuture,
      setstartdate,
      setenddate,
      prefixotherMainItems,
      suffixotherMainItems,
      ini;
  final List mainItems;
  final bool searchwithdatevisible;
  final DateTime startdate;
  final DateTime enddate;
  final List<Map> floateactionbutton;
  final Function mainrowcolor;
  @override
  Widget build(BuildContext context) {
    if (BasicInfo.LogInInfo != null) {
      ini();
      return FutureBuilder(
          future: futurefun,
          builder: (_, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return const WaitMz();
            } else if (snap.hasData) {
              return SafeArea(
                  child: Directionality(
                textDirection: BasicInfo.lang(),
                child: Scaffold(
                  appBar: AppBar(
                    centerTitle: true,
                    title: Text(
                      appbartitle[BasicInfo.indexlang()],
                      style: const TextStyle(fontFamily: 'Cairo'),
                    ),
                  ),
                  body: GetBuilder<MainController>(
                    init: mainController,
                    builder: (_) => SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextFieldMz(
                              label: ['بحث', 'search'],
                              onchange: (x) => mainController.search(
                                  range: searchrangelist,
                                  word: x,
                                  list: table[0][tablename]),
                              td: BasicInfo.lang()),
                          Visibility(
                              visible: searchwithdatevisible,
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width < 500
                                    ? MediaQuery.of(context).size.width
                                    : 500,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Row(
                                      children: [
                                        Text([
                                          'من',
                                          'from'
                                        ][BasicInfo.indexlang()]),
                                        TextButton(
                                            onPressed: () => setstartdate(),
                                            child: Text(
                                                df.DateFormat("yyyy-MM-dd")
                                                    .format(startdate)))
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text([
                                          'إلى',
                                          'to'
                                        ][BasicInfo.indexlang()]),
                                        TextButton(
                                            onPressed: () => setenddate(),
                                            child: Text(
                                                df.DateFormat("yyyy-MM-dd")
                                                    .format(enddate)))
                                      ],
                                    )
                                  ],
                                ),
                              )),
                          Expanded(
                            child: SingleChildScrollView(
                                child: Column(
                              children: [
                                ...table[0][tablename]
                                    .where((element) =>
                                        element['visible'] == true &&
                                        element['visiblesearch'] == true)
                                    .map((me) => GestureDetector(
                                          onTap: () => openitem(me),
                                          child: MouseRegion(
                                            cursor: SystemMouseCursors.click,
                                            child: Card(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    gradient:
                                                        LinearGradient(colors: [
                                                  Colors.transparent,
                                                  mainrowcolor(me) == true
                                                      ? Colors.greenAccent
                                                          .withOpacity(0.3)
                                                      : Colors.transparent,
                                                  Colors.transparent
                                                ])),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        mainitems(
                                                            me: me,
                                                            prefixotherMainItems:
                                                                (me) =>
                                                                    prefixotherMainItems(
                                                                        me),
                                                            suffixotherMainItems:
                                                                (me) =>
                                                                    suffixotherMainItems(
                                                                        me)),
                                                        easyeditpanel(
                                                            ctx: context,
                                                            me: me)
                                                      ]),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ))
                              ],
                            )),
                          ),
                          SizedBox(
                            height: AppBar().preferredSize.height,
                          )
                        ],
                      ),
                    ),
                  ),
                  floatingActionButton: GetBuilder<MainController>(
                    init: mainController,
                    builder: (_) => Row(
                      children: [
                        ...floateactionbutton.map((f) => IconbuttonMz(
                            width: 150,
                            height: 50,
                            buttonlist: floateactionbutton,
                            elevate: f['elevate'],
                            e: f,
                            index: f['index'],
                            action: (e) {
                              additemWidget(e: e, ctx: context);
                            },
                            label: addtitle))
                      ],
                    ),
                  ),
                ),
              ));
            } else {
              return Directionality(
                textDirection: BasicInfo.lang(),
                child: Scaffold(
                  appBar: AppBar(),
                  body: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text([
                          'حصل خطأ في الاتصال مع المخدم _أعد المحاولة',
                          'some thing wrong _retry'
                        ][BasicInfo.indexlang()]),
                        IconButton(
                            onPressed: () {
                              dbController.update();
                            },
                            icon: const Icon(Icons.refresh)),
                      ],
                    ),
                  ),
                ),
              );
            }
          });
    } else {
      Future(() => Get.offAllNamed('/'));
      return const SizedBox();
    }
  }

  mainitems({me, prefixotherMainItems, suffixotherMainItems}) {
    return Expanded(
      child: Row(
        children: [
          prefixotherMainItems(me),
          ...mainItems
              .where((element) => element == mainItems.first)
              .map((i) => Text("# ${me[i]} _")),
          ...mainItems
              .where((element) => mainItems.indexOf(element) > 0)
              .map((i) => Expanded(
                      child: Text(
                    me[i],
                    style: TextStyle(fontFamily: 'Changa', fontSize: 18),
                  ))),
          suffixotherMainItems(me)
        ],
      ),
    );
  }

  easyeditpanel({ctx, me}) {
    return Row(
      children: [
        ...easyeditlist[table[0][tablename].indexOf(me)]
            .where((y) => y.runtimeType != String && y['visible'] == true)
            .map((se) {
          switch (se['type']) {
            case 'wait':
              return WaitMz.waitmz0([1, 2, 3, 4], ctx);
            case 'do-it':
              return IconbuttonMz(
                icon: se['icon'],
                labelvisible: se['elevate'] == 0.0 ? false : true,
                elevate: se['elevate'],
                e: me,
                action: easyeditaction(me),
                label: se['label'],
                buttonlist: easyeditlist[table[0][tablename].indexOf(me)],
                index: se['actionindex'],
                height: 35,
                width: se['elevate'] == 0.0 ? 40 : 80,
              );
            default:
              return SizedBox();
          }
        })
      ],
    );
  }

  additemWidget({e, ctx}) {
    return showDialog(
        context: ctx,
        builder: (_) {
          return FutureBuilder(future: Future(() async {
            try {
              return await preparefunctionfuture();
            } catch (e) {
              null;
            }
          }), builder: (_, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return WaitMz.waitmz0([1, 2, 3], ctx);
            } else if (snap.hasData) {
              preparefunction();
              return DialogMz01(
                  title: addtitle,
                  mainlabels: mainlebelsdialogmz,
                  bodies: [...bodiesofadd],
                  actionlist: actionlist);
            } else {
              Future(() => Get.back());
              return const SizedBox();
            }
          });
        });
  }
}
