// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'randevu.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Color.fromARGB(255, 0, 0, 0),
          title: Text(
            'STAJ PROJESİ',
            style: TextStyle(
              fontWeight: FontWeight.w700,
            ),
          ),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Bekleyenler()));
              },
              icon: Icon(
                Icons.date_range_rounded,
              ),
            )
          ]),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/seyhan_logo_3.png"),
            colorFilter: const ColorFilter.mode(
                Color.fromARGB(29, 114, 114, 114), BlendMode.modulate),
            fit: BoxFit.scaleDown,
          ),
        ),
        child: SfCalendar(
          view: CalendarView.month,
          firstDayOfWeek: 1,
          allowedViews: const <CalendarView>[
            CalendarView.month,
            CalendarView.week,
            CalendarView.schedule,
          ],
          appointmentTimeTextFormat: 'HH:mm',
          monthViewSettings: MonthViewSettings(
              appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
              navigationDirection: MonthNavigationDirection.horizontal,
              showAgenda: true,
              dayFormat: 'EEE'),
          scheduleViewSettings: ScheduleViewSettings(
              //appointmentItemHeight: 60,weekHeaderSettings: WeekHeaderSettings(height: 40,textAlign: TextAlign.center)
              ),

          showCurrentTimeIndicator: true,
          showWeekNumber: true,
          //dataSource: getCalendarDataSource(),
        ),
      ),
    );
  }
}
