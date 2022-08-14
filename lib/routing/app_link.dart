import 'dart:convert';

class AppLink {
  static final Codec<String, String> _stringToBase64 = utf8.fuse(base64);

  static const String kPagePrivacy = "privacy";
  bool privacy = false;

  static String? encode(String? s) {
    if (s == null) return null;
    return _stringToBase64.encode(s);
  }

  static String? decode(String? s) {
    if (s == null) return null;
    return _stringToBase64.decode(s);
  }

  static AppLink fromLocation({String? loc}) {
    loc = Uri.decodeFull(loc ?? "");
    Uri locationUri = Uri.parse(loc);
    Map<String, String> params = locationUri.queryParameters;

    // Create the applink, inject any params we've found
    AppLink link = AppLink();
    List<String> pathSegments = locationUri.path.split("/");;

    if (pathSegments.isNotEmpty) {
      if (pathSegments [1] == kPagePrivacy) {
        link.privacy = true;
      }
    }


    return link;
  }

  String toLocation() {
    String loc = "/";
    if (privacy) {
      loc += kPagePrivacy;
    }
    return Uri.encodeFull(loc);
  }

  // Function to inject keys if they are not null
  void _trySet(
      {required Map<String, String> params,
        required String key,
        required void Function(String) setter}) {
    if (params.containsKey(key)) setter.call(params[key]!);
  }

  String _addKeyValPair({required String key, String? value}) =>
      value == null ? "" : "$key=$value&";

}
