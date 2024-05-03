import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:login_firebase_test/pages/alphabetfinal.dart';

class Challenger5 extends StatelessWidget {
  final int score;
  Challenger5({required this.score});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Move Forward'),
        backgroundColor: Color.fromARGB(255, 207, 238, 252),
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
        child: ThirdGame(score: score),
      ),
    );
  }
}

class ThirdGame extends StatefulWidget {
  final int score;
  ThirdGame({required this.score});
  @override
  _ThirdGameState createState() => _ThirdGameState();
}

class _ThirdGameState extends State<ThirdGame> {
  List<String?> solution = [
    "wooden",
    "wooden",
    "wooden"
  ]; // Initialize with null
  List<String> availableLetters = [
    "C",
    "A",
    "R",
    "O"
  ]; // Four alphabets to choose from
  bool? isCorrectSolution;
  int attempts = 0;
  int maxAttempts = 3;
  bool showMoveToNextButton = false;
  late int score;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    score = widget.score;
  }

  void checkSolution() {
    if (ListEquality().equals(solution, ["C", "A", "R"])) {
      // Correct solution
      setState(() {
        isCorrectSolution = true;
        showMoveToNextButton = true;
        if (attempts == 0) {
          score += 100;
        } else if (attempts == 1) {
          score += 50;
        } else if (attempts == 2) {
          score += 25;
        }
      });
    } else {
      // Incorrect solution
      setState(() {
        attempts++;
        if (attempts >= maxAttempts) {
          // If the maximum attempts are reached, place C, O, and W automatically
          solution[0] = "C";
          solution[1] = "A";
          solution[2] = "R";
          isCorrectSolution = false;
          showMoveToNextButton = false;
        } else {
          isCorrectSolution = false;
          showMoveToNextButton = false;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isCorrectSolution != null && isCorrectSolution!)
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Image.asset(
                    "images/correct.gif", // Path to correct.gif
                    width: 100,
                    height: 100,
                  ),
                ),
              if (isCorrectSolution != null && !isCorrectSolution!)
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Image.asset(
                    "images/wrong.gif", // Path to wrong.gif
                    width: 100,
                    height: 100,
                  ),
                ),
              Image.asset("images/Challenger_4.png", width: 300, height: 200),
              // Display the cow image with glass-like effect
              Stack(
                alignment: Alignment.center,
                children: [
                  // Elevated glass-like card containing the cow image
                  Material(
                    elevation: 4, // Adjust elevation as needed
                    borderRadius: BorderRadius.circular(
                        20), // Adjust border radius as needed
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors
                            .transparent, // Increased opacity for a more transparent effect
                        borderRadius: BorderRadius.circular(
                            20), // Same border radius as the Material widget
                      ),
                      child: Image.asset("images/car.png",
                          width: 180, height: 180),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              // Display the boxes for C, O, and W
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(3, (index) {
                  return DragTarget<String>(
                    builder: (context, accepted, rejected) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (solution[index] != null) {
                              availableLetters.add(solution[
                                  index]!); // Add the alphabet back to options list
                              solution[index] =
                                  "wooden"; // Set the solution box back to null
                            }
                          });
                        },
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius:
                                BorderRadius.circular(12), // Rounded corners
                          ),
                          alignment: Alignment.center,
                          child: ClipRRect(
                            // ClipRRect to ensure rounded corners
                            borderRadius: BorderRadius.circular(12),
                            child: solution[index] != null
                                ? Image.asset(
                                    "images/${solution[index]}.png",
                                    width: double.infinity,
                                    height: double.infinity,
                                    fit: BoxFit.cover,
                                  ) // Render the image if available
                                : SizedBox(), // Render nothing if no image is set
                          ),
                        ),
                      );
                    },
                    onWillAccept: (data) => true,
                    onAccept: (data) {
                      setState(() {
                        if (index >= 0 && index < solution.length) {
                          solution[index] =
                              data; // Set the alphabet in the solution
                          availableLetters
                              .remove(data); // Remove the alphabet from options
                        }
                      });
                    },
                  );
                }),
              ),
              SizedBox(height: 20),
              // Display the draggable alphabet images
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: availableLetters.map((letter) {
                  return Draggable<String>(
                    data: letter,
                    child: Image.asset("images/$letter.png",
                        width: 80, height: 80), // Adjusted path and size
                    feedback: Material(
                      child: Image.asset("images/$letter.png",
                          width: 80, height: 80), // Adjusted path and size
                    ),
                    childWhenDragging: Container(),
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              // Display the "Check Now" or "Move to Next Challenge" button
              if (!showMoveToNextButton)
                ElevatedButton(
                  onPressed: checkSolution,
                  child: Text("Check Now"),
                ),
              if (showMoveToNextButton)
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AlphabetFinal(score:score)));
                  },
                  child: Text("Move to Next Challenge"),
                ),
            ],
          ),
        ),
        Positioned(
          top: 16,
          right: 16,
          child: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              "${maxAttempts - attempts} Chance",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        Positioned(
          top: 16,
          left: 16,
          child: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              "Score: $score",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Challenger5(score:0),
  ));
}
