import 'package:flutter/material.dart';

void showMsg(context, title, content){
  Color color = Colors.pink.shade200;
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          TextButton(
            child: Text('확인', style: TextStyle(color: color, fontSize: 17)),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}