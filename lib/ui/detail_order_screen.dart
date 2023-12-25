import 'dart:async';

import 'package:booking/display_utils.dart';
import 'package:booking/model/order_model.dart';
import 'package:booking/remote/repository/account_repository.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../geolocator.dart';

class DetailOrderScreen extends StatefulWidget {
  final OrderModel orderModel;

  const DetailOrderScreen({
    super.key,
    required this.orderModel,
  });

  @override
  State<DetailOrderScreen> createState() => _DetailOrderScreenState();
}

class _DetailOrderScreenState extends State<DetailOrderScreen> {
  final AccountRepository accountRepository = AccountRepository();
  Position? myPosition;

  final primaryStyle = const TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: Color(
      0xFF000000,
    ),
  );

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(21.0297831, 105.7830019),
    zoom: 14.4746,
  );

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  @override
  initState() {
    super.initState();
  }

  void _add() {
    final MarkerId markerId = MarkerId("1");

    // creating a new MARKER
    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(
        double.tryParse(widget.orderModel.latJob ?? "0") ?? 0,
        double.tryParse(widget.orderModel.longJob ?? "0") ?? 0,
      ),
      infoWindow: InfoWindow(title: "1", snippet: '*'),
      onTap: () {},
    );

    setState(() {
      // adding a new marker to map
      markers[markerId] = marker;
    });
  }

  void init() async {
    CameraPosition _kLake = CameraPosition(
      target: LatLng(
          double.tryParse(widget.orderModel.latJob ?? "") ?? 21.0228148,
          double.tryParse(widget.orderModel.longJob ?? "") ?? 105.795764),
      zoom: 14.4746,
    );

    final GoogleMapController controller = await _controller.future;

    await controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }

  void changeStatusJob({required int id, required int status}) async {
    DisplayUtil.showLoadingDialog();
    await accountRepository
        .changeStatusJob(id: id, status: status)
        .then((value) {
      if (value) {
        Navigator.pop(context, true);
      }
    });

    DisplayUtil.dismiss();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final appBar = Container(
      height: 70,
      decoration: const BoxDecoration(color: Color(0xFF001063)),
      child: Row(
        children: [
          Expanded(
              child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Row(
              children: [
                SizedBox(
                  width: 16,
                ),
                Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                Spacer(),
              ],
            ),
          )),
          const Text(
            "Thông tin giao hàng",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          Expanded(child: Container())
        ],
      ),
    );

    final ggMap = Container(
      height: 400,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
          init();
          _add();
        },
        markers: Set<Marker>.of(markers.values),
      ),
    );
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            appBar,
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        "Đơn: ${widget.orderModel.id}",
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Color(
                            0xFF000000,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        widget.orderModel.nameJob ?? "",
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Color(
                            0xFF000000,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        "Địa chỉ: ${widget.orderModel.addressJob}",
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Color(
                            0xFF000000,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        "Thời gian còn lại: ${((widget.orderModel.estTime?.toInt() ?? 0) / 60).round()} phút",
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Color(
                            0xFF000000,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        "Trạng thái đơn hàng: ${getStatus(widget.orderModel.statusJob)}",
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Color(
                            0xFF000000,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ggMap,
                    const SizedBox(height: 12),
                    widget.orderModel.statusJob == 1 ||
                            widget.orderModel.statusJob == 3
                        ? Row(children: [
                            const SizedBox(width: 16),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  changeStatusJob(
                                    id: widget.orderModel.id ?? -1,
                                    status: 5,
                                  );
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFD9D9D9),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    "Giao hàng thất bại",
                                    style: primaryStyle,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 40),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  changeStatusJob(
                                    id: widget.orderModel.id ?? -1,
                                    status: 4,
                                  );
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF001063),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Text(
                                    "Hoàn thành",
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                          ])
                        : Container(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getStatus(int? status) {
    switch (status) {
      case 0:
        return "Đã nhận";
      case 1:
        return "Đang giao hàng";
      case 2:
        return "Huỷ";
      case 3:
        return "Đã giao";
      case 4:
        return "Hoàn thành";
      case 5:
        return "Giao hàng thất bại";
      default:
        return "";
    }
  }
}
