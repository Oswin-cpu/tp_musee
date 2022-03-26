
import 'package:gesmuseum/Models/Visiter.dart';

import '../Database/DatabaseProvider.dart';

//Bibliotheque Data Access Objects
class VisiterDao{
  final databaseProvider = DatabaseProvider.databaseProvider;

  Future close() async{
    final db = await databaseProvider.database;
    db.close();
  }

  Future<int> insertVisite(Visiter visiter) async {
    final db = await databaseProvider.database;
    return await db.insert("VISITER", visiter.toJson());
  }

  Future<List> getVisites() async{
    final db = await databaseProvider.database;
    List result = await db.rawQuery(
      'SELECT VISITER.NumMus, MUSEE.NomMus, MOMENT.jour, VISITER.nbvisiteurs FROM VISITER, MUSEE, MOMENT WHERE VISITER.NumMus = MUSEE.NumMus AND MOMENT.jour = VISITER.jour');
    
    // List result = await db.query("VISITER", orderBy: 'jour ASC');
    print ('result getVisiter $result');
    
    // return result.map((json)=>Visiter.fromJson(json)).toList();
    return result;
  }

  Future<int> updateVisite(Visiter visiter) async{
    final db = await databaseProvider.database;
    
    return await db.update(
      "VISITER", visiter.toJson(),
      where: 'jour = ? AND numMus = ?', 
      whereArgs: [visiter.jour, visiter.numMus]);
    
  }

  Future<int> deleteVisite(String jour, int numMus) async {
    final db = await databaseProvider.database;

    return await db.delete(
      "VISITER", 
      where: 'jour = ? AND numMus = ?', 
      whereArgs: [jour, numMus]);
  }

}