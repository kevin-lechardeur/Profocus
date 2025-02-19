import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/delayed_animation.dart';
import 'login_page_exist.dart';
import 'create_choice.dart';


class GetStartedPage extends StatefulWidget {
  @override
  _GetStartedPageState createState() => _GetStartedPageState();
}

class _GetStartedPageState extends State<GetStartedPage> {
  final TextEditingController emailController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    TextStyle TitleStyle = TextStyle(color: Colors.black, fontSize: 30.0);
    TextStyle defaultStyle = TextStyle(color: Colors.grey, fontSize: 15.0);
    TextStyle linkStyle = TextStyle(color: Colors.blue);
    return Scaffold(
      appBar: null,
      body: Center(  // Utilisation de Center pour centrer tout le corps
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,  // Centre verticalement
            crossAxisAlignment: CrossAxisAlignment.center, // Centre horizontalement
            children: [
              DelayedAnimation(
                delay: 1000,
                child: Container(
                  height: 100,
                  width: 100, // Définit une largeur fixe pour centrer l'image
                  child: Image.asset("assets/image/logoApple.png"),
                ),

              ),
              DelayedAnimation(
                delay: 1500,
                child: Container(
                  height: 300,
                  width: 300, // Définit une largeur fixe pour centrer l'image
                  child: Image.asset("assets/image/student.png"),
                ),

              ),
              SizedBox(height: 20),
              DelayedAnimation(
                delay: 2500,
                child: Text(
                  "Stay Focused",
                  style: TitleStyle,
                ),
              ),
              DelayedAnimation(
                delay: 2500,
                child: Text(
                  "Stay Productive",
                  style: TitleStyle,
                ),
              ),
              DelayedAnimation(
                delay: 3000,
                child: Text(
                  "Get a clear to do of your task",
                  style: defaultStyle,
                ),

              ),
              SizedBox(height: 50),
              DelayedAnimation(
                delay: 3000,
                child: Container(
                  margin: EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 50,
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CreateChoice()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      shape: StadiumBorder(),
                      padding: EdgeInsets.all(20),
                      backgroundColor: Colors.pinkAccent,
                      minimumSize: Size(double.infinity, 50),
                    ),
                    child: Text("Get Started",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 10),
              DelayedAnimation(
                delay: 4000,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPageExist()),
                    );
                  },
                  child: RichText(
                    text: TextSpan(
                      text: "Already have an account? ",
                      style: linkStyle,
                    ),
                  ),
                ),

              ),
            ],
          ),
        ),
      ),
    );
  }
}
