import 'dart:io';

import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';

import '../../models/notification_model.dart';

class NotificationsRepository {
  final String _boxName = 'notifications_box';
  final String _notificationKey = 'all_notifications';

  /// Initialize Local Notifcations
  Future<NotificationsRepository> init() async {
    await Hive.openLazyBox(_notificationSwitchBox);
    await Hive.openLazyBox(_boxName);
    return NotificationsRepository();
  }

  /// When saving without opening the app
  Future<NotificationsRepository> backgroundInit() async {
    Directory _appDocDir = await getApplicationDocumentsDirectory();
    await Hive.initFlutter(_appDocDir.path);
    await Hive.openLazyBox(_notificationSwitchBox);
    await Hive.openLazyBox(_boxName);
    return NotificationsRepository();
  }

  /// Save a notification to database
  Future<void> saveNotification(NotificationModel data) async {
    var box = await Hive.openLazyBox(_boxName);
    final _notificationsList = await box.get(_notificationKey) ?? [];

    final _fetchedList = _notificationsList
        .map((e) => NotificationModel.fromMap(Map.from(e)))
        .toList();
    _fetchedList.remove(data);
    _fetchedList.add(data);
    final _convertedData = _fetchedList.map((e) => e.toMap()).toList();
    box.put(_notificationKey, _convertedData);
  }

  /// Delete A Notification
  Future<void> deleteANotification(NotificationModel target) async {
    var box = Hive.box(_boxName);
    final _notificationsList = await box.get(_notificationKey) ?? [];
    final List _fetchedList = _notificationsList
        .map((e) => NotificationModel.fromMap(Map.from(e)))
        .toList();
    _fetchedList.remove(target);
    final _convertedData = _fetchedList.map((e) => e.toMap()).toList();
    box.put(_notificationKey, _convertedData);
  }

  /// Delete A Notification
  Future<void> clearAllNotifications() async {
    var box = Hive.box(_boxName);
    await box.put(_notificationKey, []);
  }

  /// Get All Notifications
  Future<List<NotificationModel>> getAllNotifications() async {
    var box = await Hive.openLazyBox(_boxName);
    final _notificationsList = await box.get(_notificationKey) ?? [];
    final List _fetchedList = _notificationsList
        .map((e) => NotificationModel.fromMap(Map.from(e)))
        .toList();
    return List.from(_fetchedList);
  }

  /* <---- Notifications Settings -----> */
  final String _notificationSwitchBox = 'notificationSwitchBox';
  final String _toggle = 'notificationToggle';

  Future<bool> isNotificationOn() async {
    var box = await Hive.openLazyBox(_notificationSwitchBox);
    return await box.get(_toggle) ?? true;
  }

  /// Turn on notifications
  Future<void> turnOnNotifications() async {
    var box = await Hive.openLazyBox(_notificationSwitchBox);
    await box.put(_toggle, true);
  }

  /// Turn off notifications
  Future<void> turnOffNotifications() async {
    var box = await Hive.openLazyBox(_notificationSwitchBox);
    box.put(_toggle, false);
  }
}
