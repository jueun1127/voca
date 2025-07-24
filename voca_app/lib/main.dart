import 'screens/word_edit_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
  // 앱 시작 화면으로 WordEditScreen을 사용

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Voca App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const WordEditScreen(),
    );
  }
}