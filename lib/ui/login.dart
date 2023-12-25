import 'package:booking/display_utils.dart';
import 'package:booking/password_textfield.dart';
import 'package:booking/remote/repository/account_repository.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../common_textfield.dart';
import 'home_page_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AccountRepository accountRepository = AccountRepository();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final appBar = Container(
      height: 70,
      decoration: const BoxDecoration(color: Color(0xFF001063)),
      child: Row(
        children: [
          Expanded(
            child: Container(),
          ),
          const Text(
            "Đăng nhập",
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
      child: Scaffold(
        backgroundColor: Colors.grey.shade200,
        body: Column(
          children: [
            appBar,
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 100),
                    const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text("Email")),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: CommonTextField(
                        controller: _emailController,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text("Mật khẩu")),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: PasswordTextField(
                        controller: _passwordController,
                      ),
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: () async {
                        final email = _emailController.text;
                        final password = _passwordController.text;
                        if (email == null ||
                            email.trim() == "" ||
                            password == null ||
                            password.trim() == "") {
                          Fluttertoast.showToast(msg: "Chưa đúng định dạng");
                        }
                        DisplayUtil.showLoadingDialog();
                        await accountRepository
                            .login(name: email, pass: password)
                            .then((value) {
                          if (value) {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MyHomePage()),
                                (route) => false);
                          }
                        });

                        DisplayUtil.dismiss();
                        setState(() {});
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF001063),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          "Đăng nhập",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
