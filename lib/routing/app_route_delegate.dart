

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_dice_demo/commands/die/set_active_die_command.dart';

import '../app_theme.dart';
import '../commands/ble/set_device_discovery_command.dart';
import '../model/app_model.dart';
import '../pages/dice_dashboard_page.dart';
import '../pages/die_control_board.dart';
import '../pages/die_discovery_page.dart';
import 'app_link.dart';

class AppRouterDelegate extends RouterDelegate<AppLink> with ChangeNotifier {
  AppModel appModel;

  AppRouterDelegate({required this.appModel});


  @override
  // Return an AppLink, representing the current app state
  AppLink get currentConfiguration {
    return AppLink();
      //..privacy = appModel.showPrivacy;
  }

  @override
  Widget build(BuildContext context) {
    bool showDeviceDiscovery =  appModel.isDeviceDiscovery;
    bool showSplash = !appModel.hasBootstrapped;
    bool dieSelected = appModel.activeDie != null;
    bool showPrivacy = false; //appModel.showPrivacy;

    //print("Show Privacy $showPrivacy");
    return Scaffold(
      body: Navigator(
        onPopPage: _handleNavigatorPop,
        pages: <Widget>[
          if (showSplash)...[
            // TODO Replace with splash screen
            Container(color: ThemeFactory.purpleProp,)
          ]
            /*
          else if (showPrivacy)...[
            const AppPolicyPage(
              documentMd: "assets/legal/privacy_policy.md",
            )
          ]*/
          else ...[
              // TODO Add pages.
              const GoDiceDashboardPage(),
              if (showDeviceDiscovery) ...[const GoDiceDiscoveryPage()]
              else if (dieSelected)...[
                const DieControlBoardPage()
              ]
            ]
        ].map((e) => _wrapContentInPage(widget: e)).toList(),
      ),
    );
  }

  Page _wrapContentInPage({required Widget widget}) {
    return MaterialPage(child: widget);
  }

  bool tryGoBack() {
    if (appModel.isDeviceDiscovery) {
      SetDeviceDiscoverCommand().run(discoverDevices: false);
      return true;
    }

    else if (appModel.activeDie != null) {
      SetActiveDie().run(die: null);
      return true;
    }
    /*
    else if (appModel.showPrivacy != false) {
      appModel.showPrivacy = false;
    }

     */


    return false;
  }

  @override
  Future<bool> popRoute() async => tryGoBack();

  @override
  Future<void> setNewRoutePath(AppLink configuration) async {
    // TODO Handle route.
    //appModel.showPrivacy = configuration.privacy;
  }

  // Handle Navigator.pop for any routes in our stack
  bool _handleNavigatorPop(Route<dynamic> route, dynamic result) {
    // Ask the route if it can handle pop internally...
    if (route.didPop(result)) {
      // If not, we pop one level in our stack
      return tryGoBack();
    }
    return false;
  }
}
