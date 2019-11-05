import 'package:flutter/material.dart';

class SobarDivider extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
      child: Divider(
        color: Colors.grey[700],
        height: 0,
      ),
    );
  }

}