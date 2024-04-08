<<<<<<< HEAD
// TODO Implement this library.

=======
>>>>>>> 1fa1af6ae35c639b766d8d539b79a4e0de527c57
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
