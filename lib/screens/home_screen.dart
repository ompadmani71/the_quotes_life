import 'package:amazing_quotes/screens/category_screen.dart';
import 'package:amazing_quotes/screens/quotes_screen.dart';
import 'package:amazing_quotes/screens/like_quote_screen.dart';
import 'package:amazing_quotes/utils/widgets.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/app_componet.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  int index = 0;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:  [
                  const Icon(Icons.menu),
                  // SizedBox(width: 15),
                  const Flexible(
                      child: Text(
                    "Life Quotes And Sayings",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  )),
                  SizedBox(width: 15),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const LikeQuoteScreen()));
                    },
                    child: Image.asset("assets/images/heart.png",scale: 20),
                  )
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          CarouselSlider(
                              options: CarouselOptions(
                                height: 180,
                                viewportFraction: 1,
                                onPageChanged: (i, _) {
                                  setState(() {
                                    index = i;
                                  });
                                },
                              ),
                              items: sliderImage.map((e) {
                                return Container(
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                          image: NetworkImage(e),
                                          fit: BoxFit.cover)),
                                );
                              }).toList()),
                          Positioned(
                            bottom: 5,
                            child: Row(
                                children: sliderImage.map((e) {
                              return Padding(
                                padding: const EdgeInsets.all(5),
                                child: CircleAvatar(
                                  radius: 4,
                                  backgroundColor:
                                      (index == sliderImage.indexOf(e)
                                          ? null
                                          : Colors.grey),
                                ),
                              );
                            }).toList()),
                          )
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          headLine(
                              color: Color(0xffa25684),
                              text: "Categories",
                              iconData: Icons.widgets_outlined,
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const CategoryScreen(),
                                ));
                              }),
                          headLine(
                              color: Color(0xff7589c8),
                              text: "Pic Quotes",
                              iconData: Icons.image_outlined),
                          headLine(
                              color: Color(0xffb98f41),
                              text: "Latest Quotes",
                              iconData: Icons.settings),
                          headLine(
                              color: Color(0xff6c9978),
                              text: "Articles",
                              iconData: Icons.menu_book_outlined),
                        ],
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        "Most Popular",
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          mostPopular(
                              text: "Attitude Quotes",
                              size: size,
                              image: "assets/images/category/Atttude.jpg",
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      const QuotesScreen(category: "Attitude"),
                                ));
                              }),
                          mostPopular(
                              text: "Beauty Quotes",
                              size: size,
                              image: "assets/images/category/Beauty.jpg",
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      QuotesScreen(category: "Beauty"),
                                ));
                              }),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          mostPopular(
                              text: "Business Quotes",
                              size: size,
                              image: "assets/images/category/Business.jpg",
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      QuotesScreen(category: "Business"),
                                ));
                              }),
                          mostPopular(
                              text: "Truth Quotes",
                              size: size,
                              image: "assets/images/category/Truth.jpg",
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      QuotesScreen(category: "Computers"),
                                ));
                              }),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Row(
                        children: [
                          Text(
                            "Quotes by category",
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.w500),
                          ),
                          Spacer(),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      const CategoryScreen()));
                            },
                            child: Row(
                              children: [
                                Text(
                                  "View All",
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.orange,
                                      fontWeight: FontWeight.w500),
                                ),
                                Icon(
                                  Icons.keyboard_arrow_right,
                                  color: Colors.orange,
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          mostPopular(
                              text: "Dating Quotes",
                              size: size,
                              image: "assets/images/category/Datting.jpg",
                              onTap: () {

                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      QuotesScreen(category: "Dating"),
                                ));
                              }),
                          mostPopular(
                              text: "Dreams Quotes",
                              size: size,
                              image: "assets/images/category/Dream.jpg",
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      QuotesScreen(category: "Dreams"),
                                ));
                              }),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          mostPopular(
                              text: "Birthday Quotes",
                              size: size,
                              image: "assets/images/category/Birthday.jpg",
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      QuotesScreen(category: "Birthday"),
                                ));
                              }),
                          mostPopular(
                              text: "Computer Quotes",
                              size: size,
                              image: "assets/images/category/Computer.jpg",
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      const QuotesScreen(category: "Computers"),
                                ));
                              }),
                        ],
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        "Featured",
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          featured(
                              color: categoryColors[2],
                              text: "Short\nQuotes",
                              alignment: Alignment.center,
                              size: size),
                          featured(
                              color: categoryColors[4],
                              text: "Proverbs",
                              alignment: Alignment.centerLeft,
                              size: size),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          featured(
                              color: categoryColors[5],
                              text: "Entrepreneur\nQuotes",
                              alignment: Alignment.center,
                              size: size),
                          featured(
                              color: categoryColors[8],
                              text: "Top\nQuotes",
                              alignment: Alignment.center,
                              size: size),
                        ],
                      ),
                      const SizedBox(height: 30)
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
