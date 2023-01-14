import 'package:flutter/material.dart';

// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _dates = "";
  List<String> _datesList = [];

  DateRangePickerController _datePickerController = DateRangePickerController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Text(
              'Click Plus Show Dialog',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => ExamplesDialog(disabledDate: [], controller: _datePickerController),
          ).then((value) {
            // if (value == null || value == "") return;
            // _dates = value;
            // _datesList = value.split(', ');
            // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            //   content: Text("$value"),
            // ));
            var selectedDate = "";

            if(_datePickerController.selectedDates!.isEmpty){
              selectedDate = "";
            } else{
              for(var i=0; i<_datePickerController.selectedDates!.length; i++){
                selectedDate = "$selectedDate${DateFormat('yyyy-MM-dd').format(_datePickerController.selectedDates![i])}, ";
              }
              selectedDate = selectedDate.substring(0, selectedDate.lastIndexOf(", "));
            }
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(selectedDate),
            ));
          });
          ;
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class ExamplesDialog extends StatelessWidget {
  List<String> disabledDate;
  DateRangePickerController controller;

  ExamplesDialog({
    Key? key,
    required this.disabledDate,
    required this.controller,
  }) : super(key: key);

  String _selectedDate = '';
  String _dateCount = '';
  String _range = '';
  String _rangeCount = '';
  String _result = '';

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    if (args.value is PickerDateRange) {
      _range = '${DateFormat('yyyy-MM-dd').format(args.value.startDate)} - ${DateFormat('yyyy-MM-dd').format(args.value.endDate ?? args.value.startDate)}';

      _result = _range;
    } else if (args.value is DateTime) {
      _selectedDate = args.value.toString();

      _result = _selectedDate;
    } else if (args.value is List<DateTime>) {
      _dateCount = args.value.length.toString();
      _selectedDate = "";
      for (var i = 0; i < args.value.length; i++) {
        _selectedDate = "$_selectedDate${DateFormat('yyyy-MM-dd').format(args.value[i])}, ";
      }
      _selectedDate = _selectedDate.substring(0, _selectedDate.lastIndexOf(", "));

      _result = _selectedDate;
    } else {
      _rangeCount = args.value.length.toString();

      _result = _rangeCount;
    }
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
                // Column(
                //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: <Widget>[
                //     Text('Selected date: $_selectedDate'),
                //     Text('Selected date count: $_dateCount'),
                //     Text('Selected range: $_range'),
                //     Text('Selected ranges count: $_rangeCount'),
                //   ],
                // ),
                DatePickerV1(
                  onSelectionChanged: _onSelectionChanged,
                  disabledDate: disabledDate,
                  controller: controller,
                  // disabledDate: ["2023-01-26", "2023-01-27"],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextButton(
                      // onPressed: () => Navigator.of(context).pop('NO'),
                      onPressed: () => Navigator.of(context).pop(null),
                      child: const Text('NO'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(_result),
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

class DatePickerV1Model {
  String selectedDate;
  String dateCount;
  String range;
  String rangeCount;

  DatePickerV1Model({
    Key? key,
    this.selectedDate = '',
    this.dateCount = '',
    this.range = '',
    this.rangeCount = '',
  });
}

//https://help.syncfusion.com/flutter/daterangepicker/overview
// ignore: must_be_immutable
class DatePickerV1 extends StatelessWidget {
  void Function(DateRangePickerSelectionChangedArgs args) onSelectionChanged;
  List<String> disabledDate;
  DateRangePickerController controller;

  DatePickerV1({
    Key? key,
    required this.onSelectionChanged,
    required this.disabledDate,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
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
          specialDates: [
            DateTime.now(),
          ],
          showTrailingAndLeadingDates: true,
        ),
        monthCellStyle: DateRangePickerMonthCellStyle(
          specialDatesDecoration: BoxDecoration(
            // color: Colors.blue,
            border: Border.all(color: Colors.blue, width: 1),
            shape: BoxShape.circle,
          ),
          weekendDatesDecoration: BoxDecoration(
            color: Colors.red.withOpacity(0.3),
            shape: BoxShape.circle,
          ),
          todayCellDecoration: BoxDecoration(
            color: Colors.red.withOpacity(0.3),
            shape: BoxShape.circle,
          ),
          specialDatesTextStyle: const TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
          ),
        ),
        enablePastDates: false,
        onSelectionChanged: onSelectionChanged,
        selectionMode: DateRangePickerSelectionMode.multiple,
        // selectionMode: DateRangePickerSelectionMode.single,
        // selectionMode: DateRangePickerSelectionMode.extendableRange,
        // selectionMode: DateRangePickerSelectionMode.range,
        // selectionMode: DateRangePickerSelectionMode.multiRange,
        selectableDayPredicate: (DateTime date) {
          // return DateFormat('hh:mm:ss').format(dateTime);
          if (disabledDate.contains(DateFormat('yyyy-MM-dd').format(date))) {
            return false;
          }
          if (date.weekday == DateTime.saturday || date.weekday == DateTime.sunday) {
            return false;
          }
          return true;
        },
      ),
    );
  }
}
