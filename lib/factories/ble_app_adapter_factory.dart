


import 'package:another_ble_manager/another_ble_manager.dart';
import 'package:another_ble_manager/mock/ble_mock.dart';
import 'package:another_ble_manager_plus/another_ble_manager_plus.dart';
import 'package:flutter/foundation.dart';

class BleAdapterFactory {

  static BleAdapterFactory? _instance;
  BleAdapterFactory._();

  static BleAdapterFactory getInstance() {
    return _instance ??= BleAdapterFactory._();
  }

  IBleAdapter buildAdapter() {
    if (kIsWeb) {
      return MockBleAdapter.getInstance();
    }
    else {
      return PlusBleAdapter.getInstance();
    }
  }
}

class AppBleAdapter implements IBleAdapter {

  static AppBleAdapter? _instance;
  final IBleAdapter _bleAdapter;
  AppBleAdapter._():_bleAdapter = BleAdapterFactory.getInstance().buildAdapter();

  static AppBleAdapter getInstance() {
    return _instance ??= AppBleAdapter._();
  }
  @override
  Stream<List<IBleDevice>> getScanResults() => _bleAdapter.getScanResults();

  @override
  Future<void> startScan() => _bleAdapter.startScan();

  @override
  Future<void> stopScan() => _bleAdapter.stopScan();

}