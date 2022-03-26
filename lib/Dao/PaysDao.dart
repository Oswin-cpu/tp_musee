
import 'package:gesmuseum/Database/DatabaseProvider.dart';
import 'package:gesmuseum/Models/Pays.dart';

//Pays Data Access Objects
class PaysDao{
  final databaseProvider = DatabaseProvider.databaseProvider;

  Future close() async{
    final db = await databaseProvider.database;
    db.close();
  }

  Future<int> insertPays(Pays pays) async {
    final db = await databaseProvider.database;
    return await db.insert("PAYS", pays.toJson());
  }

  Future<List<Pays>> getPays() async{
    final db = await databaseProvider.database;
    // final result = await db.rawQuery('SELECT * FROM $tableBase ORDER BY $orderBy');
    List result = await db.query("PAYS", orderBy: 'codePays ASC');
    print ('result getPays $result');
    
    return result.map((json)=>Pays.fromJson(json)).toList();
    
  }

  Future<Pays> getPaysByCode(String code) async{
    final db = await databaseProvider.database;
    final maps = await db.query("PAYS",
      where: 'codePays = ?', 
      whereArgs: [code]);

    if(maps.isNotEmpty){
      return Pays.fromJson(maps.first);
    }else{
      print('Not found');
      return Pays.fromJson(maps.first);
    }
  }

  Future<bool> getPaysFromOtherTables(String code) async{
    final db = await databaseProvider.database;
    var maps = await db.query("MUSEE",
      where: 'codePays = ?', 
      whereArgs: [code]);

    Pays pays = Pays(codePays: '', nbhabitant: 0);
    if(maps.isNotEmpty){
      pays = Pays.fromJson(maps.first);
      return true;
    }else{
      maps = await db.query("OUVRAGE",
      where: 'codePays = ?', 
      whereArgs: [code]);

      if(maps.isNotEmpty){
        pays = Pays.fromJson(maps.first);
        return true;
      }else{
        print("Ce pays n'a pas été utilisé dans une autre table");
        return false;
      }
    }
  }



  Future<int> updatePays(Pays pays) async{
    final db = await databaseProvider.database;

    return await db.update(
      "PAYS", pays.toJson(),
      where: 'codePays = ?', 
      whereArgs: [pays.codePays]);
    
  }

  Future<int> deletePays(Pays pays) async {
    final db = await databaseProvider.database;

    return await db.delete(
      "PAYS", 
      where: 'codePays = ?', 
      whereArgs: [pays.codePays]);
  }

}