import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/book_model.dart';
import '../data/book_repository.dart';


class FirestoreBookrepository implements Bookrepository {
  final CollectionReference _booksreference =
      FirebaseFirestore.instance.collection('books');

  @override
  Stream<List<Book>> watchbooks() {
    return _booksreference.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Book.fromMap(doc.id, doc.detail() as Map<String, dynamic>);
      }).toList();
    });
  }

 
  @override
  Future<void> issuebook(String id) async {
    final doc_ = _booksreference.doc(id);

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final snapshot = await transaction.get(doc_);
      if (!snapshot.exists) return;

      final bookcurravailable = (snapshot.get('available') as num).toInt();
      if (bookcurravailable > 0) {
        transaction.update(doc_, {'available': bookcurravailable - 1});
      }
    });
  }

  //if incase the available<copies
  @override
  Future<void> returnbook(String id) async {
    final doc_ = _booksreference.doc(id);

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final snapshot = await transaction.get(doc_);
      if (!snapshot.exists) return;

      final currentAvailable = (snapshot.get('available') as num).toInt();
      final totalCopies = (snapshot.get('copies') as num).toInt();

      if (currentAvailable < totalCopies) {
        transaction.update(doc_, {'available': currentAvailable + 1});
      }
    });
  }
 //coded the seed because it was taking too long to add each in the collection in firestore>database>collection
  @override
  Future<void> seedbooks() async {
    final allbooks = FirebaseFirestore.instance.batch();

    final booksdetails = [
      {'title':'Clean Code', 'author': 'Robert Martin', 'copies': 5, 'available': 3}, {'title':'The Pragmatic Programmer', 'author': 'Andrew Hunt', 'copies': 4, 'available': 1},
      {'title': 'Introduction to Algorithms', 'author': 'Thomas Cormen', 'copies': 6, 'available': 0},
      {'title': 'Flutter in Action','author': 'Eric Windmill', 'copies': 3, 'available': 2},
      {'title':'Design Patterns','author':'Erich Gamma', 'copies': 4, 'available': 0},
      {'title':'Refactoring','author': 'Martin Fowler', 'copies': 3, 'available': 3},
      {'title':'Code Complete','author':'Steve McConnell', 'copies': 2, 'available': 1},
      {'title':'Head First Java','author':'Kathy Sierra', 'copies': 5, 'available': 4},
      {'title': 'Database System Concepts','author': 'Abraham Silberschatz', 'copies': 4, 'available': 2},
      {'title':'Clean Architecture','author':'Robert Martin','copies': 3, 'available': 1},
    ];

    for (var b in booksdetails) {
      final doc = _booksreference.doc();
      allbooks.set(doc, b);
    }

    await allbooks.commit();
  }
}