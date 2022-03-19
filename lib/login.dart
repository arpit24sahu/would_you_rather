import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Game/GameHome.dart';
import 'package:firebase_core/firebase_core.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  double h=500,w=500;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    h=MediaQuery.of(context).size.height;
    w=MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: Colors.black,
          ),
          Container(
            height: h,
            width: w,
            child: Image.asset('assets/wall.jpg', fit: BoxFit.cover,),
          ),
          Container(
            color: Colors.black.withOpacity(0.7),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(),
              Container(
                width: w*0.9,
                color: Colors.transparent,
                child: Hero(
                  tag: "wouldyou",
                  child: Image.asset('assets/wouldyou.png', fit: BoxFit.contain,),
                )
              ),
              Container(
                width: w*0.8,
                color: Colors.transparent,
                child: Hero(
                  tag: 'rather',
                  child: Image.asset('assets/rather.png', fit: BoxFit.contain,),
                )
              ),
              Text(" "),
              Text(" "),
              Text(" "),
              Text(" "),
              Text(" "),
              Text(" "),
              Text(" "),
              Material(
                shape: StadiumBorder(),
                child: MaterialButton(
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Text("S T A R T", style: GoogleFonts.aladin(textStyle: TextStyle(fontWeight: FontWeight.bold,)), textScaleFactor: 1.6,),
                  ),
                  onPressed: (){
                    Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => GameHome()
                        )
                    );
                  },
                ),
              ),
              Text(" "),
            ],
          )
        ],
      ),
    );
  }
}
