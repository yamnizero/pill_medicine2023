import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pill_medicine/constants.dart';
import 'package:pill_medicine/globlal_bloc.dart';
import 'package:pill_medicine/models/medicine.dart';
import 'package:pill_medicine/pages/medicine_details/medicine_details.dart';
import 'package:pill_medicine/pages/new_entry/new_entry_page.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.all(2.h),
        child: Column(
          children: [
            const ToContainer(),
            SizedBox(
              height: 2.h,
            ),
            const Flexible(child: BottomContainer())
          ],
        ),
      ),
      floatingActionButton: InkResponse(
        onTap: () {
          //go to new entry page..
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const NewEntryPage()));
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
    final GlobalBloc globalBloc = Provider.of<GlobalBloc>(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.only(bottom: 1.h),
            child: Text(
              "Worry less. \nLive healthier.",
              textAlign: TextAlign.start,
              style: Theme.of(context).textTheme.headline4,
            )),
        Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.only(bottom: 1.h),
            child: Text(
              "Welcome to Daily Dose",
              style: Theme.of(context).textTheme.subtitle2,
            )),
        SizedBox(
          height: 2.h,
        ),
        //show number of saved medicines from shared preferences
        StreamBuilder<List<Medicine>>(
          stream: globalBloc.medicineList$,
            builder: (context, snapshot) {
          return Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(bottom: 1.h),
              child: Text(
                !snapshot.hasData ? '0' : snapshot.data!.length.toString(),
                style: Theme.of(context).textTheme.headline4,
              ));
        }),
      ],
    );
  }
}

class BottomContainer extends StatelessWidget {
  const BottomContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalBloc globalBloc = Provider.of<GlobalBloc>(context);
    // return Center(
    //   child: Text(
    //     "No Medicine",
    //     textAlign: TextAlign.center,
    //     style: Theme.of(context).textTheme.headline3,
    //   ),
    // );
   return StreamBuilder<List<Medicine>>(
        stream: globalBloc.medicineList$,
        builder: (context, snapshot) {
        if(!snapshot.hasData){
          //if no data is   saved
          return Container();
        }else if(snapshot.data!.isEmpty){
          return Center(
            child: Text("No Medicine",style: Theme.of(context).textTheme.headline3,),
          );
        }else{
          return GridView.builder(
              padding: EdgeInsets.only(top: 1.h),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return  MedicineCard(
                  medicine: snapshot.data![index],
                );
              }
          );
        }
        });
  }
}

class MedicineCard extends StatelessWidget {
  //for getting the current details of the saved items
  final Medicine medicine;
  const MedicineCard({Key? key, required this.medicine}) : super(key: key);

  Hero makeIcon(double size){
    if(medicine.medicineType == 'Bottle'){
      return Hero(tag: medicine.medicineName! + medicine.medicineType!,
        child: SvgPicture.asset('assets/icons/bottle.svg',color: kOtherColor,height: 7.h,),
      );
    }else if(medicine.medicineType == 'Pill'){
      return Hero(tag: medicine.medicineName! + medicine.medicineType!,
        child: SvgPicture.asset('assets/icons/pill.svg',color: kOtherColor,height: 7.h,),
      );
    }else if(medicine.medicineType == 'Syringe'){
      return Hero(tag: medicine.medicineName! + medicine.medicineType!,
        child: SvgPicture.asset('assets/icons/syringe.svg',color: kOtherColor,height: 7.h,),
      );
    }else if(medicine.medicineType == 'Tablet'){
      return Hero(tag: medicine.medicineName! + medicine.medicineType!,
        child: SvgPicture.asset('assets/icons/tablet.svg',color: kOtherColor,height: 7.h,),
      );
    }
    // in case of no medicine
    return Hero(
      tag: medicine.medicineName! + medicine.medicineType!,
      child:  Icon(Icons.error,color: kOtherColor,size: size,),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: kWhite,
      splashColor: Colors.grey ,
      child: Container(
        padding: EdgeInsets.only(left: 2.w,right: 2.w,top: 1.h,bottom: 1.h),
        margin: EdgeInsets.all(1.h),
        decoration: BoxDecoration(
            color: kWhite, borderRadius: BorderRadius.circular(2.h)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            makeIcon(7.h),
            const Spacer(),
            Hero(
              tag: medicine.medicineName!,
              child: Text(
              medicine.medicineName!,
                overflow: TextOverflow.fade,
                textAlign: TextAlign.start,
                style: Theme.of(context).textTheme.headline6,),
            ),
            SizedBox(height: 0.3.h,),
            //time interval data with condition....
            Text(medicine.interval == 1 ? "Every ${medicine.interval} hour" : "Every ${medicine.interval} hour",
              overflow: TextOverflow.fade,
              textAlign: TextAlign.start,
              style: Theme.of(context).textTheme.caption,),
          ],
        ),
      ),
      onTap: (){
        //go to details activity,,,
        Navigator.of(context).push(PageRouteBuilder<void>(
            pageBuilder: (BuildContext context,Animation<double> animation,Animation<double> secondaryAnimation){
              return AnimatedBuilder(
                animation: animation,
                builder: (context, Widget? child) {
                  return Opacity(
                    opacity: animation.value,
                    child: MedicineDetails(medicine),
                  );
                },
              );
            },
          transitionDuration: const Duration(milliseconds: 500),
        ),
        );

      },
    );
  }
}

