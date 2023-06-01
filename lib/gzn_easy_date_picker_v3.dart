// ignore_for_file: must_be_immutable, depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class EasyDatePickerV3 extends StatelessWidget {
  List<String> disabledDate;
  DateRangePickerController controller;
  DateRangePickerSelectionMode selectionMode;
  bool enablePastDates;
  List<int> weekendDays;
  List<String> spesialDays;

  EasyDatePickerV3({
    Key? key,
    required this.disabledDate,
    required this.controller,
    this.selectionMode = DateRangePickerSelectionMode.single, //multi, single, range, extendableRange, multiRange
    this.enablePastDates = true,
    this.weekendDays = const [6, 7],
    this.spesialDays = const [],
  }) : super(key: key);

  void onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    List<DateTime> res = [];
    if (args.value is PickerDateRange) {
      res = _getDaysInBetween(
        args.value.startDate,
        args.value.endDate ?? args.value.startDate,
      );
      res = _clearWeekendsDays(res);
    } else if (args.value is DateTime) {
      res = [args.value];
    } else if (args.value is List<DateTime>) {
      res = args.value;
    } else {
      res = [];
    }
    controller.selectedDates = res;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.transparent,
      contentPadding: EdgeInsets.zero,
      elevation: 0.0,
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(16.0)),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _DatePickerV3(
                  onSelectionChanged: onSelectionChanged,
                  disabledDate: disabledDate,
                  controller: controller,
                  selectionMode: selectionMode,
                  enablePastDates: enablePastDates,
                  weekendDays: weekendDays,
                  spesialDays: spesialDays,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        controller.selectedDates = [];
                        Navigator.of(context).pop(true);
                      },
                      child: const Text('RESET'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('NO'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text('YES'),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

//https://help.syncfusion.com/flutter/daterangepicker/overview
class _DatePickerV3 extends StatelessWidget {
  void Function(DateRangePickerSelectionChangedArgs args) onSelectionChanged;
  List<String> disabledDate;
  DateRangePickerController controller;
  DateRangePickerSelectionMode selectionMode;
  bool enablePastDates;
  List<int> weekendDays;
  List<String> spesialDays;

  _DatePickerV3({
    Key? key,
    required this.onSelectionChanged,
    required this.disabledDate,
    required this.controller,
    required this.selectionMode,
    required this.enablePastDates,
    required this.weekendDays,
    required this.spesialDays,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    // List<DateTime> blackoutDates = ;
    return SizedBox(
      height: height * 0.5,
      width: width,
      child: SfDateRangePicker(
        controller: controller,
        showTodayButton: true,
        enablePastDates: enablePastDates,
        navigationDirection: DateRangePickerNavigationDirection.vertical,
        navigationMode: DateRangePickerNavigationMode.scroll,
        backgroundColor: Colors.grey.withOpacity(0.05),
        toggleDaySelection: true,
        viewSpacing: 20,
        view: DateRangePickerView.month,
        monthViewSettings: DateRangePickerMonthViewSettings(
          showTrailingAndLeadingDates: true,
          blackoutDates: _stringToDate(disabledDate),
          weekendDays: weekendDays,
          specialDates: _stringToDate(spesialDays),
        ),
        monthCellStyle: DateRangePickerMonthCellStyle(
          //grey color
          blackoutDatesDecoration: BoxDecoration(color: Colors.grey.withOpacity(0.15), shape: BoxShape.circle),
          blackoutDateTextStyle: const TextStyle(color: Colors.grey, decoration: TextDecoration.lineThrough),
          //red color
          weekendDatesDecoration: BoxDecoration(color: Colors.red.withOpacity(0.15), shape: BoxShape.circle),
          weekendTextStyle: const TextStyle(color: Colors.red, decoration: TextDecoration.lineThrough),
          //orange color
          specialDatesDecoration: BoxDecoration(color: Colors.green.withOpacity(0.15), shape: BoxShape.circle),
          specialDatesTextStyle: const TextStyle(color: Colors.green, decoration: TextDecoration.lineThrough),
          //green
          todayCellDecoration: BoxDecoration(color: Colors.green.withOpacity(0.15), shape: BoxShape.circle),
          todayTextStyle: const TextStyle(color: Colors.green, decoration: TextDecoration.lineThrough),
        ),
        onSelectionChanged: onSelectionChanged,
        selectionMode: selectionMode,
        selectableDayPredicate: (DateTime date) {
          if (weekendDays.contains(date.weekday)) {
            return false;
          }
          if (disabledDate.contains(DateFormat('yyyy-MM-dd').format(date))) {
            return false;
          }
          return true;
        },
      ),
    );
  }
}

List<DateTime> _stringToDate(List<String> disabledDate) {
  List<DateTime> res = [];
  for (var i = 0; i < disabledDate.length; i++) {
    res.add(DateTime.parse(disabledDate[i]));
  }
  return res;
}

// List<DateTime> _getBlackoutDates(List<String> disabledDate, List<int> addWeekend) {
//   List<DateTime> allDate = _getDaysInBetween(DateTime(DateTime.now().year - 3), DateTime(DateTime.now().year + 3));
//   List<DateTime> weekends = [];
//   if (addWeekend) {
//     for (var i = 0; i < allDate.length; i++) {
//       if (allDate[i].weekday == DateTime.saturday || allDate[i].weekday == DateTime.sunday) {
//         weekends.add(allDate[i]);
//       }
//     }
//   }
//   for (var i = 0; i < disabledDate.length; i++) {
//     weekends.add(DateTime.parse(disabledDate[i]));
//   }
//   return weekends;
// }

List<DateTime> _clearWeekendsDays(List<DateTime> allDate) {
  List<DateTime> res = [];
  for (var i = 0; i < allDate.length; i++) {
    if (allDate[i].weekday == DateTime.saturday || allDate[i].weekday == DateTime.sunday) {
      //ignore
    } else {
      res.add(allDate[i]);
    }
  }
  return res;
}

List<DateTime> _getDaysInBetween(DateTime startDate, DateTime endDate) {
  List<DateTime> days = [];
  for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
    days.add(startDate.add(Duration(days: i)));
  }
  return days;
}

String generateDate(List<DateTime> date) {
  var selectedDate = "";
  if (date.isNotEmpty) {
    for (var i = 0; i < date.length; i++) {
      selectedDate = "$selectedDate${DateFormat('yyyy-MM-dd').format(date[i])}, ";
    }
    selectedDate = selectedDate.substring(0, selectedDate.lastIndexOf(", "));
  }
  return selectedDate;
}

String generateDateV2(List<DateTime> date) {
  var selectedDate = "";
  if (date.isNotEmpty) {
    for (var i = 0; i < date.length; i++) {
      if (i == 0) {
        selectedDate = "$selectedDate${DateFormat('yyyy-MM-dd').format(date[i])} sd ";
      }
      if (i == date.length - 1) {
        selectedDate = "$selectedDate${DateFormat('yyyy-MM-dd').format(date[i])}";
      }
    }
  }
  return selectedDate;
}
