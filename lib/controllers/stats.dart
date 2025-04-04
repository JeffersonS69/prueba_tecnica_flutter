import 'package:cloud_firestore/cloud_firestore.dart';

class StatsController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, Map<String, int>>> getAccessStats() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore
              .collection('access_logs')
              .orderBy('timestamp', descending: true)
              .get();

      Map<String, Map<String, int>> stats = {};

      for (var doc in querySnapshot.docs) {
        DateTime timestamp = (doc['timestamp'] as Timestamp).toDate();
        String day = timestamp.toIso8601String().split('T')[0];
        String username = doc['username'] ?? "Desconocido";

        if (!stats.containsKey(day)) {
          stats[day] = {};
        }

        if (stats[day]!.containsKey(username)) {
          stats[day]![username] = stats[day]![username]! + 1;
        } else {
          stats[day]![username] = 1;
        }
      }

      return stats;
    } catch (e) {
      print("Error obteniendo estadísticas: $e");
      return {};
    }
  }
}
