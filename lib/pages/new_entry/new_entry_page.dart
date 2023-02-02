import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pill_medicine/common/convert_time.dart';
import 'package:pill_medicine/constants.dart';
import 'package:pill_medicine/globlal_bloc.dart';
import 'package:pill_medicine/models/errors.dart';
import 'package:pill_medicine/models/medicine.dart';
import 'package:pill_medicine/models/medicine_type.dart';
import 'package:pill_medicine/pages/new_entry/new_entry_block.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../success_screen/success_screen.dart';

class NewEntryPage extends StatefulWidget {
  const NewEntryPage({Key? key}) : super(key: key);

  @override
  State<NewEntryPage> createState() => _NewEntryPageState();
}

class _NewEntryPageState extends State<NewEntryPage> {
  late TextEditingController nameController;
  late TextEditingController dosageController;
  late  NewEntryBlock _newEntryBloc;
  late GlobalKey<ScaffoldState> _scaffoldKey;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nameController.dispose();
    dosageController.dispose();
    _newEntryBloc.dispose();
  }

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    dosageController = TextEditingController();
    _scaffoldKey = GlobalKey<ScaffoldState>();
    _newEntryBloc = NewEntryBlock();
    initializeErrorListen();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalBloc globalBloc = Provider.of<GlobalBloc>(context);
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Add New"),
        centerTitle: true,
      ),
      body: Provider<NewEntryBlock>.value(
        value: _newEntryBloc,
        child: Padding(
          padding: EdgeInsets.all(2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const PanelTitle(
                title: "Medicine Name",
                isRequired: true,
              ),
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                ),
                maxLength: 12,
                textCapitalization: TextCapitalization.words,
                style: Theme.of(context).textTheme.subtitle2!.copyWith(
                      color: kOtherColor,
                    ),
              ),
              const PanelTitle(
                title: "Dosage in mg",
                isRequired: false,
              ),
              TextFormField(
                controller: dosageController,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                ),
                maxLength: 12,
                textCapitalization: TextCapitalization.words,
                keyboardType: TextInputType.number,
                style: Theme.of(context).textTheme.subtitle2!.copyWith(
                      color: kOtherColor,
                    ),
              ),
              SizedBox(
                height: 2.h,
              ),
              const PanelTitle(
                title: "Medicine Type",
                isRequired: false,
              ),
              Padding(
                padding: EdgeInsets.only(top: 1.h),
                child: StreamBuilder<MedicineType>(
                    //new entry block
                    stream: _newEntryBloc.selectedMedicineType,
                    builder: (context, snapshot) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MedicineTypeColumn(
                        name: "bottle",
                        iconValue: "assets/icons/bottle.svg",
                        isSelected:
                            snapshot.data == MedicineType.bottle ? true : false,
                        medicineType: MedicineType.bottle,
                      ),
                      MedicineTypeColumn(
                        name: "pill",
                        iconValue: "assets/icons/pill.svg",
                        isSelected:
                            snapshot.data == MedicineType.pill ? true : false,
                        medicineType: MedicineType.pill,
                      ),
                      MedicineTypeColumn(
                        name: "syringe",
                        iconValue: "assets/icons/syringe.svg",
                        isSelected:
                            snapshot.data == MedicineType.syringe ? true : false,
                        medicineType: MedicineType.syringe,
                      ),
                      //change image from tablet
                      MedicineTypeColumn(
                        name: "tablet",
                        iconValue: "assets/icons/tablet.svg",
                        isSelected:
                            snapshot.data == MedicineType.tablet ? true : false,
                        medicineType: MedicineType.tablet,
                      ),
                    ],
                  );
                }),
              ),
              const PanelTitle(
                title: "Interval Selection",
                isRequired: true,
              ),
              const IntervalSelection(),
              const PanelTitle(
                title: "Starting Time",
                isRequired: true,
              ),
              const SelectTime(),
              SizedBox(
                height: 2.h,
              ),
              Padding(
                padding: EdgeInsets.only(left: 8.w, right: 8.w),
                child: SizedBox(
                  width: 80.w,
                  height: 8.h,
                  child: TextButton(
                    style: TextButton.styleFrom(
                        backgroundColor: kPrimaryColor,
                        shape: const StadiumBorder()),
                    child: Center(
                      child: Text(
                        "Confirm",
                        style: Theme.of(context).textTheme.subtitle2!.copyWith(
                              color: kScaffoldColor,
                            ),
                      ),
                    ),
                    onPressed: () {
                      //add medicine
                      //some Validation
                      String? medicineName;
                      int? dosage;

                      //medicineName
                      if(nameController.text == "" ){
                        _newEntryBloc.submitError(EntryError.nameNull);
                        return;
                      }
                      if(nameController.text != ""){
                        medicineName = nameController.text;
                      }
                      //dosage
                      if(dosageController.text == "" ){
                        dosage =0;
                      }
                      if(dosageController.text != ""){
                        dosage = int.parse(dosageController.text);
                      }
                      for(var medicine in globalBloc.medicineList$!.value){
                        if(medicineName == medicine.medicineName){
                          _newEntryBloc.submitError(EntryError.nameDuplicate);
                          return;
                        }
                      }
                      if(_newEntryBloc.selectIntervals!.value == 0){
                        _newEntryBloc.submitError(EntryError.interval);
                        return;
                      }
                      if(_newEntryBloc.selectTimeOfDay!.value == 'None'){
                        _newEntryBloc.submitError(EntryError.startTime);
                        return;
                      }
                      String medicineType =_newEntryBloc
                      .selectedMedicineType!.value
                      .toString().substring(13);

                      int interval =_newEntryBloc.selectIntervals!.value;
                      String startTime = _newEntryBloc.selectTimeOfDay!.value;
                      List<int> intIDs = makeIDs(
                        24 / _newEntryBloc.selectIntervals!.value
                      );
                      List<String> notificationIDs =intIDs.map((i) => i.toString()).toList();

                      Medicine newEntryMedicine = Medicine(
                          notificationIDs: notificationIDs,
                        medicineName: medicineName,
                        dosage: dosage,
                        medicineType: medicineType,
                        interval: interval,
                        startTime: startTime,
                      );
                      //update medicine list via global bloc
                      globalBloc.updateMedicineList(newEntryMedicine);


                      //go to success screen
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>SuccessScreen()));

                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void initializeErrorListen(){
    _newEntryBloc.errorState!.listen((EntryError error) {
      switch (error){
        case EntryError.nameNull:displayError("Please enter the medicine's name");break;
        case EntryError.nameDuplicate:displayError("Medicine name already exists");break;
        case EntryError.dosage:displayError("Please enter the dosage required");break;
        case EntryError.interval:displayError("Please select the reminder's interval");break;
        case EntryError.startTime:displayError("Please select the reminder's starting time");break;
        default:
      }
    });
  }
  void displayError(String error){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: kOtherColor,
        content:  Text(error),
      duration: const Duration(milliseconds: 2000),
      ),

    );
  }

  List<int> makeIDs(double n){
    var rng = Random();
    List<int> ids =[];
    for(int i =0 ; i<n;i++){
      ids.add(rng.nextInt(1000000000));
    }
    return ids;
  }
}

class SelectTime extends StatefulWidget {
  const SelectTime({Key? key}) : super(key: key);

  @override
  _SelectTimeState createState() => _SelectTimeState();
}

class _SelectTimeState extends State<SelectTime> {
  TimeOfDay _time = const TimeOfDay(hour: 0, minute: 00);
  bool _clicked = false;

  Future<TimeOfDay> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _time,
    );
    if (picked != null && picked != _time) {
      setState(() {
        _time = picked;
        _clicked = true;
      });
    }
    return picked!;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 8.h,
      child: Padding(
        padding: EdgeInsets.only(top: 2.h),
        child: TextButton(
          style: TextButton.styleFrom(
              backgroundColor: kPrimaryColor, shape: const StadiumBorder()),
          onPressed: () {
            _selectTime();
          },
          child: Center(
            child: Text(
              _clicked == false
                  ? "Select Time"
                  : "${convertTime(_time.hour.toString())}:${convertTime(_time.minute.toString())}",
              style: Theme.of(context).textTheme.subtitle2!.copyWith(
                    color: kScaffoldColor,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}

class IntervalSelection extends StatefulWidget {
  const IntervalSelection({Key? key}) : super(key: key);

  @override
  _IntervalSelectionState createState() => _IntervalSelectionState();
}

class _IntervalSelectionState extends State<IntervalSelection> {
  final _intervals = [
    6,
    8,
    12,
    24,
  ];
  var _selected = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 1.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Remind me every",
            style: Theme.of(context).textTheme.subtitle2!.copyWith(
              color: kTextColor
            ),
          ),
          DropdownButton(
            iconEnabledColor: kOtherColor,
            dropdownColor: kScaffoldColor,
            itemHeight: 8.h,
            hint: _selected == 0
                ? Text(
                    "Select an Interval",
                    style: Theme.of(context).textTheme.caption!.copyWith(
                      color: kPrimaryColor
                    ),
                  )
                : null,
            elevation: 4,
            value: _selected == 0 ? null : _selected,
            items: _intervals.map(
              (int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text(
                    value.toString(),
                    style: Theme.of(context).textTheme.caption!.copyWith(
                          color: kSeconderColor,
                        ),
                  ),
                );
              },
            ).toList(),
            onChanged: (newVal) {
              setState(
                () {
                  _selected = newVal!;
                },
              );
            },
          ),
          Text(
            _selected == 1 ? "hour" : "hours",
            style: Theme.of(context).textTheme.subtitle2!.copyWith(
              color: kTextColor
            ),
          )
        ],
      ),
    );
  }
}

class PanelTitle extends StatelessWidget {
  final String title;
  final bool isRequired;

  const PanelTitle({Key? key, required this.title, required this.isRequired})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 2.h),
      child: Text.rich(
        TextSpan(children: <TextSpan>[
          TextSpan(
            text: title,
            style: Theme.of(context).textTheme.labelMedium,
          ),
          TextSpan(
            text: isRequired ? " *" : "",
            style: Theme.of(context).textTheme.labelMedium!.copyWith(
                  color: kPrimaryColor,
                ),
          ),
        ]),
      ),
    );
  }
}

class MedicineTypeColumn extends StatelessWidget {
  final String name;
  final String iconValue;
  final bool isSelected;
  final MedicineType medicineType;

  const MedicineTypeColumn({
    Key? key,
    required this.name,
    required this.iconValue,
    required this.isSelected,
    required this.medicineType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final NewEntryBlock newEntryBlock = Provider.of<NewEntryBlock>(context);
    return GestureDetector(
      onTap: () {
        //select medicine type
        newEntryBlock.updateSelectedMedicine(medicineType);
      },
      child: Column(
        children: [
          Container(
            width: 20.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3.h),
              color: isSelected ? kOtherColor : kWhite,
            ),
            child: Center(
              child: Padding(
                padding: EdgeInsets.only(
                  top: 1.h,
                  bottom: 1.h,
                ),
                child: SvgPicture.asset(
                  iconValue,
                  height: 7.h,
                  color: isSelected ? kWhite : kOtherColor,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 1.h),
            child: Container(
              width: 20.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: isSelected ? kOtherColor : Colors.transparent,
                borderRadius: BorderRadius.circular(3.h),
              ),
              child: Center(
                child: Text(
                  name,
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2!
                      .copyWith(color: isSelected ? kWhite : kOtherColor),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
