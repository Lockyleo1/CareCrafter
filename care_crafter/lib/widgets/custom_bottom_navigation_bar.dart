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
              // Azione per l'icona dell'account
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