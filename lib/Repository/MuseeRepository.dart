
import 'package:gesmuseum/Models/Musee.dart';

import '../Dao/MuseeDao.dart';

class MuseeRepository{
  final museeDao = MuseeDao();

  Future<List<Musee>> getAllMusee() => museeDao.getMusees();

  Future insertMusee(Musee musee) => museeDao.insertMusee(musee);

  Future updateMusee(Musee musee) => museeDao.updateMusee(musee);

  Future deleteMusee(Musee musee) => museeDao.deleteMusee(musee);

  Future<bool> getMuseeFromOtherTables(int numMus) => museeDao.getMuseeFromOtherTables(numMus);
}