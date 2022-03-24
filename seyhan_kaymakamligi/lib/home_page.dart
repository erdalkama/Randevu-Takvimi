// ignore_for_file: prefer_const_constructors
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:seyhan_kaymakamligi/randevu.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'ekleme.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Color> _colorCollection = <Color>[];
  MeetingDataSource? events;
  final List<String> options = <String>['Delete'];
  final databaseReference = FirebaseFirestore.instance;
  final _firestore = FirebaseFirestore.instance;
  TextEditingController randevuController = TextEditingController();
  TextEditingController baslangicController = TextEditingController();
  TextEditingController bitisController = TextEditingController();
  //selected event
  @override
  void initState() {
    _initializeEventColor();
    getDataFromFireStore().then((results) {
      SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
        setState(() {});
      });
    });
    super.initState();
  }

  Future<void> getDataFromFireStore() async {
    var snapShotsValue = await databaseReference.collection('Event').get();

    final Random random = Random();
    List<Meeting> list = snapShotsValue.docs
        .map((e) => Meeting(
            eventName: e.data()['Subject'],
            from: DateFormat('dd/MM/yyyy HH:mm').parse(e.data()['StartTime']),
            to: DateFormat('dd/MM/yyyy HH:mm').parse(e.data()['EndTime']),
            background: _colorCollection[random.nextInt(18)],
            isAllDay: false))
        .toList();
    setState(() {
      events = MeetingDataSource(list);
    });
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference databaseReference = _firestore.collection('Event');
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          leading: PopupMenuButton<String>(
            icon: Icon(Icons.settings),
            itemBuilder: (BuildContext context) => options.map((String choice) {
              return PopupMenuItem<String>(
                value: choice,
                child: Text(choice),
              );
            }).toList(),
            onSelected: (String value) {
              if (value == "Delete") {
                try {
                  databaseReference.doc().delete();
                } catch (e) {}
              }
            },
          ),
          automaticallyImplyLeading: false,
          backgroundColor: Color.fromARGB(255, 0, 0, 0),
          title: Text(
            'KAYMAKAMLIK TAKVİM',
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
            headerHeight: 30,
            todayHighlightColor: Colors.black,
            allowAppointmentResize: true,
            view: CalendarView.month,
            allowViewNavigation: true,
            dataSource: events,
            firstDayOfWeek: 1,
            allowedViews: const <CalendarView>[
              CalendarView.month,
              CalendarView.week,
              CalendarView.schedule,
            ],
            appointmentTimeTextFormat: 'HH:mm',
            monthViewSettings: MonthViewSettings(
                agendaItemHeight: 100,
                appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
                navigationDirection: MonthNavigationDirection.horizontal,
                showAgenda: true,
                dayFormat: 'EEE'),
            scheduleViewSettings: ScheduleViewSettings(
                //appointmentItemHeight: 60,weekHeaderSettings: WeekHeaderSetti
                ),
            showCurrentTimeIndicator: true,
            showWeekNumber: true,
          )),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.person_add_alt_outlined),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Ekleme()));
        },
        /*onPressed: () async {
          Map<String, dynamic> eventData = {
            'Subject': randevuController.text,
            'StartTime': baslangicController.text,
            'EndTime': bitisController.text,
          };
          await databaseReference.doc(randevuController.text).set(eventData);
        },*/
      ),
    );
  }

  void _initializeEventColor() {
    _colorCollection.add(const Color(0xFF0F8644));
    _colorCollection.add(const Color(0xFF8B1FA9));
    _colorCollection.add(const Color(0xFFD20100));
    _colorCollection.add(const Color(0xFFFC571D));
    _colorCollection.add(const Color(0xFF36B37B));
    _colorCollection.add(const Color(0xFF01A1EF));
    _colorCollection.add(const Color(0xFF3D4FB5));
    _colorCollection.add(const Color(0xFFE47C73));
    _colorCollection.add(const Color(0xFF636363));
    _colorCollection.add(const Color(0xFF0A8043));
    _colorCollection.add(Color.fromARGB(255, 44, 83, 119));
    _colorCollection.add(Color.fromARGB(255, 51, 16, 61));
    _colorCollection.add(Color.fromARGB(255, 255, 153, 0));
    _colorCollection.add(Color.fromARGB(255, 255, 68, 0));
    _colorCollection.add(Color.fromARGB(255, 3, 79, 88));
    _colorCollection.add(Color.fromARGB(255, 1, 17, 239));
    _colorCollection.add(Color.fromARGB(255, 48, 67, 68));
    _colorCollection.add(Color.fromARGB(255, 160, 83, 76));
    _colorCollection.add(Color.fromARGB(255, 48, 47, 47));
    _colorCollection.add(Color.fromARGB(255, 194, 24, 129));
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].isAllDay;
  }

  @override
  String getSubject(int index) {
    return appointments![index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments![index].background;
  }

  @override
  Color getIcon(int index) {
    return appointments![index].iconbutton;
  }
}

class Meeting {
  String? eventName;
  DateTime? from;
  DateTime? to;
  Color? background;
  bool? isAllDay;
  IconButton? iconbutton;

  Meeting(
      {this.eventName,
      this.from,
      this.to,
      this.background,
      this.isAllDay,
      this.iconbutton});
}

  /*Widget build(BuildContext context) {
    CollectionReference homeRef = _firestore.collection('data11');
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
          child:
            StreamBuilder<QuerySnapshot>(
                stream: homeRef.snapshots(),
                builder: (BuildContext context, AsyncSnapshot asyncSnapshot) {
                  if (asyncSnapshot.hasError) {
                    return Center(
                        child: Text('Bir Hata Oluştu, Tekrar Deneyiniz'));
                  } else {
                    if (asyncSnapshot.hasData) {
                      List<DocumentSnapshot> listOfDocumentSnap =
                          asyncSnapshot.data.docs;
                      return Stack(
                        children: [
                          SfCalendar(
                            view: CalendarView.month,
                            allowViewNavigation: true,
                            dataSource: MeetingDataSource(_getDataSource()),
                            firstDayOfWeek: 1,
                            allowedViews: const <CalendarView>[
                              CalendarView.month,
                              CalendarView.week,
                              CalendarView.schedule,
                            ],
                            appointmentTimeTextFormat: 'HH:mm',
                            monthViewSettings: MonthViewSettings(
                                appointmentDisplayMode:
                                    MonthAppointmentDisplayMode.appointment,
                                navigationDirection:
                                    MonthNavigationDirection.horizontal,
                                showAgenda: true,
                                dayFormat: 'EEE'),
                            scheduleViewSettings: ScheduleViewSettings(
                                //appointmentItemHeight: 60,weekHeaderSettings: WeekHeaderSettings(height: 40,textAlign: TextAlign.center)
                                ),
                            showCurrentTimeIndicator: true,
                            showWeekNumber: true,
                          ),
                        ],
                      );
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }
                }),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.more_time_sharp),
          onPressed: () async {
            DatePicker.showDateTimePicker(context,
                showTitleActions: true,
                minTime: DateTime(2022, 3, 5),
                maxTime: DateTime(2032, 6, 7), onChanged: (date) {
              print('change $date');
            }, onConfirm: (date) async {
              
              Map<String, dynamic> data11Data = {
                'date': date,
              };
              await homeRef.doc().set(data11Data);
              print('confirm $date');
            }, currentTime: DateTime.now(), locale: LocaleType.tr);
            /*Map<String, dynamic> data11Data = {
              'dakika': dakikaController.text,
              'adsoyadkonu': adsoyadController.text,
              'saat': saatController.text,
              'ay': ayController.text,
              'yıl': yilController.text,
            };
            await homeRef.doc().set(data11Data);*/
          },
        ));
  }*/

/*List<Meeting> _getDataSource() {
  final List<Meeting> meetings = <Meeting>[];
  final DateTime today = DateTime.now();
  final DateTime startTime =
      DateTime(today.year, today.month, today.day, 9, 3, 0);
  meetings.add(Meeting('Konferans', startTime, const Color(0xFF0F8644)));
  return meetings;
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  String getSubject(int index) {
    return appointments![index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments![index].background;
  }
}

class Meeting {
  Meeting(this.eventName, this.from, this.background);

  String eventName;
  DateTime from;
  Color background;
}*/
