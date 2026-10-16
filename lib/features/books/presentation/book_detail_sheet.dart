import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'books_provider.dart';

class Bookdetailsheet extends StatelessWidget {
  final String bookId;

  const Bookdetailsheet({super.key, required this.bookId});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<Booksprovider>();
    final matches = provider.books.where((b) => b.id == bookId);

    if (matches.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(23.0),
        child: Text('Book not found'),
      );
    }

    final book = matches.first;

    return Padding(
      padding: const EdgeInsets.all(23.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            book.title,
            style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 3),
          Text(
            book.author,
            style: TextStyle(color: Colors.grey[600], fontSize: 16),
          ),
          const SizedBox(height: 23),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  const Text('Available', style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 4),
                  Text(
                    '${book.available}',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: book.available == 0 ? Colors.red : null,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  const Text('Total copies', style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 4),
                  Text(
                    '${book.copies}',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: FilledButton.tonal(
                  onPressed: book.available > 0
                      ? () => provider.issueBook(book.id)
                      : null,
                  child: const Text('Issue'),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: FilledButton.tonal(
                  onPressed: book.available < book.copies
                      ? () => provider.returnBook(book.id)
                      : null,
                  child: const Text('Return'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
        ],
      ),
    );
  }
}