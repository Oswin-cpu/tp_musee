
import 'dart:async';

import 'package:gesmuseum/Models/Visiter.dart';

import '../Repository/VisiterRepository.dart';

class VisiterBloc {
  //Get instance of the Repository
  final _visiterRepository = VisiterRepository();

  //Stream controller is the 'Admin' that manages
  //the state of our stream of data like adding
  //new data, change the state of the stream
  //and broadcast it to observers/subscribers
  final _visiterController = StreamController<List>.broadcast();

  get visites => _visiterController.stream;

  VisiterBloc() {
    getVisites();
  }

  getVisites() async {
    _visiterController.sink.add(await _visiterRepository.getAllVisites());
  }

  addVisite(Visiter visiter) async {
    await _visiterRepository.insertVisite(visiter);
    getVisites();
  }

  updateVisite(Visiter visiter) async {
    await _visiterRepository.updateVisite(visiter);
    getVisites();
  }

  deleteVisite(String jour, int numMus) async {
    _visiterRepository.deleteVisite(jour, numMus);
    getVisites();
  }

  dispose() {
    _visiterController.close();
  }
}