import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mz_flutter_07/controllers/maincontroller.dart';
import 'package:mz_flutter_07/models/basicinfo.dart';
import 'package:mz_flutter_07/views/login.dart';

class IconbuttonMz extends StatelessWidget {
  const IconbuttonMz(
      {super.key,
      required this.e,
      required this.action,
      required this.label,
      this.elevetioncard = 0.0,
      this.listbutton,
      this.indexbutton,
      this.page});
  final double elevetioncard;
  final e;
  final Function action;
  final List<String> label;
  final List? listbutton;
  final int? indexbutton;
  final String? page;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => action(e),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onHover: (x) => mainController.onhoverbutton(
            listbutton: listbutton, indexbutton: indexbutton, page: page),
        onExit: (x) => mainController.onexitbutton(
            listbutton: listbutton, indexbutton: indexbutton, page: page),
        child: Card(
          elevation: elevetioncard,
          color: BasicInfo.selectedmode == 'Light'
              ? Colors.indigoAccent
              : Colors.deepPurpleAccent,
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
                style: TextStyle(
                    fontFamily: 'Changa', color: Colors.white, fontSize: 15),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
