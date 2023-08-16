import 'package:flutter/material.dart';

class ArchivePage extends StatelessWidget {
  const ArchivePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return Text(index.toString() + "archive page");
      },
      itemCount: 20,
      shrinkWrap: true,
    );
  }
}
