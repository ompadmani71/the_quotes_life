import 'dart:typed_data';
import 'package:amazing_quotes/models/quote_data_model.dart';
import 'package:amazing_quotes/screens/quotes_screen.dart';
import 'package:amazing_quotes/screens/share_screen.dart';
import 'package:amazing_quotes/utils/app_componet.dart';
import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import '../helpers/quotes_db_helper.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({Key? key, required this.id}) : super(key: key);

  final int id;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {

  Quote? quote;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {

       await QuoteDBHelper.quoteDBHelper.fetchSingleData(id: widget.id).then((value) {
        setState(() {
          quote = value;
        });
      });

    });
  }

  ScreenshotController screenshotController = ScreenshotController();

  int fontId = 0;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: (quote != null)
          ? Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Screenshot(
              controller: screenshotController,
              child: Stack(
                children: [
                  SizedBox(
                    height: size.height,
                    width: size.width,
                    child: Image.network(sliderImage[quote!.imageIndex!],fit: BoxFit.cover),
                  ),
                  Container(
                    height: size.height,
                    width: size.width,
                    color: Colors.black45,
                  ),

                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(quote!.quote,
                            textAlign: TextAlign.center,
                            style: quoteFont[fontId]),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "- ${quote!.author}",
                              textAlign: TextAlign.left,
                              style: authorFont[fontId],
                            ),
                            const SizedBox(width: 20),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 15,
              child: Container(
                height: size.height * 0.07,
                width: size.width * 0.9,
                decoration: BoxDecoration(
                    color: Color(0xff252525),
                    borderRadius: BorderRadius.circular(30)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () async {
                        if (quote!.imageIndex! > sliderImage.length - 2) {
                          await QuoteDBHelper.quoteDBHelper.changeImage(
                              imageIndex: 0, quoteID: widget.id);
                        } else {
                          await QuoteDBHelper.quoteDBHelper.changeImage(
                              imageIndex: quote!.imageIndex! + 1,
                              quoteID: quote!.id!);
                        }
                        quote = await QuoteDBHelper.quoteDBHelper
                            .fetchSingleData(id: widget.id);
                        setState(() {});
                      },
                      child: Container(
                        width: size.width * 0.18,
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(
                                    "assets/images/change_image.png"),
                                scale: 22)),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        if(fontId > quoteFont.length - 2){
                          fontId = 0;
                        }else {
                          fontId++;
                        }

                        setState(() {});
                      },
                      child: Container(
                        width: size.width * 0.18,
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage("assets/images/text.png"),
                                scale: 22)),
                      ),
                    ),
                    InkWell(
                      onTap: () async {

                        Uint8List? imageBytes = await screenshotController.capture();

                        if(imageBytes != null){
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ShareScreen(
                                imageIndex: 0,
                                quote: "",
                                imageBytes: imageBytes,
                              )));
                        }


                      },
                      child: Ink(
                        child: Container(
                          width: size.width * 0.18,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage("assets/images/share.png"),
                                  scale: 22)),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () async {

                        Uint8List? imageBytes = await screenshotController.capture();

                        if(imageBytes != null){
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ShareScreen(
                                imageIndex: 0,
                                quote: "",
                                imageBytes: imageBytes,
                              )));
                        }
                      },
                      child: Container(
                        width: size.width * 0.18,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage("assets/images/save.png"),
                                scale: 22)),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        if (quote!.isLike == "True") {
                          await QuoteDBHelper.quoteDBHelper
                              .unLikeQuote(quoteID: quote!.id!);
                        } else {
                          await QuoteDBHelper.quoteDBHelper
                              .likeQuote(quoteID: quote!.id!);
                        }
                        quote = await QuoteDBHelper.quoteDBHelper
                            .fetchSingleData(id: widget.id);
                        setState(() {});
                      },
                      child: Ink(
                        child: Container(
                          width: size.width * 0.18,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(
                                      (quote!.isLike == "True")
                                          ? "assets/images/star_fill.png"
                                          : "assets/images/star.png"),
                                  scale: 22)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: size.height * 0.06,
              left: size.width * 0.04,
              child: InkWell(
                onTap: (){
                  Navigator.of(context).pop(true);
                },
                child: Container(
                  height: 40,
                  width: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xff252525),
                    borderRadius: BorderRadius.circular(8)
                  ),
                  child: const Icon(Icons.keyboard_arrow_left,color: Colors.white),
                ),
              ),
            )
          ],
        ),
      )
          : const Center(
        child: CircularProgressIndicator(),
      )
    );
  }
}
