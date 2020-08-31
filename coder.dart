import 'dart:io';
import 'dart:async';
import 'dart:convert';

Future<List<Map>> readJson(File f) async {
  List<Map> shapes = List<Map>();
  Map<String, dynamic> data = JsonCodec().decode(await f.readAsString());
  data["shapes"].forEach((e) => shapes.add(e));
  getShapes(shapes);
  return shapes;
}

class _FunctionData {
  String id;
  String type;
  String name;
  String args;
}

class _VariableData {
  String id;
  String name;
}

class _IsnstructionData {
  String id;
  bool asing;
  String valName;
  _ConstData valConts;
  _FunctionData valFunc;
  _OperationData valOpe;
  String content;
}

class _IfElseData {
  String id;
  String operation;
  String idTrue, idFalse;
}

class _InOutData {
  bool inOut;
  String content;
  String id;
}

class _ConstData {
  String type;
  String content;
}

class _OperationData {
  String id;
  String content;
}

class _ProgramFlow {
  String id1, id2;
}

class _ProgramData {
  List<_VariableData> _vars;
  List<_IsnstructionData> _instr;
  List<_FunctionData> _funcs;
  List<_InOutData> _inOuts;
  List<_ProgramFlow> _flow;
}

class _Shape {
  String type;
  String id;
  String content;
  @override
  String toString() => "{$type, $id, $content}";
}

class _Line extends _Shape {
  String id1, id2;
  @override
  String toString() => super.toString() + " $id1, $id2";
}

List<_Shape> getShapes(List<Map> shapes) {
  List<_Shape> l = [];
  for (var s in shapes) {
    String type = s["classList"]["1"];
    if (type != "line") {
      l.add(getShape(s));
    } else {
      l.add(getLine(s));
    }
  }
  return l;
}

_Shape getShape(Map<dynamic, dynamic> shape) {
  _Shape s = _Shape();
  s.type = shape["classList"]["1"];
  s.id = shape["id"];
  s.content = shape["title"];
  return s;
}

_Line getLine(Map<dynamic, dynamic> shape) {
  _Line l = _Line();

  l.type = shape["classList"]["1"];
  l.id = shape["id"];
  l.content = shape["title"];
  l.id1 = shape["classList"]["4"].split("id1")[1];
  l.id2 = shape["classList"]["5"].split("id2")[1];

  return l;
}
