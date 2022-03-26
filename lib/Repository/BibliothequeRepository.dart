
import 'package:gesmuseum/Dao/BibliothequeDao.dart';
import 'package:gesmuseum/Models/Bibliotheque.dart';

class BibliothequeRepository{
  final bibliothequeDao = BibliothequeDao();

  Future getAllBibliotheque() => bibliothequeDao.getBibliotheque();

  Future insertBibliotheque(Bibliotheque bibliotheque) => bibliothequeDao.insertBibliotheque(bibliotheque);

  Future updateBibliotheque(Bibliotheque bibliotheque) => bibliothequeDao.updateBibliotheque(bibliotheque);

  Future deleteBibliotheque(String isbn, int numMus) => bibliothequeDao.deleteBibliotheque(isbn, numMus);
}