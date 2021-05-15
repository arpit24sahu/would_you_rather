import 'package:flutter/material.dart';

class Anim extends StatefulWidget {
  @override
  _AnimState createState() => _AnimState();
}

class _AnimState extends State<Anim> {

  double _height = 100, _width = 300;
  double _update(){
    setState(() {
      (_height==300)?_height = 100:_height=300;
      (_width==300)?_width = 100:_width=300;

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(),
          AnimatedContainer(
            duration: Duration(seconds: 1),
            curve: Curves.bounceOut,
            height: _height,
            width: _width,
            color: Colors.pink,
          ),
          Text(" "),
          MaterialButton(
            child: Text("ANimate"),
            onPressed: (){
              _update();
            },
          )
        ],
      ),
    );
  }
}
