import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pill_medicine/constants.dart';
import 'package:pill_medicine/pages/home_page.dart';
import 'package:sizer/sizer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return MaterialApp(
        title: 'Pill Reminder',
        theme: ThemeData.dark().copyWith(
          primaryColor: kPrimaryColor,
          scaffoldBackgroundColor: kScaffoldColor,
          //appbar theme
          appBarTheme: AppBarTheme(
              backgroundColor: kScaffoldColor,
              elevation: 0,
              toolbarHeight: 7.h,
              iconTheme: IconThemeData(
                color: kSeconderColor,
                size: 20.sp,
              ),
              titleTextStyle: GoogleFonts.mulish(
                color: kTextColor,
                fontWeight: FontWeight.w800,
                fontStyle: FontStyle.normal,
                fontSize: 16.sp,
              )),
          textTheme: TextTheme(
              headline3: TextStyle(
                fontSize: 28.sp,
                fontWeight: FontWeight.w500,
                color: kSeconderColor,
              ),
              headline4: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.w800,
                color: kTextColor,
              ),
              subtitle2: GoogleFonts.poppins(
                fontSize: 12.sp,
                color: kTextColor,
              ),
              caption: GoogleFonts.poppins(
                fontSize: 9.sp,
                fontWeight: FontWeight.w500,
                color: kPrimaryColor
              ),
              labelMedium: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.w500,
                color: kTextColor,
              )),
          inputDecorationTheme: const InputDecorationTheme(
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
              color: kTextLightColor,
              width: 0.7,
            )),
            border: UnderlineInputBorder(
              borderSide: BorderSide(
                color: kTextLightColor,
              ),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: kPrimaryColor),
            ),
          ),
        ),
        home: const HomePage(),
      );
    });
  }
}
