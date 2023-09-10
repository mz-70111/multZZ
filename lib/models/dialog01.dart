import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mz_flutter_07/controllers/maincontroller.dart';
import 'package:mz_flutter_07/models/basicinfo.dart';
import 'package:mz_flutter_07/models/tween.dart';
import 'package:mz_flutter_07/views/login.dart';
import 'package:mz_flutter_07/views/wait.dart';

class DialogMz01 extends StatelessWidget {
  const DialogMz01({
    super.key,
    required this.title,
    required this.mainlabels,
    required this.bodies,
    required this.actionlist,
  });
  final List<String> title;
  final List<Map> mainlabels;
  final List<Widget> bodies;
  final List<Widget> actionlist;

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: BasicInfo.lang(),
        child: GetBuilder<MainController>(
          init: mainController,
          builder: (_) => AlertDialog(
            scrollable: true,
            title: Text(
              title[BasicInfo.indexlang()],
              style: TextStyle(fontFamily: 'Cairo', fontSize: 20),
            ),
            content: SizedBox(
              width: MediaQuery.of(context).size.width < 500
                  ? MediaQuery.of(context).size.width
                  : 500,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...mainlabels.map((mi) => GestureDetector(
                        onTap: () => mainController.swapwidgetdialg(
                            index: mainlabels.indexOf(mi), list: mainlabels),
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: Row(
                            children: [
                              Expanded(
                                child: Card(
                                  shape: mi['selected'] == true
                                      ? BasicInfo.selectedlang == 'Ar'
                                          ? BeveledRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.horizontal(
                                                      left: Radius.elliptical(
                                                          20, 20)))
                                          : BeveledRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.horizontal(
                                                      right: Radius.elliptical(
                                                          20, 20)))
                                      : BeveledRectangleBorder(),
                                  elevation: mi['selected'] == true ? 6 : 0,
                                  color: BasicInfo.selectedmode == 'Light'
                                      ? Colors.indigoAccent
                                      : Colors.deepPurpleAccent,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      mi['name'][BasicInfo.indexlang()],
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontFamily: 'Changa',
                                          fontWeight: mi['selected'] == true
                                              ? FontWeight.w800
                                              : FontWeight.w400,
                                          color: Colors.white.withOpacity(0.8)),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )),
                  TweenMz.translateXM(
                    duration: 300,
                    begin: -100.0,
                    ctx: context,
                    end: 0.0,
                    child: bodies[mainlabels
                        .indexWhere((element) => element['selected'] == true)],
                  ),
                  Visibility(
                      visible: BasicInfo.error == null ? false : true,
                      child: Center(
                        child: Text("${BasicInfo.error}"),
                      ))
                ],
              ),
            ),
            actions: actionlist,
          ),
        ));
  }
}
