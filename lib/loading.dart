
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Loading extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    precacheImage(AssetImage('assets/background.png'), context);
    return Container(
      color: Colors.black54,
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: CupertinoActivityIndicator(
        animating: true,
        
          ),
      ),
    );
  }

}