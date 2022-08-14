import 'package:another_ble_manager/another_ble_manager.dart';
import 'package:another_go_dice/another_go_dice.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:permission_handler/permission_handler.dart';

import '../commands/die/connect_die_command.dart';
import '../commands/die/disconnect_die_command.dart';
import '../factories/ble_app_adapter_factory.dart';
import '../factories/die_asset_path_factory.dart';
import '../factories/go_die_factory.dart';

class GoDiceDiscoveryPage extends StatefulWidget {
  const GoDiceDiscoveryPage({Key? key}) : super(key: key);

  @override
  State<GoDiceDiscoveryPage> createState() => _GoDiceDiscoveryPageState();
}

class _GoDiceDiscoveryPageState extends State<GoDiceDiscoveryPage> {
  final IBleAdapter _adapter = AppBleAdapter.getInstance();

  @override
  void initState() {
    super.initState();
    _scanForDevices();
  }

  @override
  void dispose() {
    super.dispose();
    _adapter.stopScan();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Find Props"),
      ),
      body: StreamBuilder(
        builder: (BuildContext context,
            AsyncSnapshot<List<BleGoDiceDeviceOwner>> snapshot) {
          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            List<BleGoDiceDeviceOwner> foundDevices = snapshot.data!;
            return ListView.builder(
              itemBuilder: (BuildContext context, int position) {
                BleGoDiceDeviceOwner deviceOwner = foundDevices[position];
                String displayName = deviceOwner.device.getName();
                if (displayName.isEmpty) {
                  displayName = deviceOwner.device.getId();
                }
                return GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    BleSetupState setupState = deviceOwner.getSetupState();
                    if (setupState == BleSetupState.ready) {
                      DisconnectDieCommand().run(die: deviceOwner);
                    } else {
                      ConnectDieCommand().run(die: deviceOwner);
                    }
                  },
                  child: ListTile(
                    leading: SizedBox(
                        width: 32,
                        height: 32,
                        child: SvgPicture.asset(DieAssetPathFactory.getInstance().getDieAsset(die: deviceOwner))),
                    title: Text(displayName),
                    subtitle: StreamBuilder<BleSetupState>(
                      initialData: BleSetupState.unknown,
                      stream: deviceOwner.getSetupStates(),
                      builder: (BuildContext context,
                          AsyncSnapshot<BleSetupState> snapshot) {
                        BleSetupState bleSetupState = snapshot.data?? BleSetupState.unknown;
                        return RichText(
                          text: TextSpan(
                            text: 'State: ',
                            style: DefaultTextStyle.of(context)
                                .style
                                .copyWith(fontWeight: FontWeight.bold),
                            children: <TextSpan>[
                              TextSpan(
                                  text: bleSetupState.toShortString().toUpperCase(),
                                  style: DefaultTextStyle.of(context).style)
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
              itemCount: foundDevices.length,
            );
          } else if (snapshot.hasError) {
            return Text("Error searching devices, ${snapshot.error}");
          } else {
            return Center(child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Padding(
                  padding: EdgeInsets.only(right:8.0),
                  child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator()),
                ),
                Text("Finding nearby BLE props..."),
              ],
            ));
          }
        },
        stream: _adapter.getScanResults().map((list) => list
            .map((device) => BleGoDieFactory.getInstance()
            .buildDeviceOwner(device: device))
            .toList()),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _scanForDevices();
        },
        tooltip: 'Find Devices',
        child: const Icon(Icons.search),
      ),
    );
  }

  Future<void> _scanForDevices() async {
    // When starting check if we have permissions,
    // If we don't have permissions prompt user for permissions.
    if (!kIsWeb) {
      if (await Permission.location.request() != PermissionStatus.granted){
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("Access to location is needed in order to find Props."),
          ),
        ));
        return;
      }

      if (await Permission.bluetooth.request() != PermissionStatus.granted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("Access to Bluetooth is needed in order to find Props."),
          ),
        ));
        return;
      }

      if(await Permission.bluetoothScan.request() != PermissionStatus.granted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("Access to Bluetooth Scan is needed in order to find Props."),
          ),
        ));
        return;
      }

      if(!await Permission.locationWhenInUse.serviceStatus.isEnabled) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("Location must be on in order to find Props."),
          ),
        ));
        return;
      }
    }
    // If we do have permissions then start scanning
    await _adapter.stopScan();
    await _adapter.startScan();

  }
}
