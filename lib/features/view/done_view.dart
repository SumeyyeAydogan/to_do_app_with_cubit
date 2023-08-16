import 'package:flutter/material.dart';

class DonePage extends StatelessWidget {
  const DonePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return Text(index.toString() + "done page");
      },
      itemCount: 20,
      shrinkWrap: true,
    );
  }
}
