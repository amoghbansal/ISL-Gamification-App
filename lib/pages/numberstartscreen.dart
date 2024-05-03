import 'dart:async';
import 'package:flutter/material.dart';
import 'package:login_firebase_test/pages/learnnumbers.dart';
import 'package:login_firebase_test/pages/moveforwardtonumbers.dart';
class NumberStartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Let's Learn Numbers"),
      ),
      body: numberquizgame(),
    );
  }
}
class numberquizgame extends StatefulWidget {
  const numberquizgame({super.key});

  @override
  State<numberquizgame> createState() => _numberquizgameState();
}

class _numberquizgameState extends State<numberquizgame> {
 int _currentQuestionIndex = 0;
  int _score = 0;
  List<Map<String, dynamic>> _quizData = [
    {
      'questionGifUrl': 'https://drive.google.com/uc?id=1O_KggV8RMdHKzg03Ic0ppLMXwxZcmK-T',
      'options': ['8', '6', '10', '0'],
      'correctIndex': 2,
    },
    {
      'questionGifUrl': 'https://drive.google.com/uc?id=1OeomXu7e7XPOIlaceHLECx8gkYzUAmNT',
      'options': ['7', '8', '5', '2'],
      'correctIndex': 1,
    },
    {
      'questionGifUrl': 'https://drive.usercontent.google.com/download?id=1OZqxsYspFey5EAj1VHRCtxLLAP6mGoVU&authuser=1',
      'options': ['5', '3', '1', '0'],
      'correctIndex': 0,
    },
    {
      'questionGifUrl': 'https://drive.google.com/uc?id=1OZ_3Ny15MZcD7dFenWoba0exuzgXjPl8',
      'options': ['2', '1', '0', '10'],
      'correctIndex': 1,
    },
    {
      'questionGifUrl': 'https://drive.google.com/uc?id=1OZnpkgNZTcYGAOS_RtyOUGeL8wL-9RSw',
      'options': ['4', '6', '7', '2'],
      'correctIndex': 2,
    },
    {
      'questionGifUrl': 'https://drive.google.com/uc?id=1OcwqxUUqa_sH0PVX4e0iD223mbWg2PSu',
      'options': ['1', '0', '2', '3'],
      'correctIndex': 1,
    },
    // Add more questions here...
  ];

  void _answerQuestion(int selectedOptionIndex) {
    if (selectedOptionIndex == _quizData[_currentQuestionIndex]['correctIndex']) {
      setState(() {
        _score++;
      });
    }
    setState(() {
      if (_currentQuestionIndex < _quizData.length - 1) {
        _currentQuestionIndex++;
      } else {
        // Navigate to result screen when all questions are answered
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ResultScreen(score: _score, totalQuestions: _quizData.length)),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Question ${_currentQuestionIndex + 1}/${_quizData.length}',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            Image.network(
              _quizData[_currentQuestionIndex]['questionGifUrl'],
              height: 200,
              width: 200,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 20),
            ...(_quizData[_currentQuestionIndex]['options'] as List<String>).map((option) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ElevatedButton(
                  onPressed: () => _answerQuestion(_quizData[_currentQuestionIndex]['options'].indexOf(option)),
                  child: Text(option),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}

class ResultScreen extends StatefulWidget {
  final int score;
  final int totalQuestions;

  ResultScreen({required this.score, required this.totalQuestions});

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  bool _showRibbons = true;

  @override
  void initState() {
    super.initState();
    // Hide the ribbons after 5 seconds
    Timer(Duration(seconds: 5), () {
      setState(() {
        _showRibbons = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Result'),
      ),
      body: Stack(
        children: [
          _showRibbons ? Positioned.fill(child: Image.asset('images/ribbon.gif', fit: BoxFit.cover)) : SizedBox(),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Your Score: ${widget.score}/${widget.totalQuestions}',
                  style: TextStyle(fontSize: 24),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Action for the "Learn" button
                    // Add your functionality here
                    Navigator.push(context, MaterialPageRoute(builder: (context) => LearnNumbers()));
                  },
                  child: Text('Learn'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => MoveForwardtonumbers()));
                  },
                  child: Text('Move Forward'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
