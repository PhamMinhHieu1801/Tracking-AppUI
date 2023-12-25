import 'package:booking/geolocator.dart';
import 'package:booking/model/detail_job.dart';
import 'package:booking/model/order_model.dart';
import 'package:booking/model/space_model.dart';
import 'package:booking/remote/service/account_service.dart';
import 'package:booking/session_cache.dart';
import 'package:geolocator/geolocator.dart';

class AccountRepository {
  static final AccountRepository _singleton = AccountRepository._internal();

  factory AccountRepository() {
    return _singleton;
  }

  AccountRepository._internal() {
    _accountService = AccountService();
  }

  late final AccountService _accountService;

  Future<bool> login({
    required String name,
    required String pass,
  }) async {
    return await _accountService.login(name: name, pass: pass);
  }

  Future<List<OrderModel>> getListJobNew() {
    return _accountService.getListJobNew();
  }

  Future<List<OrderModel>> getListJobByUser() {
    return _accountService.getListJobByUser();
  }

  Future<bool> acceptJob(int id) {
    return _accountService.acceptJob(id);
  }

  Future<bool> refuseJob(int id) {
    return _accountService.refuseJob(id);
  }

  Future<String?> getAddressFromLatLong(
      {required double lat, required double long}) {
    return _accountService.getAddressFromLatLong(lat, long);
  }

  Future<bool> changeStatusJob({required int id, required int status}) {
    return _accountService.changeStatusJob(id, status);
  }

  Future<DetailJob?> getDetailJob(int id) async {
    return _accountService.getDetailJob(id);
  }

  Future<void> pushNoti(String token) async {
    Position pos = await determinePosition();
    double distanceInMeters = Geolocator.distanceBetween(
      pos.latitude,
      pos.longitude,
      SessionCache.wareHouseLocation?.lat ?? 0,
      SessionCache.wareHouseLocation?.lng ?? 0,
    );

    return _accountService.pushNoti(token, distanceInMeters);
  }
}
