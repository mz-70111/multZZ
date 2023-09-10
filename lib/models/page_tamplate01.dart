import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:mz_flutter_07/controllers/dbcontroller.dart';
import 'package:mz_flutter_07/controllers/maincontroller.dart';
import 'package:mz_flutter_07/models/basicinfo.dart';
import 'package:mz_flutter_07/models/bottonicon.dart';
import 'package:mz_flutter_07/models/database.dart';
import 'package:mz_flutter_07/models/dialog01.dart';
import 'package:mz_flutter_07/views/login.dart';
import 'package:mz_flutter_07/views/wait.dart';

class PageTamplate01 extends StatelessWidget {
  const PageTamplate01(
      {super.key,
      required this.appbartitle,
      required this.addtitle,
      required this.mainlebelsdialogmz,
      required this.actionlist,
      required this.bodies,
      this.elevationcard = 0.0,
      this.page,
      this.futurefun,
      required this.table,
      required this.tablename,
      this.prepairfunction});
  final List<String> appbartitle, addtitle;
  final List<Map> mainlebelsdialogmz;
  final List<Widget> bodies, actionlist;
  final String? page;
  final double elevationcard;
  final futurefun;
  final List table;
  final String tablename;
  final prepairfunction;
  @override
  Widget build(BuildContext context) {
    if (BasicInfo.LogInInfo != null) {
      return GetBuilder<DBController>(
        init: dbController,
        builder: (_) => FutureBuilder(
            future: futurefun,
            builder: (_, snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return WaitMz();
              } else if (snap.hasData) {
                return SafeArea(
                    child: Directionality(
                  textDirection: BasicInfo.lang(),
                  child: Scaffold(
                    appBar: AppBar(
                      centerTitle: true,
                      title: Text(
                        appbartitle[BasicInfo.indexlang()],
                        style: TextStyle(fontFamily: 'Cairo'),
                      ),
                    ),
                    floatingActionButton: SizedBox(
                      width: 150,
                      height: 50,
                      child: IconbuttonMz(
                          elevetioncard: elevationcard,
                          page: page,
                          e: null,
                          action: (e) {
                            showDialog(
                                context: context,
                                builder: (_) {
                                  return FutureBuilder(
                                    future: prepairfunction,
                                    builder: (_, snap) {
                                      if (snap.connectionState ==
                                          ConnectionState.waiting) {
                                        return WaitMz.waitmz0(
                                            [1, 2, 3, 4], context);
                                      } else {
                                        print(DB.allusersinfotable);
                                        return DialogMz01(
                                            title: addtitle,
                                            mainlabels: mainlebelsdialogmz,
                                            bodies: [...bodies],
                                            actionlist: [...actionlist]);
                                      }
                                    },
                                  );
                                });
                          },
                          label: addtitle),
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
                            'حصل خطأ ما أعد المحاولة',
                            'some thing wrong retry'
                          ][BasicInfo.indexlang()]),
                          IconButton(
                              onPressed: () {
                                dbController.update();
                              },
                              icon: Icon(Icons.refresh)),
                        ],
                      ),
                    ),
                  ),
                );
              }
            }),
      );
    } else {
      Future(() => Get.offAllNamed('/'));
      return const SizedBox();
    }
  }
}
