import 'package:flutter/material.dart';
import 'package:mz_flutter_07/models/basicinfo.dart';

class TextFieldMz extends StatelessWidget {
  const TextFieldMz(
      {super.key,
      this.maxlines = 1,
      this.controller,
      this.obscureText = false,
      this.readOnly = false,
      this.error,
      required this.label,
      this.action,
      this.icon,
      required this.onchange,
      required this.td,
      this.hint,
      this.lines = 1});
  final int maxlines;
  final TextEditingController? controller;
  final bool obscureText, readOnly;
  final String? error, hint;
  final List<String> label;
  final Function? onchange;
  final int lines;
  // ignore: prefer_typing_uninitialized_variables
  final action;
  final IconData? icon;
  final TextDirection td;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width < 500
            ? MediaQuery.of(context).size.width
            : 500,
        child: TextField(
            maxLines: lines,
            textDirection: td,
            controller: controller,
            obscureText: obscureText,
            readOnly: readOnly,
            textAlign: TextAlign.center,
            onChanged: (x) => onchange!(x),
            decoration: InputDecoration(
              hintText: hint,
              border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              errorText: error,
              label: Text(
                label[BasicInfo.indexlang()],
                style: const TextStyle(
                    fontFamily: 'Changa', fontWeight: FontWeight.w700),
              ),
              suffixIcon: IconButton(onPressed: action, icon: Icon(icon)),
            )),
      ),
    );
  }
}
