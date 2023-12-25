import 'package:booking/display_utils.dart';
import 'package:booking/model/detail_job.dart';
import 'package:booking/model/order_model.dart';
import 'package:booking/remote/repository/account_repository.dart';
import 'package:flutter/material.dart';

class NewOrderScreen extends StatefulWidget {
  const NewOrderScreen({super.key});

  @override
  State<NewOrderScreen> createState() => _NewOrderScreenState();
}

class _NewOrderScreenState extends State<NewOrderScreen> {
  final AccountRepository accountRepository = AccountRepository();
  List<OrderModel> listOrder = [];

  DetailJob? currentJob;
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
    listOrder = await accountRepository.getListJobNew();
    if (listOrder != [] && listOrder.isNotEmpty) {
      currentJob = await accountRepository.getDetailJob(listOrder[0].id ?? -1);
    }
    DisplayUtil.dismiss();
    setState(() {});
  }

  void acceptJob(int id) async {
    DisplayUtil.showLoadingDialog();
    await accountRepository.acceptJob(id).then((value) async {
      if (value) {
        listOrder = await accountRepository.getListJobNew();
      }
    });
    DisplayUtil.dismiss();
    setState(() {});
  }

  void refuseJob(int id) async {
    DisplayUtil.showLoadingDialog();
    await accountRepository.refuseJob(id).then((value) async {
      if (value) {
        listOrder = await accountRepository.getListJobNew();
      }
    });
    DisplayUtil.dismiss();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
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
                  "Đơn hàng mới",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                Expanded(child: Container())
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: RefreshIndicator(
                onRefresh: () async {
                  init();
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        "Điểm xuất phát: ${currentJob?.nameWareHouse}",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Color(
                            0xFF000000,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        "Địa chỉ kho: ${currentJob?.addressWareHouse}",
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Color(
                            0xFF000000,
                          ),
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
          )
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
          const SizedBox(
            height: 12,
          ),
          Row(children: [
            Expanded(
              child: Container(),
              // GestureDetector(
              //   onTap: () {
              //     refuseJob(orderModel.id ?? -1);
              //   },
              //   child: Container(
              //     alignment: Alignment.center,
              //     padding: const EdgeInsets.symmetric(vertical: 8),
              //     decoration: BoxDecoration(
              //       color: const Color(0xFFD9D9D9),
              //       borderRadius: BorderRadius.circular(10),
              //     ),
              //     child: Text(
              //       "Từ chối",
              //       style: primaryStyle,
              //     ),
              //   ),
              // ),
            ),
            const SizedBox(width: 40),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  acceptJob(orderModel.id ?? -1);
                },
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF001063),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    "Đồng ý",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            )
          ]),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
