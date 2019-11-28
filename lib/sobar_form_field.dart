import 'dart:ui';

import 'package:flutter/material.dart';

class SobarFormField extends StatelessWidget{
  final ValueChanged<String> onChanged;
  final String label;
  final String initialValue;
  final int maxLines;
  final bool enabled;
  final TextEditingController controller;
  final Icon suffixIcon;
  const SobarFormField({Key key, this.label, this.initialValue, this.maxLines, this.onChanged, @required this.enabled, this.controller, this.suffixIcon}) : super(key: key);
  @override
  
  Widget build(BuildContext context){
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10,sigmaY: 10),
            child: Container(
          margin: EdgeInsets.fromLTRB(8, 4, 8, 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.orange[100].withOpacity(0.1),
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
                  color: Colors.white.withOpacity(0.8),
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
                    
                    textInputAction: TextInputAction.done,
                    enabled: enabled,
                    onChanged: (string){
                      this.onChanged(string);
                    },
                    keyboardType: TextInputType.multiline,
                    maxLines: maxLines,
                    style: TextStyle(fontSize: 16,color: Colors.white),
                    initialValue: initialValue,
                    decoration: InputDecoration(
                      suffixIcon: suffixIcon,
                      border: InputBorder.none
                  ),
                ),
              ),
              ),
            ],
          ),
          )
          
        ),
      ),
    );
  }
  
}