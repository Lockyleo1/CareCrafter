import 'package:care_crafter/main.dart';
import 'package:care_crafter/screens/PetHomePage.dart';
import 'package:care_crafter/screens/petFSE.dart';
import 'package:care_crafter/widgets/PdfViewPage.dart';
import 'package:care_crafter/widgets/custom_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'dart:convert';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PetVaccini(userName: 'Mowgly',userImage: 'assets/Immagini_CareCrafter/Mowgly.png'),
    );
  }
}

class PetVaccini extends StatelessWidget {

  final String userName;
  final String userImage;

  PetVaccini({required this.userName, required this.userImage});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Health Records App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HealthRecordPage(userName: userName,userImage: userImage,),
    );
  }
}

class HealthRecordPage extends StatelessWidget {
  final String userName;
  final String userImage;

  HealthRecordPage({required this.userName, required this.userImage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
           onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PetFSE(userName:userName, userImage:userImage),
      ),
    );

           }),
        title: Text('PetVaccini'),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: DefaultAssetBundle.of(context).loadString('assets/PetVaccini.json'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Errore nel caricamento dei dati'),
            );
          } else {
            var healthRecords = json.decode(snapshot.data.toString());

            return ListView.separated(
              itemCount: healthRecords.length,
              separatorBuilder: (BuildContext context, int index) => Divider(),
              itemBuilder: (context, index) {
                return ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  leading: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Color(0xFFAED581) ,
                      border: Border.all(color:Color(0xFF2C5D39)),
                      borderRadius: BorderRadius.circular(10),
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
                            color: Colors.black,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  title: Text(
                    healthRecords[index]['title'],
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(healthRecords[index]['subtitle']),
                  trailing: IconButton(
                    icon: Icon(Icons.visibility),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PdfViewPage()),
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }
}
