import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mz_flutter_07/controllers/dbcontroller.dart';
import 'package:mz_flutter_07/controllers/maincontroller.dart';
import 'package:mz_flutter_07/models/tween.dart';

class MyLogo extends StatelessWidget {
  const MyLogo({super.key});

  @override
  Widget build(BuildContext context) {
    List itemM = [];
    itemM.clear();
    for (var i = 0; i < 30; i++) {
      itemM.add(i);
    }
    return Scaffold(
      body: Directionality(
          textDirection: TextDirection.ltr,
          child: Center(
            child: Stack(
              children: [
                ...itemM.map((e) => TweenMz.opacityM(
                    ctx: context,
                    begin: 0.0,
                    end: 1.0,
                    duration: e * 100,
                    child: TweenMz.rotateM(
                        ctx: context,
                        begin: 0.0,
                        end: e < 5
                            ? 0.0
                            : e < 15
                                ? ((e - 5) * 9).toDouble()
                                : e < 20
                                    ? 0.0
                                    : e < 30
                                        ? 90.0
                                        : 0.0,
                        duration: e * 100,
                        alignment: Alignment.bottomCenter,
                        child: TweenMz.translateYM(
                          ctx: context,
                          begin: 0.0,
                          end: e < 5
                              ? -(e * 9).toDouble()
                              : e < 15
                                  ? -((e - 5)) - (9 * 5).toDouble()
                                  : e < 20
                                      ? -(10.3 * 9).toDouble()
                                      : e < 30
                                          ? -(13 * 9).toDouble()
                                          : 0.0,
                          duration: e * 100,
                          child: TweenMz.translateXM(
                              ctx: context,
                              begin: 0.0,
                              end: e < 5
                                  ? 0.0
                                  : e < 15
                                      ? -((e - 4.3) * 12).toDouble()
                                      : e < 20
                                          ? ((e - 7.5) * 12).toDouble()
                                          : e < 30
                                              ? (((e - 30) * 9)).toDouble()
                                              : 0.0,
                              duration: e * 100,
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white),
                                  color: e < 30
                                      ? Colors.blueAccent.withOpacity(0.3)
                                      : Colors.amberAccent,
                                ),
                              )),
                        ))))
              ],
            ),
          )),
    );
  }
}
