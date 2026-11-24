import 'dart:async';
import 'package:crafty_bay/core/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/app_colors.dart';
import '../../../../core/app_strings.dart';
import '../../auth/login/view/login_page.dart';
import '../widget/splash_loader.dart';



class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Timer? _timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _timer = Timer(Duration(seconds: 3), (){   Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {


    return  Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
          child: SizedBox.expand(
            child: Stack(
              alignment: Alignment.center,
              children: [
                SvgPicture.asset(AppAssets.logo,width: 160,),
              const Positioned(
                bottom: 24,
                left: 0,
                right: 0,
                child: Column(
                    spacing: 16,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                    SplashLoader(),
                Text(
                  AppStrings.appVersion,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  )
                )
              ],
            ),
          ),
            ]
      ),
      ),
    )
    );
  }
}
