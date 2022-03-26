
import 'package:gesmuseum/Models/Moment.dart';

import '../Database/DatabaseProvider.dart';

class MomentDao{
  final databaseProvider = DatabaseProvider.databaseProvider;

  Future close() async{
    final db = await databaseProvider.database;
    db.close();
  }

  Future<List<Moment>> getMoment() async{
    final db = await databaseProvider.database;
    List result = await db.query("MOMENT");
    print ('result getMoment $result');
    
    return result.map((json)=>Moment.fromJson(json)).toList();

  }

}