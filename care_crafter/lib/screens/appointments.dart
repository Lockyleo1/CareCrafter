import 'dart:convert' show json;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:care_crafter/models/event.dart';
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
    Map<String, dynamic> jsonData = await readJsonData();
    setState(() {
      doctors = List<String>.from(jsonData['doctors']);
      locations = List<String>.from(jsonData['locations']);
      appointmentTitles = List<String>.from(jsonData['appointmentTitles']);
    });
  }

  Future<Map<String, dynamic>> readJsonData() async {
    String data =
        await DefaultAssetBundle.of(context).loadString('assets/data.json');
    return json.decode(data);
  }

  List<Event> _getEventsForDay(DateTime day) {
    return events[day] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _selectedEvents.value = _getEventsForDay(selectedDay);
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
          showDialog(
            context: context,
            builder: (context) {
              String? _selectedDoctor = null;
              String? _selectedLocation = null;
              String? _selectedAppointmentTitle = null;
              _eventController.clear();

              return AlertDialog(
                scrollable: true,
                title: Text("Aggiungi un nuovo appuntamento"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<String>(
                      value: _selectedAppointmentTitle,
                      onChanged: (value) {
                        setState(() {
                          _selectedAppointmentTitle = value;
                        });
                      },
                      items: appointmentTitles.map((title) {
                        return DropdownMenuItem<String>(
                          value: title,
                          child: Text(title),
                        );
                      }).toList(),
                      isExpanded: true,
                      decoration: InputDecoration(
                        labelText: 'Titolo',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 8.0),
                    DropdownButtonFormField<String>(
                      value: _selectedDoctor,
                      onChanged: (value) {
                        setState(() {
                          _selectedDoctor = value;
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
                        showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        ).then((selectedTime) {
                          if (selectedTime != null) {
                            DateTime selectedDateTime = DateTime(
                              _selectedDay!.year,
                              _selectedDay!.month,
                              _selectedDay!.day,
                              selectedTime.hour,
                              selectedTime.minute,
                            );
                            events.update(
                              _selectedDay!,
                              (value) => [
                                ...value,
                                Event(
                                    _selectedAppointmentTitle!,
                                    selectedDateTime,
                                    _selectedDoctor!,
                                    _selectedLocation!)
                              ],
                              ifAbsent: () => [
                                Event(
                                    _selectedAppointmentTitle!,
                                    selectedDateTime,
                                    _selectedDoctor!,
                                    _selectedLocation!)
                              ],
                            );
                            _selectedEvents.value =
                                _getEventsForDay(_selectedDay!);
                            Navigator.of(context).pop();
                          }
                        });
                      },
                      child: Text('Scegli un orario'),
                    ),
                  ],
                ),
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
          Text(
            'Prossimi appuntamenti',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          ValueListenableBuilder<List<Event>>(
            valueListenable: _selectedEvents,
            builder: (context, value, _) {
              final futureAppointments = _getAllFutureAppointments();
              futureAppointments
                  .sort((a, b) => a.dateTime!.compareTo(b.dateTime!));
              return ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: futureAppointments.length,
                itemBuilder: (context, index) {
                  final appointment = futureAppointments[index];
                  return Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: ListTile(
                      title: Text(appointment.title),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              'Data: ${DateFormat('dd/MM/yyyy').format(appointment.dateTime!)}'),
                          Text(
                              'Ora: ${DateFormat('HH:mm').format(appointment.dateTime!)}'),
                          Text('Dottore: ${appointment.doctor}'),
                          Text('Sede: ${appointment.location}'),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              _editAppointment(context, appointment);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              _deleteAppointment(appointment);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
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
        .where((event) => event.dateTime.isAfter(DateTime.now()))
        .toList();
    futureAppointments.sort((a, b) => a.dateTime.compareTo(b.dateTime));

    return futureAppointments;
  }

  void _editAppointment(BuildContext context, Event event) {
    DateTime selectedDateTime = event.dateTime!;
    String? _selectedAppointmentTitle = event.title;
    String? _selectedDoctor = event.doctor;
    String? _selectedLocation = event.location;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          scrollable: true,
          title: Text("Modifica appuntamento"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: _selectedAppointmentTitle,
                onChanged: (value) {
                  setState(() {
                    _selectedAppointmentTitle = value;
                  });
                },
                items: appointmentTitles.map((title) {
                  return DropdownMenuItem<String>(
                    value: title,
                    child: Text(title),
                  );
                }).toList(),
                isExpanded: true,
                decoration: InputDecoration(
                  labelText: 'Titolo',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 8.0),
              Row(
                children: [
                  Expanded(
                    child: Text(
                        'Orario attuale: ${DateFormat('HH:mm').format(selectedDateTime)}'),
                  ),
                  TextButton(
                    onPressed: () async {
                      final TimeOfDay? pickedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(selectedDateTime),
                      );
                      if (pickedTime != null) {
                        setState(() {
                          selectedDateTime = DateTime(
                            selectedDateTime.year,
                            selectedDateTime.month,
                            selectedDateTime.day,
                            pickedTime.hour,
                            pickedTime.minute,
                          );
                        });
                      }
                    },
                    child: Text('Cambia orario'),
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              DropdownButtonFormField<String>(
                value: _selectedDoctor,
                onChanged: (value) {
                  setState(() {
                    _selectedDoctor = value;
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
                    event.dateTime = selectedDateTime;
                    event.doctor = _selectedDoctor!;
                    event.location = _selectedLocation!;
                  });
                  Navigator.of(context).pop();
                },
                child: Text('Salva modifiche'),
              ),
            ],
          ),
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
