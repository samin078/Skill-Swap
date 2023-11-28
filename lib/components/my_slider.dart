import 'package:flutter/material.dart';

class MySlider extends StatefulWidget {
  final Function(double) onSliderChanged;

  const MySlider({Key? key, required this.onSliderChanged}) : super(key: key);

  @override
  _MySliderState createState() => _MySliderState();
}

class _MySliderState extends State<MySlider> {
  double _currentValue = 1000;

  @override
  Widget build(BuildContext context) {
    return Slider(
      value: _currentValue,
      min: 0000,
      max: 15000,
      onChanged: (value) {
        setState(() {
          _currentValue = value;
        });
        widget.onSliderChanged(value);
      },
    );
  }
}
