import 'package:care_crafter/main.dart';
import 'package:care_crafter/widgets/custom_bottom_navigation_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kommunicate_flutter/kommunicate_flutter.dart';

void main() {
  runApp(const Specialista());
}

class Specialista extends StatelessWidget {
  const Specialista({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'specialista',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    startConversation();
  }

  void startConversation() {
    dynamic conversationObject = {
      'appId': '2f19c9ee0a7721af07ab4487897ee436e',
    };

    KommunicateFlutterPlugin.buildConversation(conversationObject)
        .then((clientConversationId) {
      if (kDebugMode) {
        print("Conversation builder success : $clientConversationId");
      }
    }).catchError((error) {
      if (kDebugMode) {
        print("Conversation builder error : $error");
      }
    });
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
          },
        ),
        title: Text('Parla con specialista'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'Chat con i dottori in attivazione...',
          style: TextStyle(fontSize: 20),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }
}
