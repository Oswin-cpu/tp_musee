
import 'package:gesmuseum/Models/Bibliotheque.dart';

import '../Database/DatabaseProvider.dart';

//Bibliotheque Data Access Objects
class BibliothequeDao{
  final databaseProvider = DatabaseProvider.databaseProvider;

  Future close() async{
    final db = await databaseProvider.database;
    db.close();
  }

  Future<int> insertBibliotheque(Bibliotheque bibliotheque) async {
    final db = await databaseProvider.database;
    return await db.insert("BIBLIOTHEQUE", bibliotheque.toJson());
  }

  Future<List> getBibliotheque() async{
    final db = await databaseProvider.database;
    List result = await db.rawQuery(
      'SELECT BIBLIOTHEQUE.NumMus, MUSEE.NomMus, BIBLIOTHEQUE.isbn, OUVRAGE.titre, dateAchat FROM BIBLIOTHEQUE, OUVRAGE, MUSEE WHERE BIBLIOTHEQUE.isbn = OUVRAGE.isbn AND BIBLIOTHEQUE.NumMus = MUSEE.NumMus');
    
    //List result = await db.query("BIBLIOTHEQUE", orderBy: 'numMus ASC');
    print ('result getBibliothèque $result');
    
    // return result.map((json)=>Bibliotheque.fromJson(json)).toList();
    return result;
  }

  Future<int> updateBibliotheque(Bibliotheque bibliotheque) async{
    final db = await databaseProvider.database;

    return await db.update(
      "BIBLIOTHEQUE", bibliotheque.toJson(),
      where: 'isbn = ? AND numMus = ?', 
      whereArgs: [bibliotheque.isbn, bibliotheque.numMus]);
    
  }

  Future<int> deleteBibliotheque(String isbn, int numMus) async {
    final db = await databaseProvider.database;

    return await db.delete(
      "BIBLIOTHEQUE", 
      where: 'isbn = ? AND numMus = ?', 
      whereArgs: [isbn, numMus]);
  }

}