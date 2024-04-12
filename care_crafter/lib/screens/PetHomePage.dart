import 'dart:io';
import 'dart:ui';
import 'package:care_crafter/screens/petFSE.dart';
import 'package:care_crafter/widgets/addPet.dart';
import 'package:care_crafter/widgets/custom_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';

class PetCareCrafterPage extends StatefulWidget {
  @override
  _PetCareCrafterPageState createState() => _PetCareCrafterPageState();
}

class _PetCareCrafterPageState extends State<PetCareCrafterPage> {
  final List<String> imagePaths = [
    'assets/Immagini_CareCrafter/Fuffy.png',
    'assets/Immagini_CareCrafter/Mowgly.png',
  ];

  List<String> petNames = ['Fuffy', 'Mowgly'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PetCareCrafter'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          _buildBackgroundImage(),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 200.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  _buildPetCarousel(context),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AddPetPage()),
                      ).then((newPet) {
                        setState(() {
                          petNames.add(newPet.name);
                          imagePaths.add(newPet.imagePath);
                        });
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.black,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text('Aggiungi animale'),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(),
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

  Widget _buildPetCarousel(BuildContext context) {
    return Expanded(
      child: Align(
        alignment: Alignment.center,
        child: SizedBox(
          height: 200,
          child: PageView.builder(
            itemCount: imagePaths.length,
            itemBuilder: (context, index) {
              return _buildCircularButton(
                  context, petNames[index], imagePaths[index]);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCircularButton(
      BuildContext context, String username, String imagePath) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PetFSE(userName: username, userImage: imagePath)),
        );
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
                image: _getImageProvider(imagePath),
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
              fontSize: 25,
            ),
          ),
        ],
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
