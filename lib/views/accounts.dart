import 'package:flutter/material.dart';
import 'package:mz_flutter_07/models/basicinfo.dart';

class Accounts extends StatelessWidget {
  const Accounts({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Directionality(
      textDirection: BasicInfo.lang(),
      child: Scaffold(
        appBar: AppBar(),
      ),
    ));
  }
}
