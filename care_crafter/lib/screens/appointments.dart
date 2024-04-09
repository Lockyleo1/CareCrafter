import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:care_crafter/event.dart';
import 'package:intl/intl.dart';

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

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  @override
  void dispose() {
    _eventController.dispose();
    super.dispose();
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
              // Pulisce il controller della casella di testo
              _eventController.clear();

              return AlertDialog(
                scrollable: true,
                title: Text("Aggiungi un nuovo appuntamento"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _eventController,
                      decoration: InputDecoration(labelText: 'Titolo'),
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
                              (value) => [...value, Event(_eventController.text, selectedDateTime)],
                              ifAbsent: () => [Event(_eventController.text, selectedDateTime)],
                            );
                            _selectedEvents.value = _getEventsForDay(_selectedDay!);
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
      ),
      body: content(),
    );
  }

  Widget content() {
    return Column(
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
        SizedBox(height: 1.0),
        Expanded(
          child: ValueListenableBuilder<List<Event>>(
            valueListenable: _selectedEvents,
            builder: (context, value, _) {
              value.sort((a, b) => a.dateTime!.compareTo(b.dateTime!));
              return value.length>0 ? ListView.builder(
                itemCount: value.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 4.0,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: ListTile(
                      title: Text(value[index].title),
                      subtitle: Text(value[index].dateTime.toString()),
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
              ) : Text('Nessun appuntamento in data ${_selectedDay!.day}/${_selectedDay!.month}/${_selectedDay!.year}');
            },
          ),
        ),
        SizedBox(height: 1.0), // Aggiungi spazio tra le due sezioni
        Text(
          'Prossimi appuntamenti',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: ValueListenableBuilder<List<Event>>(
            valueListenable: _selectedEvents,
            builder: (context, value, _) {
              final futureAppointments = _getAllFutureAppointments();
              futureAppointments.sort((a, b) => a.dateTime!.compareTo(b.dateTime!));
              return ListView.builder(
                itemCount: futureAppointments.length,
                itemBuilder: (context, index) {
                  final appointment = futureAppointments[index];
                  return Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 4.0,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: ListTile(
                      title: Text(appointment.title),
                      subtitle: Text(DateFormat('dd/MM/yyyy HH:mm').format(appointment.dateTime)),
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
        ),
      ],
    );
  }

  List<Event> _getAllFutureAppointments() {
    // Filtra gli appuntamenti futuri
    List<Event> futureAppointments = events.values.expand((events) => events).where((event) => event.dateTime.isAfter(DateTime.now())).toList();
    
    // Ordina gli appuntamenti per data e ora
    futureAppointments.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    
    return futureAppointments;
  }

  void _editAppointment(BuildContext context, Event event) {
    DateTime selectedDateTime = event.dateTime!; // Salva l'orario attuale dell'evento
    
    _eventController.text = event.title; // Riempie il campo di input con il titolo dell'evento esistente
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          scrollable: true,
          title: Text("Modifica appuntamento"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _eventController,
                decoration: InputDecoration(labelText: 'Nuovo titolo'),
              ),
              SizedBox(height: 8.0),
              Row(
                children: [
                  Expanded(
                    child: Text('Orario attuale: ${DateFormat('HH:mm').format(selectedDateTime)}'),
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
              TextButton(
                onPressed: () {
                  // Aggiorna l'evento con il nuovo titolo e l'orario
                  setState(() {
                    event.title = _eventController.text;
                    event.dateTime = selectedDateTime;
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
      events[_selectedDay!]!.remove(event);
    });
  }
}
