import 'package:flutter/material.dart';

class AllToDosPage extends StatelessWidget {
  const AllToDosPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return Text(index.toString() + "all todos page");
      },
      itemCount: 20,
      shrinkWrap: true,
    );
  }
}
