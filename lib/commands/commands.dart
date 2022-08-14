

import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../model/app_model.dart';

BuildContext? _mainContext;
BuildContext get mainContext => _mainContext!;
bool get hasContext => _mainContext != null;

/// Someone needs to call this so our Commands can access models and services.
void setContext(BuildContext c) {
  _mainContext = c;
}

class BaseAppCommand {
  /// Provide quick lookups for the main Models and Services in the App.
  T getProvided<T>() {
    assert(_mainContext != null, "You must call `setContext(BuildContext)` method before calling Commands.");
    return _mainContext!.read<T>();
  }

  AppModel get appModel => getProvided();
}