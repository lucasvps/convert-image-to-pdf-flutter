import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter/services.dart';

class PdfViewerPage extends StatelessWidget {
  final String path;
  final pdf;
  final doc;
  const PdfViewerPage({Key key, this.path, this.doc, this.pdf})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.red),
        backgroundColor: Colors.white,
        actions: <Widget>[
          FlatButton(
              onPressed: () async {
                final ByteData bytes = await rootBundle.load(path);
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
          child: PDFViewer(document: doc),
        ),
      ),
    );

    // PDFViewerScaffold(
    //   //primary: false,
    //   appBar: AppBar(
    //     title: Text(''),
    //     actions: <Widget>[
    //       FlatButton(
    //           onPressed: () async {
    //             // final ByteData bytes = await rootBundle.load(path);
    //             // await Share.file('PDF', 'relatorio.pdf',
    //             //     bytes.buffer.asUint8List(), 'image/png',
    //             //     text: 'My optional text.');
    //           },
    //           child: Icon(
    //             Icons.email,
    //             color: Colors.white,
    //           ))
    //     ],
    //   ),
    //   path: path,
    // );
  }
}
