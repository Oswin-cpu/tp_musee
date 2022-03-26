
import 'package:gesmuseum/Models/Ouvrage.dart';
import '../Database/DatabaseProvider.dart';

//Ouvrage Data Access Objects
class OuvrageDao{
  final databaseProvider = DatabaseProvider.databaseProvider;

  Future close() async{
    final db = await databaseProvider.database;
    db.close();
  }

  Future<int> insertOuvrage(Ouvrage ouvrage) async {
    final db = await databaseProvider.database;
    return await db.insert("OUVRAGE", ouvrage.toJson());
  }

  Future<List<Ouvrage>> getOuvrage() async{
    final db = await databaseProvider.database;
    // final result = await db.rawQuery('SELECT * FROM $tableBase ORDER BY $orderBy');
    List result = await db.query("OUVRAGE", orderBy: 'isbn ASC');
    print ('result getOuvrage $result');
    
    return result.map((json)=>Ouvrage.fromJson(json)).toList();
    
  }

  Future<int> updateOuvrage(Ouvrage ouvrage) async{
    final db = await databaseProvider.database;

    return await db.update(
      "OUVRAGE", ouvrage.toJson(),
      where: 'isbn = ?', 
      whereArgs: [ouvrage.isbn]);
    
  }

  Future<int> deleteOuvrage(Ouvrage ouvrage) async {
    final db = await databaseProvider.database;

    return await db.delete(
      "OUVRAGE", 
      where: 'isbn = ?', 
      whereArgs: [ouvrage.isbn]);
  }

  Future<bool> getOuvrageFromOtherTables(String ISBN) async{
    final db = await databaseProvider.database;
    var maps = await db.query("BIBLIOTHEQUE",
      where: 'ISBN = ?', 
      whereArgs: [ISBN]);

    if(maps.isNotEmpty){
      return true;
    }else{
      print("Cet ouvrage n'a pas été utilisé dans une autre table");
      return false;
    }
  }

}