import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'widgets/custom_bottom_navigation_bar.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(PetVaccini());
}

class PetVaccini extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PetVaccini',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: VacineRecordPage(),
    );
  }
}

class VacineRecordPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Navigate back to the homepage
          },
        ),
        title: Text('Pet Vaccini'),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: DefaultAssetBundle.of(context)
            .loadString('assets/PetVaccini.json'),
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
                        bottom: BorderSide(
                            color: Colors.black,
                            width: 1), // Aggiunge una linea nera in basso
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(174, 213, 129, 1),
                            border: Border.all(color: Color(0xff2C5D39)),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                healthRecords[index]['date'],
                                style: TextStyle(color: Colors.black),
                              ),
                              SizedBox(
                                  height:
                                      4), // Spazio tra la data e l'anno
                              Text(
                                '2023',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12), // Stile per l'anno
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                            width:
                                8), // Spazio tra la data e l'icona
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
                          icon: Icon(Icons.visibility), // Icona dell'occhio
                          onPressed: () {
                            // Apri il PDF
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PdfViewerPage(
                                  pdfAssetPath:
                                      'assets/Vaccino.pdf',
                                ),
                              ),
                            );
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

class PdfViewerPage extends StatelessWidget {
  final String pdfAssetPath;

  PdfViewerPage({required this.pdfAssetPath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Viewer'),
      ),
      body: PDFView(
        filePath: pdfAssetPath,
        enableSwipe: true,
        swipeHorizontal: false,
      ),
    );
  }
}
