import 'package:flutter/material.dart';

class ConditionRadio extends StatefulWidget {
  final int? groupValue;
  final Function(int?) onChanged;

  const ConditionRadio({required this.groupValue, required this.onChanged});

  @override
  _ConditionRadioState createState() => _ConditionRadioState();
}

class _ConditionRadioState extends State<ConditionRadio> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        RadioListTile<int>(
          title: const Text('Baik'),
          value: 1,
          groupValue: widget.groupValue,
          onChanged: widget.onChanged,
        ),
        RadioListTile<int>(
          title: const Text('Rusak'),
          value: 2,
          groupValue: widget.groupValue,
          onChanged: widget.onChanged,
        ),
      ],
    );
  }
}
