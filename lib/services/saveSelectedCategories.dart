import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> saveSelectedCategories(List<String> selectedCategories) async {
  final userId = FirebaseAuth.instance.currentUser!.uid;
  final firestore = FirebaseFirestore.instance;
  final selectedCategoriesRef = firestore
      .collection('users')
      .doc(userId)
      .collection('categories');

  // Önce tüm eski seçimleri sil (istersen opsiyonel yapabilirsin)
  final oldSelections = await selectedCategoriesRef.get();
  for (var doc in oldSelections.docs) {
    await doc.reference.delete();
  }

  // Yeni seçimleri ekle
  for (String category in selectedCategories) {
    await selectedCategoriesRef.add({
      'name': category,
      'created_at': FieldValue.serverTimestamp(),
    });
  }
}
