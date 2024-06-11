import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        brightness: Brightness.light,
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
        ),
      ),
      home: Calculator(),
    );
  }
}

class Calculator extends StatefulWidget {
  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String _output = '';
  String _expression = '';

  void _onPressed(String buttonText) {
    setState(() {
      if (buttonText == 'AC') {
        _output = '';
        _expression = '';
      } else if (buttonText == '+/-') {
        _expression = _expression.startsWith('-')
            ? _expression.substring(1)
            : '-' + _expression;
        _output = _expression;
      } else if (buttonText == '%') {
        _expression = (_expression.isEmpty ? '0' : _expression) + ' / 100';
        _output = _evaluateExpression(_expression);
      } else if (buttonText == '=') {
        _expression = _output;
        _output = _evaluateExpression(_expression);
      } else {
        buttonText = buttonText == '×' ? '*' : buttonText;
        buttonText = buttonText == '÷' ? '/' : buttonText;
        _expression += buttonText;
        _output = _expression;
      }
    });
  }

  String _evaluateExpression(String expression) {
    try {
      Parser p = Parser();
      Expression exp = p.parse(expression);
      ContextModel cm = ContextModel();
      double result = exp.evaluate(EvaluationType.REAL, cm);
      return result.toString();
    } catch (e) {
      return 'Error';
    }
  }

  Widget buildButton(String buttonText) {
    int flexValue = buttonText == '0' ? 2 : 1;

    return Expanded(
      flex: flexValue,
      child: ElevatedButton(
        onPressed: () => _onPressed(buttonText),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
            if (['AC', '+/-', '%'].contains(buttonText)) {
              return Color.fromARGB(255, 78, 78, 78);
            } else if (['÷', '×', '+', '-', '='].contains(buttonText)) {
              return Colors.orange;
            } else {
              return Color.fromARGB(197, 153, 150, 150);
            }
          }),
          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
            EdgeInsets.all(24.0),
          ),
          shape: MaterialStateProperty.all<OutlinedBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
              side: BorderSide(width: 1.0, color: Colors.black),
            ),
          ),
        ),
        child: Text(
          buttonText,
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "CALCULATOR",
          style: TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 78, 78, 78),
        centerTitle: true,
      ),
      body: Container(
        color: Color.fromARGB(255, 39, 38, 38),
        child: Column(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
                alignment: Alignment.bottomRight,
                child: Text(
                  _output,
                  style: TextStyle(
                    fontSize: 48.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Colors.grey[900],
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        buildButton('AC'),
                        buildButton('+/-'),
                        buildButton('%'),
                        buildButton('÷'),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        buildButton('7'),
                        buildButton('8'),
                        buildButton('9'),
                        buildButton('×'),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        buildButton('4'),
                        buildButton('5'),
                        buildButton('6'),
                        buildButton('+'),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        buildButton('1'),
                        buildButton('2'),
                        buildButton('3'),
                        buildButton('-'),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        buildButton('0'),
                        buildButton('.'),
                        buildButton('='),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
