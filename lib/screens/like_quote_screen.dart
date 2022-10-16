import 'package:amazing_quotes/screens/share_screen.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../helpers/quotes_db_helper.dart';
import '../models/quote_data_model.dart';
import '../utils/app_componet.dart';
import 'detail_screen.dart';

class LikeQuoteScreen extends StatefulWidget {
  const LikeQuoteScreen({Key? key}) : super(key: key);

  @override
  State<LikeQuoteScreen> createState() => _LikeQuoteScreenState();
}

class _LikeQuoteScreenState extends State<LikeQuoteScreen> {
  List<Quote> likeQuoteDataList = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      likeQuoteDataList =
          await QuoteDBHelper.quoteDBHelper.fetchLikeData() ?? [];
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

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
                      "Favourite Quotes",
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w600),
                    )
                  ],
                ),
              ),
              Expanded(
                  child: (likeQuoteDataList.isNotEmpty)
                      ? ListView.builder(
                          itemCount: likeQuoteDataList.length,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    InkWell(
                                      onTap: (){
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    DetailScreen(
                                                      id: likeQuoteDataList[index]
                                                          .id!,
                                                    )));
                                      },
                                      child: Container(
                                        height: size.height * 0.55,
                                        width: size.width * 0.9,
                                        margin: const EdgeInsets.fromLTRB(
                                            10, 17, 10, 1),
                                        padding: EdgeInsets.only(bottom: 10),
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
                                                    likeQuoteDataList[index]
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
                                                  likeQuoteDataList[index].quote,
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
                                                if (likeQuoteDataList[index]
                                                        .imageIndex! >
                                                    sliderImage.length - 2) {
                                                  await QuoteDBHelper
                                                      .quoteDBHelper
                                                      .changeImage(
                                                          imageIndex: 0,
                                                          quoteID:
                                                              likeQuoteDataList[
                                                                      index]
                                                                  .id!);
                                                } else {
                                                  await QuoteDBHelper
                                                      .quoteDBHelper
                                                      .changeImage(
                                                          imageIndex:
                                                              likeQuoteDataList[
                                                                          index]
                                                                      .imageIndex! +
                                                                  1,
                                                          quoteID:
                                                              likeQuoteDataList[
                                                                      index]
                                                                  .id!);
                                                }
                                                likeQuoteDataList =
                                                    await QuoteDBHelper
                                                            .quoteDBHelper
                                                            .fetchLikeData() ??
                                                        [];
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
                                                FlutterClipboard.copy(
                                                        likeQuoteDataList[index]
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
                                                decoration: const BoxDecoration(
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
                                                        builder:
                                                            (context) =>
                                                                ShareScreen(
                                                                  imageIndex: likeQuoteDataList[
                                                                          index]
                                                                      .imageIndex!,
                                                                  quote: likeQuoteDataList[
                                                                          index]
                                                                      .quote,
                                                                )));
                                              },
                                              child: Ink(
                                                child: Container(
                                                  width: size.width * 0.18,
                                                  decoration: const BoxDecoration(
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
                                                        builder:
                                                            (context) =>
                                                                ShareScreen(
                                                                  imageIndex: likeQuoteDataList[
                                                                          index]
                                                                      .imageIndex!,
                                                                  quote: likeQuoteDataList[
                                                                          index]
                                                                      .quote,
                                                                )));
                                              },
                                              child: Container(
                                                width: size.width * 0.18,
                                                decoration: const BoxDecoration(
                                                    image: DecorationImage(
                                                        image: AssetImage(
                                                            "assets/images/save.png"),
                                                        scale: 22)),
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () async {
                                                if (likeQuoteDataList[index]
                                                        .isLike ==
                                                    "True") {
                                                  await QuoteDBHelper
                                                      .quoteDBHelper
                                                      .unLikeQuote(
                                                          quoteID:
                                                              likeQuoteDataList[
                                                                      index]
                                                                  .id!);
                                                } else {
                                                  await QuoteDBHelper
                                                      .quoteDBHelper
                                                      .likeQuote(
                                                          quoteID:
                                                              likeQuoteDataList[
                                                                      index]
                                                                  .id!);
                                                }
                                                likeQuoteDataList =
                                                    await QuoteDBHelper
                                                            .quoteDBHelper
                                                            .fetchLikeData() ??
                                                        [];
                                                setState(() {});
                                              },
                                              child: Ink(
                                                child: Container(
                                                  width: size.width * 0.18,
                                                  decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                          image: AssetImage((likeQuoteDataList[
                                                                          index]
                                                                      .isLike ==
                                                                  "True")
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
                                  ],
                                ),
                                const SizedBox(height: 10),
                              ],
                            );
                          },
                        )
                      : const Center(
                          child: Text("Not Add in Favourites"),
                        ),
              ),
              // SizedBox(height: 30),
            ],
          )),
    );
  }
}
