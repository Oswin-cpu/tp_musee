import 'package:gesmuseum/Dao/MomentDao.dart';
import 'package:gesmuseum/Models/Moment.dart';

class MomentRepository{
  final momentDao = MomentDao();

  Future<List<Moment>> getAllMoment() => momentDao.getMoment();

}