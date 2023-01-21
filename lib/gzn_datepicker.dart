// ignore_for_file: must_be_immutable, depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class DatePickerDialogV1 extends StatelessWidget {
  List<String> disabledDate;
  DateRangePickerController controller;
  DateRangePickerSelectionMode selectionMode;

  DatePickerDialogV1({
    Key? key,
    required this.disabledDate,
    required this.controller,
    this.selectionMode = DateRangePickerSelectionMode.single, //multi, single, range, extendableRange, multiRange
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

  _DatePickerV1({
    Key? key,
    required this.onSelectionChanged,
    required this.disabledDate,
    required this.controller,
    required this.selectionMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    List<DateTime> weekends = _getWeekends(disabledDate);
    return SizedBox(
      height: height * 0.5,
      width: width,
      child: SfDateRangePicker(
        controller: controller,
        navigationDirection: DateRangePickerNavigationDirection.vertical,
        navigationMode: DateRangePickerNavigationMode.scroll,
        backgroundColor: Colors.grey.withOpacity(0.05),
        toggleDaySelection: true,
        viewSpacing: 20,
        view: DateRangePickerView.month,
        monthViewSettings: DateRangePickerMonthViewSettings(
          weekendDays: const [7, 6],
          showTrailingAndLeadingDates: true,
          specialDates: [DateTime.now()],
          blackoutDates: weekends,
        ),
        monthCellStyle: DateRangePickerMonthCellStyle(
          specialDatesDecoration: BoxDecoration(
            border: Border.all(color: Colors.blue, width: 1),
            shape: BoxShape.circle,
          ),
          weekendDatesDecoration: BoxDecoration(color: Colors.red.withOpacity(0.15), shape: BoxShape.circle),
          todayCellDecoration: BoxDecoration(color: Colors.red.withOpacity(0.3), shape: BoxShape.circle),
          specialDatesTextStyle: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
        ),
        // enablePastDates: false,
        onSelectionChanged: onSelectionChanged,
        selectionMode: selectionMode,
        selectableDayPredicate: (DateTime date) {
          if (date.weekday == DateTime.saturday || date.weekday == DateTime.sunday) {
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

List<DateTime> _getWeekends(List<String> disabledDate) {
  List<DateTime> allDate = _getDaysInBetween(DateTime(DateTime.now().year - 3), DateTime(DateTime.now().year + 3));
  List<DateTime> weekends = [];
  for (var i = 0; i < allDate.length; i++) {
    if (allDate[i].weekday == DateTime.saturday || allDate[i].weekday == DateTime.sunday) {
      weekends.add(allDate[i]);
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
