import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_to_pdf/create_pdf_page.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //var controller = PdfController();

  List<Asset> images = List<Asset>();

  Widget buildGridView() {
    return GridView.count(
      shrinkWrap: false,
      physics: PageScrollPhysics(),
      primary: false,
      crossAxisCount: 3,
      children: List.generate(images.length, (index) {
        Asset asset = images[index];
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: AssetThumb(
            asset: asset,
            width: 150,
            height: 150,
          ),
        );
      }),
    );
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 30,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#ff0000",
          actionBarTitle: "Choose your images",
          allViewTitle: "All Photos",
          useDetailsView: false,
          textOnNothingSelected: "Nothing Selected",
          selectCircleStrokeColor: "#000000",
          statusBarColor: "#ff0000",
        ),
      );
    } on Exception catch (e) {
      print(e.toString());
    }

    if (!mounted) return;
    setState(() {
      images = resultList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Convert Images to PDF",
          style: GoogleFonts.pangolin(color: Colors.red, fontSize: 22),
        ),
        centerTitle: true,
      ),
      body: Container(
          height: MediaQuery.of(context).size.height * 1.5,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        loadAssets();
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.3,
                        child: Card(
                          elevation: 20,
                          shape: RoundedRectangleBorder(
                              side: BorderSide(color: Colors.white, width: 2),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16))),
                          color: Colors.red,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_photo_alternate,
                                size: MediaQuery.of(context).size.width * 0.15,
                                color: Colors.white,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Gallery',
                                  style: GoogleFonts.pangolin(
                                      color: Colors.white, fontSize: 16),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: images.length != 0
                          ? () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CreatePdfPage(
                                            images: images,
                                          )));
                            }
                          : null,
                      child: Container(
                        //height: MediaQuery.of(context).size.height * 0.15,
                        width: MediaQuery.of(context).size.width * 0.3,
                        child: Card(
                          elevation: 20,
                          shape: RoundedRectangleBorder(
                              side: BorderSide(color: Colors.white, width: 2),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16))),
                          color: Colors.red,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.picture_as_pdf,
                                size: MediaQuery.of(context).size.width * 0.15,
                                color: Colors.white,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Create PDF',
                                  style: GoogleFonts.pangolin(
                                      color: Colors.white, fontSize: 16),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          images = [];
                        });
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.3,
                        child: Card(
                          elevation: 20,
                          shape: RoundedRectangleBorder(
                              side: BorderSide(color: Colors.white, width: 2),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16))),
                          color: Colors.red,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.clear,
                                size: MediaQuery.of(context).size.width * 0.15,
                                color: Colors.white,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Remove All',
                                  style: GoogleFonts.pangolin(
                                      color: Colors.white, fontSize: 16),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: Text(
                    "Selected Images : ${images.length}",
                    style:
                        GoogleFonts.pangolin(color: Colors.black, fontSize: 26),
                  ),
                ),
              ),
              Container(
                child: Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      //color: Colors.redAccent,
                      elevation: 50,
                      child: buildGridView(),
                    ),
                  ),
                ),
              )
            ],
          )),
    );
  }
}
