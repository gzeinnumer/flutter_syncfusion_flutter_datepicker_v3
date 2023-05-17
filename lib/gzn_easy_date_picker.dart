// ignore_for_file: must_be_immutable, depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class EasyDatePicker extends StatelessWidget {
  List<String> disabledDate;
  DateRangePickerController controller;
  DateRangePickerSelectionMode selectionMode;
  bool enablePastDates;
  bool enableWeekends;

  EasyDatePicker({
    Key? key,
    required this.disabledDate,
    required this.controller,
    this.selectionMode = DateRangePickerSelectionMode.single, //multi, single, range, extendableRange, multiRange
    this.enablePastDates = true,
    this.enableWeekends = true,
  }) : super(key: key);

  void onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    List<DateTime> res = [];
    if (args.value is PickerDateRange) {
      res = _getDaysInBetween(args.value.startDate, args.value.endDate ?? args.value.startDate);
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
                _DatePickerV1(
                  onSelectionChanged: onSelectionChanged,
                  disabledDate: disabledDate,
                  controller: controller,
                  selectionMode: selectionMode,
                  enablePastDates: enablePastDates,
                  enableWeekends: enableWeekends,
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
class _DatePickerV1 extends StatelessWidget {
  void Function(DateRangePickerSelectionChangedArgs args) onSelectionChanged;
  List<String> disabledDate;
  DateRangePickerController controller;
  DateRangePickerSelectionMode selectionMode;
  bool enablePastDates;
  bool enableWeekends;

  _DatePickerV1({
    Key? key,
    required this.onSelectionChanged,
    required this.disabledDate,
    required this.controller,
    required this.selectionMode,
    required this.enablePastDates,
    required this.enableWeekends,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    List<DateTime> blackoutDates = _getBlackoutDates(disabledDate, enableWeekends);
    return SizedBox(
      height: height * 0.5,
      width: width,
      child: SfDateRangePicker(
        controller: controller,
        enablePastDates: enablePastDates,
        navigationDirection: DateRangePickerNavigationDirection.vertical,
        navigationMode: DateRangePickerNavigationMode.scroll,
        backgroundColor: Colors.grey.withOpacity(0.05),
        toggleDaySelection: true,
        viewSpacing: 20,
        view: DateRangePickerView.month,
        monthViewSettings: DateRangePickerMonthViewSettings(
          showTrailingAndLeadingDates: true,
          blackoutDates: blackoutDates,
        ),
        monthCellStyle: DateRangePickerMonthCellStyle(
          blackoutDatesDecoration: BoxDecoration(color: Colors.red.withOpacity(0.15), shape: BoxShape.circle),
          blackoutDateTextStyle: const TextStyle(color: Colors.red, decoration: TextDecoration.lineThrough),
        ),
        onSelectionChanged: onSelectionChanged,
        selectionMode: selectionMode,
        selectableDayPredicate: (DateTime date) {
          if (disabledDate.contains(DateFormat('yyyy-MM-dd').format(date))) {
            return false;
          }
          return true;
        },
      ),
    );
  }
}

List<DateTime> _getBlackoutDates(List<String> disabledDate, bool addWeekend) {
  List<DateTime> allDate = _getDaysInBetween(DateTime(DateTime.now().year - 3), DateTime(DateTime.now().year + 3));
  List<DateTime> weekends = [];
  if (addWeekend) {
    for (var i = 0; i < allDate.length; i++) {
      if (allDate[i].weekday == DateTime.saturday || allDate[i].weekday == DateTime.sunday) {
        weekends.add(allDate[i]);
      }
    }
  }
  for (var i = 0; i < disabledDate.length; i++) {
    weekends.add(DateTime.parse(disabledDate[i]));
  }
  return weekends;
}

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
