import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import '../utils/app_componet.dart';

class ShareScreen extends StatefulWidget {
  const ShareScreen(
      {Key? key, required this.quote, required this.imageIndex, this.imageBytes})
      : super(key: key);

  final String quote;
  final int imageIndex;
  final Uint8List? imageBytes;

  @override
  State<ShareScreen> createState() => _ShareScreenState();
}

class _ShareScreenState extends State<ShareScreen> {
  ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;

    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: [
              Container(
                width: size.width,
                height: size.height * 0.07,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: Icon(Icons.keyboard_arrow_left)),
                    SizedBox(width: 15),
                    Text(
                      "Save and Share",
                      style:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              if(widget.imageBytes == null)
                Screenshot(
                  controller: screenshotController,
                  child: Container(
                    height: size.height * 0.3,
                    width: size.width * 0.7,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(sliderImage[widget.imageIndex]),
                            fit: BoxFit.cover)),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          height: size.height * 0.3,
                          width: size.width * 0.7,
                          color: Colors.black38,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            widget.quote,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              if(widget.imageBytes != null)
                SizedBox(
                  height: size.height * 0.5,
                  width: size.width * 0.6,
                  child: Image.memory(widget.imageBytes!,fit: BoxFit.cover),
                ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () async {
                      PermissionStatus permissionStatus = await Permission
                          .storage.status;

                      if (permissionStatus.isDenied) {
                        await Permission.storage.request();
                      }


                      if (widget.imageBytes == null) {
                        Uint8List? imageBytes = await screenshotController
                            .capture();
                        if (imageBytes != null) {
                          String name =
                              "quote-${DateTime
                              .now()
                              .millisecondsSinceEpoch}";
                          final save = await ImageGallerySaver.saveImage(
                              imageBytes,
                              name: name,
                              quality: 100);


                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Save"),
                                  action: SnackBarAction(
                                      label: "Cancel", onPressed: () {
                                    ScaffoldMessenger.of(context)
                                        .removeCurrentSnackBar();
                                  }))
                          );
                        }
                      }
                      else {
                        String name =
                            "quote-${DateTime
                            .now()
                            .millisecondsSinceEpoch}";
                        final save = await ImageGallerySaver.saveImage(
                            widget.imageBytes!,
                            name: name,
                            quality: 100);

                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Save"),
                                action: SnackBarAction(
                                    label: "Cancel", onPressed: () {
                                  ScaffoldMessenger.of(context)
                                      .removeCurrentSnackBar();
                                }))
                        );
                      }

                        },

                    child: Container(
                      height: 70,
                      width: 70,
                      margin: EdgeInsets.only(right: 5),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Color(0xffffb574),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(height: 5),
                          Icon(Icons.arrow_downward_rounded),
                          Text("Save"),
                          SizedBox(height: 5),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      final directory = await getExternalStorageDirectory();

                      if(widget.imageBytes == null) {

                        final bytes = await screenshotController.capture();

                        final image = File(
                            "${directory!.absolute.path}/Quote-${DateTime
                                .now()
                                .millisecondsSinceEpoch}.png");
                        image.writeAsBytesSync(bytes!);

                        await Share.shareFiles([image.path]);
                      } else {
                        final image = File(
                            "${directory!.absolute.path}/Quote-${DateTime
                                .now()
                                .millisecondsSinceEpoch}.png");
                        image.writeAsBytesSync(widget.imageBytes!);

                        await Share.shareFiles([image.path]);
                      }


                    },
                    child: Container(
                      height: 70,
                      width: 70,
                      margin: EdgeInsets.only(left: 5),
                      decoration: BoxDecoration(
                        color: Color(0xffce8cf8),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(height: 5),
                          Icon(Icons.share),
                          Text("Save"),
                          SizedBox(height: 5),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ],
          )),
    );
  }
}
