import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:login_firebase_test/pages/numberstartscreen.dart';
import 'home.dart';
import 'package:firebase_database/firebase_database.dart';

void saveScoresToFirebase(int score) {
  // Get the current user
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    // Save the score under the user's UID
    DatabaseReference scoresRef = FirebaseDatabase.instance.reference().child('users').child(user.uid).child('score');
    scoresRef.set({
      'score1': score,
    });
  }
}

class AlphabetFinal extends StatefulWidget {
  final int score;
  AlphabetFinal({required this.score});
  @override
  _AlphabetFinalState createState() => _AlphabetFinalState();
}

class _AlphabetFinalState extends State<AlphabetFinal> {
  Timer? _timer;
  bool _showRibbon = true;
  bool _showTeacher = false;
  late int score;

  @override
  void initState() {
    super.initState();
    score = widget.score;
    saveScoresToFirebase(score);
    // Start the timer when the widget is initialized
    _timer = Timer(Duration(seconds: 5), () {
      // After 5 seconds, stop the timer and hide the ribbon
      setState(() {
        _showRibbon = false;
        _showTeacher = true; // Start showing teacher.gif
      });
    });
  }

  @override
  void dispose() {
    // Dispose the timer when the widget is disposed
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Alphabet Final"),
          backgroundColor: Color.fromARGB(255, 207, 238, 252),
        ),
        body: Stack(
          fit: StackFit.expand,
          children: [
            Container(
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
            ),
            // Background image (ribbon.gif)
            AnimatedOpacity(
              duration: Duration(seconds: 1),
              opacity: _showRibbon ? 1 : 0,
              child: Image.asset(
                'images/ribbon2.gif',
                fit: BoxFit.cover,
              ),
            ),
            // Congratulations message and Card
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Congratulations!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'You have completed all the alphabets',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      'Lets Learn Numbers !!',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 20),
                    // Card with image
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NumberStartScreen()),
                        );
                      },
                      child: Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: SizedBox(
                            width: MediaQuery
                                .of(context)
                                .size
                                .width * 0.8,
                            height: MediaQuery
                                .of(context)
                                .size
                                .width * 0.8,
                            child: Image.asset(
                              'images/number.jpeg',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Teacher image below the Card
            Positioned(
              bottom: 0,
              right: 0,
              child: AnimatedOpacity(
                duration: Duration(seconds: 1),
                opacity: _showTeacher ? 1 : 0,
                child: Image.asset(
                  'images/teacher.gif',
                  fit: BoxFit.fill,
                  height: MediaQuery
                      .of(context)
                      .size
                      .width *
                      0.5, // Increase height as needed
                ),
              ),
            ),
            // Button at the left bottom corner
            Positioned(
              bottom: 20,
              left: 20,
              child: MaterialButton(
                onPressed: () {
                  // Action to perform when the button is pressed
                },
                color: Colors.transparent,
                elevation: 0,
                shape: CircleBorder(),
                child: Row(
                  children: [
                    Image.asset(
                      'images/trophy.png',
                      width: 40,
                      height: 40,
                    ),
                    SizedBox(width: 8), // Add some space between icon and text
                    Text(
                      '$score', // Display the score
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 1, 49, 89),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Future<bool> _onBackPressed() async {
    return showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: Text('Are you sure you want to leave?'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  // Navigate to the home page
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HomePage()),
                    // Replace NumberStartScreen with your home page
                        (route) => false,
                  );
                },
                child: Text('Go to Home Page'),
              ),
              TextButton(
                onPressed: () {
                  SystemNavigator.pop(); // Exit the app
                },
                child: Text('Leave'),
              ),
            ],
          ),
    ).then((value) {
      return false;
    });
  }
}

  void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: AlphabetFinal(score: 0),
  ));
}
