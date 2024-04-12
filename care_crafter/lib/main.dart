import 'package:care_crafter/screens/MapScreen.dart';
import 'package:care_crafter/screens/PetHomePage.dart';
import 'package:flutter/material.dart';
import 'widgets/custom_bottom_navigation_bar.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePageCareCrafter(),
    );
  }
}

class HomePageCareCrafter extends StatefulWidget {
  @override
  _HomePageCareCrafterState createState() => _HomePageCareCrafterState();
}

class _HomePageCareCrafterState extends State<HomePageCareCrafter> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AppBar(
          elevation: 0,
          toolbarHeight: 60,
          backgroundColor: Color(0xFF58E4FF),
          leading: Padding(
            padding: EdgeInsets.all(4.0),
            child: Container(
              width: 40,
              height: 40,
              padding: EdgeInsets.all(1.0),
              child: Image.asset(
                "assets/Immagini_CareCrafter/LogoBlu.png",
                fit: BoxFit.cover,
              ),
            ),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.all(0),
              child: Container(
                width: 100,
                height: 100,
                child: Image.asset(
                  "assets/Immagini_CareCrafter/logoCareCrafterR.png",
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _buildExpansionPanel(),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                _buildHealthRecordButton(),
                _buildChatWithSpecialistButton(),
                _buildAppointmentButton(),
                _buildPetRecordButton(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }

  Widget _buildExpansionPanel() {
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
      children: [
        ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Menù',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            );
          },
          body: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildRoundedButton('Vaccini', () {
                    print('Vaccines Button clicked');
                  }),
                  SizedBox(width: 25),
                  _buildRoundedButton('Farmaci da ritirare', () {
                    print('Medicines Button clicked');
                  }),
                ],
              ),
              SizedBox(height: 5),
              _buildRoundedButton('Trova una Farmacia', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MapScreen()),
                );
              }),
            ],
          ),
          isExpanded: _isExpanded,
        ),
      ],
    );
  }

  Widget _buildHealthRecordButton() {
    return _buildSquareButton('Fascicolo Sanitario',
        "assets/Immagini_CareCrafter/FascicoloElettronico.png", () {
      print('HealthRecord Button clicked');
    });
  }

  Widget _buildChatWithSpecialistButton() {
    return _buildSquareButton('Chatta con uno specialista',
        "assets/Immagini_CareCrafter/ChattaConSpecialista.png", () {
      print('Chat with Specialist Button clicked');
    });
  }

  Widget _buildAppointmentButton() {
    return _buildSquareButton(
        'Prendi appuntamento', "assets/Immagini_CareCrafter/Calendar.png", () {
      print('Appointment Button clicked');
    });
  }

  Widget _buildPetRecordButton() {
    return _buildSquareButton(
        'Pet Fascicolo', "assets/Immagini_CareCrafter/Veterinario.png", () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PetCareCrafterPage()),
      );
    });
  }

  Widget _buildSquareButton(
      String text, String iconData, VoidCallback onPressed) {
    return Container(
      height: 200,
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF58E4FF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
            side: BorderSide(width: 1, color: Color.fromARGB(255, 5, 37, 246)),
          ),
        ),
        onPressed: onPressed,
        child: Row(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(5),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Image.asset(
                  iconData,
                  width: 100,
                  height: 100,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Center(
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildRoundedButton(String text, VoidCallback onPressed) {
    return Container(
      width: 180,
      height: 70,
      padding: EdgeInsets.symmetric(vertical: 10),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Color.fromARGB(255, 5, 37, 246),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
            side: BorderSide(
                width: 1,
                color:
                    Color.fromARGB(255, 5, 37, 246)), // Aggiungi il bordo qui
          ),
          backgroundColor: Color(0xFF58E4FF),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
