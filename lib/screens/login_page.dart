import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:soremar_inventory/Widgets/FormCard.dart';
import 'home_page.dart'; // Make sure to import the HomePage

class LoginPage extends StatelessWidget {
  static const String path = '/login';

  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(750, 1334),
      builder: (context, child) => const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  bool _isSelected = false;

  void _radio() {
    setState(() {
      _isSelected = !_isSelected;
    });
  }

  Widget radioButton(bool isSelected) => Container(
        width: 16.0,
        height: 16.0,
        padding: const EdgeInsets.all(2.0),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(width: 2.0, color: Colors.black)),
        child: isSelected
            ? Container(
                width: double.infinity,
                height: double.infinity,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: Colors.black),
              )
            : Container(),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Image.asset("assets/images/maritine.jpg"),
              ),
              Expanded(
                child: Container(),
              ),
            ],
          ),
          SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 28.0, vertical: 60.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Image.asset(
                        "assets/images/soremarlogo.png",
                        width: 110.w,
                        height: 110.h,
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        "SOREMAR",
                        style: TextStyle(
                          fontFamily: "CustomIcons",
                          fontSize: 46.sp,
                          letterSpacing: .6,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 100.h),
                  const FormCard(),
                  SizedBox(height: 40.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          const SizedBox(width: 12.0),
                          GestureDetector(
                            onTap: _radio,
                            child: radioButton(_isSelected),
                          ),
                          const SizedBox(width: 8.0),
                          Text(
                            "Remember me",
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontFamily: "CustomIcons",
                            ),
                          ),
                        ],
                      ),
                      InkWell(
                        child: Container(
                          width: 330.w,
                          height: 100.h,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF17ead9),
                                Color(0xFF6078ea),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(6.0),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF6078ea).withOpacity(.3),
                                offset: const Offset(0.0, 8.0),
                                blurRadius: 8.0,
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                Navigator.pushNamed(context, HomePage.path);
                              },
                              child: Center(
                                child: Text(
                                  "SIGN IN",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: "CustomIcons",
                                    fontSize: 18.sp,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 40.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
