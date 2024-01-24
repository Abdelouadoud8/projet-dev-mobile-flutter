import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addSensorData(num temperature, num luminosity) async {
    try {
      await _firestore.collection('temp_lum').add({
        'temperature': temperature,
        'luminosity': luminosity,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error adding data: $e');
    }
  }

  Stream<QuerySnapshot> getData() {
    return _firestore.collection('temp_lum').snapshots();
  }
}
