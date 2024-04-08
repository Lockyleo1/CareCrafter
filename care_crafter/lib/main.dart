import 'package:flutter/material.dart';
import 'widgets/custom_bottom_navigation_bar.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(PetCareCrafterPage());
}

class PetCareCrafterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: AppBar(
            toolbarHeight: 60,
            leading: Padding(
              padding: EdgeInsets.all(4.0),
              child: Container(
                width: 40,
                height: 40,
                // Aggiungi padding al logo blu
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
        body: _buildBody(),
        bottomNavigationBar: CustomBottomNavigationBar(),
      ),
    );
  }

  Widget _buildBody() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _buildSquareButton('Fascicolo Sanitario',
                  "assets/Immagini_CareCrafter/FascicoloElettronico.png"),
              _buildSquareButton('Chatta con uno specialista',
                  "assets/Immagini_CareCrafter/ChattaConSpecialista.png"),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _buildSquareButton('Prendi appuntamento',
                  "assets/Immagini_CareCrafter/Calendar.png"),
              _buildSquareButton('Pet Fascicolo',
                  "assets/Immagini_CareCrafter/Veterinario.png"),
            ],
          ),
          SizedBox(height: 20),
          _buildRoundedButton('Vaccini'),
        ],
      ),
    );
  }

  Widget _buildSquareButton(String text, String iconData) {
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
        onPressed: () {
          print('Button clicked: $text');
        },
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
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.account_circle),
                onPressed: () {
                  // Navigate to account page
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCircularButton(BuildContext context, String username, String imagePath) {
    return GestureDetector(
      onTap: () {
        // Handle button tap, for example, navigate to user details page
      },
      child: Column(
        children: [
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 10), // Spazio tra il cerchio e la scritta
          Text(
            username,
            style: TextStyle(color: Colors.black, decoration: TextDecoration.underline, fontSize: 18), // Aumento della dimensione del carattere
          ),
        ],
      ),
    );
  }

  Widget _buildAddUserButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Handle add user button tap, for example, navigate to add user page
      },
      child: Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey,
        ),
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: 50,
        ),
      ),
    );
  }

  Widget _buildRoundedButton(String text) {
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
        onPressed: () {
          print('Button clicked: $text');
        },
        child: Text(
          text,
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
