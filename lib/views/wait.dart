import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mz_flutter_07/controllers/dbcontroller.dart';
import 'package:mz_flutter_07/models/basicinfo.dart';
import 'package:mz_flutter_07/models/tween.dart';

class WaitMz extends StatelessWidget {
  const WaitMz({super.key});
  static double endscale = 1.0;
  static double endopacity = 1.0;

  @override
  Widget build(BuildContext context) {
    List items = [];
    items.clear();
    for (var i = 1; i < 10; i++) {
      items.add(i);
    }
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(['رجاءا الانتظار', "Please Wait"][BasicInfo.indexlang()]),
            waitmz0(items, context),
          ],
        ),
      ),
    );
  }

  static Widget waitmz0(List<dynamic> items, BuildContext context) {
    DBController dbController = Get.find();
    return GetBuilder<DBController>(
      init: dbController,
      builder: (_) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ...items.map((e) {
            return StreamBuilder(
              stream: Stream.periodic(const Duration(seconds: 2), (a) async {
                return a++;
              }),
              builder: (_, snap) {
                if (snap.hasData) {
                  snap.data!.then((value) {
                    WaitMz.endscale = value.isOdd ? 0.5 : 1.0;
                    WaitMz.endopacity = value.isOdd ? 1.0 : 0.5;
                  });
                }
                return TweenMz.scaleYM(
                    ctx: context,
                    begin: 0.0,
                    end: endscale,
                    duration: e * 200,
                    child: TweenMz.opacityM(
                      ctx: context,
                      begin: 0.5,
                      end: endopacity,
                      duration: e * 200,
                      child: Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: Container(
                          height: 10,
                          width: 10,
                          decoration: BoxDecoration(
                            boxShadow: const [
                              BoxShadow(
                                  color: Colors.teal,
                                  spreadRadius: 2,
                                  blurRadius: 5)
                            ],
                            shape: BoxShape.circle,
                            border:
                                Border.all(color: Colors.transparent, width: 1),
                            color: BasicInfo.selectedmode == 'Light'
                                ? Colors.black
                                : Colors.white,
                          ),
                        ),
                      ),
                    ));
              },
            );
          })
        ],
      ),
    );
  }
}
