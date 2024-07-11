import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';
import '../models/app_card.dart';
import '../widgets/animated_background.dart';
import 'settings_page.dart';
import 'game_over_page.dart';

class QuizPage extends StatefulWidget {
  final List<AppCard> data;
  final String questionAttribute;
  final String answerAttribute;

  const QuizPage({
    super.key,
    required this.data,
    required this.questionAttribute,
    required this.answerAttribute,
  });

  @override
  QuizPageState createState() => QuizPageState();
}

class QuizPageState extends State<QuizPage> {
  late List<AppCard> _data;
  late String _questionAttribute;
  late String _answerAttribute;

  int _currentIndex = 0;
  int _score = 0;
  final Random _random = Random();
  String? _selectedAnswer;
  bool _showOverlay = false;
  bool _isCorrect = false;
  bool _showCorrectOption = false;
  late Timer _timer;
  late List<String> _options;

  @override
  void initState() {
    super.initState();
    _data = widget.data;
    _questionAttribute = widget.questionAttribute;
    _answerAttribute = widget.answerAttribute;
    _generateOptions();
  }

  void _generateOptions() {
    final currentCard = _data[_currentIndex];
    final correctAnswer = currentCard.getAttributeValue(_answerAttribute);

    _options = [correctAnswer];
    while (_options.length < 4) {
      final randomIndex = _random.nextInt(_data.length);
      final randomCard = _data[randomIndex];
      final randomAnswer = randomCard.getAttributeValue(_answerAttribute);
      if (!_options.contains(randomAnswer)) {
        _options.add(randomAnswer);
      }
    }
    _options.shuffle();
  }

  void _checkAnswer(String selectedAnswer) {
    final currentCard = _data[_currentIndex];
    final correctAnswer = currentCard.getAttributeValue(_answerAttribute);

    setState(() {
      _selectedAnswer = selectedAnswer;
      _isCorrect = selectedAnswer == correctAnswer;
      _showOverlay = true;
      _showCorrectOption = true;
    });

    _timer = Timer(const Duration(seconds: 1), () {
      setState(() {
        if (_isCorrect) {
          _score++;
        }
        _nextQuestion();
        _showOverlay = false;
        _selectedAnswer = null;
        _showCorrectOption = false;
      });
    });
  }

  void _nextQuestion() {
    setState(() {
      if (_currentIndex < _data.length - 1) {
        _currentIndex++;
        _generateOptions();
      } else {
        // Navigate to the Game Over screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GameOverPage(totalQuestions: _data.length),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentCard = _data[_currentIndex];
    final question = currentCard.getAttributeValue(_questionAttribute);
    final correctAnswer = currentCard.getAttributeValue(_answerAttribute);
    final totalQuestions = _data.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Study App'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                '${_currentIndex + 1}/$totalQuestions',
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsPage(),
                ),
              );

              if (result != null && result is Map<String, dynamic>) {
                setState(() {
                  _data = result['data'] as List<AppCard>;
                  _questionAttribute = result['questionAttribute'] as String;
                  _answerAttribute = result['answerAttribute'] as String;
                  _score = 0;
                  _generateOptions();
                });
              }
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          const AnimatedBackground(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Score: $_score',
                style: const TextStyle(color: Colors.white)),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      width: 500,
                      height: 500, // Define the area for the question text
                      alignment: Alignment.center,
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: FittedBox(
                            fit: BoxFit.contain,
                            child: Text(
                              question,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            )),
                      )),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 300, // Set a specific width
                    height: 200, // Set a specific height
                    child: GridView.count(
                      shrinkWrap: true,
                      crossAxisCount: 2,
                      mainAxisSpacing: 16.0,
                      crossAxisSpacing: 16.0,
                      childAspectRatio: 3,
                      children: _options.map((answer) {
                        final bool isSelected = answer == _selectedAnswer;
                        final bool isCorrectOption = answer == correctAnswer;
                        return GestureDetector(
                          onTap: _showOverlay
                              ? null
                              : () {
                                  _checkAnswer(answer);
                                  setState(() {
                                    _selectedAnswer = answer;
                                  });
                                },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                              color: isSelected ||
                                      (_showCorrectOption && isCorrectOption)
                                  ? (_isCorrect || isCorrectOption
                                      ? Colors.green
                                      : Colors.red)
                                  : Colors.blueAccent,
                            ),
                            child: Center(
                              child: Text(
                                answer,
                                style: const TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_showOverlay)
            IgnorePointer(
              child: Center(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.8,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Center(
                    child: Icon(
                      _isCorrect ? Icons.check_circle_outline : Icons.clear,
                      color: _isCorrect ? Colors.green : Colors.red,
                      size: 100,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
