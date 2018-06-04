import 'package:configorator/EditPageViewModel.dart';
import 'package:configorator/model/Data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BooleanInputWidget extends StatelessWidget {

  final BooleanInputData data;
  final num position;
  final ItemClicked clickListener;

  BooleanInputWidget(this.data, this.position, this.clickListener);

  void onClicked(bool value) {
    data.isOn = value;
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
                child: new Checkbox(
                    value: data.isOn,
                    onChanged: onClicked
                )
            ),
          ]
      ),
    );
  }
}