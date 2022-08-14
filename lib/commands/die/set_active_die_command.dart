

import 'package:another_go_dice/another_go_dice.dart';

import '../commands.dart';

class SetActiveDie extends BaseAppCommand {

  Future<void> run({BleGoDiceDeviceOwner? die}) async {
    appModel.activeDie = die;
  }
}