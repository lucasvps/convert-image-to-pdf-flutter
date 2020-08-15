import 'dart:io';

import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:image_to_pdf/pdf_viewer.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:google_fonts/google_fonts.dart';

class CreatePdfPage extends StatefulWidget {
  final List<Asset> images;
  const CreatePdfPage({Key key, this.images}) : super(key: key);

  @override
  _CreatePdfPageState createState() => _CreatePdfPageState();
}

class _CreatePdfPageState extends State<CreatePdfPage> {
  List<File> fileImageArray = [];

  void converToFile() {
    widget.images.forEach((imageAsset) async {
      final filePath =
          await FlutterAbsolutePath.getAbsolutePath(imageAsset.identifier);

      File tempFile = File(filePath);
      if (tempFile.existsSync()) {
        fileImageArray.add(tempFile);
        //print("LENGTH : " + fileImageArray.length.toString());
        //print(fileImageArray[0]);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    converToFile();
  }

  createPdf(context) async {
    final pw.Document pdf = pw.Document(deflate: zlib.encode);

    var size = MediaQuery.of(context).size;

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a5.copyWith(marginTop: 0),
        margin: pw.EdgeInsets.fromLTRB(16, 16, 16, 16),
        build: (context) {
          return <pw.Widget>[
            //! THIS IS WORKING
            pw.Wrap(
              direction: pw.Axis.horizontal,
              children: List<pw.Widget>.generate(
                  fileImageArray.length,
                  (int n) => pw.Container(
                      alignment: pw.Alignment.center,
                      width: size.width,
                      height: size.height * 0.4,
                      child: pw.Padding(
                          padding: pw.EdgeInsets.only(bottom: 10),
                          child: pw.Image(
                            PdfImage.file(pdf.document,
                                bytes: File(fileImageArray[n].path)
                                    .readAsBytesSync()),
                          )))),
            ),
            //!
          ];
        },
      ),
    );

    final String dir = (await getApplicationDocumentsDirectory()).path;
    //final String dir = (await getTemporaryDirectory()).path;
    final String path = '$dir/images.pdf';
    final File file = File(path);
    await file.writeAsBytes(pdf.save(), flush: true);

    // await Printing.layoutPdf(
    //     onLayout: (PdfPageFormat format) async => pdf.save());

    PDFDocument doc = await PDFDocument.fromFile(file);

    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (_) => PdfViewerPage(
                file: file,
                doc: doc,
              )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.red),
        title: Text(
          'View PDF',
          style: GoogleFonts.pangolin(color: Colors.red, fontSize: 22),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: GestureDetector(
              onTap: () {
                createPdf(context);
              },
              child: Container(
                height: MediaQuery.of(context).size.height * 0.25,
                width: MediaQuery.of(context).size.width * 0.5,
                child: Card(
                  elevation: 20,
                  shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.white, width: 2),
                      borderRadius: BorderRadius.all(Radius.circular(16))),
                  color: Colors.red,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.picture_as_pdf,
                        size: MediaQuery.of(context).size.width * 0.2,
                        color: Colors.white,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'View PDF',
                          style: GoogleFonts.pangolin(
                              color: Colors.white, fontSize: 24),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
