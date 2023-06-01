// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_syncfusion_flutter_datepicker_v3/gzn_easy_date_picker_v3.dart';
import 'package:intl/intl.dart';

// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

// var COLOR_PRIMARY = Colors.red;

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
  String _selectedDate = "";
  List<String> _disabledDates = [];
  List<int> _weekendDays = [];
  List<String> _spesialDays = [];
  final DateRangePickerController _datePickerController = DateRangePickerController();
  final _resController = TextEditingController();

  /*
  PR :
  Today Color
  Callback
   */
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _disabledDate = _getWeekends([]);
    _disabledDates = ["2023-06-01", "2023-06-05"];
    _weekendDays = const [6, 7];
    String strToday = DateFormat('yyyy-MM-dd').format(DateTime.now());
    // _spesialDays = ["2023-06-02", "2023-06-06"];
    _spesialDays = [strToday];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              textAlign: TextAlign.center,
              'Click Plus Show Dialog\n${_resController.text}',
            ),
            TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => EasyDatePickerV3(
                    selectionMode: DateRangePickerSelectionMode.multiple,
                    // selectionMode: DateRangePickerSelectionMode.range,
                    // selectionMode: DateRangePickerSelectionMode.single,
                    // selectionMode: DateRangePickerSelectionMode.multiRange,
                    // selectionMode: DateRangePickerSelectionMode.extendableRange,
                    controller: _datePickerController,
                    enablePastDates: true,
                    weekendDays: _weekendDays,
                    disabledDate: _disabledDates,
                    spesialDays: _spesialDays,
                  ),
                ).then((value) {
                  if (value == false) return;
                  _selectedDate = generateDate(_datePickerController.selectedDates!);
                  setState(() {
                    _resController.text = _selectedDate;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(_selectedDate),
                  ));
                });
              },
              child: const Text('Show Dialog'),
            ),
          ],
        ),
      ),
    );
  }
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
