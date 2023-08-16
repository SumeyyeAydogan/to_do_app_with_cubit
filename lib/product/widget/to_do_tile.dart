import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ToDoTile extends StatelessWidget {
  const ToDoTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        children: [
          Text("title"),
          Spacer(),
          IconButton(onPressed: (){}, icon: const Icon(Icons.check), color: Colors.green,),
          IconButton(onPressed: (){}, icon: const Icon(Icons.book)),
        ],
      ),
      subtitle: Padding(padding: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("hi"),
          Text(
            DateFormat.yMMMEd().format(DateTime.now()),
          )
        ],
      ),
      ),
    );
  }
}