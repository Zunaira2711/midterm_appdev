import 'dart:async';
import 'package:flutter/material.dart';
import '../data/book_model.dart';
import '../data/book_repository.dart';

class Booksprovider extends ChangeNotifier {
  final Bookrepository _repository;
  StreamSubscription<List<Book>>? _subscription;

  List<Book> _allBooks = [];
  String _authorquery = '';
  bool _onlyavailable = false;
  bool _isloading = true;

  Booksprovider(this._repository) {
    _subscription = _repository.watchbooks().listen((books) {
      _allBooks = books;
      _isloading = false;
      notifyListeners();
    });
  }

  bool get isloading => _isloading;
    int get count => _allBooks.length;
  bool get onlyavailable => _onlyavailable;

  
  List<Book> get books {
    return _allBooks.where((book) {
      final matchesAuthor = book.author
          .toLowerCase()
          .contains(_authorquery.toLowerCase());
      final matchesAvailability = !_onlyavailable || book.available > 0;
      return matchesAuthor && matchesAvailability;
    }).toList();
  }

  void setauthorquery(String query) {
    _authorquery = query;
    notifyListeners();
  }

  void toggleOnlyAvailable(bool value) {
    _onlyavailable = value;
    notifyListeners();
  }

  Future<void> issueBook(String id) => _repository.issuebook(id);
  Future<void> returnBook(String id) => _repository.returnbook(id);
  Future<void> seedDatabase() => _repository.seedbooks();

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

