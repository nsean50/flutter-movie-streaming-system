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

  Future<bool> addMovie(Movie movie) async {
    try {
      await _firestore.collection(_collection).doc(movie.id).set(movie.toMap());
      return true;
    } catch (e) {
      print('Error adding movie: $e');
      return false;
    }
  }

  Future<bool> updateMovie(Movie movie) async {
    try {
      await _firestore.collection(_collection).doc(movie.id).update(movie.toMap());
      return true;
    } catch (e) {
      print('Error updating movie: $e');
      return false;
    }
  }

  Future<bool> deleteMovie(String movieId) async {
    try {
      await _firestore.collection(_collection).doc(movieId).delete();
      return true;
    } catch (e) {
      print('Error deleting movie: $e');
      return false;
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
}
