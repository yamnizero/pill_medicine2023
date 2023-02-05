import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pill_medicine/constants.dart';
import 'package:pill_medicine/models/medicine.dart';
import 'package:sizer/sizer.dart';

class MedicineDetails extends StatefulWidget {
  final Medicine medicine;
  const MedicineDetails(this.medicine,{Key? key}) : super(key: key);

  @override
  _MedicineDetailsState createState() => _MedicineDetailsState();
}

class _MedicineDetailsState extends State<MedicineDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Details"),
        centerTitle: true,
      ),
      body: Padding(
        padding:  EdgeInsets.all(2.h),
        child: Column(
          children:   [
            const MainSection(),
            const  ExtendedSection(),
            const Spacer(),
            SizedBox(
              width: 100.w,
              height: 7.h,
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: kSeconderColor,
                  shape: const StadiumBorder(),

                ),
                child:  Text(
                  "Delete",
                  style: Theme.of(context).textTheme.subtitle1!.copyWith(
                    color: kScaffoldColor
                  ),
                ),
                onPressed: () {
                  //open  alert dialog box ,
                  openAlertBox(context);
                },
              ),
            ),
            SizedBox(height: 2.h,),
          ],
        ),
      ),
    );
  }

  openAlertBox(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: kScaffoldColor,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              bottomRight: Radius.circular(20.0),
            ),
          ),
          contentPadding: EdgeInsets.only(top: 1.h),
          title: Text(
            'Delete This Reminder?',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.subtitle1,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: Theme.of(context).textTheme.caption,
              ),
            ),
            TextButton(
              onPressed: () {
                // global block  to delete medicine ,
              },
              child: Text(
                'OK',
                style: Theme.of(context).textTheme.caption!.copyWith(
                  color: kSeconderColor
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class MainSection extends StatelessWidget {
  const MainSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        SvgPicture.asset(
          'assets/icons/bottle.svg',
          height: 7.h,
          color: kOtherColor,
        ),
        SizedBox(width: 2.w,),
        Column(
          children: const [
            MainInfoTab(
              fieldTitle: "Medicine Name",
              fieldInfo: "Catapol",
            ),
            MainInfoTab(
              fieldTitle: "Dosage",
              fieldInfo: "500",
            ),
          ],
        ),
      ],
    );
  }
}

class MainInfoTab extends StatelessWidget {
  final String fieldTitle;
  final String fieldInfo;

  const MainInfoTab(
      {Key? key, required this.fieldTitle, required this.fieldInfo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40.w,
      height: 10.h,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              fieldTitle,
              style: Theme.of(context).textTheme.subtitle2,
            ),
            SizedBox(
              height: .3.h,
            ),
            Text(
              fieldInfo,
              style: Theme.of(context).textTheme.headline5,
            ),
          ],
        ),
      ),
    );
  }
}

class ExtendedInfoTab extends StatelessWidget {
  final String fieldTitle;
  final String fieldInfo;
  const ExtendedInfoTab({Key? key, required this.fieldTitle, required this.fieldInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.symmetric(vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:  EdgeInsets.only(bottom: 1.h),
            child: Text(
              fieldTitle,
              style: Theme.of(context).textTheme.subtitle2!.copyWith(
              color: kTextColor,
            ),),
          ),
          Text(
            fieldInfo,
            style: Theme.of(context).textTheme.caption!.copyWith(
            color: kSeconderColor,
          ),),
        ],
      ),
    );
  }
}

class ExtendedSection extends StatelessWidget {
  const ExtendedSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: const [
        ExtendedInfoTab(
          fieldTitle: 'Medicine Type',
          fieldInfo: 'pill',
        ),
        ExtendedInfoTab(
          fieldTitle: 'Dose Interval',
          fieldInfo: 'Every 8 hours | 3 time a day',
        ),
        ExtendedInfoTab(
          fieldTitle: 'Start Time',
          fieldInfo: '09:30',
        ),
      ],
    );
  }
}


