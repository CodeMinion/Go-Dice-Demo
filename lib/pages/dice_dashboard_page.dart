import 'package:another_go_dice/another_go_dice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_dice_demo/commands/die/set_active_die_command.dart';
import 'package:go_dice_demo/factories/die_asset_path_factory.dart';
import 'package:provider/provider.dart';

import '../commands/ble/set_device_discovery_command.dart';
import '../model/app_model.dart';

class GoDiceDashboardPage extends StatelessWidget {
  const GoDiceDashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppModel appModel = context.read<AppModel>();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
      ),
      body: StreamBuilder<List<BleGoDiceDeviceOwner>>(
          stream: appModel.getGoDice(),
          initialData: appModel.getActiveDice(),
          builder: (BuildContext context,
              AsyncSnapshot<List<BleGoDiceDeviceOwner>> snapshot) {
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  SetDeviceDiscoverCommand().run(discoverDevices: true);
                },
                child: const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text("No GoDice connected. Once connected GoDice will appear here.", textAlign: TextAlign.center),
                  ),
                ),
              );
            }
            return GridView.builder(
              padding: const EdgeInsets.all(24),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  crossAxisSpacing: 24,
                  mainAxisSpacing: 24,
                  childAspectRatio: 0.7,
                  maxCrossAxisExtent: 120),
              itemBuilder: (BuildContext context, int index) {
                BleGoDiceDeviceOwner goDiceOwner = snapshot.data![index];
                return _buildDieWidget(context: context, goDie: goDiceOwner);
              },
              itemCount: snapshot.data!.length,
            );
          }),
      floatingActionButton: FloatingActionButton(
        tooltip: "Add GoDie",
        onPressed: () {
          SetDeviceDiscoverCommand().run(discoverDevices: true);
        },
        child: const Icon(Icons.bluetooth),
      ),
    );
  }

  Widget _buildDieWidget(
      {required BuildContext context, required BleGoDiceDeviceOwner goDie}) {
    String propAsset = DieAssetPathFactory.getInstance().getDieAsset(die: goDie);

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        SetActiveDie().run(die: goDie);
      },
      child: Column(key: ObjectKey(goDie.device.getId()),
        children: [
          SizedBox(
            width: 100,
            height: 100,
            child: StreamBuilder<IGoDiceMessage>(
              builder: (BuildContext context, AsyncSnapshot<IGoDiceMessage> snapshot) {
                if (!snapshot.hasData) {
                  propAsset = DieAssetPathFactory.getInstance().getDieRollAsset(die: goDie, message: null);
                }
                else {
                  propAsset = DieAssetPathFactory.getInstance().getDieRollAsset(die: goDie, message: snapshot.data);
                }
                return SvgPicture.asset(propAsset);
              },
              initialData: goDie.getLastMessage(),
              stream: goDie.getDieMessages(),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top:8.0),
              child: Text(goDie.device.getName(), textAlign: TextAlign.center,),
            ),
          )
        ],
      ),
    );
  }
}
