import 'package:flutter/material.dart';

class PetFSE extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {},
          ),
          title: Text(
            'Pet FSE',
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
        ),
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/fattoria.jpg',
                fit: BoxFit.cover,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: Center(
                    child: Text(
                      'Pet-CareCrafter',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 250,
                        child: TextButton.icon(
                          onPressed: () {},
                          icon: Icon(Icons.pets),
                          label: Text(
                            'Pet-Vaccini',
                            style: TextStyle(color: Colors.black),
                          ),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Color(0xFFAED581)),
                            foregroundColor: MaterialStateProperty.all(Colors.white),
                            padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 16, horizontal: 32)),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: BorderSide(color: Color(0xFF2C5D39)),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 100),
                      SizedBox(
                        width: 250,
                        child: TextButton.icon(
                          onPressed: () {},
                          icon: Icon(Icons.local_hospital),
                          label: Text(
                            'Pet-Veterinario',
                            style: TextStyle(color: Colors.black),
                          ),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Color(0xFFAED581)),
                            foregroundColor: MaterialStateProperty.all(Colors.white),
                            padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 16, horizontal: 32)),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: BorderSide(color: Color(0xFF2C5D39)),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 100),
                      SizedBox(
                        width: 250,
                        child: TextButton.icon(
                          onPressed: () {},
                          icon: Icon(Icons.event),
                          label: Text(
                            'Pet-Appuntamenti',
                            style: TextStyle(color: Colors.black),
                          ),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Color(0xFFAED581)),
                            foregroundColor: MaterialStateProperty.all(Colors.white),
                            padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 16, horizontal: 32)),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: BorderSide(color: Color(0xFF2C5D39)),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.account_circle),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}