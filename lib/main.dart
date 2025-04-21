//import 'views/onboardingscreen.dart';
//import 'views/member/member_dashboard.dart';
import 'views/admin/admin_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart'; 
import 'package:google_fonts/google_fonts.dart';
import 'package:device_preview/device_preview.dart';

void main() {
  runApp(
      DevicePreview(
        ///enabled: !kReleaseMode,
        builder: (context) =>
            MyApp(), // Wrap your app
      ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp( // replace MaterialApp with GetMaterialApp
      theme: ThemeData(
        textTheme: GoogleFonts.latoTextTheme(
          Theme.of(context).textTheme,
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xff274560),
          brightness: Brightness.light,
        ),
      ),
      //      home: OnBoardingScreen(),
      title: 'Club Management System',
      //home: const MemberDashboard(),
      home: const AdminDashboard(),
      debugShowCheckedModeBanner: false,
    );
  }
}
