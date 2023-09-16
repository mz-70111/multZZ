// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:mz_flutter_07/models/basicinfo.dart';
import 'package:mz_flutter_07/views/homepage.dart';
import 'package:mz_flutter_07/views/login.dart';

class IconbuttonMz extends StatelessWidget {
  const IconbuttonMz(
      {super.key,
      required this.e,
      required this.action,
      required this.label,
      this.elevate = 0.0,
      required this.buttonlist,
      required this.index,
      required this.height,
      required this.width,
      this.textsize = 14,
      this.icon,
      this.labelvisible = true,
      required this.backcolor});
  final List buttonlist;
  final double elevate;
  final e;
  final int index;
  final Function action;
  final List<String> label;
  final double width, height, textsize;
  final IconData? icon;
  final bool labelvisible;
  final Color backcolor;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => action(e),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onHover: (x) => mainController.onhover(
            elevate: elevate,
            list: buttonlist,
            index: index,
            backcolor: backcolor),
        onExit: (x) => mainController.onexit(
            elevate: elevate, list: buttonlist, index: index),
        child: SizedBox(
          width: width,
          height: height,
          child: Card(
            elevation: elevate,
            color: backcolor,
            shadowColor: BasicInfo.selectedmode == 'Light'
                ? Colors.black87
                : Colors.white70,
            shape:
                BeveledRectangleBorder(borderRadius: BorderRadius.circular(5)),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    icon == null
                        ? SizedBox()
                        : Icon(
                            icon,
                            color: backcolor == Colors.transparent
                                ? BasicInfo.selectedmode == 'Light'
                                    ? Colors.indigoAccent
                                    : Colors.white
                                : Colors.white,
                          ),
                    Visibility(
                      visible: labelvisible,
                      child: Text(
                        label[BasicInfo.indexlang()],
                        style: TextStyle(
                            fontFamily: 'Changa',
                            color: Colors.white,
                            fontSize: textsize),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
