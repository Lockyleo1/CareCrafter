import 'dart:io';
import 'dart:ui';
import 'package:care_crafter/screens/PetHomePage.dart';
import 'package:care_crafter/screens/appointments.dart';
import 'package:care_crafter/screens/petVaccini.dart';
import 'package:flutter/material.dart';
import 'package:care_crafter/widgets/custom_bottom_navigation_bar.dart';

class PetFSE extends StatelessWidget {
  final String userName;
  final String userImage;

  PetFSE({required this.userName, required this.userImage});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PetCareCrafterPage()),
              );
            },
          ),
          title: Text(userName),
          actions: <Widget>[
            Container(
              child: CircleAvatar(
                radius: 70.0,
                backgroundImage: _getImageProvider(userImage),
              ),
            ),
          ],
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: Stack(
          children: [
            _buildBackgroundImage(),
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
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => PetVaccini(userName: userName,userImage: userImage,)),
                            );
                          },
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
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Appointments()),
                            );
                          },
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
        bottomNavigationBar: CustomBottomNavigationBar(),
      ),
    );
  }

  Widget _buildBackgroundImage() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/Immagini_CareCrafter/fattoria.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
        child: Container(
          color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.7),
        ),
      ),
    );
  }
ImageProvider<Object> _getImageProvider(String imagePath) {
    if (imagePath.contains("assets")) {
      return AssetImage(imagePath);
    } else {
      return FileImage(File(imagePath));
    }
  }
}