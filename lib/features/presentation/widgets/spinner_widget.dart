import 'package:flutter/material.dart';

class SpinnerWidget extends StatefulWidget {

  List<String> listData;
  Function(String value, int index) onItemSelectedListener;

  SpinnerWidget({Key? key,
    required this.listData,
    required this.onItemSelectedListener
  }) : super(key: key);

  @override
  State<SpinnerWidget> createState() => _SpinnerWidgetState();
}

class _SpinnerWidgetState extends State<SpinnerWidget> {

  String _dropDownValue = '';
  int _dropDownIndex = -1;
  late ThemeData _theme;


  @override
  void initState() {
    super.initState();

    if(widget.listData.isNotEmpty){
      _dropDownValue = widget.listData[0];
      _dropDownIndex = 0;
    }

  }

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(right: 8.0, top: 4),
      child: DropdownButton<String>(
        value: _dropDownValue,
        icon: const Icon(Icons.arrow_drop_down_outlined),
        elevation: 16,
        style: _theme.textTheme.bodyText1,
        underline: Container(
          height: 1,
          color: Colors.transparent,
        ),
        onChanged: (String? newValue) {
          setState(() {
            _dropDownValue = newValue ?? '';
            _dropDownIndex = newValue != null ? widget.listData.indexOf(newValue) : -1;
            newValue != null
                ? widget.onItemSelectedListener(_dropDownValue, _dropDownIndex)
                : {};
          });
        },
        items: widget.listData.map<DropdownMenuItem<String>>((value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value, style: _theme.textTheme.bodyText1),
          );
        }).toList(),
      ),
    );
  }
}
