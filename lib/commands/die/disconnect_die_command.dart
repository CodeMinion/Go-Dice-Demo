

import 'dart:async';

import 'package:another_ble_manager/another_ble_manager.dart';
import 'package:another_go_dice/another_go_dice.dart';
import 'package:go_dice_demo/commands/die/remove_die_command.dart';

import '../commands.dart';

class DisconnectDieCommand extends BaseAppCommand {

  late StreamSubscription _subscription;

  Future<void> run({required BleGoDiceDeviceOwner die}) async {

    _subscription = die.getSetupStates().listen((setupState) {
      if (setupState == BleSetupState.initial) {
        RemoveDieCommand().run(die: die);
        _subscription.cancel();
      }
    });

    await die.handleEvent(
        event: BleDisconnectDeviceEvent(
            device: die.device));


  }
}