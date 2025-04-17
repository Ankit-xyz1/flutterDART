import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Country Time App',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        brightness: Brightness.dark,
        textTheme: TextTheme(
          headlineMedium: TextStyle(
              fontSize: 32.0, fontWeight: FontWeight.bold, color: Colors.white),
          bodyLarge: TextStyle(fontSize: 20.0, color: Colors.white70),
          bodyMedium: TextStyle(fontSize: 18.0, color: Colors.white),
        ),
      ),
      home: CountryTimePage(),
    );
  }
}

class CountryTimePage extends StatefulWidget {
  @override
  _CountryTimePageState createState() => _CountryTimePageState();
}

class _CountryTimePageState extends State<CountryTimePage> {
  String _selectedCountry = 'United States';
  late Timer _timer;

  final List<String> _countries = [
    'United States',
    'Canada',
    'Mexico',
    'United Kingdom',
    'Germany',
    'France',
    'Japan',
    'Australia',
    'India',
    'China'
  ];

  final Map<String, Duration> _countryTimeOffsets = {
    'United States': Duration(hours: -5), // Example offset, adjust as needed
    'Canada': Duration(hours: -5),
    'Mexico': Duration(hours: -6),
    'United Kingdom': Duration(hours: 0),
    'Germany': Duration(hours: 1),
    'France': Duration(hours: 1),
    'Japan': Duration(hours: 9),
    'Australia': Duration(hours: 10),
    'India': Duration(hours: 5, minutes: 30),
    'China': Duration(hours: 8),
  };

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _formatCurrentDateTime() {
    final now = DateTime.now().toUtc();
    final offset = _countryTimeOffsets[_selectedCountry] ?? Duration.zero;
    final localTime = now.add(offset);

    final date = '${localTime.year.toString().padLeft(4, '0')}-'
        '${localTime.month.toString().padLeft(2, '0')}-'
        '${localTime.day.toString().padLeft(2, '0')}';

    final time = '${localTime.hour.toString().padLeft(2, '0')}:'
        '${localTime.minute.toString().padLeft(2, '0')}:'
        '${localTime.second.toString().padLeft(2, '0')} '
        '${_getTimeZoneAbbreviation(offset)}';

    return '$date\n$time';
  }

  String _getTimeZoneAbbreviation(Duration offset) {
    if (offset == Duration.zero) return 'UTC';
    final sign = offset.isNegative ? '-' : '+';
    final totalMinutes = offset.inMinutes.abs();
    final hours = (totalMinutes ~/ 60).toString().padLeft(2, '0');
    final minutes = (totalMinutes % 60).toString().padLeft(2, '0');
    return 'UTC$sign$hours:$minutes';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Country Date and Time'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Selected Country:',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              SizedBox(height: 10),
              DropdownButton<String>(
                value: _selectedCountry,
                dropdownColor: Colors.deepOrange[800],
                iconEnabledColor: Colors.white,
                style: Theme.of(context).textTheme.bodyMedium,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCountry = newValue!;
                  });
                },
                items: _countries.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              SizedBox(height: 30),
              Text(
                'Current Date and Time:',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              SizedBox(height: 10),
              Text(
                _formatCurrentDateTime(),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
