
import 'package:another_go_dice/another_go_dice.dart';
import 'package:go_dice_demo/factories/go_die_factory.dart';

class DieAssetPathFactory {

  static DieAssetPathFactory? _instance;

  DieAssetPathFactory._();

  static DieAssetPathFactory getInstance() {
    return _instance ??= DieAssetPathFactory._();
  }

  String getDieAsset({required BleGoDiceDeviceOwner die}) {
    if (die is UnknownBleGoDieDeviceOwner) {
      return "assets/cmd_icon_unknown.svg";
    }
    if (die.getDieType() == DieType.d6) {
      return "assets/cmd_icon_6.svg";
    }

    return "assets/cmd_icon_unknown.svg";
  }

  String getDieRollAsset({required BleGoDiceDeviceOwner die, IGoDiceMessage? message}) {

    if (message == null) {
      return "assets/cmd_icon_unknown.svg";
    }

    if (message is GoDiceRollingMessage) {
      return "assets/cmd_icon_rolling.svg";
    }
    if (die.getDieType() == DieType.d6) {
      if (message is GoDiceRollMessage) {
        if (message.getValue() == 6) {
          return "assets/cmd_icon_6.svg";
        }
        else if (message.getValue() == 5) {
          return "assets/cmd_icon_5.svg";
        }
        else if (message.getValue() == 4) {
          return "assets/cmd_icon_4.svg";
        }
        else if (message.getValue() == 3) {
          return "assets/cmd_icon_3.svg";
        }
        else if (message.getValue() == 2) {
          return "assets/cmd_icon_2.svg";
        }
        else if (message.getValue() == 1) {
          return "assets/cmd_icon_1.svg";
        }
      }
      else if (message is GoDiceRollingMessage) {
        return "assets/cmd_icon_unknown.svg";
      }
    }
    return "assets/cmd_icon_unknown.svg";
  }
}