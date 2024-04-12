import 'package:care_crafter/main.dart';
import 'package:care_crafter/widgets/PdfViewPage.dart';
import 'package:care_crafter/widgets/custom_bottom_navigation_bar.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(FascicoloElettronico());
}

class FascicoloElettronico extends StatelessWidget {
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
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => HomePageCareCrafter()));
          },
        ),
        title: Text('Fascicolo Sanitario'),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future:
            DefaultAssetBundle.of(context).loadString('assets/referti.json'),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          var healthRecords = json.decode(snapshot.data.toString());

          return ListView.builder(
            itemCount: healthRecords == null ? 0 : healthRecords.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.black, width: 1),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
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
                              SizedBox(height: 4),
                              Text(
                                '2023',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 8), // Spazio tra la data e l'icona
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                healthRecords[index]['title'],
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(healthRecords[index]['subtitle']),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.visibility),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        PdfViewPage()));
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }
}
