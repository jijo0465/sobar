import 'package:flutter/material.dart';

class SobarHolidayTile extends StatelessWidget{
  final String title;
  final DateTime date;
  final String desc;
  final Animation animation;
  const SobarHolidayTile({Key key, this.title, this.date, this.desc, this.animation}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Card(
            child: ListTile(
              title: Text(
                date.toIso8601String(),
                style: TextStyle(fontSize: 20),
              ),
            ),
          );
  }

}