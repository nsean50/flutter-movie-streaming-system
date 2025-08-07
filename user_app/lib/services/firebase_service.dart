import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/movie.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'movies';

  Future<List<Movie>> getMovies() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection(_collection)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => Movie.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error getting movies: $e');
      return [];
    }
  }

  Future<List<Movie>> getMoviesByCategory(String category) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection(_collection)
          .where('category', isEqualTo: category)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => Movie.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error getting movies by category: $e');
      return [];
    }
  }

  Stream<List<Movie>> getMoviesStream() {
    return _firestore
        .collection(_collection)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Movie.fromMap(doc.data() as Map<String, dynamic>))
            .toList());
  }

  Stream<List<Movie>> getMoviesByCategoryStream(String category) {
    return _firestore
        .collection(_collection)
        .where('category', isEqualTo: category)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Movie.fromMap(doc.data() as Map<String, dynamic>))
            .toList());
  }
}
