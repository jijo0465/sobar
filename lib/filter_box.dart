import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:avatar_glow/avatar_glow.dart';

class AnimatedFab extends StatefulWidget {
  final void Function(String) onTap;
  const AnimatedFab({Key key, this.onTap}) : super(key: key);
  @override
  _AnimatedFabState createState() =>  _AnimatedFabState();
}

class _AnimatedFabState extends State<AnimatedFab>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<Color> _colorAnimation;
  static String filtered="bevco";
  final double expandedSize = 180.0;
  final double hiddenSize = 20.0;

  @override
  void initState() {
    super.initState();
    _animationController =  AnimationController(
        vsync: this, duration: Duration(milliseconds: 200));
    _colorAnimation =  ColorTween(begin: Colors.deepOrange, end: Colors.deepOrange[800])
        .animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  SizedBox(
      width: expandedSize,
      height: expandedSize,
      child:  AnimatedBuilder(
        animation: _animationController,
        builder: (BuildContext context, Widget child) {
          return  Stack(
            alignment: Alignment.center,
            children: <Widget>[
              _buildExpandedBackground(),
              _buildOption(Icons.local_bar, 0.0,"bar"),
              _buildOption(Icons.terrain, -math.pi / 2,"bevco"),
              _buildOption(Icons.access_time, -2 * math.pi / 2,"toddy"),
              _buildFabCore(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildOption(IconData icon, double angle,String tappedIcon) {
    if (_animationController.isDismissed) {
      return Container();
    }
    double iconSize = 0.0;
    if (_animationController.value > 0.8) {
      iconSize = 26.0 * (_animationController.value - 0.8) * 5;
    }
    
    return  Transform.rotate(
      angle: angle,
      child:  Align(
        alignment: Alignment.topCenter,
        child:  Padding(
          padding:  EdgeInsets.only(top: 8.0),
          child:  IconButton(
            onPressed: (){
              filtered=tappedIcon;
              widget.onTap(tappedIcon);
              close();
              },
            icon:  Transform.rotate(
              angle: -angle,
              child:  (filtered==tappedIcon)?
              AvatarGlow(
                startDelay: Duration(milliseconds: 300),
                glowColor: Colors.orange[200],
                endRadius: 90.0,
                duration: Duration(milliseconds: 1200),
                repeat: false,
                showTwoGlows: true,
                child: Icon(
                icon,
                color: Colors.orange[200],
              ),
              )
              :Icon(
                icon,
                color: Colors.white,
              ),
            ),
            iconSize: iconSize,
            alignment: Alignment.center,
            padding:  EdgeInsets.all(0.0),
          ),
        ),
      ),
    );
  }
  Widget _buildExpandedBackground() {
    double size =
        hiddenSize + (expandedSize - hiddenSize) * _animationController.value;
    return  Container(
      height: size,
      width: size,
      decoration:  BoxDecoration(shape: BoxShape.circle, color: Colors.deepOrange),
    );
  }

  Widget _buildFabCore() {
    double scaleFactor = 2 * (_animationController.value - 0.5).abs();
    return  FloatingActionButton(
      onPressed: _onFabTap,
      child:  Transform(
        alignment: Alignment.center,
        transform:  Matrix4.identity()..scale(1.0, scaleFactor),
        child:  Icon(
          _animationController.value > 0.5 ? Icons.close : Icons.filter_list,
          color: Colors.white,
          size: 26.0,
        ),
      ),
      backgroundColor: _colorAnimation.value,
    );
  }

  open() {
    if (_animationController.isDismissed) {
      _animationController.forward();
    }
  }

  close() {
    if (_animationController.isCompleted) {
      _animationController.reverse();
    }
  }

  _onFabTap() {
    if (_animationController.isDismissed) {
      open();
    } else {
      close();
    }
  }
}