import 'package:flutter/material.dart';
import 'package:skill_swap/swap_mode/MatchedScreen.dart';


class SwapMode extends StatefulWidget {
  const SwapMode({Key? key}) : super(key: key);

  @override
  State<SwapMode> createState() => _SwapModeState();
}

class _SwapModeState extends State<SwapMode> {
  String selectedOption = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Option"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RadioListTile(
            title: Text("Learn"),
            value: "Learn",
            groupValue: selectedOption,
            onChanged: (String? value) {
              setState(() {
                selectedOption = value!;
              });
            },
          ),
          RadioListTile(
            title: Text("Teach"),
            value: "Teach",
            groupValue: selectedOption,
            onChanged: (String? value) {
              setState(() {
                selectedOption = value!;
              });
            },
          ),
          RadioListTile(
            title: Text("Exchange"),
            value: "Exchange",
            groupValue: selectedOption,
            onChanged: (String? value) {
              setState(() {
                selectedOption = value!;
              });
            },
          ),
          ElevatedButton(
            child: Text("Next"),
            onPressed: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => MatchedScreen(selectedOption: selectedOption),
              //   ),
              // );
            },
          ),
        ],
      ),
    );
  }
}
