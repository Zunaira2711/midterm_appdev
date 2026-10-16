import 'package:cloud_firestore/cloud_firestore.dart';


class Book {
  const Book({
    required this.id,
    required this.title,
    required this.author,
    required this.copies,
    required this.available
  });

  final String id; //could be A8975
  final String title;
  final String author;
  final int copies;
  final int available;

  factory Book.fromMap(String id, Map<String, dynamic> data) {
    return Book(
      id: id, 
      title: data['title'] as String? ?? '',
      author: data['author'] as String? ?? '',
     copies: data['copies'] ?? 0,
     available: data['available'] ?? 0,
      
    );
  }


  Map<String, dynamic> toMap() {
    return {
       'title': title,
      'author': author,
      'copies': copies,
      'available': available,
      
    };
  }

}



  

 