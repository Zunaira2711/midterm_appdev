import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'books_provider.dart';
import 'book_detail_sheet.dart';
class Booklistscreen extends StatelessWidget {
  const Booklistscreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<Booksprovider>();

    return Scaffold(
      appBar: AppBar(
       title: const Text('Library'),
        actions: [
          IconButton(
          icon: const Icon(Icons.cloud_upload_outlined),
          tooltip: 'Seed database',
          onPressed: () => provider.seedDatabase(),
          ),
        ],
      ),
    body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            child: Text(
              '${provider.count} books in the catalogue',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),
           Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search by author',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: const Color.fromARGB(255, 180, 176, 176),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: provider.setauthorquery,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 194, 185, 185),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.filter_list, size: 20),
                      SizedBox(width: 8),
                      Text('Show only available'),
                    ],
                  ),
                  Switch(
                    value: provider.onlyavailable,
                    onChanged: provider.toggleOnlyAvailable,
                  ),
                ],
              ),
            ),
          ),
        const SizedBox(height: 8),
        Expanded(
          child: provider.isloading
              ? const Center(child: CircularProgressIndicator())
                : provider.books.isEmpty
                    ? const Center(
                        child: Text(
                          'No books found',
                          style: TextStyle(color: Color.fromARGB(255, 129, 122, 122)),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        itemCount: provider.books.length,
                        itemBuilder: (context, index) {
                          final book = provider.books[index];
                          final isUnavailable = book.available == 0;

                          return Card(
                            elevation: 0,
                            margin: const EdgeInsets.only(bottom: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                              side: BorderSide(color: Colors.grey.shade200),
                            ),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (_) => Bookdetailsheet(bookId: book.id),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.indigo.shade50,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Icon(Icons.menu_book, color: Colors.indigo),
                                    ),
                                    const SizedBox(width: 11),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          // Q7: Red text if Not Available
                                          Text(
                                            book.title,
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: isUnavailable ? Colors.red.shade700 : Colors.black,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            book.author,
                                            style: TextStyle(color: const Color.fromARGB(255, 194, 180, 180), fontSize: 13),
                                          ),
                                          const SizedBox(height: 6),
                                          // Q7: Red badge if 0, else count
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: isUnavailable ? const Color.fromARGB(255, 202, 125, 136) : const Color.fromARGB(255, 126, 137, 198),
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                            child: Text(
                                              isUnavailable
                                                  ? 'Not Available'
                                                  : '${book.available} / ${book.copies} available',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: isUnavailable ? const Color.fromARGB(255, 251, 116, 116) : Colors.indigo.shade700,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        IconButton(
                                          visualDensity: VisualDensity.compact,
                                          icon: const Icon(Icons.arrow_upward, size: 20),
                                          tooltip: 'Issue',
                                          onPressed: book.available > 0
                                              ? () => provider.issueBook(book.id)
                                              : null,
                                        ),
                                        IconButton(
                                          visualDensity: VisualDensity.compact,
                                          icon: const Icon(Icons.arrow_downward, size: 20),
                                          tooltip: 'Return',
                                          onPressed: book.available < book.copies
                                              ? () => provider.returnBook(book.id)
                                              : null,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}