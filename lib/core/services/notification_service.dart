import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:app_settings/app_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../repositories/user_repository.dart';

// Global navigator key for accessing navigation from anywhere in the app
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class NotificationService {
  
  //initialising firebase message plugin
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  //initialising firebase message plugin
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  
  // Store the last received message for local notification handling
  RemoteMessage? _lastReceivedMessage;

  // Initialize local notifications for both platforms
  Future<void> initializeLocalNotifications() async {
    try {
      var androidInitializationSettings =
          const AndroidInitializationSettings('@mipmap/ic_launcher');
      var iosInitializationSettings = const DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      var initializationSetting = InitializationSettings(
          android: androidInitializationSettings, iOS: iosInitializationSettings);

      await _flutterLocalNotificationsPlugin.initialize(initializationSetting,
          onDidReceiveNotificationResponse: (NotificationResponse response) {
        // handle interaction when app is active
        debugPrint('Notification tapped: ${response.payload}');
        
        // Use the stored message data if available
        if (_lastReceivedMessage != null) {
          handleMessage(_lastReceivedMessage!);
        }
      });
      
      debugPrint('Local notifications initialized successfully');
    } catch (e) {
      debugPrint('Error initializing local notifications: $e');
    }
  }

   //send notificartion request
  void requestNotificationPermission() async {
    try {
      NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        carPlay: true,
        criticalAlert: true,
        provisional: false,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        debugPrint('User granted permission');
      } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
        debugPrint('User granted provisional permission');
      } else {
        debugPrint('User declined or has not accepted permission');
      }
    } catch (e) {
      debugPrint('Error requesting notification permission: $e');
    }
  }

  // Check current notification permission status
  Future<AuthorizationStatus> checkNotificationPermission() async {
    try {
      NotificationSettings settings = await messaging.getNotificationSettings();
      return settings.authorizationStatus;
    } catch (e) {
      debugPrint('Error checking notification permission: $e');
      return AuthorizationStatus.denied;
    }
  }

  // Request permission and handle denied case
  Future<bool> requestPermissionWithSettings() async {
    try {
      NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        carPlay: true,
        criticalAlert: true,
        provisional: true,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        debugPrint('Notification permission granted');
        return true;
      } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
        debugPrint('Provisional notification permission granted');
        return true;
      } else {
        debugPrint('Notification permission denied: ${settings.authorizationStatus}');
        // Open app settings to let user manually enable notifications
        await AppSettings.openAppSettings();
        return false;
      }
    } catch (e) {
      debugPrint('Error requesting notification permission: $e');
      return false;
    }
  }

  //Fetch FCM Token
  Future<String> getDeviceToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      requestNotificationPermission();
      String? apnsToken;
      if (Platform.isIOS) {
        do {
          apnsToken = await messaging.getAPNSToken();
          await Future.delayed(Duration(milliseconds: 100));
        } while (apnsToken == null);
        debugPrint('APNS Token: $apnsToken');
      }

      // Now safe to call FCM token
      String? fcmToken = await messaging.getToken();
      prefs.setString("fcm", fcmToken??"");
      debugPrint('FCM Token: $fcmToken');
      return fcmToken ?? '';
    } catch (e) {
      debugPrint('Error getting device token: $e');
      return '';
    }
  }

  Future<void> deleteDeviceToken() async {
    try {
      // Delete token from Firebase
      await messaging.deleteToken();
      
      // Clear token from SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove("fcm");
      
      debugPrint('FCM Token deleted successfully');
    } catch (e) {
      debugPrint('Error deleting FCM token: $e');
    }
  }

  void firebaseInit() {
    // Initialize local notifications first
    initializeLocalNotifications();
    
    // Create the notification channel for Android
    if (Platform.isAndroid) {
      createNotificationChannel();
    }
    
    FirebaseMessaging.onMessage.listen((message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      debugPrint('Received foreground message:');
      debugPrint("notifications title: ${notification?.title}");
      debugPrint("notifications body: ${notification?.body}");
      debugPrint('count: ${android?.count}');
      debugPrint('data: ${message.data.toString()}');

      // Store the message for local notification handling
      _lastReceivedMessage = message;

      if (Platform.isIOS) {
        forgroundMessage();
      }

      if (Platform.isAndroid) {
        showNotification(message);
      }
    });

    // Handle background messages
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  // Create notification channel for Android
  Future<void> createNotificationChannel() async {
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const androidChannel = AndroidNotificationChannel(
      'speezu_notifications',
      'Speezu Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
      enableLights: true,
      showBadge: true,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);
  }

  //handle tap on notification when app is in background or terminated
  Future<void> setupInteractMessage() async {
    //when app is in background
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      debugPrint('App opened from background notification');
      handleMessage(event);
    });

    // Handle terminated state
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null && message.data.isNotEmpty) {
        debugPrint('App opened from terminated state notification');
        handleMessage(message);
      }
    });
  }

  // function to show visible notification when app is active
  Future<void> showNotification(RemoteMessage message) async {
    try {
      if (message.notification == null) {
        debugPrint('No notification data in message');
        return;
      }

      AndroidNotificationChannel channel = const AndroidNotificationChannel(
        'speezu_notifications',
        'Speezu Notifications',
        importance: Importance.max,
        showBadge: true,
        playSound: true,
        enableVibration: true,
        enableLights: true,
      );

      AndroidNotificationDetails androidNotificationDetails =
          AndroidNotificationDetails(
              channel.id.toString(), channel.name.toString(),
              channelDescription: 'This channel is used for important notifications.',
              importance: Importance.high,
              priority: Priority.high,
              playSound: true,
              enableVibration: true,
              ticker: 'ticker',
              sound: channel.sound
              );

      const DarwinNotificationDetails darwinNotificationDetails =
          DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        sound: 'default',
        interruptionLevel: InterruptionLevel.active  // This enables vibration on iOS
      );

      NotificationDetails notificationDetails = NotificationDetails(
          android: androidNotificationDetails, iOS: darwinNotificationDetails);

      Future.delayed(Duration.zero, () {
        _flutterLocalNotificationsPlugin.show(
          message.hashCode,
          message.notification!.title.toString(),
          message.notification!.body.toString(),
          notificationDetails,
          payload: message.data.toString(),
        );
        debugPrint('Local notification shown successfully');
      });
    } catch (e) {
      debugPrint('Error showing notification: $e');
    }
  }

  Future forgroundMessage() async {
    try {
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
      
      // Request critical alerts authorization for iOS
      if (Platform.isIOS) {
        await messaging.requestPermission(
          alert: true,
          badge: true,
          sound: true,
          criticalAlert: true,
          provisional: false,
        );
      }
      
      debugPrint('Foreground notification options set successfully');
    } catch (e) {
      debugPrint('Error setting foreground notification options: $e');
    }
  }

  Future<void> handleMessage(RemoteMessage message) async {
    debugPrint(
        "Navigating to appointments screen. Hit here to handle the message. Message data: ${message.data}");
  }

  // Test method to verify local notifications are working
  Future<void> testLocalNotification() async {
    try {
      const AndroidNotificationDetails androidNotificationDetails =
          AndroidNotificationDetails(
        'test_channel',
        'Test Channel',
        channelDescription: 'Test notification channel',
        importance: Importance.max,
        priority: Priority.high,
      );

      const DarwinNotificationDetails darwinNotificationDetails =
          DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails,
        iOS: darwinNotificationDetails,
      );

      await _flutterLocalNotificationsPlugin.show(
        999,
        'Test Notification',
        'This is a test notification to verify local notifications are working',
        notificationDetails,
        payload: 'test_payload',
      );
      
      debugPrint('Test notification sent successfully');
    } catch (e) {
      debugPrint('Error sending test notification: $e');
    }
  }

  // Utility method to check and request permissions with user feedback
  Future<void> ensureNotificationPermissions() async {
    try {
      AuthorizationStatus currentStatus = await checkNotificationPermission();
      
      if (currentStatus == AuthorizationStatus.authorized || 
          currentStatus == AuthorizationStatus.provisional) {
        debugPrint('Notification permissions already granted');
        return;
      }
      
      debugPrint('Requesting notification permissions...');
      bool granted = await requestPermissionWithSettings();
      
      if (granted) {
        debugPrint('Notification permissions granted successfully');
      } else {
        debugPrint('Notification permissions denied - user needs to enable in settings');
      }
    } catch (e) {
      debugPrint('Error ensuring notification permissions: $e');
    }
  }

  // Method to manually open app settings
  Future<void> openAppSettings() async {
    try {
      await AppSettings.openAppSettings();
      debugPrint('App settings opened');
    } catch (e) {
      debugPrint('Error opening app settings: $e');
    }
  }

  // Set up token refresh listener to automatically save updated tokens to server
  void setupTokenRefreshListener() {
    messaging.onTokenRefresh.listen((String newToken) async {
      debugPrint('FCM Token refreshed: $newToken');
      
      // Update stored token
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("fcm", newToken);
      
      // Check if user is logged in before saving to server
      final userRepository = UserRepository();
      final isAuthenticated = await userRepository.isUserAuthenticated();
      
      if (isAuthenticated && newToken.isNotEmpty) {
        try {
          await userRepository.saveFcmTokenToServer(newToken);
        } catch (e) {
          debugPrint('Error saving refreshed FCM token to server: $e');
        }
      } else {
        debugPrint('FCM token refreshed but user not logged in, skipping server update');
      }
    });
    
    debugPrint('FCM token refresh listener set up');
  }

}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Initialize Firebase for background messages if needed
  // await Firebase.initializeApp();
  
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  
  // Show the notification
  await flutterLocalNotificationsPlugin.show(
    message.hashCode,
    message.notification?.title ?? '',
    message.notification?.body ?? '',
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'high_importance_channel',
        'High Importance Notifications',
        channelDescription: 'This channel is used for important notifications.',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        enableVibration: true,
        showWhen: true,
      ),
    ),
    payload: message.data.toString(),
  );
}