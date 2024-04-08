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

class HomePageCareCrafter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AppBar(
          toolbarHeight: 60,
          leading: Padding(
            padding: EdgeInsets.all(4.0),
            child: Container(
              width: 40,
              height: 40,
              padding: EdgeInsets.all(3.0),
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
      body: _buildBody(context),
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _buildHealthRecordButton(),
              _buildChatWithSpecialistButton(),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _buildAppointmentButton(),
              _buildPetRecordButton(),
            ],
          ),
          SizedBox(height: 20),
          _buildVaccinesButton(),
        ],
      ),
    );
  }

  Widget _buildHealthRecordButton() {
    return _buildSquareButton('Fascicolo Sanitario',
        "assets/Immagini_CareCrafter/FascicoloElettronico.png", () {
      print('Fascicolo elettronico Button clicked');
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
      print('Pet Fascicolo Button clicked');
    });
  }

  Widget _buildVaccinesButton() {
    return _buildRoundedButton('Vaccini',() {
      print('Vaccines Button clicked');
    });
  }

  Widget _buildSquareButton(
      String text, String iconData, VoidCallback onPressed) {
    return Container(
      width: 150,
      height: 150,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF58E4FF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: BorderSide(color: Color(0xFF1C448E)),
          ),
        ),
        onPressed: onPressed,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Image.asset(
                iconData,
                width: 50,
                height: 50,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 10),
            Text(
              text,
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoundedButton(String text, VoidCallback onPressed) {
    return Container(
      width: 200,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF58E4FF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
            side: BorderSide(color: Color(0xFF1C448E)),
          ),
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
