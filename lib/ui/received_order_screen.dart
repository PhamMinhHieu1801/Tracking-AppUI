import 'package:booking/display_utils.dart';
import 'package:booking/geolocator.dart';
import 'package:booking/model/order_model.dart';
import 'package:booking/model/space_model.dart';
import 'package:booking/remote/repository/account_repository.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../main.dart';

class ReceivedOrderScreen extends StatefulWidget {
  const ReceivedOrderScreen({super.key});

  @override
  State<ReceivedOrderScreen> createState() => _ReceivedOrderScreenState();
}

class _ReceivedOrderScreenState extends State<ReceivedOrderScreen> {
  final AccountRepository accountRepository = AccountRepository();
  List<OrderModel> listOrder = [];
  OrderModel? currentOrder;
  double? currentPlace;
  Position? myPosition;
  String? currentAddress;
  final primaryStyle = const TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: Color(
      0xFF000000,
    ),
  );

  @override
  initState() {
    super.initState();
    init();
  }

  void init() async {
    DisplayUtil.showLoadingDialog();
    listOrder = await accountRepository.getListJobByUser();
    // final check = listOrder.where((element) => element.statusJob == 1).toList();
    myPosition = await determinePosition();
    currentAddress = await accountRepository.getAddressFromLatLong(
      lat: myPosition?.latitude ?? 0,
      long: myPosition?.longitude ?? 0,
    );
    final check = listOrder.where((element) => element.statusJob == 1).toList();
    if (check != [] && check.isNotEmpty) {
      currentOrder = check[0];
    } else {
      currentOrder = null;
    }

    DisplayUtil.dismiss();
    setState(() {});
  }

  void changeStatusJob({required int id, required int status}) async {
    DisplayUtil.showLoadingDialog();
    await accountRepository
        .changeStatusJob(id: id, status: status)
        .then((value) async {
      if (value) {
        DisplayUtil.showLoadingDialog();
        listOrder = await accountRepository.getListJobByUser();
        final check =
            listOrder.where((element) => element.statusJob == 1).toList();
        currentAddress = await accountRepository.getAddressFromLatLong(
          lat: myPosition?.latitude ?? 0,
          long: myPosition?.longitude ?? 0,
        );
        if (check != [] && check.isNotEmpty) {
          currentOrder = check[0];
        }

        DisplayUtil.dismiss();
        setState(() {});
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
              Scaffold.of(context).openDrawer();
            },
            child: Row(
              children: [
                const SizedBox(
                  width: 16,
                ),
                Image.asset(
                  "assets/img/ic_drawer.png",
                  height: 24,
                  width: 24,
                  fit: BoxFit.fill,
                ),
                const Spacer(),
              ],
            ),
          )),
          const Text(
            "Đơn hàng đang nhận",
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
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          appBar,
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                init();
              },
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
                        "Vị trí của bạn: ${currentAddress}",
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
                        currentOrder == null
                            ? "Hiện tại bạn đang k giao đơn hàng nào"
                            : "Thời gian giao hàng dự kiến: ${(currentOrder?.estTime ?? 0) / 60} phút",
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Colors.red,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    listOrder.isEmpty
                        ? const Center(
                            child: Text(
                              "Không có đơn hàng",
                            ),
                          )
                        : ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: listOrder.length,
                            itemBuilder: (context, index) {
                              final item = listOrder[index];
                              return Padding(
                                padding: const EdgeInsets.only(
                                  bottom: 16,
                                ),
                                child: _cardOrder(item),
                              );
                            },
                          ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _cardOrder(OrderModel orderModel) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(16),
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 5,
            color: Colors.black,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 16,
          ),
          Text(
            "Đơn: ${orderModel.id}",
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Color(
                0xFF000000,
              ),
            ),
          ),
          Text(
            orderModel.nameJob ?? "",
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Color(
                0xFF000000,
              ),
            ),
          ),
          Text(
            "Địa chỉ: ${orderModel.addressJob}",
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Color(
                0xFF000000,
              ),
            ),
          ),
          Text(
            "Thời gian còn lại: ${((orderModel.estTime?.toInt() ?? 0) / 60).round()} phút",
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Color(
                0xFF000000,
              ),
            ),
          ),
          Text(
            "Khoảng cách: ${orderModel.distance?.toInt()} km",
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Color(
                0xFF000000,
              ),
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          Row(
            children: [
              const Spacer(),
              orderModel.statusJob == 0
                  ? GestureDetector(
                      onTap: () {
                        changeStatusJob(id: orderModel.id ?? -1, status: 1);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF001063),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          "Bắt đầu giao",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  : Text(
                      getStatus(orderModel.statusJob),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
            ],
          ),
          const SizedBox(height: 12),
        ],
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
        return "Đã huỷ";
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
