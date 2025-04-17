import 'package:flutter/material.dart';

void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Calculator',
      theme: ThemeData.dark(),
      home: CalculatorHome(),
    );
  }
}

class CalculatorHome extends StatefulWidget {
  @override
  _CalculatorHomeState createState() => _CalculatorHomeState();
}

class _CalculatorHomeState extends State<CalculatorHome> {
  String _input = '';
  String _output = '';

  void _onPressed(String value) {
    setState(() {
      if (value == 'C') {
        _input = '';
        _output = '';
      } else if (value == '=') {
        _output = _calculate(_input);
      } else {
        _input += value;
      }
    });
  }

  String _calculate(String expr) {
    try {
      // Replace symbols
      expr = expr.replaceAll('×', '*').replaceAll('÷', '/');

      // Very simple parsing for expressions like: number1 operator number2
      RegExp exp = RegExp(r'^(\-?\d+\.?\d*)([\+\-\*/])(\-?\d+\.?\d*)$');
      final match = exp.firstMatch(expr);

      if (match != null) {
        double num1 = double.parse(match.group(1)!);
        String operator = match.group(2)!;
        double num2 = double.parse(match.group(3)!);

        double result;
        switch (operator) {
          case '+':
            result = num1 + num2;
            break;
          case '-':
            result = num1 - num2;
            break;
          case '*':
            result = num1 * num2;
            break;
          case '/':
            result = num2 != 0 ? num1 / num2 : double.nan;
            break;
          default:
            return 'Error';
        }

        return result.toStringAsFixed(2);
      } else {
        return 'Error';
      }
    } catch (e) {
      return 'Error';
    }
  }

  Widget _buildButton(String text) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: ElevatedButton(
          onPressed: () => _onPressed(text),
          style: ElevatedButton.styleFrom(padding: EdgeInsets.all(20)),
          child: Text(text, style: TextStyle(fontSize: 24)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Calculator')),
      body: Column(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.bottomRight,
              padding: EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(_input, style: TextStyle(fontSize: 28, color: Colors.white70)),
                  SizedBox(height: 8),
                  Text(_output, style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
          Divider(),
          Row(children: [_buildButton('7'), _buildButton('8'), _buildButton('9'), _buildButton('÷')]),
          Row(children: [_buildButton('4'), _buildButton('5'), _buildButton('6'), _buildButton('×')]),
          Row(children: [_buildButton('1'), _buildButton('2'), _buildButton('3'), _buildButton('-')]),
          Row(children: [_buildButton('C'), _buildButton('0'), _buildButton('='), _buildButton('+')]),
        ],
      ),
    );
  }
}
