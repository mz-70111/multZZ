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
            cursorColor: BasicInfo.selectedmode == 'Light'
                ? Colors.blue.shade500
                : Color.fromARGB(99, 23, 126, 130),
            decoration: InputDecoration(
              labelStyle: TextStyle(
                color: BasicInfo.selectedmode == 'Light'
                    ? Colors.black54
                    : Colors.white54,
              ),
              suffixIconColor: BasicInfo.selectedmode == 'Light'
                  ? Colors.black54
                  : Colors.white54,
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                width: 2.0,
                color: BasicInfo.selectedmode == 'Light'
                    ? Colors.black54
                    : Colors.white54,
              )),
              hintText: hint,
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
