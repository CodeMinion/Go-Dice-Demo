
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class DiceDiscoveryWidget extends StatefulWidget {
  const DiceDiscoveryWidget({Key? key}) : super(key: key);

  @override
  State<DiceDiscoveryWidget> createState() => _DiceDiscoveryWidgetState();
}

class _DiceDiscoveryWidgetState extends State<DiceDiscoveryWidget> {

  FlutterBluePlus flutterBlue = FlutterBluePlus.instance;
  List<BluetoothDevice> _foundDice = List.empty(growable: true);


  @override
  Widget build(BuildContext context) {
    return Container();
  }
}