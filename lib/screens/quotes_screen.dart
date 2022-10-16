import 'package:amazing_quotes/helpers/quotes_db_helper.dart';
import 'package:amazing_quotes/screens/detail_screen.dart';
import 'package:amazing_quotes/screens/share_screen.dart';
import 'package:clipboard/clipboard.dart';
import '../utils/app_componet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/quote_data_model.dart';

class QuotesScreen extends StatefulWidget {
  const QuotesScreen({Key? key, required this.category}) : super(key: key);

  final String category;

  @override
  State<QuotesScreen> createState() => QuotesScreenState();
}

class QuotesScreenState extends State<QuotesScreen> {
  List<Quote> quoteListData = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await QuoteDBHelper.quoteDBHelper
          .fetchData(where: widget.category)
          .then((value) {
        setState(() {
          quoteListData = value;
        });
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      print("==> didChange");

    quoteListData = await QuoteDBHelper.quoteDBHelper.fetchData(where: widget.category);
    });

  }
  bool isLoaded = false;

  // Random random = Random();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;


    (isLoaded)
        ? {
      print("|||||||||||||||||||||||||||||||"),
            // QuoteDBHelper.quoteDBHelper
            //     .fetchData(where: widget.category)
            //     .then((value) {
            //   quoteListData = value;
            //   setState(() {});
            // })

          }
        : {
      print("${isLoaded}_________________"),
    };

    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: [
              Container(
                height: size.height * 0.07,
                width: size.width,
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(Icons.keyboard_arrow_left)),
                    const SizedBox(width: 20),
                    Text(
                      widget.category,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w600),
                    )
                  ],
                ),
              ),
              Expanded(
                child: (quoteListData.isNotEmpty)
                    ? ListView.builder(
                        itemCount: quoteListData.length,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      isLoaded = true;
                                      print("object ==> $isLoaded");
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  DetailScreen(
                                                    id: quoteListData[index]
                                                        .id!,
                                                  )));
                                    },
                                    child: Container(
                                      height: size.height * 0.55,
                                      width: size.width * 0.9,
                                      margin: const EdgeInsets.fromLTRB(
                                          10, 17, 10, 1),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          boxShadow: const [
                                            BoxShadow(
                                                color: Colors.black12,
                                                blurRadius: 10,
                                                spreadRadius: 5)
                                          ],
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          image: DecorationImage(
                                              image: NetworkImage(sliderImage[
                                                  quoteListData[index]
                                                      .imageIndex!]),
                                              fit: BoxFit.cover)),
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Container(
                                            height: size.height * 0.55,
                                            width: size.width * 0.9,
                                            decoration: BoxDecoration(
                                              color:
                                                  Colors.black.withOpacity(0.6),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                          Container(
                                              height: size.height * 0.55,
                                              width: size.width * 0.9,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10),
                                              alignment: Alignment.center,
                                              child: Text(
                                                quoteListData[index].quote,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white,
                                                ),
                                                textAlign: TextAlign.center,
                                              )),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    child: Container(
                                      height: size.height * 0.07,
                                      width: size.width * 0.9,
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.vertical(
                                            bottom: Radius.circular(10)),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          InkWell(
                                            onTap: () async {
                                              if (quoteListData[index]
                                                      .imageIndex! >
                                                  sliderImage.length - 2) {
                                                await QuoteDBHelper
                                                    .quoteDBHelper
                                                    .changeImage(
                                                        imageIndex: 0,
                                                        quoteID:
                                                            quoteListData[index]
                                                                .id!);
                                              } else {
                                                await QuoteDBHelper
                                                    .quoteDBHelper
                                                    .changeImage(
                                                        imageIndex:
                                                            quoteListData[index]
                                                                    .imageIndex! +
                                                                1,
                                                        quoteID:
                                                            quoteListData[index]
                                                                .id!);
                                              }
                                              quoteListData =
                                                  await QuoteDBHelper
                                                      .quoteDBHelper
                                                      .fetchData(
                                                          where:
                                                              widget.category);
                                              setState(() {});
                                            },
                                            child: Container(
                                              width: size.width * 0.18,
                                              decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                      image: AssetImage(
                                                          "assets/images/change_image.png"),
                                                      scale: 22)),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              FlutterClipboard.copy(
                                                      quoteListData[index]
                                                          .quote)
                                                  .then((value) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                        content:
                                                            Text("Copid")));
                                              });
                                            },
                                            child: Container(
                                              width: size.width * 0.18,
                                              decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                      image: AssetImage(
                                                          "assets/images/copy.png"),
                                                      scale: 22)),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () async {
                                              PermissionStatus storageStatus =
                                                  await Permission
                                                      .storage.status;

                                              print(
                                                  "Permission Storage ==> ${storageStatus}");

                                              if (storageStatus.isDenied) {
                                                await [Permission.storage]
                                                    .request();
                                              }

                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ShareScreen(
                                                            imageIndex:
                                                                quoteListData[
                                                                        index]
                                                                    .imageIndex!,
                                                            quote:
                                                                quoteListData[
                                                                        index]
                                                                    .quote,
                                                          )));
                                            },
                                            child: Ink(
                                              child: Container(
                                                width: size.width * 0.18,
                                                decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                        image: AssetImage(
                                                            "assets/images/share.png"),
                                                        scale: 22)),
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () async {
                                              PermissionStatus storageStatus =
                                                  await Permission
                                                      .storage.status;

                                              print(
                                                  "Permission Storage ==> ${storageStatus}");

                                              if (storageStatus.isDenied) {
                                                await [Permission.storage]
                                                    .request();
                                              }

                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ShareScreen(
                                                            imageIndex:
                                                                quoteListData[
                                                                        index]
                                                                    .imageIndex!,
                                                            quote:
                                                                quoteListData[
                                                                        index]
                                                                    .quote,
                                                          )));
                                            },
                                            child: Container(
                                              width: size.width * 0.18,
                                              decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                      image: AssetImage(
                                                          "assets/images/save.png"),
                                                      scale: 22)),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () async {
                                              if (quoteListData[index].isLike ==
                                                  "True") {
                                                await QuoteDBHelper
                                                    .quoteDBHelper
                                                    .unLikeQuote(
                                                        quoteID:
                                                            quoteListData[index]
                                                                .id!);
                                              } else {
                                                await QuoteDBHelper
                                                    .quoteDBHelper
                                                    .likeQuote(
                                                        quoteID:
                                                            quoteListData[index]
                                                                .id!);
                                              }
                                              quoteListData =
                                                  await QuoteDBHelper
                                                      .quoteDBHelper
                                                      .fetchData(
                                                          where:
                                                              widget.category);
                                              setState(() {});
                                            },
                                            child: Ink(
                                              child: Container(
                                                width: size.width * 0.18,
                                                decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                        image: AssetImage((quoteListData[
                                                                        index]
                                                                    .isLike ==
                                                                "True")
                                                            ? "assets/images/star_fill.png"
                                                            : "assets/images/star.png"),
                                                        scale: 22)),
                                              ),
                                            ),
                                          ),
                                          // IconButton(
                                          //     onPressed: () {
                                          //       setState(() {
                                          //         int randomID =
                                          //             random.nextInt(7);
                                          //       });
                                          //     },
                                          //     icon: Icon(Icons
                                          //         .picture_in_picture_outlined)),

                                          // Icon(Icons
                                          //     .picture_in_picture_outlined),
                                          // Icon(Icons
                                          //     .picture_in_picture_outlined),
                                          // Icon(Icons
                                          //     .picture_in_picture_outlined),
                                          // Icon(Icons
                                          //     .picture_in_picture_outlined),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                            ],
                          );
                        },
                      )
                    : const Center(
                        child: CircularProgressIndicator(),
                      ),
              )
            ],
          )),
    );
  }
}
