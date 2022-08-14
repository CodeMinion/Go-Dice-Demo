
import 'dart:async';

import 'package:another_ble_manager/connection/ble_connection.dart';
import 'package:another_ble_manager/connection/ble_connection_event.dart';
import 'package:another_go_dice/another_go_dice.dart';

import '../commands.dart';
import 'add_die_command.dart';

class ConnectDieCommand extends BaseAppCommand {

  late StreamSubscription _subscription;
  Future<void> run({required BleGoDiceDeviceOwner die}) async {

    _subscription = die.getSetupStates().listen((setupState) {
      print("Got State - $setupState");
      if (setupState == BleSetupState.ready) {
        AddDieCommand().run(die: die).then((value) => _subscription.cancel());
      }
    });

    await die.handleEvent(
        event: BleConnectDeviceEvent(
            device: die.device));


  }
}