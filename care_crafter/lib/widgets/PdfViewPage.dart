import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(PdfViewPage());
}

class PdfViewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('PDF Viewer'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: SfPdfViewer.asset('assets/Vaccino.pdf'),
      ),
    );
  }
}
