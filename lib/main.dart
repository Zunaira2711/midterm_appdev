import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

import 'features/books/data/book_model.dart';
import 'features/books/data/book_repository.dart';
import 'features/books/data/firestore_book_repository.dart';
import 'features/books/presentation/books_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => TaskViewModel(TaskRepository()),
        ),
      ],
      child: MaterialApp(
        title: 'Library',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Colors.indigo,
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            elevation: 0,
          ),
          inputDecorationTheme: const InputDecorationTheme(
            border: OutlineInputBorder(),
            isDense: true,
          ),
        ),
        home: const TaskListScreen(),
      ),
    );
  }
}