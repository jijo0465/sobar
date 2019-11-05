import 'package:flutter/material.dart';

class HolidayBottomSheet extends StatefulWidget{
  final double fullSizeHeight;
  final double persistantBottomSheetHeaderHeight;

  HolidayBottomSheet({@required this.fullSizeHeight, this.persistantBottomSheetHeaderHeight
  });

  @override
  BottomWidgetState createState() => BottomWidgetState();
}


class BottomWidgetState extends State<HolidayBottomSheet> with SingleTickerProviderStateMixin{
  Animation <double> animation;
  AnimationController animationController;
  Offset startPosition;
  //offset from startPosition within drag event of widget's gesture detector
  double dyOffset;
  //boundaries for height of widget (bottom sheet)
  List<double> heights;
  //current height of widget (bottom sheet)
  double height;
  //ScrollController for inner ListView
  ScrollController innerListScrollController;
  //is user scrolling down inner ListView
  bool isInnerScrollDoingDown;

  @override
  void initState(){
    super.initState();
    animationController=AnimationController(vsync: this,duration: Duration(milliseconds: 300));
    animation=Tween<double>(begin: 0.0,end: 0.0).animate(animationController);
    heights = [widget.persistantBottomSheetHeaderHeight, widget.fullSizeHeight];
    height = heights[0];

    //initialize inner list's scroll controller and listen to its changes
    innerListScrollController = ScrollController();
    innerListScrollController.addListener(_scrollOffsetChanged);
    isInnerScrollDoingDown = false;
    dyOffset = 0.0;
  }

  @override
  Widget build(BuildContext context) {
    //GestureDetector can catch drag events only if inner ListView isn't scrollable (only if _getScrollEnabled() returns false)
    return GestureDetector(
      onVerticalDragUpdate: (DragUpdateDetails dragDetails) => dyOffset += dragDetails.delta.dy,
      onVerticalDragStart: (DragStartDetails dragDetails) {
        startPosition = dragDetails.globalPosition;
        dyOffset = 0;
      },
      onVerticalDragEnd: (DragEndDetails dragDetails) => _changeHeight(),
      child: Container(
        height: height,
        color: Colors.blueAccent,
        child: InnerList(
          scrollEnabled: _getInnerScrollEnabled(),
          listViewScrollController: innerListScrollController,
        ),
      ),
    );
  }

  //returns if inner ListView scroll is enabled
  //true if:
  // 1) container's height is height of entire screen
  // 2) inner ListView has not been scrolled down from first element
  bool _getInnerScrollEnabled(){
    bool isFullSize = heights.last == height;
    bool isScrollZeroOffset = innerListScrollController.hasClients ? innerListScrollController.offset == 0.0 && isInnerScrollDoingDown: false;
    bool result = isFullSize && !isScrollZeroOffset;

    //reset isInnerScrollDoingDown
    if(!result) isInnerScrollDoingDown = false;
    return result;
  }


  void _scrollOffsetChanged(){
    if (innerListScrollController.offset < 0.0) {
      isInnerScrollDoingDown = true;
    } else if (innerListScrollController.offset > 0.0){
      isInnerScrollDoingDown = false;
    }

    if (innerListScrollController.offset <= 0.0) {
      setState(() {});
    }
  }

  void _changeHeight() {
    if(dyOffset < 0) {
      setState(() {
        int curIndex = heights.indexOf(height);
        int newIndex = curIndex+1;
        height = newIndex >= heights.length
            ? heights[curIndex]
            : heights[newIndex];
      });
    } else if (dyOffset > 0) {
      setState(() {
        int curIndex = heights.indexOf(height);
        int newIndex = curIndex-1 ;
        height = newIndex < 0
            ? heights[curIndex]
            : heights[newIndex];
      });
    }
  }

  @override
  void dispose(){
    innerListScrollController.removeListener(_scrollOffsetChanged);

    super.dispose();
  }
}

class InnerList extends StatelessWidget{
  final bool scrollEnabled;
  final ScrollController listViewScrollController;

  InnerList({
    @required this.scrollEnabled,
    @required this.listViewScrollController
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text("Upcoming Holidays"),
        Expanded(
          child: holidaysListBuilder(context)
          ),
      ],
    );
  }
  holidaysListBuilder(BuildContext context){
    return ListView.builder(
      controller: listViewScrollController,
            physics: scrollEnabled ? AlwaysScrollableScrollPhysics() : NeverScrollableScrollPhysics(),
            itemBuilder: (context,index){
              return ListTile(title: Text(DateTime.now().toString()),subtitle: Text("Gandhi Jayanthi!"),);
            }
    );
  }
}