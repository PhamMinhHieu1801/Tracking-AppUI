import 'dart:convert';
import 'package:booking/main.dart';
import 'package:booking/model/space_model.dart';
import 'package:booking/model/token.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/api_client.dart';

class SessionCache {
  static String? _token;
  static bool _available = false;
  static String? _userID;
  static String? branchID;
  static BookingPtitLocation? _wareHouseLocation;
  static String? trackingId;
  static Function(bool, String?)? availableListener;

  static Future<void> init() async {}

  static Future<void> newSession(String token) async {
    logger.v("new login session");
    _token = token;
    _available = true;
  }

  static Future<void> newWarehouseLocation(
      BookingPtitLocation wareHouseLocation) async {
    _wareHouseLocation = wareHouseLocation;
  }

  static void clear({String? errMessage, bool? notChangeScreen}) {
    _token = null;
    _available = false;
    _userID = null;
    branchID = null;
    trackingId = null;
    if (notChangeScreen != true) {
      availableListener?.call(false, errMessage);
    }
  }

  static bool get available => _available;

  static String? get token => _token;

  static BookingPtitLocation? get wareHouseLocation => _wareHouseLocation;

  static String? get userId => _userID;

  static void saveUserId(String? id) {
    _userID = id;
  }
}
