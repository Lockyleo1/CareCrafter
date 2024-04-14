import 'dart:convert' show json;
import 'package:care_crafter/models/event.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Appointments(),
    );
  }
}

class Appointments extends StatefulWidget {
  const Appointments({Key? key});

  @override
  State<Appointments> createState() => _AppointmentsState();
}

class _AppointmentsState extends State<Appointments> {
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime? _selectedDay;
  Map<DateTime, List<Event>> events = {};
  TextEditingController _eventController = TextEditingController();
  late final ValueNotifier<List<Event>> _selectedEvents;
  List<String> doctors = [];
  List<String> locations = [];
  List<String> appointmentTitles = [];
  List<String> specializations = [];
  List<String> availableTimes = [];
  Map<String, dynamic> doctorData = {};

  String? _selectedSpecialization;
  String? _selectedLocation;
  String? _selectedDoctor;
  String? _selectedTime;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
    loadData();
  }

  @override
  void dispose() {
    _eventController.dispose();
    super.dispose();
  }

  void loadData() async {
    Map<String, dynamic> specializationData =
        await readJsonData('assets/tipovisite.json');
    setState(() {
      specializations = List<String>.from(specializationData['tipovisite']);
    });

    Map<String, dynamic> locationData = await readJsonData('assets/sedi.json');
    setState(() {
      locations = List<String>.from(locationData['sedi']);
    });

    doctorData = await readJsonData('assets/dottori.json');

    Map<String, dynamic> timeData =
        await readJsonData('assets/oraridisponibili.json');
    setState(() {
      availableTimes = List<String>.from(timeData['oraridisponibili']);
    });
  }

  Future<Map<String, dynamic>> readJsonData(String path) async {
    String data = await DefaultAssetBundle.of(context).loadString(path);
    return json.decode(data);
  }

  List<Event> _getEventsForDay(DateTime day) {
    return events[day] ?? [];
  }

  List<String> _getAvailableTimesForDayAndDoctor(DateTime day, String doctor) {
    List<String> availableTimesForDoctor = List.from(availableTimes);

    if (events.containsKey(day)) {
      events[day]!.forEach((event) {
        if (event.doctor == doctor) {
          availableTimesForDoctor
              .remove(DateFormat('HH:mm').format(event.dateTime!));
        }
      });
    }

    return availableTimesForDoctor;
  }

  bool isWeekend(DateTime day) {
    return day.weekday == DateTime.saturday || day.weekday == DateTime.sunday;
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay) && !isWeekend(selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _selectedEvents.value = _getEventsForDay(selectedDay);
      });
    }
  }

  void updateDoctorList(String? specialization) {
    if (specialization != null) {
      setState(() {
        _selectedSpecialization = specialization;
        _selectedDoctor = null;
        doctors = List<String>.from(doctorData['dottori'][specialization]);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appuntamenti'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _selectedSpecialization = null;
            _selectedLocation = null;
            _selectedDoctor = null;
            _selectedTime = null;
          });
          showDialog(
            context: context,
            builder: (context) {
              return StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return AlertDialog(
                    scrollable: true,
                    title: Text("Aggiungi un nuovo appuntamento"),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        DropdownButtonFormField<String>(
                          value: _selectedSpecialization,
                          onChanged: (value) {
                            updateDoctorList(value);
                            setState(() {
                              _selectedSpecialization = value;
                              _selectedDoctor = null;
                              _selectedTime = null;
                            });
                          },
                          items: specializations.map((specialization) {
                            return DropdownMenuItem<String>(
                              value: specialization,
                              child: Text(specialization),
                            );
                          }).toList(),
                          isExpanded: true,
                          decoration: InputDecoration(
                            labelText: 'Tipo di visita',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: 8.0),
                        DropdownButtonFormField<String>(
                          value: _selectedLocation,
                          onChanged: (value) {
                            setState(() {
                              _selectedLocation = value;
                              _selectedDoctor = null;
                              _selectedTime = null;
                            });
                          },
                          items: locations.map((location) {
                            return DropdownMenuItem<String>(
                              value: location,
                              child: Text(location),
                            );
                          }).toList(),
                          isExpanded: true,
                          decoration: InputDecoration(
                            labelText: 'Sede',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: 8.0),
                        if (_selectedSpecialization != null &&
                            _selectedLocation != null)
                          DropdownButtonFormField<String>(
                            value: _selectedDoctor,
                            onChanged: (value) {
                              setState(() {
                                _selectedDoctor = value;
                                _selectedTime = null;
                              });
                            },
                            items: doctors.map((doctor) {
                              return DropdownMenuItem<String>(
                                value: doctor,
                                child: Text(doctor),
                              );
                            }).toList(),
                            isExpanded: true,
                            decoration: InputDecoration(
                              labelText: 'Dottore',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        SizedBox(height: 8.0),
                        if (_selectedDoctor != null)
                          DropdownButtonFormField<String>(
                            value: _selectedTime,
                            onChanged: (value) {
                              setState(() {
                                _selectedTime = value;
                              });
                            },
                            items: _getAvailableTimesForDayAndDoctor(
                                    _selectedDay!, _selectedDoctor!)
                                .map((time) {
                              return DropdownMenuItem<String>(
                                value: time,
                                child: Text(time),
                              );
                            }).toList(),
                            isExpanded: true,
                            decoration: InputDecoration(
                              labelText: 'Orario',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        SizedBox(height: 8.0),
                        ElevatedButton(
                          onPressed: () {
                            if (_selectedSpecialization != null &&
                                _selectedLocation != null &&
                                _selectedDoctor != null &&
                                _selectedTime != null) {
                              DateTime selectedDateTime = DateTime(
                                _selectedDay!.year,
                                _selectedDay!.month,
                                _selectedDay!.day,
                                int.parse(_selectedTime!.split(':')[0]),
                                int.parse(_selectedTime!.split(':')[1]),
                              );

                              events.update(
                                _selectedDay!,
                                (value) => [
                                  ...value,
                                  Event(
                                    _selectedSpecialization!,
                                    selectedDateTime,
                                    _selectedDoctor!,
                                    _selectedLocation!,
                                  )
                                ],
                                ifAbsent: () => [
                                  Event(
                                    _selectedSpecialization!,
                                    selectedDateTime,
                                    _selectedDoctor!,
                                    _selectedLocation!,
                                  )
                                ],
                              );

                              _selectedEvents.value =
                                  _getEventsForDay(_selectedDay!);

                              Navigator.of(context).pop();
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Si prega di compilare tutti i campi.'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            }
                          },
                          child: Text('Aggiungi'),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
        child: Icon(Icons.add),
        mini: true,
      ),
      body: ListView(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2000, 1, 1),
            lastDay: DateTime.utc(3000, 1, 1),
            locale: "en_US",
            rowHeight: 45,
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),
            availableGestures: AvailableGestures.all,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            startingDayOfWeek: StartingDayOfWeek.monday,
            onDaySelected: _onDaySelected,
            eventLoader: _getEventsForDay,
            calendarStyle: CalendarStyle(
              outsideDaysVisible: false,
            ),
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
          Divider(color: Colors.black, height: 1.0),
          ValueListenableBuilder<List<Event>>(
            valueListenable: _selectedEvents,
            builder: (context, value, _) {
              value.sort((a, b) => a.dateTime!.compareTo(b.dateTime!));
              return value.length > 0
                  ? Column(
                      children: [
                        Text(
                            'Appuntamenti del ${DateFormat('dd/MM/yyyy').format(_selectedDay!)}',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: value.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 12.0, vertical: 4.0),
                              decoration: BoxDecoration(
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: ListTile(
                                title: Text(value[index].title),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        'Data: ${DateFormat('dd/MM/yyyy').format(value[index].dateTime!)}'),
                                    Text(
                                        'Ora: ${DateFormat('HH:mm').format(value[index].dateTime!)}'),
                                    Text('Dottore: ${value[index].doctor}'),
                                    Text('Sede: ${value[index].location}'),
                                  ],
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.edit),
                                      onPressed: () {
                                        _editAppointment(context, value[index]);
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () {
                                        _deleteAppointment(value[index]);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    )
                  : Text(
                      "Nessun appuntamento in data ${_selectedDay!.day}/${_selectedDay!.month}/${_selectedDay!.year}",
                      textAlign: TextAlign.center);
            },
          ),
          Divider(color: Colors.black, height: 1.0),
          ValueListenableBuilder<List<Event>>(
            valueListenable: _selectedEvents,
            builder: (context, selectedEvents, _) {
              List<Event> allEvents = _getAllFutureAppointments();
              allEvents.sort((a, b) => a.dateTime!.compareTo(b.dateTime!));
              return allEvents.length > 0
                  ? Column(
                      children: [
                        Text(
                          'Prossimi Appuntamenti',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: allEvents.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 12.0, vertical: 4.0),
                              decoration: BoxDecoration(
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: ListTile(
                                title: Text(allEvents[index].title),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        'Data: ${DateFormat('dd/MM/yyyy').format(allEvents[index].dateTime!)}'),
                                    Text(
                                        'Ora: ${DateFormat('HH:mm').format(allEvents[index].dateTime!)}'),
                                    Text('Dottore: ${allEvents[index].doctor}'),
                                    Text('Sede: ${allEvents[index].location}'),
                                  ],
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.edit),
                                      onPressed: () {
                                        _editAppointment(context, allEvents[index]);
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () {
                                        _deleteAppointment(allEvents[index]);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    )
                  : Text(
                      "Nessun appuntamento futuro",
                      textAlign: TextAlign.center,
                    );
            },
          ),
        ],
      ),
    );
  }

  List<Event> _getAllFutureAppointments() {
    List<Event> futureAppointments = events.values
        .expand((events) => events)
        .where((event) => event.dateTime!.isAfter(DateTime.now()))
        .toList();
    futureAppointments.sort((a, b) => a.dateTime!.compareTo(b.dateTime));

    return futureAppointments;
  }

  void _editAppointment(BuildContext context, Event event) {
    DateTime selectedDateTime = event.dateTime!;
    String? _selectedAppointmentTitle = event.title;
    String? _selectedDoctor = event.doctor;
    String? _selectedLocation = event.location;
    List<String> availableTimesForDoctor =
        _getAvailableTimesForDayAndDoctor(selectedDateTime, _selectedDoctor!);

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              scrollable: true,
              title: Text("Modifica appuntamento"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    value: DateFormat('HH:mm').format(selectedDateTime),
                    onChanged: (value) {
                      setState(() {
                        selectedDateTime = DateTime(
                          selectedDateTime.year,
                          selectedDateTime.month,
                          selectedDateTime.day,
                          int.parse(value!.split(':')[0]),
                          int.parse(value.split(':')[1]),
                        );
                      });
                    },
                    items: availableTimesForDoctor.map((time) {
                      return DropdownMenuItem<String>(
                        value: time,
                        child: Text(time),
                      );
                    }).toList(),
                    isExpanded: true,
                    decoration: InputDecoration(
                      labelText: 'Orario',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 8.0),
                  DropdownButtonFormField<String>(
                    value: _selectedDoctor,
                    onChanged: (value) {
                      setState(() {
                        _selectedDoctor = value;
                        availableTimesForDoctor =
                            _getAvailableTimesForDayAndDoctor(
                                selectedDateTime, _selectedDoctor!);
                      });
                    },
                    items: doctors.map((doctor) {
                      return DropdownMenuItem<String>(
                        value: doctor,
                        child: Text(doctor),
                      );
                    }).toList(),
                    isExpanded: true,
                    decoration: InputDecoration(
                      labelText: 'Dottore',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 8.0),
                  DropdownButtonFormField<String>(
                    value: _selectedLocation,
                    onChanged: (value) {
                      setState(() {
                        _selectedLocation = value;
                      });
                    },
                    items: locations.map((location) {
                      return DropdownMenuItem<String>(
                        value: location,
                        child: Text(location),
                      );
                    }).toList(),
                    isExpanded: true,
                    decoration: InputDecoration(
                      labelText: 'Sede',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 8.0),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        event.title = _selectedAppointmentTitle!;
                        event.doctor = _selectedDoctor!;
                        event.location = _selectedLocation!;
                        event.dateTime = selectedDateTime;
                      });
                      _selectedEvents.value = _getEventsForDay(_selectedDay!);
                      Navigator.of(context).pop();
                    },
                    child: Text('Salva modifiche'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _deleteAppointment(Event event) {
    setState(() {
      events.forEach((day, eventsList) {
        eventsList.removeWhere((e) => e == event);
      });
    });
  }
}
