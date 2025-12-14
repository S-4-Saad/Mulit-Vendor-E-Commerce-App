import 'package:flutter/material.dart';
import 'package:app_settings/app_settings.dart';
import 'package:speezu/core/utils/labels.dart';
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
              Icon(Icons.location_off, color: Colors.orange[700]),
              const SizedBox(width: 8),
              Text(
                Labels.locationAccessRequired,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSecondary,
                  fontSize: 14,
                ),
              ),
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
              child: Text(Labels.cancel),
            ),
            if (isPermanentlyDenied) ...[
              // Removed "Try Again" button as per instruction to only have "Open Settings"
              ElevatedButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  // Open app settings (not location settings specifically)
                  await AppSettings.openAppSettings();
                },
                child: Text(
                  Labels.openSetting,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ] else
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                ),
                onPressed: () async {
                  Navigator.of(context).pop();
                  // Open app settings so user can grant location permission
                  await AppSettings.openAppSettings();
                },
                child: Text(
                  Labels.openSetting,
                  style: TextStyle(color: Colors.white),
                ),
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
              Icon(Icons.no_photography, color: Colors.orange[700]),
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
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 40,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon Container
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.location_off_rounded,
                    color: Colors.red[600],
                    size: 32,
                  ),
                ),

                const SizedBox(height: 20),

                // Title
                Text(
                  Labels.locationServicesOff,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                ),

                const SizedBox(height: 12),

                // Description
                Text(
                  Labels.enableLocationServicesAccess,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSecondary.withValues(alpha: .6),
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 24),

                // Steps Container
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.onPrimary.withValues(alpha: .1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Labels.quickSetup,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSecondary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildStep(context, '1', Labels.tapOpenSettingBelow),
                      const SizedBox(height: 8),
                      _buildStep(context, '2', Labels.goToPrivacyAndSecurity),
                      const SizedBox(height: 8),
                      _buildStep(context, '3', Labels.tapLocationServices),
                      const SizedBox(height: 8),
                      _buildStep(context, '4', Labels.turnOnLocationServices),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          Labels.cancel,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          Navigator.of(context).pop();
                          // Open device location settings (not app settings)
                          await AppSettings.openAppSettings(
                            type: AppSettingsType.location,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          Labels.openSetting,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static Widget _buildStep(BuildContext context, String number, String text) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onPrimary,
            shape: BoxShape.circle,
            border: Border.all(
              color: Theme.of(context).colorScheme.primary,
              width: 2,
            ),
          ),
          child: Center(
            child: Text(
              number,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSecondary,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(
                context,
              ).colorScheme.onSecondary.withValues(alpha: .6),
            ),
          ),
        ),
      ],
    );
  }
}
