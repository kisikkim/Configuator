import 'dart:async';

import 'package:configorator/main.dart';
import 'package:configorator/model/Data.dart';
import 'package:configorator/model/JsonLoader.dart';
import 'package:configorator/widgets/BooleanWidget.dart';
import 'package:configorator/widgets/SaveConfirmationWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/navigator.dart';




class EditPageViewModel {

  Map<String, Object> _json = new Map();
  List<Data> _data = <Data>[];
  List<String> _title;

  StreamController<List<Data>> _stream = new StreamController();

  EditPageViewModel(this._title, this._json) {
    if (_json.isNotEmpty) {
      _data = _parseJson(showCurrentNodePerKey(_title));
      _stream.add(_data);
    } else {
      loadJson().asStream().listen((map) {
        _json = map;
        _data = _parseJson(_json);
        _stream.add(_data);
      });
    }
  }

  List<Data> _parseJson(Map<String, Object> json) {
    List<Data> datas = <Data>[];
    json.forEach((String key, Object value){
      if (value is bool) {
        datas.add(new BooleanInputData(key, value, _title));
      } else if (value is Map) {
        datas.add(new ObjectInputData(key, value, _title));
      } else if (value is String) {
        datas.add(new StringInputData(key, value, _title));
      } else {

      }
    });

    return datas;
  }


  Stream data() {
    return _stream.stream;
  }

  void itemUpdated(Data value, num index, BuildContext context) {
    if (value is ObjectInputData) {
      Navigator.of(context).push(new CustomRoute(builder: (BuildContext context) {
        List<String> next = new List();
        next.addAll(value.breadCrumb);
        next.add(value.key);
        return new MyHomePage(title: next, json: _json);
      },
      ));
    } else {

      _updateJson(value.breadCrumb, value);
      _data[index] = value;
      _stream.add(_data);
    }
  }

  void goToSummary(BuildContext context) {
    Navigator.of(context).push(new CustomRoute(
      builder: (BuildContext context) { return new SaveConfirmationWidget(modifiedJson: _json); },
    ));
  }

  String createTitle(List<String> breadCrumb) {
    String title = "";

    breadCrumb.forEach((value) =>
      title.length == 0 ? title = value : title = title + "->" + value

    );
    if (title.isEmpty) {
      return "Configorator";
    }

    return title;
  }

  Map<String, Object> showCurrentNodePerKey(List<String> keys) {
    Map<String, Object> map = _json;

    for (int i = 0; i < keys.length; i++) {
      map = map[keys[i]];
    }

    return map;
  }

  void _updateJson(List<String> keys, Data value) {
    print(_json.toString());

    Map<String, Object> map = showCurrentNodePerKey(keys);

    if (value is BooleanInputData) {
      map[value.key] = value.isOn;
    } else if (value is StringInputData) {
      map[value.key] = value.value;
    }

    _data = _parseJson(showCurrentNodePerKey(_title));
    _stream.add(_data);

    print(_json.toString());
  }

}

typedef ItemClicked(Data data, num index, BuildContext context);

class CustomRoute<T> extends MaterialPageRoute<T> {

  CustomRoute({ WidgetBuilder builder }) : super(builder: builder);

  @override
  Widget buildTransitions(BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {

//    Animation<Offset> animation = = new FractionalOffsetTween(
//        begin: FractionalOffset.centerRight,
//        end: FractionalOffset.centerRight).animate(new CurvedAnimation(parent: animation, curve: Curves.ease));

    //Animation<Offset> animation = new FractionalOffsetTween();
    //return new SlideTransition(position: new FractionalOffset(4, 2).animate());
    return new FadeTransition(opacity: animation, child: child);
  }
}