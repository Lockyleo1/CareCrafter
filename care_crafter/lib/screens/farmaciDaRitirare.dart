import 'package:care_crafter/main.dart';
import 'package:care_crafter/widgets/custom_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';

class farmaciDaRitirare extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Farmaci Da Ritirare',
      home: farmaci(),
    );
  }
}

class farmaci extends StatefulWidget {
  @override
  _CarouselFarmaci createState() => _CarouselFarmaci();
}

class _CarouselFarmaci extends State<farmaci> {
  final List<ImageInfo> images = [
    ImageInfo(
      title: 'Tachipirina 1000',
      description: 'Prescritta da: Dr. Neri',
      imagePath: 'assets/Immagini_CareCrafter/tachipirina1000.png',
    ),
    ImageInfo(
      title: 'Brufen',
      description: 'Prescritta da: Dr. Bianchi',
      imagePath: 'assets/Immagini_CareCrafter/brufen.png',
    ),
    ImageInfo(
      title: 'Aspirina',
      description: 'Prescritta da: Dr. Rossi',
      imagePath: 'assets/Immagini_CareCrafter/aspirina.png',
    ),
    ImageInfo(
      title: 'Losec',
      description: 'Prescritta da: Dr. Costa',
      imagePath: 'assets/Immagini_CareCrafter/losec.png',
    ),
    ImageInfo(
      title: 'Zocor',
      description: 'Prescritta da: Dr. Gialli',
      imagePath: 'assets/Immagini_CareCrafter/zocor.png',
    ),
    ImageInfo(
      title: 'Clamoxyl',
      description: 'Prescritta da: Dr. Verdi',
      imagePath: 'assets/Immagini_CareCrafter/clamoxyl.png',
    )
  ];

  void removeImage(BuildContext context, ImageInfo image) {
    setState(() {
      images.remove(image);
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePageCareCrafter()),
              );
            }),
        title: Text('I tuoi Farmaci'),
      ),
      body: ListView.builder(
        itemCount: images.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ImageDetailScreen(
                    imageInfo: images[index],
                    onDelete: () => removeImage(context, images[index]),
                  ),
                ),
              );
            },
            child: Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.asset(
                    images[index].imagePath,
                    fit: BoxFit.cover,
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          images[index].title,
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4.0),
                        Text(
                          images[index].description,
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }
}

class ImageDetailScreen extends StatelessWidget {
  final ImageInfo imageInfo;
  final VoidCallback onDelete;

  ImageDetailScreen({required this.imageInfo, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(imageInfo.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imageInfo.imagePath,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: onDelete,
              child: Text('Farmaco Ritirato'),
            ),
          ],
        ),
      ),
    );
  }
}

class ImageInfo {
  final String title;
  final String description;
  final String imagePath;

  ImageInfo({
    required this.title,
    required this.description,
    required this.imagePath,
  });
}
