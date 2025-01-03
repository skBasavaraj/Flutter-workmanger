// lib/main.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:workmanager/workmanager.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    switch (taskName) {
      case 'incrementCounter':
        print('Background task executed');
        break;
    }
    return Future.value(true);
  });
}

Future<void> initNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings =
  InitializationSettings(android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initNotifications();
  Workmanager().initialize(callbackDispatcher);
  runApp(MyApp());
}

// lib/controllers/counter_controller.dart
class CounterController extends GetxController {
  var count = 0.obs;
  var isRunning = false.obs;
  Timer? _timer;

  void showNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'counter_channel',
      'Counter Updates',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      'Counter Update',
      'Current count: ${count.value}',
      platformChannelSpecifics,
    );
  }

  void startBackgroundTask() {
    if (!isRunning.value) {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        count++;
        showNotification();
      });

      Workmanager().registerPeriodicTask(
        'counter_task',
        'incrementCounter',
        frequency: Duration(minutes: 15),
      );
      isRunning.value = true;
    }
  }

  void stopBackgroundTask() {
    _timer?.cancel();
    Workmanager().cancelAll();
    isRunning.value = false;
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: HomeScreen(),
    );
  }
}


// lib/screens/home_screen.dart
class HomeScreen extends StatelessWidget {
  final CounterController controller = Get.put(CounterController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Background Counter')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(() => Text(
              'Count: ${controller.count}',
              style: TextStyle(fontSize: 24),
            )),
            SizedBox(height: 20),
            Obx(() => ElevatedButton(
              onPressed: controller.isRunning.value
                  ? controller.stopBackgroundTask
                  : controller.startBackgroundTask,
              child: Text(
                  controller.isRunning.value ? 'Stop Counter' : 'Start Counter'
              ),
            )),
          ],
        ),
      ),
    );
  }
}
