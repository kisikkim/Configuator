import 'package:configorator/EditPageViewModel.dart';
import 'package:configorator/model/Data.dart';
import 'package:configorator/model/JsonLoader.dart';
import 'package:configorator/model/TestJsonLoader.dart';
import 'package:configorator/widgets/BooleanWidget.dart';
import 'package:configorator/widgets/ObjectWidget.dart';
import 'package:configorator/widgets/StringWidget.dart';
import 'package:configorator/widgets/SaveConfirmationWidget.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Configurator',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: <String>[], json: new Map(),),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, this.json}) : super(key: key);

  final List<String> title;
  Map<String, Object> json = new Map();

  @override
  _MyHomePageState createState() => new _MyHomePageState(title, json);
}

class _MyHomePageState extends State<MyHomePage> {
  _MyHomePageState(this.title, this.json);

  Map<String, Object> json = new Map();
  bool isSelected = true;
  List<String> title;

  List<Data> _data = <Data>[];
  EditPageViewModel _vm;

  @override
  void initState() {
    super.initState();
    _vm = new EditPageViewModel(title, json);
    _vm.data().listen((value) => onUpdateView(value));
  }

  void onUpdateView(List<Data> data) {
    setState(() {
      _data = data;
    });
  }

  Widget _listItemBuilder(num index, BuildContext context) {
    Data data = _data[index];
    if (data is BooleanInputData) {
      return new BooleanInputWidget(_data[index], index, _vm.itemUpdated);
    } else if (data is ObjectInputData) {
      return new ObjectInputWidget(_data[index], index, _vm.itemUpdated, context);
    } else {
      return new StringInputWidget(_data[index], index, _vm.itemUpdated);
    }
  }

  void _onClicked() {
    _vm.goToSummary(context);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(_vm.createTitle(widget.title)),
        ),
        body: new ListView.builder(
          itemCount: _data.length,
          itemBuilder: (_, position) {
            return _listItemBuilder(position, context);
          },
          physics: new BouncingScrollPhysics(),
        ),
      floatingActionButton: new FloatingActionButton(
        onPressed: _onClicked,
        child: new Icon(Icons.check_circle),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
