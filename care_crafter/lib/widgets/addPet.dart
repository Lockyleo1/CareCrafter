import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Pet {
  final String name;
  final String imagePath;

  Pet({required this.name, required this.imagePath});
}

class AddPetPage extends StatefulWidget {
  @override
  _AddPetPageState createState() => _AddPetPageState();
}

class _AddPetPageState extends State<AddPetPage> {
  late File? _image = null; // Inizializzato con null
  TextEditingController _nameController = TextEditingController();
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Aggiungi animale'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _buildImagePicker(),
          SizedBox(height: 20),
          _buildNameTextField(),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (_nameController.text.isNotEmpty && _image != null) {
                final newPet =
                    Pet(name: _nameController.text, imagePath: _image!.path);
                Navigator.pop(context, newPet);
              }
            },
            child: Text('Conferma'),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePicker() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.black),
          color: Colors.grey[200],
        ),
        child: _image != null
            ? Image.file(
                _image!,
                width: 150,
                height: 150,
                fit: BoxFit.cover,
              )
            : Icon(
                Icons.add_a_photo,
                size: 50,
              ),
      ),
    );
  }

  Widget _buildNameTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        controller: _nameController,
        decoration: InputDecoration(
          labelText: 'Nome dell\'animale',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
