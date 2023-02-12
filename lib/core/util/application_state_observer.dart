import 'package:flutter/widgets.dart';
import 'package:uuid/uuid.dart';

class ApplicationStateObserver extends WidgetsBindingObserver {

  static ApplicationStateObserver? _instance;

  static ApplicationStateObserver getInstance() {
    _instance ??= ApplicationStateObserver();
    return _instance!;
  }

  static registerApplicationStateCallback(AppLifecycleCallback handler) {
    handler.generateId();
    ApplicationStateObserver.getInstance()._listRegistrant.add(handler);
  }

  static unregisterApplicationStateCallback(String registrantId) {
    var appObserver = ApplicationStateObserver.getInstance();
    appObserver._listRegistrant.removeWhere((element) => element.getRegistrantId() == registrantId);
  }

  final List<AppLifecycleCallback> _listRegistrant = [];

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    for (var element in _listRegistrant) {
      element.onStateChanged(state);
    }
  }
}

abstract class AppLifecycleCallback {

  late String registrantId;

  @protected
  void generateId() {
    registrantId = const Uuid().v4().toString();
  }

  String getRegistrantId() {
    return registrantId;
  }

  void onStateChanged(AppLifecycleState state);

}