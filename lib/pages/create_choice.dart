import 'package:flutter/material.dart';
import '../widgets/delayed_animation.dart';
import 'create_account_page.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class CreateChoice extends StatefulWidget {
  @override
  _CreatePageState createState() => _CreatePageState();
}

class _CreatePageState extends State<CreateChoice> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( // Ajouter l'AppBar avec la flèche de retour
        backgroundColor: Color(0xFFEDECF2),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Color(0xFFEDECF2),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            DelayedAnimation(
              delay: 500,
              child: Container(
                height: 300,
                child: Image.asset("assets/image/groupe.png"),
              ),
            ),
            SizedBox(height: 20),
            DelayedAnimation(
              delay: 500,
              child: Text(
                "Create an account",
                style: GoogleFonts.poppins(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.pinkAccent,
                ),
              ),
            ),
            SizedBox(height: 20),

            DelayedAnimation(
              delay: 1500,
              child: Container(
                margin: EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 40,
                ),
                child: Column(
                  children: [
                    ElevatedButton(
                        onPressed: (){},
                        style: ElevatedButton.styleFrom(
                          shape: StadiumBorder(),
                          backgroundColor: Color(0xFF3B5998),
                          padding: EdgeInsets.all(20),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FaIcon(FontAwesomeIcons.facebook,
                              color: Colors.white,
                            ),
                            SizedBox(width: 5),
                            Text("FACEBOOK",
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        )
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                        onPressed: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => CreateAccountPage()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          shape: StadiumBorder(),
                          backgroundColor: Colors.pinkAccent,
                          padding: EdgeInsets.all(20),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.mail_outline_outlined,
                              color: Colors.white,
                            ),
                            SizedBox(width: 5),
                            Text("EMAIL",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                        onPressed: (){},
                        style: ElevatedButton.styleFrom(
                          shape: StadiumBorder(),
                          backgroundColor: Colors.white ,
                          padding: EdgeInsets.all(20),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset("assets/image/googleLogo.png",
                              height: 20,
                            ),
                            SizedBox(width: 5),
                            Text("GOOGLE",
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        )
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
}
