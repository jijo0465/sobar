import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';

class Calendar extends StatelessWidget{
  final List<DateTime> holidays;
  const Calendar(this.holidays);
  
  @override
  Widget build(BuildContext context) { 
    return Container(
      child: CalendarCarousel(
        weekendTextStyle: TextStyle(color: Colors.deepOrange[100]),
        showHeaderButton: true,
        headerTextStyle: TextStyle(color: Colors.white.withOpacity(0.9),fontSize: 25,),
        leftButtonIcon: Icon(CupertinoIcons.left_chevron,size: 25,color: Colors.white,),
        rightButtonIcon: Icon(CupertinoIcons.right_chevron,size: 25,color: Colors.white ),
        markedDateIconBorderColor: Colors.red,
        weekdayTextStyle: TextStyle(color: Colors.deepOrange[300]),
        markedDatesMap: getEventList(),
        markedDateShowIcon: true,
        markedDateMoreShowTotal: null,
        markedDateIconMaxShown: 1,
        daysTextStyle: TextStyle(color: Colors.white),
        markedDateIconBuilder: (event){
          return event.icon;
        },
        markedDateIconMargin: 0,
        isScrollable: true,
        headerTitleTouchable: false,
        daysHaveCircularBorder: true,
        todayButtonColor: Colors.green,
        todayBorderColor: Colors.green,
        headerMargin: EdgeInsets.all(8),
        height: MediaQuery.of(context).size.height/1.8,
        width: MediaQuery.of(context).size.width/1.25,
        ),
    );
  }

  EventList<Event> getEventList(){
    EventList<Event> eventList=EventList<Event>(events: {});
    for(int i=0;i<holidays.length;i++){
      eventList.add(holidays[i], Event(
        date: holidays[i],
        icon: setIcon(holidays[i].day.toString())
      ));
    }
    return eventList;
  }

  Widget setIcon(String day){
    return Container(
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.all(Radius.circular(1000))
      ),
      child: Center(
        child: Text(day,style: TextStyle(
          color: Colors.white
        ),),
      ),
    );
  }
}