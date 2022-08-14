
import 'package:flutter/material.dart';

import 'app_link.dart';

class AppRouteParser extends RouteInformationParser<AppLink> {

  @override
  Future<AppLink> parseRouteInformation(RouteInformation routeInformation) async {
    AppLink link = AppLink.fromLocation(loc: routeInformation.location);
    return link;
  }

  @override
  RouteInformation? restoreRouteInformation(AppLink configuration) {
    String location = configuration.toLocation();
    return RouteInformation(location: location);
  }

}