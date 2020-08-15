import 'dart:io';

import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';

class PdfViewerPage extends StatefulWidget {
  final doc;
  final File file;
  const PdfViewerPage({Key key,this.doc, this.file})
      : super(key: key);

  @override
  _PdfViewerPageState createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.red),
        backgroundColor: Colors.white,
        actions: <Widget>[
          FlatButton(
              onPressed: () async {
                final bytes = (widget.file).readAsBytesSync();
                await Share.file(
                  'PDF',
                  'imagesToPdf.pdf',
                  bytes.buffer.asUint8List(),
                  'application/pdf',
                );
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.share,
                    color: Colors.red,
                    size: 24,
                  ),
                  Text('Share')
                ],
              )),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          elevation: 50,
          child: PDFViewer(document: widget.doc),
        ),
      ),
    );
  }
}
