class Event {
  String title;
  DateTime dateTime;
  String doctor;
  String location;

  Event(this.title, this.dateTime, this.doctor, this.location);
  
  @override
  String toString() => title;
}
