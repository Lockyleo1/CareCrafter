import 'package:flutter/material.dart';
import 'dart:convert';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Health Records App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HealthRecordPage(),
    );
  }
}

class HealthRecordPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fascicolo Sanitario'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              // Navigate back to the homepage
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future:
            DefaultAssetBundle.of(context).loadString('assets/referti.json'),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child:
                  CircularProgressIndicator(), // Visualizza un indicatore di caricamento durante il recupero dei dati
            );
          }

          var healthRecords = json.decode(snapshot.data.toString());

          return ListView.builder(
            itemCount: healthRecords == null ? 0 : healthRecords.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: Color(0xFF58E4FF),
                    border: Border.all(color: Color(0xFF1C448E)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        healthRecords[index]['date'],
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
                title: Text(healthRecords[index]['title']),
                subtitle: Text(healthRecords[index]['subtitle']),
              );
            },
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.account_circle),
              onPressed: () {
                // Navigate to user account page
              },
            ),
          ],
        ),
      ),
    );
  }
}
