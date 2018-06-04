

class Data {
  String key;
  List<String> breadCrumb;
  Data(this.key, this.breadCrumb);
}

class StringInputData extends Data {
  String value;
  StringInputData(key, this.value, breadCrumb) : super(key, breadCrumb);
}

class BooleanInputData extends Data {
  bool isOn;
  BooleanInputData(key, this.isOn, breadCrumb) : super(key, breadCrumb);
}

class ObjectInputData extends Data {
  Map value;
  bool isExpanded = false;
  ObjectInputData(key, this.value, breadCrumb) : super(key, breadCrumb);
}