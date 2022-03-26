
import 'dart:async';

import 'package:gesmuseum/Models/Bibliotheque.dart';
import 'package:gesmuseum/Repository/BibliothequeRepository.dart';

class BibliothequeBloc {
  //Get instance of the Repository
  final _bibliothequeRepository = BibliothequeRepository();

  //Stream controller is the 'Admin' that manages
  //the state of our stream of data like adding
  //new data, change the state of the stream
  //and broadcast it to observers/subscribers
  final _bibliothequeController = StreamController<List>.broadcast();

  get bibliotheque => _bibliothequeController.stream;

  BibliothequeBloc() {
    getBibliotheques();
  }

  getBibliotheques() async {
    _bibliothequeController.sink.add(await _bibliothequeRepository.getAllBibliotheque());
  }

  addBibliotheque(Bibliotheque bibliotheque) async {
    await _bibliothequeRepository.insertBibliotheque(bibliotheque);
    getBibliotheques();
  }

  updateBibliotheque(Bibliotheque bibliotheque) async {
    await _bibliothequeRepository.updateBibliotheque(bibliotheque);
    getBibliotheques();
  }

  deleteBibliotheque(String isbn, int numMus) async {
    _bibliothequeRepository.deleteBibliotheque(isbn, numMus);
    getBibliotheques();
  }

  dispose() {
    _bibliothequeController.close();
  }
}