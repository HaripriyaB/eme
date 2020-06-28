import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import '../sizeconfig.dart';

class SpeechToTextPage extends StatefulWidget {
  @override
  _SpeechToTextPageState createState() => _SpeechToTextPageState();
}

class _SpeechToTextPageState extends State<SpeechToTextPage> {

  bool _hasSpeech = false;
  double level = 0.0;
  double minSoundLevel = 50000;
  double maxSoundLevel = -50000;
  String recognizedWords = "";
  String lastError = "";
  String lastStatus = "";
  String _currentLocaleId = "";
  List<LocaleName> _localeNames = [];
  final SpeechToText speech = SpeechToText();


  @override
  void initState() {
    super.initState();
    initSpeechState();
  }


  Future<void> initSpeechState() async {
    bool hasSpeech = await speech.initialize(
        onError: errorListener, onStatus: statusListener);
    if (hasSpeech) {
      _localeNames = await speech.locales();

      var systemLocale = await speech.systemLocale();
      _currentLocaleId = systemLocale.localeId;
    }

    if (!mounted) return;

    setState(() {
      _hasSpeech = hasSpeech;
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Column(
        children: <Widget>[
          Container(
            height: SizeConfig.blockSizeHorizontal * 25,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: Column(
              children: <Widget>[
                SizedBox(height: SizeConfig.blockSizeHorizontal * 14,),
                Text('Speech To Text',style: TextStyle(color: Theme.of(context).backgroundColor,fontWeight: FontWeight.bold,fontSize: 24),),
              ],
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).backgroundColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(45),
                      topRight: Radius.circular(45))),
              child: Column(
                children: <Widget>[
                  SizedBox(height: 50,),
                  Row(mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      FloatingActionButton(
                        child: Icon(Icons.cancel,color: Theme.of(context).accentColor,),
                        mini: true,
                        backgroundColor: Colors.white,
                        onPressed: speech.isListening ? cancelListening : null,
                      ),
                      FloatingActionButton(
                          child: Icon(Icons.mic,color: Theme.of(context).accentColor,),

                          backgroundColor: Colors.white,
                          onPressed:
                            !_hasSpeech || speech.isListening
                                ? null
                                : startListening,

                      ),
                      FloatingActionButton(
                          child: Icon(Icons.stop,color: Theme.of(context).accentColor,),
                          mini: true,
                          backgroundColor: Colors.white,
                          onPressed: speech.isListening ? stopListening : null,
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Container(padding: EdgeInsets.all(15.0),
                      height: SizeConfig.blockSizeHorizontal * 42,
                      width: SizeConfig.blockSizeVertical*45,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(25.0)),
                          color: Theme.of(context).backgroundColor,
                          boxShadow: [
                            BoxShadow(color: Colors.grey, blurRadius: 2.5),
                          ]),
                      child: Text(recognizedWords),
                    )
                  ),
                  RaisedButton(
                    child: Text('Clear',style: TextStyle(color: Theme.of(context).accentColor),),
                    elevation: 2.4,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                    onPressed: (){
                      setState(() {
                        recognizedWords = "";
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


  void startListening() {
    recognizedWords = "";
    lastError = "";
    speech.listen(
        onResult: resultListener,
        listenFor: Duration(seconds: 60),
        localeId: _currentLocaleId,
        onSoundLevelChange: soundLevelListener,
        cancelOnError: true,
        partialResults: true);
    setState(() {});
  }

  void stopListening() {
    speech.stop();
    setState(() {
      level = 0.0;
    });
  }

  void cancelListening() {
    speech.cancel();
    setState(() {
      level = 0.0;
    });
  }

  void resultListener(SpeechRecognitionResult result) {
    setState(() {
      recognizedWords = "${result.recognizedWords}";
    });
  }

  void soundLevelListener(double level) {
    minSoundLevel = min(minSoundLevel, level);
    maxSoundLevel = max(maxSoundLevel, level);
    //print("sound level $level: $minSoundLevel - $maxSoundLevel ");
    setState(() {
      this.level = level;
    });
  }

  void errorListener(SpeechRecognitionError error) {
    print("Received error status: $error, listening: ${speech.isListening}");
    setState(() {
      lastError = "${error.errorMsg} - ${error.permanent}";
    });
  }

  void statusListener(String status) {
    print(
        "Received listener status: $status, listening: ${speech.isListening}");
    setState(() {
      lastStatus = "$status";
    });
  }

}


