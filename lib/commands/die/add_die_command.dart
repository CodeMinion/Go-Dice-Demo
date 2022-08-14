

import 'package:another_go_dice/another_go_dice.dart';

import '../commands.dart';

class AddDieCommand extends BaseAppCommand {
  Future<void>run({required BleGoDiceDeviceOwner die}) async {
    appModel.addDie(die: die);
  }
}