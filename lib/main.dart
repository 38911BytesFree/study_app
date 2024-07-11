import 'package:flutter/material.dart';
import 'pages/quiz_page.dart';
import 'data/fish_data.dart';

void main() {
  runApp(const StudyApp());
}

class StudyApp extends StatelessWidget {
  const StudyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Study App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: QuizPage(answerAttribute: "hiragana", questionAttribute: "kanji", data: fishData),
    );
  }
}
