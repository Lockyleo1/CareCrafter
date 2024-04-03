import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(PetCareCrafterPage());
}

class PetCareCrafterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Text('PetCareCrafter'),
          centerTitle: true,
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/fattoria.jpg'),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.dstATop), // Trasparenza al 50%
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 100), // Spazio aggiunto sopra i cerchi
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildCircularButton(context, 'fuffy', 'assets/images/cANE1.png'),
                    SizedBox(width: 20), // Spazio tra i cerchi
                    _buildCircularButton(context, 'mowgly', 'assets/images/CareCrafter.jpeg'),
                  ],
                ),
                SizedBox(height: 50), // Spazio tra i cerchi e il pulsante "Aggiungi utente"
                _buildAddUserButton(context),
              ],
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
}
