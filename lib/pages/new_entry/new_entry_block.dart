import 'package:pill_medicine/models/errors.dart';
import 'package:pill_medicine/models/medicine_type.dart';
import 'package:rxdart/rxdart.dart';

class NewEntryBlock {
  BehaviorSubject<MedicineType>? _selectedMedicineType$;

  ValueStream<MedicineType>? get selectedMedicineType =>
      _selectedMedicineType$!.stream;

  BehaviorSubject<int>? _selectedInterval$;

  BehaviorSubject<int>? get selectIntervals => _selectedInterval$;

  BehaviorSubject<String>? _selectedTimeOfDay$;

  BehaviorSubject<String>? get selectTimeOfDay => _selectedTimeOfDay$;

  //error state
  BehaviorSubject<EntryError>? _errorState$;

  BehaviorSubject<EntryError>? get errorState => _errorState$;

  NewEntryBlock() {
    _selectedMedicineType$ =
        BehaviorSubject<MedicineType>.seeded(MedicineType.none);
    _selectedTimeOfDay$ = BehaviorSubject<String>.seeded('none');
    _selectedInterval$ = BehaviorSubject<int>.seeded(0);
    _errorState$ = BehaviorSubject<EntryError>();
  }

  void dispose() {
    _selectedMedicineType$!.close();
    _selectedTimeOfDay$!.close();
    _selectedInterval$!.close();
  }

  void submitError(EntryError error) {
    _errorState$!.add(error);
  }

  void updateInterval(int interval) {
    _selectedInterval$!.add(interval);
  }

  void updateTime(String time) {
    _selectedTimeOfDay$!.add(time);
  }

  void updateSelectedMedicine(MedicineType type) {
    MedicineType _tempType = _selectedMedicineType$!.value;
    if (type == _tempType) {
      _selectedMedicineType$!.add(MedicineType.none);
    } else {
      _selectedMedicineType$!.add(type);
    }
  }

}
