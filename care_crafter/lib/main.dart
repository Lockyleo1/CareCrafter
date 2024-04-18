import 'package:care_crafter/screens/vaccini.dart';
import 'package:care_crafter/screens/MapScreen.dart';
import 'package:care_crafter/screens/farmaciDaRitirare.dart';
import 'package:flutter/material.dart';
import 'package:care_crafter/screens/FascicoloSanitario.dart';
import 'package:care_crafter/screens/PetHomePage.dart';
import 'package:care_crafter/screens/appointments.dart';
import 'package:care_crafter/screens/specialista.dart';
import 'package:care_crafter/widgets/custom_bottom_navigation_bar.dart';
import 'package:table_calendar/table_calendar.dart';
import 'models/event.dart';

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
            Spacer(
              flex: 5,
            ),
            Text(
              'Ciao Gianluca',
              style: TextStyle(
                color: Color.fromRGBO(37, 1, 199, 1),
                fontSize: 27,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
                decorationColor: Color.fromARGB(255, 5, 37, 246),
                decorationThickness: 1.5,
              ),
            ),
            Spacer(),
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
          body: Container(
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.black, width: 1)),
            ),
            child: Column(
              children: <Widget>[
                _buildExtendedButton('Vaccini', Icons.vaccines_outlined, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Vaccini()),
                  );
                }),
                SizedBox(height: 10),
                _buildExtendedButton(
                    'Farmaci da ritirare', Icons.add_shopping_cart, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => farmaciDaRitirare()),
                  );
                }),
                SizedBox(height: 10),
                _buildExtendedButton(
                    'Trova le farmacie', Icons.medical_services, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MapScreen()),
                  );
                }),
              ],
            ),
          ),
          isExpanded: _isExpanded,
        ),
      ],
    );
  }

  Widget _buildExtendedButton(
      String text, IconData iconData, VoidCallback onPressed) {
    return Container(
      margin: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border(bottom: BorderSide(color: Colors.blue)),
        color: Color.fromRGBO(200, 230, 255, 1),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Icon(
                  iconData,
                  size: 24,
                  color: Colors.black,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    text,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(width: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHealthRecordButton() {
    return _buildSquareButton('Fascicolo Sanitario',
        "assets/Immagini_CareCrafter/FascicoloElettronico.png", () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => FascicoloElettronico()),
      );
    });
  }

  Widget _buildChatWithSpecialistButton() {
    return _buildSquareButton('Chatta con uno specialista',
        "assets/Immagini_CareCrafter/ChattaConSpecialista.png", () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Specialista()),
      );
    });
  }

  Widget _buildAppointmentButton() {
    return _buildSquareButton(
        'Prendi appuntamento', "assets/Immagini_CareCrafter/Calendar.png", () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Appointments(tipe: 'human')),
      );
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
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(15),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Image.asset(
                  iconData,
                  width: 60,
                  height: 60,
                  color: Colors.black,
                ),
                Text(
                  text,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoundedButton(String text, VoidCallback onPressed) {
    return Container(
      width: 180,
      height: 50,
      margin: EdgeInsets.symmetric(vertical: 10),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          foregroundColor: Color.fromARGB(255, 5, 37, 246),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side: BorderSide(
              color: Color.fromARGB(255, 5, 37, 246),
              width: 1,
            ),
          ),
          padding: EdgeInsets.symmetric(vertical: 10),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: Color.fromARGB(255, 5, 37, 246),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
