import 'package:flutter/material.dart';

class SobarFormField extends StatelessWidget{
  final ValueChanged<String> onChanged;
  final String label;
  final String initialValue;
  final int maxLines;
  final bool enabled;
  final TextEditingController controller;
  const SobarFormField({Key key, this.label, this.initialValue, this.maxLines, this.onChanged, @required this.enabled, this.controller}) : super(key: key);
  @override
  
  Widget build(BuildContext context){
    return Container(
      margin: EdgeInsets.fromLTRB(4, 4, 4, 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.orange[300],
      ),
      child: IntrinsicHeight(
        child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex:2,
            child:Container(
              padding: EdgeInsets.fromLTRB(12, 0, 0, 0),
            child: Text(label,style: TextStyle(
              color: Colors.black87,
              fontSize: 14
            ),),
            ),
          ),

          VerticalDivider(
            indent: 4,
            endIndent: 4,
            color: Colors.grey[700],
            ),
          Expanded(
            flex: 9,
            child: Container(
              padding: (maxLines>1)? EdgeInsets.fromLTRB(0, 0, 50, 0):EdgeInsets.fromLTRB(0, 0, 8, 0),
              child: TextFormField(
                enabled: enabled,
                onChanged: (string){
                  this.onChanged(string);
                },
                keyboardType: TextInputType.multiline,
                maxLines: maxLines,
                style: TextStyle(fontSize: 16,color: Colors.black),
                initialValue: initialValue,
                decoration: InputDecoration(
                  border: InputBorder.none
              ),
            ),
          ),
          ),
        ],
      ),
      )
      
    );
  }
  
}