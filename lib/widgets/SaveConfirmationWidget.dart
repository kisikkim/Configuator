import 'dart:async';
import 'dart:convert';

import 'package:configorator/model/JsonLoader.dart';
import 'package:configorator/widgets/DiffStringWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;


const String _API1 = "http://stg-ampinternal.ihrcloud.net/internal/api/v3/configuration";
const String _API2 = "http://qa-ampinternal.ihrcloud.net/internal/api/v3/configuration";

class SaveConfirmationWidget extends StatefulWidget {

  SaveConfirmationWidget({Key key, this.modifiedJson}) : super(key: key);

  final Map<String, Object> modifiedJson;

  @override
  SaveConfigState createState() => new SaveConfigState(modifiedJson);
}

class SaveConfigState extends State<SaveConfirmationWidget> {

  final Future<Map> origJson = loadJson();
  final Map<String, Object> modifiedJson;

  var diffs = new List();

  SaveConfigState(this.modifiedJson) {
    _collectDiffs();
  }

  void _collectDiffs() {
    origJson.asStream().listen((Map map){
      _traverse(map, modifiedJson, "");
    });
  }

  void _traverse(Map<String, Object> map, Map<String, Object> modifMap, String path) {
    if (map == null || modifMap == null) return;

    map.forEach((String key, Object value){
      if (value is Map) {
        _traverse(value, modifMap[key], path + key + "->");
      } else  {
        if (value is String && modifMap[key] is String && value != modifMap[key]) {
          diffs.add(new DiffString(path, key, modifMap[key]));
        } else if (value is bool && modifMap[key] is bool && value != modifMap[key]) {
          diffs.add(new DiffString(path, key, modifMap[key]));

        }
      }
    });
  }

  void _onClicked() {
    //curl -s -o /dev/null -w "%{http_code}" -X POST --header "Content-Type: application/json" --header "Accept: application/json" --data "@android.mobile.us" http://qa-ampinternal.ihrcloud.net/internal/api/v3/configuration
    print("PRESSED");
    _onLoading();
    Future.wait([pushToServer(_API1), pushToServer(_API2)])
        .then((List<http.Response> responses) {
      Navigator.pop(context); //pop dialog
      responses.forEach((r) => print("RESULT: " + r.request.toString()));
      _showInfoDialog(responses);
    }).catchError((e) => print(e));
  }


  Future<http.Response> pushToServer(String api) {
    return http.post(
        api,
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json'
        },
        body: JSON.encode(modifiedJson));
  }

  void _onLoading() {
    showDialog(
      context: context,
      barrierDismissible: false,
      child: new AlertDialog(
        content: new SingleChildScrollView(

          child: new Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              new CircularProgressIndicator(),
              new Text("Pushing update to QA..."),
            ],
          ),
        ),
      ),
    );
  }

  void _showInfoDialog(List<http.Response> responses) {
    showDialog<Null>(
      context: context,
      barrierDismissible: false, // user must tap button!
      child: new AlertDialog(
        title: new Text('Finished'),
        content: new SingleChildScrollView(
          child: new ListBody(
            children: <Widget>[
              new Text("Complete"),
              new Text(responses[0].request.url.host.toString() + " :: " + responses[0].statusCode.toString()),
              new Text(responses[1].request.url.host.toString() + " :: " + responses[1].statusCode.toString()),
            ],
          ),
        ),
        actions: <Widget>[
          new FlatButton(
            child: new Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  Widget _diffBuilder(num index) {
    DiffString diff = diffs[index];
    return new DiffStringWidget(diff);
  }

  Widget buildAppBar(BuildContext context) {
    return new AppBar(
        title: const Text('Preview')
    );
  }

  Widget buildBody(BuildContext context) {
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        new Expanded(
          flex: 2,
          child: new Container(
            margin: const EdgeInsets.all(16.0),
            color: Colors.blue,
            child: new Card(
              color: Colors.white,
              child: new ListView.builder(
                  itemCount: diffs.length,
                  itemBuilder: (_, index) {
                    return _diffBuilder(index);
                  }
              ),
            ),
          ),
        ),

        new Expanded(
            flex: 0,
            child: new Padding(
              padding: const EdgeInsets.all(16.0),
              child: new RaisedButton(
                child: const Text("Post"),
                onPressed: _onClicked,
              ),
            )
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: buildAppBar(context),
      body: buildBody(context)
    );
  }
}