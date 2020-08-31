import 'package:flutter/material.dart';
import "package:file_picker/file_picker.dart";
import 'dart:io';
import 'package:DiagramaCoder/coder.dart';

void main() {
  runApp(MainWindow());
}

class MainWindow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: _MainWindow_(),
    );
  }
}

// ignore: camel_case_types
class _MainWindow_ extends StatefulWidget {
  @override
  createState() => _MainWindow();
}

class _MainWindow extends State<_MainWindow_> {
  String _filePath = "";
  File file;
  var selectedLangs = <bool>[];
  var checkboxes;
  bool generated = false;
  var _textControllers = [];
  var langs = <String>[
    "C",
    "C++",
    "Java",
    "Python",
    "Go",
    "Dart",
    "Javascript"
  ];
  var _scrollPreview = ScrollController();
  Size screenSize;
  var _previewWidth = 500.0;
  var _cbheight = 60.0;
  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    print(screenSize.width);
    print(screenSize.height);
    _previewWidth = screenSize.width - 320;
    _cbheight = screenSize.height * 0.0857142857143;
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: Text("Diagrama Coder"),
          ),
          body: createMainBody()),
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.grey,
        accentColor: Colors.blue,
      ),
    );
  }

  Widget createMainBody() {
    checkboxes = _generateCheckBox(langs);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(minWidth: 300, minHeight: 700),
          child: Container(
            padding: EdgeInsets.only(top: 10, left: 10, right: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 200,
                  height: 30,
                  child: Scrollbar(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        "File:$_filePath",
                      ),
                    ),
                  ),
                ),
                RaisedButton(onPressed: _selectFile, child: Text("Open")),
                checkboxes[0],
                checkboxes[1],
                checkboxes[2],
                checkboxes[3],
                checkboxes[4],
                checkboxes[5],
                checkboxes[6],
                RaisedButton(
                  onPressed: langSelected() ? _createFiles : null,
                  child: Text("Create"),
                  disabledColor: Colors.blue,
                )
              ],
            ),
          ),
        ),
        _makePreview()
      ],
    );
  }

  List<Widget> _generateCheckBox(List<String> langs) {
    List<Widget> cbs = [];
    for (int i = 0; i < langs.length; i++) {
      if (!generated) {
        selectedLangs.add(i == 0);
      }
      cbs.add(SizedBox(
        width: 200,
        height: _cbheight,
        child: CheckboxListTile(
          contentPadding: EdgeInsets.only(bottom: 5),
          controlAffinity: ListTileControlAffinity.platform,
          dense: true,
          value: selectedLangs[i],
          onChanged: (bool val) {
            setState(() {
              selectedLangs[i] = val;
              print(val);
            });
          },
          title: Text(langs[i]),
        ),
      ));
    }
    generated = true;
    return cbs;
  }

  bool langSelected() {
    var selected = false;
    for (var i in selectedLangs) {
      selected |= i;
    }
    print(selectedLangs);
    print(selected);
    return selected;
  }

  Widget _makePreview() {
    return SizedBox(
      child: Container(
        color: Colors.grey[900],
        child: Scrollbar(
            child: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ListView(
                  children: _makePreviewItems(langs),
                  controller: _scrollPreview),
            ),
            isAlwaysShown: true,
            controller: _scrollPreview),
      ),
      width: _previewWidth,
      height: 500,
    );
  }

  List<Widget> _makePreviewItems(List<String> _langs) {
    List items = <Widget>[];
    for (int i = 0; i < langs.length; i++) {
      if (items.length <= langs.length * 3) {
        _textControllers.add(TextEditingController());
        items.add(Container(
          color: Colors.blue,
          width: 500,
          height: 30,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              langs[i],
            ),
          ),
        ));
        items.add(
          TextField(
            controller: _textControllers[i],
            minLines: 5,
            maxLines: 25,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
        );
        items.add(Divider());
      }
    }
    return items;
  }

  _selectFile() async {
    file = await FilePicker.getFile();
    print(file.path);
    setState(() {
      _filePath = file != null ? file.path : "";
    });
  }

  _createFiles() async {
    await readJson(file);
  }
}
