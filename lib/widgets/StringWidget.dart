import 'package:configorator/EditPageViewModel.dart';
import 'package:configorator/model/Data.dart';
import 'package:configorator/widgets/BooleanWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class StringInputWidget extends StatelessWidget {

  StringInputData data;
  final num position;
  final TextEditingController controller = new TextEditingController();
  final ItemClicked clickListener;

  StringInputWidget(this.data, this.position, this.clickListener) {
    controller.value = new TextEditingValue(text: data.value);
  }

  void onClicked(String value) {
    data.value = value;
    clickListener(data, position, null);
  }

  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: new EdgeInsets.all(16.0),
      child: new Row(
          children: <Widget>[
            new Expanded(
              child: new Text(
                data.key,
                textAlign: TextAlign.left,
                style: new TextStyle(fontSize: 18.0),
              ),
            ),
            new Expanded(
                child: new TextField(
                  controller: controller,
                  onSubmitted: onClicked,
                )
            ),
          ]
      ),
    );
  }
}