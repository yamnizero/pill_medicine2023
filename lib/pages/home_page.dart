import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pill_medicine/constants.dart';
import 'package:pill_medicine/pages/new_entry/new_entry_page.dart';
import 'package:sizer/sizer.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding:  EdgeInsets.all(2.h),
        child: Column(
          children:  [
             const ToContainer(),
            SizedBox(height: 2.h,),
            const Flexible(child: BottomContainer())
          ],
        ),
      ),
      floatingActionButton: InkResponse(
        onTap: (){
          //go to new entry page..
          Navigator.push(context, MaterialPageRoute(builder: (context)=>const NewEntryPage()));
        },
        child: SizedBox(
          width: 18.w,
          height: 9.h,
          child: Card(
            color: kPrimaryColor,
            shape: BeveledRectangleBorder(
              borderRadius: BorderRadius.circular(3.h),
            ),
            child: Icon(
              Icons.add_outlined,
              color: kScaffoldColor,
              size: 50.sp,
            ),
          ),
        ),
      ),
    );
  }
}

class ToContainer extends StatelessWidget {
  const ToContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
            alignment: Alignment.topLeft,
            padding:  EdgeInsets.only(bottom: 1.h),
            child: Text("Worry less. \nLive healthier.",
                textAlign: TextAlign.start,
                style: Theme.of(context).textTheme.headline4,)),
        Container(
            alignment: Alignment.topLeft,
            padding:  EdgeInsets.only(bottom: 1.h),
            child: Text("Welcome to Daily Dose",style: Theme.of(context).textTheme.subtitle2,)),
        SizedBox(height: 2.h,),
        Container(
            alignment: Alignment.center,
            padding:  EdgeInsets.only(bottom: 1.h),
            child: Text("0",style: Theme.of(context).textTheme.headline4,)),
      ],
    );
  }
}

class BottomContainer extends StatelessWidget {
  const BottomContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Center(
      child: Text("No Medicine",textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.headline3,
      ),
    );
  }
}


