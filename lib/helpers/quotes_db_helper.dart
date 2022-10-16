import 'dart:convert';
import 'dart:math';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/quote_data_model.dart';
import '../utils/app_componet.dart';

class QuoteDBHelper {

  QuoteDBHelper._();

  static final QuoteDBHelper quoteDBHelper = QuoteDBHelper._();

  Database? dbs;

  String dbName = "quoteDatabase.db";
  String quoteTableName = "quotes";

  String quoteColumn1_id = "id";
  String quoteColumn2_quote = "quotes";
  String quoteColumn3_author = "author";
  String quoteColumn4_category = "category";
  String quoteColumn5_isLike = "is_like";
  String quoteColumn6_imageIndex = "image_index";


  Future<Database?> initDB() async {

    String dbPath =  await getDatabasesPath();
    String path = join(dbPath , dbName);

    dbs = await openDatabase(path, version: 1, onCreate: (Database db, int version) async {
      String query = "CREATE TABLE IF NOT EXISTS $quoteTableName($quoteColumn1_id INTEGER PRIMARY KEY AUTOINCREMENT, $quoteColumn2_quote TEXT, $quoteColumn3_author TEXT, $quoteColumn4_category TEXT, $quoteColumn5_isLike TEXT, $quoteColumn6_imageIndex INTEGER);";
      await db.execute(query);
    });

      String query = "CREATE TABLE IF NOT EXISTS $quoteTableName($quoteColumn1_id INTEGER PRIMARY KEY AUTOINCREMENT, $quoteColumn2_quote TEXT, $quoteColumn3_author TEXT, $quoteColumn4_category TEXT, $quoteColumn5_isLike TEXT, $quoteColumn6_imageIndex INTEGER);";

    await dbs!.execute(query);

    return dbs;
  }


  Future insertBulkRecord(List<Quote> quoteDataList) async {
     dbs = await initDB();

     for(Quote value in quoteDataList){

       Random random = Random() ;

       value.isLike = "false";
       value.imageIndex = random.nextInt(sliderImage.length);

       String query = "INSERT INTO $quoteTableName VALUES(?,?,?,?,?,?)";

       List args = [
         null,
         '${value.quote}',
         '${value.author}',
         '${value.category}',
         '${value.isLike}',
         '${value.imageIndex}'
       ];
       int id = await dbs!.rawInsert(query,args);

       print("object ==> $id");

     }
  }

  Future changeImage({required int imageIndex, required int quoteID}) async {
    dbs = await initDB();

    String  query = "UPDATE $quoteTableName set $quoteColumn6_imageIndex = $imageIndex WHERE $quoteColumn1_id = $quoteID";
    int id = await dbs!.rawUpdate(query);
    print("object ==> id $id");
  }

  Future likeQuote({required int quoteID}) async {
     dbs = await initDB();

       String  query = "UPDATE $quoteTableName set $quoteColumn5_isLike = 'True' WHERE $quoteColumn1_id = $quoteID";
       int id = await dbs!.rawUpdate(query);
       print("object ==> id $id");
  }

  Future unLikeQuote({required int quoteID}) async {
     dbs = await initDB();

       String  query = "UPDATE $quoteTableName set $quoteColumn5_isLike = 'False' WHERE $quoteColumn1_id = $quoteID";
       int id = await dbs!.rawUpdate(query);
       print("object ==> id $id");
  }

  Future<List<Quote>> fetchData({required String where}) async {

    dbs = await initDB();

    String query = "SELECT *FROM $quoteTableName WHERE ${quoteColumn4_category} LIKE '%$where%'";

   List<Map<String,dynamic>> data = await dbs!.rawQuery(query);

   List<Quote> quoteListData = quoteFromJsonDatabase(jsonEncode(data));

   print("object ==> ${data.length}");
   print("object ==> ${quoteListData[0].imageIndex}");
   print("object ==> ${data[0]}");

   return quoteListData;
  }

  Future<Quote> fetchSingleData({required int id}) async {

    dbs = await initDB();

    String query = "SELECT *FROM $quoteTableName WHERE $quoteColumn1_id = $id";

   List<Map<String,dynamic>> data = await dbs!.rawQuery(query);

   Quote quoteData = Quote.fromJsonDatabase(data[0]);

   return quoteData;
  }

  Future<List<Quote>?> fetchLikeData() async {

    dbs = await initDB();

    String query = "SELECT *FROM $quoteTableName WHERE ${quoteColumn5_isLike} LIKE '%True%'";

   List<Map<String,dynamic>> data = await dbs!.rawQuery(query);

   List<Quote> quoteListData = quoteFromJsonDatabase(jsonEncode(data));


   return quoteListData;
  }


  Future deleteTable () async {
    dbs = await initDB();

    String query = "DROP TABLE $quoteTableName";;
    await dbs!.execute(query).then((value) {
      print("$quoteTableName ==> Delete Table");
    });
  }

}