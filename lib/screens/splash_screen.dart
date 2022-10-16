import 'package:amazing_quotes/helpers/quotes_db_helper.dart';
import 'package:amazing_quotes/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/quote_data_model.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      bool isFirst = prefs.getBool("isFirst") ?? true;

      if (isFirst) {
        String loadString =
            await rootBundle.loadString("assets/json/quote.json");
        List<Quote> quoteListData = quoteFromJson(loadString);

        await QuoteDBHelper.quoteDBHelper.initDB();
        await QuoteDBHelper.quoteDBHelper.deleteTable();
        await QuoteDBHelper.quoteDBHelper
            .insertBulkRecord(quoteListData)
            .then((value) async {
          await prefs.setBool("isFirst", false);

          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ));
        });
      } else {
        Future.delayed(Duration(seconds: 3), () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => HomeScreen()));
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset("assets/images/quote_logo.jpg"),
      ),
    );
  }
}
