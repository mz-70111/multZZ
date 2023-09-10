import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mz_flutter_07/controllers/maincontroller.dart';
import 'package:mz_flutter_07/models/basicinfo.dart';
import 'package:mz_flutter_07/models/bottonicon.dart';
import 'package:mz_flutter_07/models/textfeild.dart';
import 'package:mz_flutter_07/views/login.dart';

class DropDownWithSearchMz extends StatelessWidget {
  const DropDownWithSearchMz(
      {super.key, required this.items, required this.ontap});
  final List items;
  final Function ontap;
  static bool visiblemain = false;
  static TextEditingController searchcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconbuttonMz(
            e: null,
            action: (e) => mainController.showdropwithsearchmz(items),
            label: ['إضافة عضو', 'Add member']),
        Visibility(
          visible: visiblemain,
          child: SizedBox(
            height: (((items
                                .where((element) =>
                                    element['visible'] == true &&
                                    element['visiblesearch'] == true)
                                .length *
                            180) /
                        (MediaQuery.of(context).size.width).ceil()) *
                    100) +
                100,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                TextFieldMz(
                    controller: searchcontroller,
                    label: ['بحث', 'search'],
                    onchange: (x) => mainController
                        .search(range: ['name'], list: items, word: x),
                    td: BasicInfo.lang()),
                Expanded(
                  child: GridView(
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                              mainAxisExtent: 50, maxCrossAxisExtent: 180),
                      children: [
                        ...items
                            .where((element) =>
                                element['visible'] == true &&
                                element['visiblesearch'] == true)
                            .map((e) => GestureDetector(
                                  onTap: () => ontap(e),
                                  child: MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    child: Card(
                                      elevation: 6,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          e['name'],
                                          style: const TextStyle(
                                              fontFamily: 'Changa',
                                              fontSize: 15),
                                        ),
                                      ),
                                    ),
                                  ),
                                ))
                      ]),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
