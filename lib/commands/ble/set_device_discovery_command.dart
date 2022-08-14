


import '../commands.dart';

class SetDeviceDiscoverCommand extends BaseAppCommand {

  Future<void> run({bool discoverDevices = false}) async {
    appModel.isDeviceDiscovery = discoverDevices;
  }
}