/* import 'package:flutter/material.dart';

class ArchivePage extends StatelessWidget {
  const ArchivePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return Text(index.toString() + " Archive Page");
      },
      itemCount: 20,
      shrinkWrap: true,
    );
  }
} */









import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ArchivePage extends StatefulWidget {
  ArchivePage({Key? key}) : super(key: key);

  @override
  State<ArchivePage> createState() => _ArchivePageState();
}

class _ArchivePageState extends State<ArchivePage> {
  ScrollController _scrollController = ScrollController();
  int _currentMax = 10;
  List<String> dummyList = List.generate(10, (index) => "Item: ${index + 1}");

  @override
  void initState() {
    _scrollController.addListener(() {
      if ( _scrollController.position.maxScrollExtent == _scrollController.offset) {
        dummyList = List.generate(_currentMax, (index) => "Item: ${index + 1}");
        _getMoreList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      itemBuilder: (context, index) {
        if (index == dummyList.length) {
          return CupertinoActivityIndicator();
        }
        return ListTile(leading: Text(dummyList[index] + " archive page"));
      },
      itemCount: dummyList.length + 1,
      shrinkWrap: true,
    );
  }

  void _getMoreList() {
    debugPrint("Get more list");
    for (var i = _currentMax; i < _currentMax + 10; i++) {
      dummyList.add("Item: ${i + 1}");
    }
    _currentMax = _currentMax + 10;
    setState(() {});
  }
}