import 'package:flutter/material.dart';
import 'package:login_firebase_test/pages/Quizscreen'; // Corrected import statement

class NewScreen extends StatefulWidget {
  @override
  _NewScreenState createState() => _NewScreenState();
}

class _NewScreenState extends State<NewScreen> {
  bool showTeacherImage = true;

  double calculateCardSize() {
    // Calculate card size based on the visibility of the teacher image
    return showTeacherImage ? 150.0 : 250.0;
  }

  @override
  void initState() {
    super.initState();
    // Hide the teacher image after 10 seconds
    Future.delayed(Duration(seconds: 10), () {
      setState(() {
        showTeacherImage = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Screen'),
        backgroundColor: Color.fromARGB(255, 207, 238, 252), // App bar color
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 207, 238, 252),
              Color.fromARGB(255, 242, 222, 246),
              Colors.white,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => QuizScreen()), // Define your quiz screen widget here
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center, // Center align the Row
              children: [
                // Column for alphabet and number circle widgets
                Column(
                  mainAxisAlignment: MainAxisAlignment.center, // Center align the Column
                  children: [
                    // Alphabet Circle widget
                    AnimatedContainer(
                      duration: Duration(milliseconds: 500), // Animation duration
                      curve: Curves.easeInOut, // Animation curve
                      height: calculateCardSize(), // Adjust height based on visibility of teacher image
                      width: calculateCardSize(), // Adjust width based on visibility of teacher image
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15), // Rounded corners
                        child: Image.asset(
                          'images/alphabet.png', // Adjust the path to your image
                          fit: BoxFit.fill, // Ensure the image covers the entire card, possibly distorting its aspect ratio
                        ),
                      ),
                    ),
                    SizedBox(height: 10), // Spacer between alphabet and number circle widgets
                    // Number Circle widget
                    AnimatedContainer(
                      duration: Duration(milliseconds: 500), // Animation duration
                      curve: Curves.easeInOut, // Animation curve
                      height: calculateCardSize(), // Adjust height based on visibility of teacher image
                      width: calculateCardSize(), // Adjust width based on visibility of teacher image
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15), // Rounded corners
                        child: Image.asset(
                          'images/number.jpeg', // Adjust the path to your image
                          fit: BoxFit.fill, // Ensure the image covers the entire card, possibly distorting its aspect ratio
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 10), // Spacer between the columns
                // Column for teacher2.gif image
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Conditional rendering of Teacher2.gif image
                    if (showTeacherImage)
                      Image.asset(
                        'images/teacher2.gif', // Adjust the path to your image
                        height: 600, // Adjust height as needed
                        width: 170, // Adjust width as needed
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
