import 'package:another_ble_manager/another_ble_manager.dart';
import 'package:another_go_dice/another_go_dice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_dice_demo/commands/die/disconnect_die_command.dart';
import 'package:provider/provider.dart';

import '../commands/die/reconnect_die_command.dart';
import '../model/app_model.dart';

class DieControlBoardPage extends StatelessWidget {
  const DieControlBoardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppModel appModel = context.read<AppModel>();
    BleGoDiceDeviceOwner prop = appModel.activeDie!;
    return Scaffold(
      appBar: AppBar(
        title: Text(prop.device.getName()),
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.only(left: 24, right: 24),
            sliver: SliverToBoxAdapter(
              child: _buildStatusWidget(context: context, goDie: prop),
            ),
          ),
          /*
          SliverPadding(
              padding: const EdgeInsets.only(left: 24, right: 24),
              sliver: _buildPropControls(context: context, prop: prop))

           */
        ],
      ),
    );
  }

  Widget _buildStatusWidget(
      {required BuildContext context, required BleGoDiceDeviceOwner goDie}) {
    return StreamBuilder<BleSetupState>(
      stream: goDie.getSetupStates(),
      builder: (BuildContext context, AsyncSnapshot<BleSetupState> snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }
        BleSetupState setupState = snapshot.data!;
        return SizedBox(
          height: 64,
          child: Stack(
            children: [
              Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: RichText(
                      text: TextSpan(
                          text: 'State: ',
                          style: DefaultTextStyle.of(context)
                              .style
                              .copyWith(fontWeight: FontWeight.bold),
                          children: <TextSpan>[
                            TextSpan(
                                text: setupState.toShortString().toUpperCase(),
                                style: DefaultTextStyle.of(context).style)
                          ]),
                    ),
                  )),
              if (setupState == BleSetupState.disconnected) ...[
                Positioned(
                    top: 0,
                    bottom: 0,
                    right: 0,
                    child: Center(
                      child: ElevatedButton(
                        onPressed: () {
                          ReconnectDieCommand().run(die:goDie);
                        },
                        child: const Text("Reconnect"),
                      ),
                    ))
              ] else if (setupState == BleSetupState.ready) ...[
                Positioned(
                  top: 0,
                  bottom: 0,
                  right: 0,
                  child: Center(
                    child: OutlinedButton(
                      onPressed: () {
                        DisconnectDieCommand().run(die: goDie);
                      },
                      child: const Text("Disconnect"),
                    ),
                  ),
                )
              ]
            ],
          ),
        );
      },
      initialData: goDie.getSetupState(),
    );
  }

  /*
  Widget _buildPropControls(
      {required BuildContext context, required BleGoDiceDeviceOwner prop}) {
    return SliverGrid.extent(
      maxCrossAxisExtent: 100,
      mainAxisSpacing: 24,
      crossAxisSpacing: 24,
      children: prop
          .getActions()
          .map((action) =>
          _buildCommandWidget(context: context, prop: prop, action: action))
          .toList(),
    );
  }

  Widget _buildCommandWidget(
      {required BuildContext context,
        required BleGoDiceDeviceOwner prop,
        required IBlePropAction action}) {
    String actionAsset = _getActionAsset(prop: prop, action: action);
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        ExecutePropActionCommand().run(prop: prop, action: action);
      },
      child: SizedBox(
        width: 100,
        height: 100,
        child: SvgPicture.asset(actionAsset),
      ),
    );
  }

  String _getActionAsset(
      {required BlePropDeviceOwner prop, required IBlePropAction action}) {
    return AssetPathFactory.getInstance().getActionAsset(prop: prop, action: action);
  }

   */
}
