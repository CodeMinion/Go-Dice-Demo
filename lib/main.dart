import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_dice_demo/routing/app_route_delegate.dart';
import 'package:go_dice_demo/routing/app_route_parser.dart';
import 'package:provider/provider.dart';

import 'app_theme.dart';
import 'commands/bootstrap_command.dart';
import 'model/app_model.dart';

void main() {
  AppModel appModel = AppModel();

  runApp(MultiProvider(
    providers: [ChangeNotifierProvider.value(value: appModel)],
    child: AppBoostraper(),
  ));
}

class AppBoostraper extends StatefulWidget {
  const AppBoostraper({Key? key}) : super(key: key);

  @override
  State<AppBoostraper> createState() => _AppBoostraperState();
}

class _AppBoostraperState extends State<AppBoostraper> {
  AppRouteParser routeParser = AppRouteParser();
  late AppRouterDelegate router;

  @override
  void initState() {
    super.initState();
    AppModel appModel = context.read<AppModel>();
    router = AppRouterDelegate(appModel: appModel);
    // This runs the command on a new process, meaning that any initialization that takes place
    // won't have effect in the main process
    scheduleMicrotask(() {
      BootstrapCommand boostrap = BootstrapCommand();
      boostrap.run(context);
    });
    //compute(boostrap.run, context).then((bootStrapped) => appModel.hasBootstrapped = bootStrapped);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppModel>(
      builder: (BuildContext context, AppModel appModel, Widget? widget) {
        return MaterialApp.router(
            theme: ThemeFactory.getInstance().getTheme(context: context),
            routeInformationParser: routeParser, routerDelegate: router);
      },
    );
  }
}
