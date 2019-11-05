import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BottomSheetTitle extends StatelessWidget{
  final String title;

  const BottomSheetTitle({Key key, this.title}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Text(title,style: TextStyle(
        fontSize: 16,
        color: Colors.grey[900]
      ),),
    );
  }

}