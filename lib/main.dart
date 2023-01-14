// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_syncfusion_flutter_datepicker_v3/gzn_datepicker.dart';

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
  List<String> _disabledDate = [];
  final DateRangePickerController _datePickerController = DateRangePickerController();
  final _resController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _disabledDate = ["2023-01-31"];
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
                  builder: (context) => DatePickerDialogV1(
                    disabledDate: _disabledDate,
                    controller: _datePickerController,
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
