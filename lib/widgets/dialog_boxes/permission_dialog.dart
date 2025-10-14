import 'package:flutter/material.dart';
import 'package:app_settings/app_settings.dart';
import '../../core/services/permission_service.dart';

class PermissionDialog {
  /// Show location permission dialog
  static Future<bool?> showLocationPermissionDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(
                Icons.location_on,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              const Text('Location Permission'),
            ],
          ),
          content: const Text(
            'Speezu needs your location to:\n\n'
            '• Show nearby stores and restaurants\n'
            '• Provide accurate delivery tracking\n'
            '• Give you turn-by-turn directions\n\n'
            'Your location data is only used to enhance your experience and is not shared with third parties.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Not Now'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop(true);
              },
              child: const Text('Allow'),
            ),
          ],
        );
      },
    );
  }

  /// Show location permission denied dialog with settings option
  static Future<void> showLocationPermissionDeniedDialog(
    BuildContext context, {
    bool isPermanentlyDenied = false,
  }) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(
                Icons.location_off,
                color: Colors.orange[700],
              ),
              const SizedBox(width: 8),
              const Text('Location Access Required'),
            ],
          ),
          content: Text(
            isPermanentlyDenied
                ? 'Location permission is required to use this feature. '
                    'Please enable it in your device settings.\n\n'
                    'Steps:\n'
                    '1. Tap "Open Settings" below\n'
                    '2. Find and tap "Location"\n'
                    '3. Select "While Using the App" or "Always"'
                : 'Location permission is required to show nearby stores, '
                    'track deliveries, and provide directions.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            if (isPermanentlyDenied) ...[
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  await PermissionService.requestLocationPermission();
                },
                child: const Text('Try Again'),
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  // Open app settings (not location settings specifically)
                  await AppSettings.openAppSettings();
                },
                child: const Text('Open Settings'),
              ),
            ] else
              ElevatedButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  await PermissionService.requestLocationPermission();
                },
                child: const Text('Try Again'),
              ),
          ],
        );
      },
    );
  }

  /// Show camera permission dialog (for QR scanning)
  static Future<bool?> showCameraPermissionDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(
                Icons.camera_alt,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              const Text('Camera Permission'),
            ],
          ),
          content: const Text(
            'Speezu needs camera access to:\n\n'
            '• Scan QR codes for order verification\n'
            '• Process payments via QR codes\n'
            '• Take photos for reviews\n\n'
            'Your camera is only used when you explicitly use these features.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Not Now'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop(true);
              },
              child: const Text('Allow'),
            ),
          ],
        );
      },
    );
  }

  /// Show camera permission denied dialog with settings option
  static Future<void> showCameraPermissionDeniedDialog(
    BuildContext context, {
    bool isPermanentlyDenied = false,
  }) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(
                Icons.no_photography,
                color: Colors.orange[700],
              ),
              const SizedBox(width: 8),
              const Text('Camera Access Required'),
            ],
          ),
          content: Text(
            isPermanentlyDenied
                ? 'Camera permission is required to scan QR codes. '
                    'Please enable it in your device settings.\n\n'
                    'Steps:\n'
                    '1. Tap "Open Settings" below\n'
                    '2. Find and tap "Camera"\n'
                    '3. Enable the toggle'
                : 'Camera permission is required to scan QR codes for order verification.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            if (isPermanentlyDenied)
              ElevatedButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  // Open app settings
                  await AppSettings.openAppSettings();
                },
                child: const Text('Open Settings'),
              )
            else
              ElevatedButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  await PermissionService.requestCameraPermission();
                },
                child: const Text('Try Again'),
              ),
          ],
        );
      },
    );
  }

  /// Show location services disabled dialog
  static Future<void> showLocationServicesDisabledDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(
                Icons.location_disabled,
                color: Colors.red[700],
              ),
              const SizedBox(width: 8),
              const Text('Location Services Off'),
            ],
          ),
          content: const Text(
            'Location services are disabled on your device. '
            'Please enable them in your device settings to use location-based features.\n\n'
            'Steps:\n'
            '1. Tap "Open Settings" below\n'
            '2. Go to Privacy & Security\n'
            '3. Tap Location Services\n'
            '4. Turn on Location Services',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                // Open device settings - user will need to navigate to Privacy > Location Services
                await AppSettings.openAppSettings();
              },
              child: const Text('Open Settings'),
            ),
          ],
        );
      },
    );
  }
}

