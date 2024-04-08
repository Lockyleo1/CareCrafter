import 'package:care_crafter/screens/account_screen.dart';
import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {
               Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AccountScreen()),
            );
            },
          ),
          SizedBox(width: 20),
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              // Azione per l'icona di home
            },
          ),
        ],
      ),
    );
  }
}
