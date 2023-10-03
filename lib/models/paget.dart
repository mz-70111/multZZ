import 'package:flutter/material.dart';
import 'package:mz_flutter_07/models/database.dart';
import 'package:mz_flutter_07/views/login.dart';

class paget extends StatelessWidget {
  const paget({
    super.key,
    required this.updatetable,
    required this.mainitem,
  });
  final Function updatetable, mainitem;
  static List? table;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: Future(() async => await updatetable()),
          builder: (_, snap) {
            if (snap.hasData) {
              return Column(children: [
                ...table!.map(
                  (e) => mainitem(e),
                )
              ]);
            } else {
              return Text("no");
            }
          }),
    );
  }
}
