import 'package:flutter/material.dart';
import 'package:login_firebase_test/pages/challenger3number.dart';

class Challenger2Image extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Let's Play!"),
      ),
      body: Challenger2Game(),
    );
  }
}

class Challenger2Game extends StatefulWidget {
  const Challenger2Game({Key? key}) : super(key: key);

  @override
  State<Challenger2Game> createState() => _Challenger2GameState();
}

class _Challenger2GameState extends State<Challenger2Game> {
  String? solution; // Store the solution
  List<String> availableNumbers = ["9", "6", "2", "4"]; // Available numbers
  bool isCorrectSolution = false; // Track solution correctness

  void checkSolution() {
    if (solution == "9") {
      // Correct solution
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Result'),
          content: Text('Correct solution!'),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  isCorrectSolution = true; // Update state to indicate correct solution
                });
                Navigator.pop(context); // Close dialog
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    } else {
      // Incorrect solution
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Result'),
          content: Text('Incorrect solution!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Challenger 2",
              style: TextStyle(fontFamily: 'Cursive', fontSize: 24),
            ),
          ),
          // Image "nine.png" above the solution box
          SizedBox(
            width: 350,
            height: 200,
            child: Image.asset(
              "images/nine.png",
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 20),
          // Display the box for solution
          DragTarget<String>(
            builder: (context, accepted, rejected) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (solution != null) {
                      availableNumbers
                          .add(solution!); // Add number back to options list
                      solution = null; // Clear solution
                    }
                  });
                },
                child: Container(
                  width: 100,
                  height: 100,
                  color: Colors.grey,
                  alignment: Alignment.center,
                  child: solution != null
                      ? SizedBox(
                          width: 100,
                          height: 100,
                          child: Image.asset(
                            "images/$solution.png",
                            fit: BoxFit.contain,
                          ),
                        )
                      : SizedBox(), // Render nothing if no image is dropped
                ),
              );
            },
            onWillAccept: (data) => true,
            onAccept: (data) {
              setState(() {
                if (solution == null && availableNumbers.contains(data)) {
                  solution = data; // Update solution
                  availableNumbers
                      .remove(data); // Remove dropped number from options
                }
              });
            },
          ),
          SizedBox(height: 20),
          // Display draggable number cards
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: availableNumbers.map((number) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (solution == null) {
                      solution = number; // Update solution
                      availableNumbers.remove(number); // Remove selected number
                    }
                  });
                },
                child: SizedBox(
                  width: 100,
                  height: 100,
                  child: Material(
                    elevation: 5, // Increase elevation
                    borderRadius: BorderRadius.circular(12), // Round corners
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12), // Round corners
                      child: Image.asset(
                        "images/$number.png",
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 20),
          // Display "Check Solution" button
          isCorrectSolution
              ? ElevatedButton(
                  onPressed: () {
                    // Navigate to next screen
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Challenger3Image()));
                  },
                  child: Text("Move to Next Screen"),
                )
              : ElevatedButton(
                  onPressed: checkSolution,
                  child: Text("Check Solution"),
                ),
        ],
      ),
    );
  }
}
