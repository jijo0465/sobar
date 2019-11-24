
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Loading extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        
        Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.black87,
          child: FittedBox(
            fit:  BoxFit.fill,
            child: Image.asset('assets/background.png')),
            
        ),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5,sigmaY: 5),
          child: Container(
            child: CupertinoActivityIndicator(
                animating: true,
              ),
          ),
        ),
          
      ],
    );
  }

}