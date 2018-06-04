import 'package:flutter/material.dart';

class DiffString {

  final String key;
  final Object value;
  final String path;

  DiffString(this.path, this.key, this.value);

  String getDiffItem() {
    return path + " : " + key + " : " + value.toString();
  }
}

class DiffStringWidget extends StatelessWidget {

  final DiffString diffString;

  DiffStringWidget(this.diffString);

  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: const EdgeInsets.all(5.0),
      child: new Text(diffString.getDiffItem()),
    );
  }
}