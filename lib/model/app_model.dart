
import 'dart:async';

import 'package:another_go_dice/another_go_dice.dart';
import 'package:go_dice_demo/easy_notifier.dart';

class AppModel extends EasyNotifier {

  bool _hasBootstrapped = false;
  bool get hasBootstrapped => _hasBootstrapped;
  set hasBootstrapped (bool value) => notify(()=> _hasBootstrapped = value);

  bool _isDeviceDiscovery = false;
  bool get isDeviceDiscovery => _isDeviceDiscovery;
  set isDeviceDiscovery (bool value) => notify(() => _isDeviceDiscovery = value);

  BleGoDiceDeviceOwner? _activeDie;
  BleGoDiceDeviceOwner? get activeDie => _activeDie;
  set activeDie(BleGoDiceDeviceOwner? value) => notify(() => _activeDie = value);

  final List<BleGoDiceDeviceOwner> _activeGoDies = List.empty(growable: true);
  final StreamController<List<BleGoDiceDeviceOwner>> _goDiceStreamController = StreamController.broadcast();

  Stream<List<BleGoDiceDeviceOwner>> getGoDice() => _goDiceStreamController.stream;

  List<BleGoDiceDeviceOwner> getActiveDice() => _activeGoDies;

  void addDie({required BleGoDiceDeviceOwner die}) {
    print("Adding Die $die");
    _activeGoDies.add(die);
    _goDiceStreamController.add(_activeGoDies);
  }

  void removeDie({required BleGoDiceDeviceOwner die}) {
    _activeGoDies.remove(die);
    _goDiceStreamController.add(_activeGoDies);
    if (die == _activeDie) {
      activeDie = null;
    }
  }
}