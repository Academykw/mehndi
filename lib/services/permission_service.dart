import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  static final PermissionService _instance = PermissionService._internal();

  factory PermissionService() {
    return _instance;
  }

  PermissionService._internal();

  // Check if storage permission is granted
  Future<bool> hasStoragePermission() async {
    final status = await Permission.storage.status;
    return status.isGranted;
  }

  // Request storage permission
  Future<bool> requestStoragePermission() async {
    final status = await Permission.storage.request();
    return status.isGranted;
  }

  // Check if photo permission is granted
  Future<bool> hasPhotoPermission() async {
    final status = await Permission.photos.status;
    return status.isGranted;
  }

  // Request photo permission
  Future<bool> requestPhotoPermission() async {
    final status = await Permission.photos.request();
    return status.isGranted;
  }

  // Check both storage and photo permissions
  Future<bool> hasMediaPermissions() async {
    final storageGranted = await hasStoragePermission();
    final photoGranted = await hasPhotoPermission();
    return storageGranted && photoGranted;
  }

  // Request both permissions
  Future<bool> requestMediaPermissions() async {
    final storageGranted = await requestStoragePermission();
    final photoGranted = await requestPhotoPermission();
    return storageGranted && photoGranted;
  }

  // Open app settings
  Future<void> openAppSettings() async {
    await openAppSettings();
  }

  // Check permission status with readable message
  Future<String> getPermissionStatusMessage(Permission permission) async {
    final status = await permission.status;
    switch (status) {
      case PermissionStatus.granted:
        return 'Permission granted';
      case PermissionStatus.denied:
        return 'Permission denied';
      case PermissionStatus.restricted:
        return 'Permission restricted';
      case PermissionStatus.limited:
        return 'Permission limited';
      case PermissionStatus.permanentlyDenied:
        return 'Permission permanently denied';
      case PermissionStatus.provisional:
        // TODO: Handle this case.
        throw UnimplementedError();
    }
  }
}
