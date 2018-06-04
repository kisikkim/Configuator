import 'package:configorator/EditPageViewModel.dart';
import 'package:configorator/model/Data.dart';
import 'package:configorator/widgets/BooleanWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';




typedef ObjectInputClicked(map);



class ObjectInputWidget extends StatelessWidget {

  final ObjectInputData data;
  final num position;
  final ItemClicked clickListner;
  final BuildContext context;

  ObjectInputWidget(this.data, this.position, this.clickListner, this.context);

  void onClicked() {
    clickListner(data, position, context);
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
                child: new IconButton(
                    icon: new Icon(Icons.arrow_forward),
                    onPressed: onClicked
                )
            ),
          ]
      ),
    );
  }
}