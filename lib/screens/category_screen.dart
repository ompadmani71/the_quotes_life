import 'dart:math';
import 'package:amazing_quotes/screens/quotes_screen.dart';
import 'package:flutter/material.dart';
import '../utils/app_componet.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
              height: size.height * 0.07,
              width: size.width,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                 GestureDetector(
                   onTap: (){
                     Navigator.of(context).pop();
                   },
                   child: Container(
                       alignment: Alignment.center,
                       child: Icon(Icons.keyboard_arrow_left)),
                 ),
                  const SizedBox(width: 20),
                  Text(
                    "Quotes by Category",
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w600),
                  )
                ],
              ),
            ),
            Expanded(
                child: ListView.builder(
                    itemCount: categoryList.length,
                    itemBuilder: (context, index){
                      var random = Random();

                      return GestureDetector(
                        onTap: (){
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => QuotesScreen(category: categoryList[index]),));
                        },
                        child: Container(
                          width: size.width,
                          height: size.height * 0.1,
                          color: Colors.transparent,
                          margin: EdgeInsets.symmetric(horizontal: 15,vertical: 5),
                          alignment: Alignment.center,

                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  Container(
                                    height: 60,
                                    width: 60,
                                    margin: EdgeInsets.only(right: 20,bottom: 10),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                        color: categoryColors[random.nextInt(categoryColors.length)]
                                    ),
                                    child: Text(categoryList[index].substring(0,2).toUpperCase(),style: const TextStyle(color: Colors.white,fontSize: 20)),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                              Text(categoryList[index],style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),
                                  Container(
                                    width: size.width * 0.68,
                                    height: 0.5,
                                    color: Colors.black26,
                                  )

                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    },
                ),
            )
          ],
        )
      ),
    );
  }
}
