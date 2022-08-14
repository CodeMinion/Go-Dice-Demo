


import 'package:flutter/widgets.dart';

import 'commands.dart';

class BootstrapCommand extends BaseAppCommand {

  Future<bool> run(BuildContext context) async {
    //print ("Bootstrapping app");
    // int startTime = TimeUtils.nowMillis;
    if (hasContext == false) {
      setContext(context);
    }

    print("Bootstrap Complete");
    appModel.hasBootstrapped = true;
    print("Bootstrap Complete - ${appModel.hasBootstrapped}");
    // Remove splash screen.
    //FlutterNativeSplash.remove();
    return true;
  }
}