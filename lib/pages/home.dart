import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:login_firebase_test/pages/gridDashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => new HomePageState();
}

class HomePageState extends State<HomePage> {
  int userScore = 0;

  @override
  void initState() {
    super.initState();
    fetchScore();
  }

  void fetchScore() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DatabaseReference scoresRef = FirebaseDatabase.instance.reference().child('users').child(user.uid).child('score');
      scoresRef.once().then((event) {
        final dataSnapshot = event.snapshot;
        final val = dataSnapshot.value!;
        if (val != null) {
          setState(() {
            userScore = (val as Map)['score1'];
          });
        }
      }).catchError((error) {
        print("Failed to fetch score: $error");
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final userName = user != null ? user.email!.split('@')[0] : 'Unknown';

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 51, 22, 36),
      body: Column(
        children: <Widget>[
          SizedBox(height: 110),
          Padding(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Welcome Aboard: $userName',
                      style: GoogleFonts.openSans(
                        textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Your Total Points: ${userScore ?? 'Loading...'}",
                      style: GoogleFonts.openSans(
                        textStyle: TextStyle(
                            color: Color(0xffa29aac),
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
                MaterialButton(
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                  },
                  color: Colors.amber,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset("images/sign-out.png", width: 24),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 40),
          //TODO Grid Dashboard
          GridDashboard()
        ],
      ),
    );
  }
}
