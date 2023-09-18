import 'package:flutter/material.dart';
import 'package:mz_flutter_07/models/basicinfo.dart';
import 'package:mz_flutter_07/models/textfeild.dart';
import 'package:mz_flutter_07/views/login.dart';

class DropDownWithSearchMz extends StatelessWidget {
  const DropDownWithSearchMz(
      {super.key,
      required this.items,
      required this.ontap,
      required this.label});
  final List items;
  final List<String> label;
  final Function ontap;
  static bool visiblemain = false;
  static TextEditingController searchcontroller = TextEditingController();
  static List titleiconlist = [
    {'index': 0, 'elevate': 0.0}
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            ...titleiconlist.map((f) => GestureDetector(
                  onTap: () => mainController.showdropwithsearchmz(items),
                  child: Row(
                    children: [
                      Text(label[BasicInfo.indexlang()]),
                      Icon(visiblemain == true
                          ? Icons.expand_circle_down
                          : Icons.expand_less)
                    ],
                  ),
                )),
          ],
        ),
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
                150,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                TextFieldMz(
                    controller: searchcontroller,
                    label: const ['بحث', 'search'],
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
                            .map((s) => GestureDetector(
                                  onTap: () => ontap(s),
                                  child: MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Icon(Icons.add),
                                          Text(
                                            s['name'],
                                            style: const TextStyle(
                                                overflow: TextOverflow.ellipsis,
                                                fontFamily: 'Changa',
                                                fontSize: 15),
                                          ),
                                          Container(
                                            color: Colors.black,
                                            height: 50,
                                            width: 5,
                                          )
                                        ],
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
