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
      required this.index});
  final List buttonlist;
  final double elevate;
  final e;
  final int index;
  final Function action;
  final List<String> label;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => action(e),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onHover: (x) => mainController.onhover(
            elevate: elevate, list: buttonlist, index: index),
        onExit: (x) => mainController.onexit(
            elevate: elevate, list: buttonlist, index: index),
        child: Card(
          elevation: elevate,
          color: BasicInfo.selectedmode == 'Light'
              ? Colors.blueAccent.withOpacity(0.8)
              : Colors.teal.withOpacity(0.6),
          shadowColor: BasicInfo.selectedmode == 'Light'
              ? Colors.black87
              : Colors.white70,
          shape:
              BeveledRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                label[BasicInfo.indexlang()],
                style: const TextStyle(
                    fontFamily: 'Changa', color: Colors.white, fontSize: 15),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
