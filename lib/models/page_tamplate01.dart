// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mz_flutter_07/controllers/maincontroller.dart';
import 'package:mz_flutter_07/models/basicinfo.dart';
import 'package:mz_flutter_07/models/bottonicon.dart';
import 'package:mz_flutter_07/models/database.dart';
import 'package:mz_flutter_07/models/dialog01.dart';
import 'package:mz_flutter_07/models/lang_mode_theme.dart';
import 'package:mz_flutter_07/models/textfeild.dart';
import 'package:mz_flutter_07/views/login.dart';
import 'package:mz_flutter_07/views/wait.dart';
import 'package:intl/intl.dart' as df;

class PageTamplate01 extends StatelessWidget {
  const PageTamplate01(
      {super.key,
      this.officenameclmname,
      required this.appbartitle, //page title
      required this.mainItem,
      required this.addtitle, //add action title  n
      required this.maintitlesdialogMz01, //main titles for pages of dialogMz01 _List of maps contain selected to choose n
      required this.listofactionbuttonforadd, //button for add functions
      required this.lisofpagesforadd,
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
      required this.mainrowcolor,
      this.chooseofficevisible = false,
      required this.listoffunctionforadd});
  final List<String> appbartitle;
  final Function mainItem;
  final String? officenameclmname;
  final List<String> addtitle, searchrangelist;
  final List<Map> listofactionbuttonforadd, maintitlesdialogMz01;
  final Function listoffunctionforadd;
  final List<Widget> lisofpagesforadd;
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
  final bool searchwithdatevisible, chooseofficevisible;
  final DateTime startdate;
  final DateTime enddate;
  final List<Map> floateactionbutton;
  final Function mainrowcolor;
  @override
  Widget build(BuildContext context) {
    List officeslist = [];
    officeslist.clear();
    for (var i in DB.allofficeinfotable[0]['offices']) {
      if (DB.allofficeinfotable[0]['offices'].isNotEmpty) {
        for (var j in DB.userinfotable[0]['users_priv_office']) {
          if (j.isNotEmpty && j['upo_office_id'] == i['office_id']) {
            officeslist.add(i['officename']);
          }
        }
      }
    }

    if (BasicInfo.LogInInfo != null) {
      ini();
      return SafeArea(
          child: Directionality(
        textDirection: BasicInfo.lang(),
        child: GetBuilder<MainController>(
          init: mainController,
          builder: (_) => Scaffold(
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
                        label: const ['بحث', 'search'],
                        onchange: (x) => mainController.search(
                            range: searchrangelist,
                            word: x,
                            list: table[0][tablename]),
                        td: BasicInfo.lang()),
                    officeslist.length > 1
                        ? Visibility(
                            visible: chooseofficevisible,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Text([
                                    '  اختيار المكتب',
                                    'Choose Office  '
                                  ][BasicInfo.indexlang()]),
                                  DropdownButton(
                                      value: officeslist[0],
                                      items: officeslist
                                          .map((ol) => DropdownMenuItem(
                                              value: ol, child: Text(ol)))
                                          .toList(),
                                      onChanged: (x) {
                                        mainController.chooseoffice(
                                            x: x,
                                            officeslist: officeslist,
                                            officenameclmname:
                                                officenameclmname,
                                            list: table[0][tablename]);
                                      }),
                                ],
                              ),
                            ))
                        : SizedBox(),
                    Visibility(
                      visible: true,
                      child: SizedBox(
                          width: MediaQuery.of(context).size.width < 500
                              ? MediaQuery.of(context).size.width
                              : 500,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Row(
                                  children: [
                                    Text(['من', 'from'][BasicInfo.indexlang()]),
                                    TextButton(
                                      onPressed: () => setstartdate(),
                                      child: Text(df.DateFormat("yyyy-MM-dd")
                                          .format(startdate)),
                                      style: Theme.of(context)
                                          .textButtonTheme
                                          .style,
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
                              ])),
                    ),
                    GetBuilder<MainController>(
                      init: mainController,
                      builder: (_) => Expanded(
                        child: SingleChildScrollView(
                            child: Column(
                          children: [
                            ...table[0][tablename]
                                .where((element) =>
                                    element['visible'] == true &&
                                    element['visiblesearch'] == true)
                                .map((me) => mainItem(me))
                          ],
                        )),
                      ),
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
                      backcolor: ThemeMz.iconbuttonmzbc(),
                      width: 150,
                      height: 50,
                      buttonlist: floateactionbutton,
                      elevate: f['elevate'],
                      e: f,
                      index: f['index'],
                      action: (e) => adddialogasWidget(ctx: context),
                      label: addtitle))
                ],
              ),
            ),
          ),
        ),
      ));
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
                backcolor: se['backcolor'],
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

  GetBuilder<MainController> addactionaswidget({ctx}) {
    return GetBuilder<MainController>(
      init: mainController,
      builder: (_) => Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        ...listofactionbuttonforadd
            .where((element) => element['visible'] == true)
            .map((u) {
          switch (u['type']) {
            case 'do-it':
              return IconbuttonMz(
                  backcolor: ThemeMz.iconbuttonmzbc(),
                  height: 40,
                  width: 75,
                  index: u['index'],
                  buttonlist: listofactionbuttonforadd,
                  elevate: u['elevate'],
                  e: u,
                  action: listoffunctionforadd(
                      u)[listofactionbuttonforadd.indexOf(u)],
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

  adddialogasWidget({ctx}) {
    Lang.mainerrormsg = null;
    return showDialog(
        context: ctx,
        builder: (_) {
          preparefunction();
          return DialogMz01(
              title: addtitle,
              mainlabels: maintitlesdialogMz01,
              bodies: [...lisofpagesforadd],
              actionlist: addactionaswidget(ctx: ctx));
        });
  }
}
