// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mz_flutter_07/controllers/dbcontroller.dart';
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
      required this.appbartitle, //app bar title
      this.searchwithdatevisible = false,
      required this.searchrangelist, //search range
      required this.tablename,
      required this.table, //main table like DB.alloffice
      this.chooseofficevisible = false,
      this.officechooselist, //offices list for choose
      this.officenameclm, //column name of office name for choose
      this.officechooselist2,
      this.officenameclm2,
      required this.mainItem, //main items in page like user name ,office name
      required this.addactionvisible, //visible of add action
      required this.initialofadd,
      required this.floateactionbuttonlist, //float action button list
      required this.addactiontitle, //add action title
      required this.addactionpages, //pages of add action
      required this.addactionmainlabelsofpages, //titles of pages of add action
      required this.listoffunctionforadd, //list of function for button for add action
      required this.listofactionbuttonforadd, //list of buttom for add action
      required this.conditionofview,
      this.accountssearch,
      this.subitems,
      this.titleofmain,
      required this.tableofsearch,
      required this.updatetable,
      this.searchlist,
      this.multisearch = false});
  final String? tablename, officenameclm, officenameclm2, titleofmain;
  final List? table, tableofsearch, officechooselist, officechooselist2;
  final List<String> appbartitle, searchrangelist, addactiontitle;
  final List<Widget> addactionpages;
  final List<Map> addactionmainlabelsofpages,
      listofactionbuttonforadd,
      floateactionbuttonlist;
  final bool addactionvisible;
  final bool multisearch;
  final List? searchlist;
  final Function mainItem,
      initialofadd,
      listoffunctionforadd,
      conditionofview,
      updatetable;
  final bool searchwithdatevisible, chooseofficevisible;
  final Widget? subitems;
  final String? accountssearch;
  static String selectedoffice = 'all';
  static String choosenoffice = 'all';
  static TextEditingController searchcontroller = TextEditingController();
  static List searchbydateList = [
    {'date': DateTime.now().add(Duration(days: -30))},
    {'date': DateTime.now()}
  ];
  @override
  Widget build(BuildContext context) {
    //create list of sort by office if user who login and in tow office at least
    List officeslist = [];
    officeslist.clear();
    officeslist.add('all');
    for (var i in DB.userinfotable![0]['users_priv_office']) {
      if (DB.userinfotable![0]['users_priv_office'].isNotEmpty) {
        officeslist.add(DB.allofficeinfotable![0]['offices'][DB
                .allofficeinfotable![0]['offices']
                .indexWhere((of) => of['office_id'] == i['upo_office_id'])]
            ['officename']);
      }
    }
    //check if user login by correct username and password
    if (BasicInfo.LogInInfo != null) {
      return GetBuilder<DBController>(
        init: dbController,
        builder: (_) => SafeArea(
            child: Directionality(
          textDirection: BasicInfo.lang(),
          child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                appbartitle[BasicInfo.indexlang()], //app bar title
                style: ThemeMz.titlelargCairo(),
              ),
            ),
            body: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //search
                  TextFieldMz(
                      controller: searchcontroller,
                      label: const ['بحث', 'search'],
                      onchange: (x) => mainController.search(
                          range: searchrangelist, word: x, list: tableofsearch),
                      td: BasicInfo.lang()),
                  //choose by office
                  GetBuilder<MainController>(
                    init: mainController,
                    builder: (_) => Visibility(
                        visible: chooseofficevisible && officeslist.length > 2,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width < 500
                                ? MediaQuery.of(context).size.width
                                : 500,
                            child: Card(
                              shape: const BeveledRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10))),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text([
                                    '  اختيار المكتب',
                                    'Choose Office  '
                                  ][BasicInfo.indexlang()]),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10),
                                    child: DropdownButton(
                                        value: selectedoffice,
                                        items: officeslist
                                            .map((ol) => DropdownMenuItem(
                                                value: ol, child: Text(ol)))
                                            .toList(),
                                        onChanged: (x) {
                                          mainController.chooseoffice(
                                              accounts: accountssearch,
                                              x: x,
                                              list: officechooselist,
                                              list2: officechooselist2,
                                              officenameclm: officenameclm,
                                              officenameclm2: officenameclm2);
                                        }),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )),
                  ),
                  //search by date range
                  GetBuilder<MainController>(
                    init: mainController,
                    builder: (_) => Visibility(
                      visible: searchwithdatevisible,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width < 500
                            ? MediaQuery.of(context).size.width
                            : 500,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(children: [
                              Text(['من', 'from'][BasicInfo.indexlang()]),
                              TextButton(
                                onPressed: () {
                                  mainController.setstartdatefor(
                                      searchlist: searchlist,
                                      ctx: context,
                                      list: searchbydateList,
                                      index: 0,
                                      date: 'date');
                                },
                                style: Theme.of(context).textButtonTheme.style,
                                child: Text(df.DateFormat("yyyy-MM-dd")
                                    .format(searchbydateList[0]['date'])),
                              ),
                            ]),
                            Row(
                              children: [
                                Text(['إلى', 'to'][BasicInfo.indexlang()]),
                                TextButton(
                                    onPressed: () {
                                      mainController.setrnddatefor(
                                          searchlist: searchlist,
                                          ctx: context,
                                          list: searchbydateList,
                                          index: 1,
                                          date: 'date');
                                    },
                                    child: Text(df.DateFormat("yyyy-MM-dd")
                                        .format(searchbydateList[1]['date'])))
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  const Divider(),
                  GetBuilder<MainController>(
                    init: mainController,
                    builder: (_) => Expanded(
                      child: SingleChildScrollView(
                          child: table != null
                              ? Column(
                                  children: [
                                    ...table!.where((element) {
                                      return conditionofview(element) == true &&
                                          element['visible'] == true &&
                                          element['visiblesearch'] == true;
                                    }).map((me) => mainItem(me)),
                                  ],
                                )
                              : SizedBox()),
                    ),
                  ),
                  SizedBox(
                    height: AppBar().preferredSize.height,
                  )
                ],
              ),
            ),
            floatingActionButton: Visibility(
              visible: addactionvisible,
              child: GetBuilder<MainController>(
                init: mainController,
                builder: (_) => SizedBox(
                  height: AppBar().preferredSize.height,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      ...floateactionbuttonlist.map((f) => IconbuttonMz(
                          backcolor: ThemeMz.iconbuttonmzbc(),
                          width: 150,
                          height: 40,
                          buttonlist: floateactionbuttonlist,
                          elevate: f['elevate'],
                          e: f,
                          index: f['index'],
                          action: (e) => adddialogasWidget(ctx: context),
                          label: addactiontitle))
                    ],
                  ),
                ),
              ),
            ),
          ),
        )),
      );
    } else {
      Future(() => Get.offAllNamed('/'));
      return const SizedBox();
    }
  }

//for add action
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
    initialofadd();
    return showDialog(
        context: ctx,
        builder: (_) {
          return DialogMz01(
              title: addactiontitle,
              mainlabels: addactionmainlabelsofpages,
              bodies: [...addactionpages],
              actionlist: addactionaswidget(ctx: ctx));
        });
  }
}
