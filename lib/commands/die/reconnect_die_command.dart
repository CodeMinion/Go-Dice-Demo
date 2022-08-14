
import 'package:another_ble_manager/another_ble_manager.dart';
import 'package:another_go_dice/another_go_dice.dart';

import '../commands.dart';


/// Used to request a re-connection to a device that was
/// previously connected.
class ReconnectDieCommand extends BaseAppCommand {

  Future<void> run({required BleGoDiceDeviceOwner die}) async {
    await die.handleEvent(
        event: BleReconnectDeviceEvent(
            device: die.device));
  }
}