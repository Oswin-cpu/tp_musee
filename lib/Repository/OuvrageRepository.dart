
import 'package:gesmuseum/Dao/OuvrageDao.dart';
import 'package:gesmuseum/Models/Ouvrage.dart';

class OuvrageRepository{
  final ouvrageDao = OuvrageDao();

  Future<List<Ouvrage>> getAllOuvrage() => ouvrageDao.getOuvrage();

  Future insertOuvrage(Ouvrage ouvrage) => ouvrageDao.insertOuvrage(ouvrage);

  Future updateOuvrage(Ouvrage ouvrage) => ouvrageDao.updateOuvrage(ouvrage);

  Future deleteOuvrage(Ouvrage ouvrage) => ouvrageDao.deleteOuvrage(ouvrage);

  Future<bool> getOuvrageFromOtherTables(String ISBN) => ouvrageDao.getOuvrageFromOtherTables(ISBN);
}