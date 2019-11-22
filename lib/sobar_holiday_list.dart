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
            return Card(
              elevation: 6,
              color:  Colors.white.withOpacity(0.14),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                child: ListTile(
                  title: Padding(
                    padding: const EdgeInsets.only(top:8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(DateFormat.yMMMMd("en_US").format(holidays[index].date,),style: TextStyle(
                          color: Colors.deepOrange.withOpacity(0.6),
                          fontSize: 18,
                          fontWeight: FontWeight.w600
                        ),),
                        Text(DateFormat.EEEE("en_US").format(holidays[index].date),style: TextStyle(
                          fontSize: 13,
                          color: Colors.white.withOpacity(0.6)
                        ),),
                      ],
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(holidays[index].reason=='Month First'?'First of '+DateFormat.MMMM("en_US").format(holidays[index].date):holidays[index].reason,style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Colors.black
                      ),),
                  ),
                ),
              ),
            );
          },
          itemCount: numOfHolidays,
          viewportFraction: 0.75,
          scale: 0.8,
          fade: 0.8,
        );
  }
}
