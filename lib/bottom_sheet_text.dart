import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BottomSheetText extends StatelessWidget{
  final String text;

  const BottomSheetText({Key key, this.text}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Text(text,style: TextStyle(
        fontSize: 13,
        color: Colors.grey[800]
      ),),
    );
  }

}