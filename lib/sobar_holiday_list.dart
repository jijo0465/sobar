import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:kudians/holidays.dart';
import 'package:intl/intl.dart';
import 'package:kudians/my_flutter_app_icons.dart';

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
              elevation: 0,
              color:  Colors.grey[800].withOpacity(0.8),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                child: Stack(
                  children: <Widget>[
                    Container(
                      height: double.infinity,
                      width: double.infinity,
                      color: Colors.grey[800],
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: Image.asset('assets/no_alcohol.png')),
                    ),
                    ClipRRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 5.5,sigmaY: 5.5),
                        child: Container(
                          height: double.infinity,
                          child: ListTile(
                            enabled: false,
                            title: Padding(
                              padding: const EdgeInsets.only(top:8),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(DateFormat.yMMMMd("en_US").format(holidays[index].date,),style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
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
                                color: Colors.white54
                                ),),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          itemCount: numOfHolidays,
          viewportFraction: 0.8,
          scale: 0.85,
          fade: 0.7,
        );
  }
}
