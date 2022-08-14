

import 'package:another_go_dice/another_go_dice.dart';
import '../commands.dart';

class RemoveDieCommand extends BaseAppCommand {
  Future<void>run({required BleGoDiceDeviceOwner die}) async {
    appModel.removeDie(die: die);
  }
}