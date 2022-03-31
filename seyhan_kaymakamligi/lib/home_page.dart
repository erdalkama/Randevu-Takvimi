// ignore_for_file: prefer_const_constructors
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:seyhan_kaymakamligi/kullanici_adi.dart';
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
  final List<String> options = <String>[
    'SİL', /*'GÜNCELLE'*/
  ];
  final databaseReference = FirebaseFirestore.instance;
  final logReference = FirebaseFirestore.instance;
  final _firestore = FirebaseFirestore.instance;
  TextEditingController randevuController = TextEditingController();
  TextEditingController baslangicController = TextEditingController();
  TextEditingController bitisController = TextEditingController();
  Meeting? _selectedAppointment;
  @override
  void initState() {
    _selectedAppointment = null;
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
            id: e.id,
            eventName: e.data()['Subject'],
            from: DateFormat('yyyy-MM-dd HH:mm').parse(e.data()['StartTime']),
            to: DateFormat('yyyy-MM-dd HH:mm').parse(e.data()['EndTime']),
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
    CollectionReference logReference = _firestore.collection('SilenKisi');
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          leading: PopupMenuButton<String>(
            icon: Icon(Icons.delete_forever),
            itemBuilder: (BuildContext context) => options.map((String choice) {
              return PopupMenuItem<String>(
                value: choice,
                child: Text(choice),
              );
            }).toList(),
            onSelected: (String value) {
              if (value == "SİL") {
                try {
                  if (_selectedAppointment != null) {
                    events!.appointments?.removeAt(
                        events!.appointments!.indexOf(_selectedAppointment));
                    events!.notifyListeners(CalendarDataSourceAction.remove,
                        <Meeting>[_selectedAppointment!]);

                    databaseReference.doc(_selectedAppointment?.id).delete();
                    Map<String, dynamic> deleteData = {
                      'silenKisi': Kullanicikaydi.email,
                      'silmeZamanı': DateTime.now(),
                      'KonuAdi': _selectedAppointment!.eventName,
                      'EtkinlikBaşlangıçTarihi': _selectedAppointment!.from,
                      'EtkinlikBitişTarihi': _selectedAppointment!.to,
                    };
                    logReference.doc().set(deleteData);
                  } else if (_selectedAppointment == null) {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                              title: Text("SİLİNEMİYOR"),
                              content: Text(
                                  "Lüften takvim üzerinde bulunan randevuyu seçtikten sonra sil butonuna tıklayınız."),
                              actions: [
                                // ignore: deprecated_member_use
                                FlatButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text("Tamam"))
                              ]);
                        });
                  }
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
            onTap: calendarTapped,
            headerHeight: 30,
            todayHighlightColor: Colors.black,
            view: CalendarView.month,
            allowViewNavigation: true,
            dataSource: events,
            firstDayOfWeek: 1,
            showDatePickerButton: true,
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

  void calendarTapped(CalendarTapDetails calendarTapDetails) {
    if ((calendarTapDetails.appointments!.isNotEmpty) &&
        (calendarTapDetails.targetElement == CalendarElement.agenda ||
            calendarTapDetails.targetElement == CalendarElement.appointment)) {
      final Meeting appointment = calendarTapDetails.appointments![0];
      _selectedAppointment = appointment;
    }
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
  String getId(int index) {
    return appointments![index].id;
  }
  @override
  Color getColor(int index) {
    return appointments![index].background;
  }
}
class Meeting {
  String? eventName;
  DateTime? from;
  DateTime? to;
  Color? background;
  bool? isAllDay;
  String? id;
  Meeting(
      {this.eventName,
      this.from,
      this.to,
      this.background,
      this.isAllDay,
      this.id});
}
