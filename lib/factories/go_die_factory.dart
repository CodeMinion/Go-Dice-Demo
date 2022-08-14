
import 'dart:collection';

import 'package:another_ble_manager/another_ble_manager.dart';
import 'package:another_go_dice/another_go_dice.dart';

class BleGoDieFactory {
  static BleGoDieFactory? _instance;

  BleGoDieFactory._();

  final HashMap<String, BleGoDiceDeviceOwner> _devices = HashMap();
  static BleGoDieFactory getInstance() {
    return _instance ??= BleGoDieFactory._();
  }

  BleGoDiceDeviceOwner buildDeviceOwner({required IBleDevice device}) {
    if (device.getName().contains("GoDice")) {
      if (_devices.containsKey(device.getId())) {
        return _devices[device.getId()]!;
      }

      BleGoDiceDeviceOwner deviceOwner = BleGoDiceDeviceOwner(device: device);
      _devices.putIfAbsent(device.getId(), () => deviceOwner);
      return deviceOwner;
    }
    return UnknownBleGoDieDeviceOwner(device: device);
  }
}

class UnknownBleGoDieDeviceOwner extends BleGoDiceDeviceOwner{
  UnknownBleGoDieDeviceOwner({required super.device});
}