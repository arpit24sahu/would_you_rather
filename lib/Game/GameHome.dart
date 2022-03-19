import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:animated_button/animated_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class GameHome extends StatefulWidget {
  @override
  _GameHomeState createState() => _GameHomeState();
}

class _GameHomeState extends State<GameHome> {
  double h=500, w=500;

  String _blueText = "Loading...", _redText = "Loading...";
  int _blueClicks = 1, _redClicks = 1;
  bool _nextAvailable = false, show = false;
  int _total=0;
  String _docID = "";

  double _widthb = 100;
  double _widthr = 100;

  double _updateState(){
    setState(() {
      _widthb = (_blueClicks)/(_blueClicks+_redClicks)*0.8*w-5;
      _widthr = (_redClicks)/(_blueClicks+_redClicks)*0.8*w-5;
    });
  }

  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  int _curr = 0;
  Future<void> _getNew()async{
    Future.delayed((Duration(milliseconds: 100)));
    if(randoms.length==0){
      _getDocsNo();
    }
    setState(() {
      _curr = randoms[0];
      randoms.removeAt(0);
      _total=5;
    });
    setState(() {
      _blueText = "Loading..."; _redText = "Loading...";
    });
    if (_total!=0){
      setState(() {
        show = false;
      });
      await _firestore.collection('questions').where('no', isEqualTo: _curr).get().then((value)async{
        if(value.size==0){
          _getNew();
        }
        else if(value.size==1){
          DocumentSnapshot _docu = value.docs.last;
          _blueText = _docu.get('blue');
          _redText = _docu.get('red');
          _docID = _docu.get('id');
          _blueClicks = _docu.get('blueClicks');
          _redClicks = _docu.get('redClicks');
          setState(() {
          });
        }
      });
    }
    else{
      _getNew();
    }
  }

  Future<void> _buttonPressed(String which, String docID)async{
    show = true;
    _nextAvailable = true;
    setState(() {

    });
    if(which=="blue"){
      _firestore.collection('questions').doc(docID).update({
        'blueClicks': FieldValue.increment(1)
      }).then((value){
        _nextAvailable = true;
      });
    }
    else if(which=="red"){
      _firestore.collection('questions').doc(docID).update({
        'redClicks': FieldValue.increment(1)
      }).then((value) {
        _nextAvailable = true;
      });
    }
  }

  List<int> randoms = List.empty(growable: true);

  void _getDocsNo()async{
    int _count;
    await _firestore.collection('values').doc('stats').get().then((value){
      _count = value.get('docs');
    });
    for(int i=0; i<_count; i++){
      randoms.add(i);
    }
    randoms.shuffle();
    Future.delayed(Duration(milliseconds: 100), (){
      _getNew();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getDocsNo();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    h = MediaQuery.of(context).size.height;
    w = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              height: h,
              width: w,
              color: Colors.black,
            ),
            Positioned(
              top: h/2-w/7+3,
              left: w/2-w/7,
              child: Card(
                elevation: 5,
                shape: StadiumBorder(),
                color: Colors.white,
                child: Container(
                    height: w/3.5,
                    width: w/3.5,
                    color: Colors.transparent,
                    child: Center(
                      child: Text("OR", textScaleFactor: 2, style: TextStyle(color: Colors.white),),
                    )
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(),
                Container(
                    width: 0.9*w,
                    height: h/6,
                    color: Colors.transparent,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(),
                        Container(
                          height: h/12,
                          color: Colors.transparent,
                          child: Hero(
                            tag: 'wouldyou',
                            child: Image.asset('assets/wouldyou.png', fit: BoxFit.contain,),
                          )
                        ),
                        Container(
                          height: h/12,
                          color: Colors.transparent,
                          child: Hero(
                            tag: 'rather',
                            child: Image.asset('assets/rather.png', fit: BoxFit.contain,),
                          )
                        ),
                      ],
                    )
                ),
                Card(
                  child: Container(
                    width: 0.9*w,
                    height: h/3.5,
                    color: Colors.black,
                    child: (!show)?
                      AnimatedButton(
                      width: 0.9*w,
                      height: h/3.5,
                      color: Colors.blue,
                      child: Text(_blueText,
                        style: GoogleFonts.aladin(textStyle: TextStyle(fontWeight: FontWeight.bold)),
                        textScaleFactor: 2,
                        textAlign: TextAlign.center,
                      ),
                      onPressed: (){
                        _buttonPressed("blue", _docID);
                        FirebaseAnalytics().logEvent(name: 'click',
                          parameters: {
                            'doc': _docID,
                            'num': _curr,
                            'chosen': _blueText,
                          }
                        );
                        setState(() {
                          _widthb=10;
                          _widthr=10;
                        });
                        // _width=10;
                        Future.delayed(Duration(milliseconds: 100), (){
                          _updateState();
                        });
                      },
                    ):
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)
                        ),
                        color: Colors.blue,
                        child: Container(
                          width: 0.9*w,
                          height: h/3.5,
                          color: Colors.transparent,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Center(),
                              Text(_blueText,
                                style: GoogleFonts.aladin(textStyle: TextStyle(fontWeight: FontWeight.bold)),
                                textScaleFactor: 1.6,
                                textAlign: TextAlign.center,
                              ),
                              Text("${((_blueClicks)*100/(_blueClicks+_redClicks)).toStringAsFixed(2)}%", textScaleFactor: 2,),
                              Slider(w,_widthb,true),
                              Text(" "),
                            ],
                          ),
                        ),
                      )
                  ),
                ),
                Card(
                  child: Container(
                    width: 0.9*w,
                    height: h/3.5,
                    color: Colors.black,
                    child: (!show)?
                      AnimatedButton(
                      shadowDegree: ShadowDegree.light,
                      width: 0.9*w,
                      height: h/3.5,
                      color: Colors.red,
                      child: Text(_redText,
                        style: GoogleFonts.aladin(textStyle: TextStyle(fontWeight: FontWeight.bold)),
                        textScaleFactor: 2,
                        textAlign: TextAlign.center,
                      ),
                      onPressed: (){
                        _buttonPressed("red", _docID);
                        FirebaseAnalytics().logEvent(name: 'click',
                            parameters: {
                              'doc': _docID,
                              'num': _curr,
                              'chosen': _redText,
                            }
                        );
                        setState(() {
                          _widthb=10;
                          _widthr=10;
                        });
                        // _width=10;
                        Future.delayed(Duration(milliseconds: 100), (){
                          _updateState();
                        });
                      },
                    ):
                      Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)
                      ),
                      color: Colors.red,
                      child: Container(
                        width: 0.9*w,
                        height: h/3.5,
                        color: Colors.transparent,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Center(),
                            Text(_redText,
                              style: GoogleFonts.aladin(textStyle: TextStyle(fontWeight: FontWeight.bold)),
                              textScaleFactor: 1.6,
                              textAlign: TextAlign.center,
                            ),
                            Text("${((_redClicks)*100/(_blueClicks+_redClicks)).toStringAsFixed(2)}%", textScaleFactor: 2,),
                            Slider(w,_widthr,false),
                            Text(" "),
                          ],
                        ),
                      ),
                    )
                  ),
                ),
                Card(
                  child: Container(
                    width: 0.4*w,
                    height: h/10,
                    color: Colors.black,
                    child: AnimatedButton(
                      shadowDegree: ShadowDegree.dark,
                      enabled: _nextAvailable,
                      width: 0.4*w,
                      height: h/10,
                      color: Colors.yellow,
                      child: Text("Next", style: TextStyle(fontWeight: FontWeight.bold),),
                      onPressed: (){
                        _nextAvailable = false;
                        setState(() {

                        });
                        _getNew();
                      },
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              top: h/2-w/9+3,
              left: w/2-w/9,
              child: Card(
                elevation: 5,
                shape: StadiumBorder(),
                color: Colors.black,
                child: Container(
                  height: w/4.5,
                  width: w/4.5,
                  color: Colors.transparent,
                  child: Center(
                    child: Text("OR", textScaleFactor: 2, style: TextStyle(color: Colors.white),),
                  )
                ),
              ),
            )
          ],
        ),
      )
    );

  }
}

Widget Slider(double w, double _width, bool left){
  return Container(
      height: 25,
      width: 0.8*w,
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.only(left: 2.5, right: 2.5),
        child: Align(
          alignment: (left==true)?Alignment.centerLeft:Alignment.centerRight,
          child: AnimatedContainer(
            duration: Duration(milliseconds: 1500),
            curve: Curves.decelerate,
            height: 20,
            width: _width,
            color: Colors.green,
          ),
        ),
      )
  );
}

void Dummy()async{

  List<String> k = [
    "Would you rather Be a cow or Be a chicken?",
    "Would you rather have no taste buds or be color blind?",
    "Would you rather Eat everything you see or lick everything you see?",
    "Would you rather Have a foot long nose or Have a foot-long tongue?",
    "Would you rather Have a baby at 10 or Have a baby at 60?",
    "Would you rather Be in jail for ten years or be in a coma for 20 years?",
    "Would you rather Have no brother or Have no sister?",
    "Would you rather Be invisible or be fast?",
    "Would you rather Look like a fish or smell like a fish?",
    "Would you rather Play on Minecraft or play FIFA?",
    "Would you rather Fight 100 duck-sized horses or Fight 1 horse-sized duck?",
    "Would you rather Have a grapefruit-sized head or Have a head the size of a watermelon?",
    "Would you rather Be a tree for the rest of your life or have to live in a tree for the rest of your life?",
    "Would you rather Live in space or Live under the sea?",
    "Would you rather lose your sense of touch or lose your sense of smell?",
    "Would you rather be Donald Trump or be George Bush?",
    "Would you rather Have no hair or be completely hairy?",
    "Would you rather wake up in the morning looking like a giraffe or wake up in the morning looking like a kangaroo?",
    "Would you rather have a booger hanging from your nose for the rest of your life or Have earwax planted on your earlobes?",
    "Would you rather Have a sumo wrestler on top of you or Have yourself on top of him?",


    // "Would you rather Stop using YouTube or stop using Instagram?",
    // "Would you rather check your email first every morning or check your social media first every morning?",
    // "Would you rather lose your keys or forget your cell phone?",
    // "Would you rather Only have access to YouTube on the Internet or only have access to games on the Internet?",
    // "Would you rather eat the same food for the rest of your life or never use Instagram again?",
    // "Would you rather watch TV all the time or not watch TV at all?",
    // "Would you rather Have slow but unlimited internet or Paid but Limited Internet?",
    // "Would you rather Give up shopping for three or give up emoji for three months?",
    // "Would you rather lose all your contacts or lose \$1000?",
    // "Would you rather eat an entire stick of butter or send an embarrassing email to your entire company?",
    // "Would you rather Be stung by a jellyfish or give up Facebook for a week?",
    // "Would you rather Never have internet access or be a professional clown?",
    // "Would you rather Create a super successful app or go on tour with Beyoncé?",
    // "Would you rather not use email for a week or feel hungover for a week?",
    // "Would you rather have an iPod fitted in your mind and listen to any music of your choice, anytime or watch your dreams alive on television?",
    // "Would you rather give up search engines or social media applications?",
    // "Would you rather play Minecraft or Super Mario?",
    // "Would you rather have a lifelong free subscription to Apple Music or Spotify?",
    // "Would you rather have free internet for life or free food?",
    // "Would you rather live without a cell phone or news?",
    // "Would you rather have your brain transplanted into a robot or an animal of your choice?",
    // "Would you rather have infinite battery life for your cell phone or infinite fuel for your car?",
  ];
  List<String> r = [ " " ];
  List<String> b = [" "];
  for(int i=0; i<k.length; i++){
    if(k[i].length<=0) continue;
    String s = k[i];
    s = s.substring(17);
    int kk = s.indexOf(" or ");
    String one = s.substring(0,kk);
    String two = s.substring(kk+4);
    one = '${one[0].toUpperCase()}${one.substring(1)}';
    two = '${two[0].toUpperCase()}${two.substring(1)}';
    two = two.replaceAll('?','');
    r.add(two); b.add(one);
  }
  b.removeAt(0); r.removeAt(0);

  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  int current = 100;

  for(int i=0; i<b.length; i++) {
    await _firestore.collection('values').doc('stats').get().then((value) {
      current = value.get('docs');
    });

    await _firestore.collection('questions').add({
      'red': r[i],
      'blue': b[i],
      'redClicks': 1,
      'blueClicks': 1,
      'timestamp': DateTime
          .now()
          .millisecondsSinceEpoch,
      'no': current,
    }).then((value) {
      _firestore.collection('questions').doc(value.id).update({
        'id': value.id,
      });
      _firestore.collection('values').doc('stats').update({
        'docs': FieldValue.increment(1),
      }).then((value) async {

        await _firestore.collection('values').doc('stats').get().then((value) {
          current = value.get('docs');
        });
      });
    });
  }
}