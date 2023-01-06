import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pill_medicine/constants.dart';
import 'package:pill_medicine/models/medicine_type.dart';
import 'package:sizer/sizer.dart';

class NewEntryPage extends StatefulWidget {
  const NewEntryPage({Key? key}) : super(key: key);

  @override
  State<NewEntryPage> createState() => _NewEntryPageState();
}

class _NewEntryPageState extends State<NewEntryPage> {
  late TextEditingController nameController;
  late TextEditingController dosageController;

  late GlobalKey<ScaffoldState> _scaffoldKey;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nameController.dispose();
    dosageController.dispose();
  }

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    dosageController = TextEditingController();
    _scaffoldKey = GlobalKey<ScaffoldState>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Add New"),
        centerTitle: true,
      ),
      body: Padding(
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
              child: StreamBuilder(
                  //new entry block
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
                      name: "syringe",
                      iconValue: "assets/icons/syringe.svg",
                      isSelected:
                          snapshot.data == MedicineType.syringe ? true : false,
                      medicineType: MedicineType.syringe,
                    ),
                  ],
                );
              }),
            ),
            const PanelTitle(
              title: "Interval Selection",
              isRequired: true,
            ),
            IntervalSelection()
          ],
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


            style: Theme.of(context).textTheme.subtitle2,
          ),
          DropdownButton(
            iconEnabledColor: kOtherColor,
            dropdownColor: kScaffoldColor,
            itemHeight: 8.h,
            hint: _selected == 0
                ? Text(
                    "Select an Interval",
                    style: Theme.of(context).textTheme.caption,
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
          Text(_selected == 1 ? "hour" : "hours",
          style: Theme.of(context).textTheme.subtitle2 ,
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
    return GestureDetector(
      onTap: () {
        //select medicine type
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
