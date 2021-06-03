import 'package:flutter/material.dart';

class SwitchScreen extends StatefulWidget {
  final Function toggleHandler;
  SwitchScreen({
    required this.toggleHandler,
  });

  @override
  _SwitchScreenState createState() => _SwitchScreenState();
}

class _SwitchScreenState extends State<SwitchScreen> {
  bool isSwitched = false;
  var textValue = 'Switch is OFF';

  void toggleSwitch(bool value) {
    if (isSwitched == false) {
      setState(() {
        isSwitched = true;
        widget.toggleHandler(true);
        textValue = 'Switch Button is ON';
      });
    } else {
      setState(() {
        isSwitched = false;
        widget.toggleHandler(false);
        textValue = 'Switch Button is OFF';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Transform.scale(
              scale: 1,
              child: Switch(
                onChanged: toggleSwitch,
                value: isSwitched,
                activeColor: Colors.blue,
                activeTrackColor: Colors.yellow,
                inactiveThumbColor: Colors.redAccent,
                inactiveTrackColor: Colors.orange,
              )),
          // Text(
          //   '$textValue',
          //   style: TextStyle(fontSize: 20),
          // )
        ]);
  }
}
