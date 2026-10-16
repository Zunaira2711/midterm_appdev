import '../data/book_model.dart';

abstract class Bookrepository {
  Stream<List<Book>> watchbooks();
  Future<void> issuebook(String id);
  Future<void> returnbook(String id);
  Future<void> seedbooks();
}