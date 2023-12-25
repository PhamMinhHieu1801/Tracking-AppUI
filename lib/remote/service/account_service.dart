import 'package:booking/core/api_client.dart';
import 'package:booking/core/map_client.dart';
import 'package:booking/display_utils.dart';
import 'package:booking/main.dart';
import 'package:booking/model/detail_job.dart';
import 'package:booking/model/order_model.dart';
import 'package:booking/model/space_model.dart';
import 'package:booking/session_cache.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AccountService {
  Future<bool> login({
    required String name,
    required String pass,
  }) async {
    // var route = '/api/app/auth/authorize';
    const route = "Login.php";

    try {
      final Response response = await ApiClient().dio.post(route,
          data: {"email": name, "password": pass},
          options: Options(
            headers: {"Content-Type": "application/x-www-form-urlencoded"},
          ));
      if (response.statusCode == 200) {
        // SessionCache.saveUserId(response.data["result"]["userId"].toString());
        Fluttertoast.showToast(
            msg: response.data["message"],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0);
        await SessionCache.newSession(response.data["token"]);
        return response.data["status"];
      }
    } catch (e) {
      logger.e('login failed: $e');
    }
    return false;
  }

  Future<List<OrderModel>> getListJobNew() async {
    const route = "get-list-job.php";

    try {
      final Response response = await ApiClient().dio.get(
            route,
          );
      if (response.statusCode == 200) {
        if (response.data["data"] == null) {
          Fluttertoast.showToast(
              msg: response.data["message"],
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black,
              textColor: Colors.white,
              fontSize: 16.0);
        }
        return List.of(response.data["data"])
            .map((e) => e as Map<String, dynamic>)
            .map(OrderModel.fromJson)
            .toList();
      }
    } catch (e) {
      logger.e('login failed: $e');
    }
    return [];
  }

  Future<List<OrderModel>> getListJobByUser() async {
    const route = "get-list-job-by-user.php";

    try {
      final Response response = await ApiClient().dio.get(
            route,
          );
      if (response.statusCode == 200) {
        if (response.data["data"] == null) {
          Fluttertoast.showToast(
              msg: response.data["message"],
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black,
              textColor: Colors.white,
              fontSize: 16.0);
        }
        return List.of(response.data["data"])
            .map((e) => e as Map<String, dynamic>)
            .map(OrderModel.fromJson)
            .toList();
      }
    } catch (e) {
      logger.e('login failed: $e');
    }
    return [];
  }

  Future<DetailJob?> getDetailJob(int id) async {
    const route = "get-detail-job.php";

    try {
      final Response response =
          await ApiClient().dio.get(route, queryParameters: {"id": id});
      if (response.statusCode == 200) {
        if (response.data["data"] == null) {
          Fluttertoast.showToast(
              msg: response.data["message"],
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black,
              textColor: Colors.white,
              fontSize: 16.0);
        }
        await SessionCache.newWarehouseLocation(
          BookingPtitLocation(response.data["data"][0]["lat_ware_house"] ?? 0.0,
              response.data["data"][0]["long_ware_house"] ?? 0.0),
        );

        return DetailJob.fromJson(response.data["data"][0]);
      }
    } catch (e) {
      logger.e('login failed: $e');
    }
    return null;
  }

  Future<bool> acceptJob(int id) async {
    const route = "accept-job.php";

    try {
      final Response response =
          await ApiClient().dio.post(route, queryParameters: {"id": id});
      if (response.statusCode == 200) {
        Fluttertoast.showToast(
            msg: response.data["message"],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0);
        return response.data["status"];
      }
    } catch (e) {
      logger.e('login failed: $e');
    }
    return false;
  }

  Future<bool> refuseJob(int id) async {
    const route = "refuse-job.php";

    try {
      final Response response =
          await ApiClient().dio.post(route, queryParameters: {"id": id});
      if (response.statusCode == 200) {
        Fluttertoast.showToast(
            msg: response.data["message"],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0);
        return response.data["status"];
      }
    } catch (e) {
      logger.e('login failed: $e');
    }
    return false;
  }

  Future<String?> getAddressFromLatLong(double lat, double long) async {
    const route = "/reverse";

    try {
      final Response response = await MapClient().dio.get(route,
          queryParameters: {"lat": lat, "lon": long, "format": "jsonv2"});
      if (response.statusCode == 200) {
        return response.data["display_name"];
      }
    } catch (e) {
      logger.e('login failed: $e');
    }
    return null;
  }

  Future<bool> changeStatusJob(int id, int status) async {
    const route = "change-status-job.php";

    try {
      final Response response = await ApiClient()
          .dio
          .post(route, queryParameters: {"id": id, "status": status});
      if (response.statusCode == 200) {
        Fluttertoast.showToast(
            msg: response.data["message"],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0);
        return response.data["status"];
      }
    } catch (e) {
      logger.e('login failed: $e');
    }
    return false;
  }

  Future<void> pushNoti(String token, double distance) async {
    const route = "push-notify.php";

    try {
      final Response response =
          await ApiClient().dio.post(route, queryParameters: {
        "token": token,
        "distance": distance,
      });
      if (response.statusCode == 200) {
        return;
      }
    } catch (e) {
      logger.e('login failed: $e');
    }
    return;
  }
}
