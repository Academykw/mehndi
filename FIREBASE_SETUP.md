# Firebase Setup & Image Uploading Guide

You have successfully added `google-services.json`. I have already configured your `build.gradle` files to include the necessary Google Services plugins.

## 1. Complete `firebase_options.dart`
Since you have the `google-services.json` file, you should update `lib/firebase_options.dart` with your actual project values. You can find these in the `google-services.json` file:
- `apiKey`: Look for `current_key` under `api_key`.
- `appId`: Look for `mobilesdk_app_id`.
- `projectId`: Look for `project_id`.
- `messagingSenderId`: Look for `project_number`.
- `storageBucket`: Usually `your-project-id.appspot.com`.

## 2. Enable Services in Firebase Console
Go to [Firebase Console](https://console.firebase.google.com/) and enable:
1. **Firestore Database**: Create a database in "Start in test mode" (or locked mode if you add rules).
2. **Firebase Storage**: This is where your images will be stored. Enable it and set the rules to allow public read/authenticated write.

## 3. Image Uploading (Admin Side)
To upload images to your app, you have two choices:

### Option A: Manual Upload (Easiest for starting)
1. **Upload to Storage**: Go to "Storage" in Firebase Console, create folders (e.g., `bridal`, `arabic`), and upload your images.
2. **Copy URL**: Click on the uploaded image and copy the "Download URL".
3. **Add to Firestore**: Go to "Firestore", create a collection named `henna_images`, and add a document for each image with these fields:
   - `categoryId`: (String) e.g., "bridal"
   - `title`: (String)
   - `imageUrl`: (String) The URL you copied from Storage
   - `uploadedAt`: (Timestamp)
   - `views`: (Number) 0
   - `likes`: (Number) 0

### Option B: Upload via App (Programmatic)
If you want to build an admin upload screen, use this logic:

```dart
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

Future<void> uploadMehndiDesign(File imageFile, String title, String categoryId) async {
  // 1. Upload to Storage
  String fileName = DateTime.now().millisecondsSinceEpoch.toString();
  Reference ref = FirebaseStorage.instance.ref().child('designs/$fileName');
  UploadTask uploadTask = ref.putFile(imageFile);
  TaskSnapshot snapshot = await uploadTask;
  String downloadUrl = await snapshot.ref.getDownloadURL();

  // 2. Save Metadata to Firestore
  await FirebaseFirestore.instance.collection('henna_images').add({
    'title': title,
    'imageUrl': downloadUrl,
    'categoryId': categoryId,
    'uploadedAt': FieldValue.serverTimestamp(),
    'views': 0,
    'likes': 0,
  });
}
```

## 4. Run the App
After updating `firebase_options.dart`, run:
```bash
flutter clean
flutter pub get
flutter run
```
