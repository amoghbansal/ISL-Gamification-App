import 'dart:async';
import 'package:flutter/material.dart';
import 'package:login_firebase_test/pages/thirdstep.dart';

class MoveForward extends StatelessWidget {
  final int score; // Add a parameter to accept the score

  MoveForward({required this.score}); // Constructor to receive the score

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.blue,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Color.fromARGB(255, 207, 238, 252),
        title: Text('Move Forward'),
        actions: [
          IconButton(
            icon: Image.asset(
              'images/trophy.png', // Replace 'path/to/trophy.png' with the actual path to your trophy image
              width: 50, // Adjust the size as needed
              height: 50,
            ),
            onPressed: () {
              // Define the action for trophy icon press
              // For example: Show achievements or leaderboards
              // You can replace this with your desired functionality
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 207, 238, 252),
              Color.fromARGB(255, 242, 222, 246),
              Colors.white
            ],
          ),
        ),
        child: AlphabetFruitMatch(score: score), // Pass the score to the widget
      ),
    );
  }
}

class AlphabetFruitMatch extends StatefulWidget {
  final int score; // Add a parameter to accept the score

  AlphabetFruitMatch({required this.score}); // Constructor to receive the score

  @override
  _AlphabetFruitMatchState createState() => _AlphabetFruitMatchState();
}

class _AlphabetFruitMatchState extends State<AlphabetFruitMatch>
    with SingleTickerProviderStateMixin {
  List<String> alphabetList = ['O', 'K', 'C', 'D', 'E'];
  Map<String, String> matches = {
    'O': 'Orange',
    'K': 'Kite',
    'C': 'Cherry',
    'D': 'Dog',
    'E': 'Egg',
  };
  Map<String, String> images = {
    'O': 'orange.png',
    'K': 'kite.png',
    'C': 'cherry.png',
    'D': 'dog.png',
    'E': 'egg.png',
  };
  late int score; // Declare score variable
  bool showRibbon = false;
  bool showNextStepButton =
      false; // Flag to control the visibility of the button
  late AnimationController _controller;
  late Timer _ribbonTimer;
  late Timer _buttonTimer;
  bool showMagicEffect = false; // Flag to track whether the magic effect is shown

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    score = widget.score; // Initialize score with the received score
  }

  @override
  void dispose() {
    _controller.dispose();
    _ribbonTimer.cancel(); // Cancel the ribbon timer when disposing the widget
    _buttonTimer.cancel(); // Cancel the button timer when disposing the widget
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              Text(
                'Score: $score', // Display the score
                style: TextStyle(fontSize: 20),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: alphabetList
                            .map((alphabet) => Draggable<String>(
                                  data: alphabet,
                                  child: Image.asset(
                                    'images/$alphabet.png',
                                    width: 100,
                                    height: 100,
                                  ),
                                  feedback: Image.asset(
                                    'images/$alphabet.png',
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                  childWhenDragging: Container(),
                                ))
                            .toList(),
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: DragTarget<String>(
                          builder: (context, accepted, rejected) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: matches.entries.map((entry) {
                                return DragTarget<String>(
                                  builder: (context, accepted, rejected) {
                                    return Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 16.0),
                                      child: accepted == entry.key
                                          ? Image.asset(
                                              'images/${images[entry.key]}',
                                              width: 100,
                                              height: 100,
                                            )
                                          : Draggable<String>(
                                              data: entry.key,
                                              child: Image.asset(
                                                'images/${images[entry.key]}',
                                                width: 100,
                                                height: 100,
                                              ),
                                              feedback: Image.asset(
                                                'images/${images[entry.key]}',
                                                width: 100,
                                                height: 100,
                                                fit: BoxFit.cover,
                                              ),
                                              childWhenDragging: Container(),
                                            ),
                                    );
                                  },
                                  onWillAccept: (data) => true,
                                  onAccept: (data) {
                                    if (matches[data] == entry.value) {
                                      setState(() {
                                        score = score + 100;
                                        alphabetList.remove(data);
                                        matches.remove(entry.key);
                                        if (alphabetList.isEmpty) {
                                          _completeGame();
                                        }
                                      });
                                      if (!_controller.isAnimating) {
                                        _controller.reset();
                                        _controller.forward();
                                      }
                                      setState(() {
                                        showMagicEffect = true;
                                      });
                                      Future.delayed(Duration(seconds: 1), () {
                                        setState(() {
                                          showMagicEffect = false;
                                        });
                                      });
                                    }
                                  },
                                );
                              }).toList(),
                            );
                          },
                          onWillAccept: (data) => true,
                          onAccept: (data) {},
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (showRibbon) RibbonWidget(),
        if (showNextStepButton)
          Positioned(
            bottom: 20,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(108.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Action to perform when button is pressed
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => Thirdstep(score: score)));
                  },
                  child: Text('Move to next step'),
                ),
              ),
            ),
          ),
        if (showMagicEffect)
          Positioned.fill(
            child: Image.asset(
              'images/star.gif',
              fit: BoxFit.cover,
            ),
          ),
      ],
    );
  }

  void _completeGame() {
    setState(() {
      showRibbon = true;
      showNextStepButton = true; // Set the flag to true when game is completed
    });
    _controller.forward();
    _ribbonTimer = Timer(Duration(seconds: 10), () {
      // Start a timer to hide the ribbon after 10 seconds
      setState(() {
        showRibbon = false;
      });
    });
    _buttonTimer = Timer(Duration(seconds: 20), () {
      // Start a timer to hide the button after 20 seconds
      setState(() {
        showNextStepButton = false;
      });
    });
  }
}

class RibbonWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Image.asset(
        'images/ribbon.gif',
        fit: BoxFit.cover,
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: MoveForward(score: 0), // Pass the initial score
  ));
}
