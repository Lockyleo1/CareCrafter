import 'package:flutter/material.dart';
import 'widgets/custom_bottom_navigation_bar.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(HomePageCareCrafter());
}

class HomePageCareCrafter extends StatelessWidget {
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
              image: AssetImage('assets/Immagini_CareCrafter/fattoria.png'),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.25),
                  BlendMode.dstATop),
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 100),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildCircularButton(context, 'Fuffy',
                        'assets/Immagini_CareCrafter/Fuffy.png'),
                    SizedBox(width: 30),
                    _buildCircularButton(context, 'Mowgly',
                        'assets/Immagini_CareCrafter/Mowgly.png'),
                  ],
                ),
                SizedBox(height: 50),
                _buildAddUserButton(context),
              ],
            ),
          ),
        ),
        bottomNavigationBar: CustomBottomNavigationBar(),
      ),
    );
  }

  Widget _buildCircularButton(
      BuildContext context, String username, String imagePath) {
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
              border: Border.all(color: Colors.black),
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 10),
          Text(
            username,
            style: TextStyle(
                color: Colors.black,
                decoration: TextDecoration.underline,
                fontSize: 25),
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
          border: Border.all(color: Colors.black),
          color: Colors.transparent,
        ),
        child: Icon(
          Icons.add,
          color: const Color.fromARGB(255, 0, 0, 0),
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


