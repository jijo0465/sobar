import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:kudians/holidays.dart';
import 'package:intl/intl.dart';

class SobarHolidayList extends StatelessWidget {
  final List<Holidays> holidays;
  final int numOfHolidays;
  const SobarHolidayList({Key key, @required this.holidays,@required this.numOfHolidays}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Swiper(
          loop: false,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                color: Colors.orange[300],
              ),
              child: ListTile(
                title: Padding(
                  padding: const EdgeInsets.only(top:8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(DateFormat.yMMMMd("en_US").format(holidays[index].date,),style: TextStyle(
                        color: Colors.red[700],
                        fontSize: 18,
                        fontWeight: FontWeight.w600
                      ),),
                      Text(DateFormat.EEEE("en_US").format(holidays[index].date),style: TextStyle(
                        fontSize: 13
                      ),),
                    ],
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(holidays[index].reason=='Month First'?'First of '+DateFormat.MMMM("en_US").format(holidays[index].date):holidays[index].reason,style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    fontStyle: FontStyle.italic,
                    color: Colors.black87
                    ),),
                ),
              ),
            );
          },
          itemCount: numOfHolidays,
          viewportFraction: 0.7,
          scale: 0.8,
          fade: 0.8,
        );
  }
}
