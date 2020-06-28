import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../sizeconfig.dart';

class TextToSpeechPage extends StatefulWidget {
  @override
  _TextToSpeechPageState createState() => _TextToSpeechPageState();
}

class _TextToSpeechPageState extends State<TextToSpeechPage> {
  String description = "";
  bool isPlaying = false;
  FlutterTts _flutterTts;
  @override
  void initState() {
    super.initState();
    initializeTts();
  }

  @override
  void dispose() {
    super.dispose();
    myController.dispose();
    super.dispose();
    _flutterTts.stop();
  }

  initializeTts() {
    _flutterTts = FlutterTts();
    setTtsLanguage();

    _flutterTts.setStartHandler(() {
      setState(() {
        isPlaying = true;
      });
    });

    _flutterTts.setCompletionHandler(() {
      setState(() {
        isPlaying = false;
      });
    });

    _flutterTts.setErrorHandler((err) {
      setState(() {
        print("error occurred: " + err);
        isPlaying = false;
      });
    });
  }

  void setTtsLanguage() async {
    await _flutterTts.setLanguage("en-US");
  }

  Future _speak(String text) async {
    if (text != null && text.isNotEmpty) {
      var result = await _flutterTts.speak(text);
      if (result == 1)
        setState(() {
          isPlaying = true;
        });
    }
  }

  Future _stop() async {
    var result = await _flutterTts.stop();
    if (result == 1)
      setState(() {
        isPlaying = false;
      });
  }

  final myController = TextEditingController();
  @override
  Widget build(BuildContext context) {
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
                SizedBox(
                  height: SizeConfig.blockSizeHorizontal * 14,
                ),
                Text(
                  'Text To Speech',
                  style: TextStyle(
                      color: Theme.of(context).backgroundColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 24),
                ),
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
                  SizedBox(
                    height: 50,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      FloatingActionButton(
                        child: Icon(
                          Icons.volume_up,
                          color: Theme.of(context).accentColor,
                        ),
                        backgroundColor: Colors.white,
                        onPressed: () {
                          setState(() {
                            _speak(description);
                          });
                        },
                      ),
                      FloatingActionButton(
                        child: Icon(
                          Icons.stop,
                          color: Theme.of(context).accentColor,
                        ),
                        mini: true,
                        backgroundColor: Colors.white,
                        onPressed: _stop,
                      ),
                    ],
                  ),
                  Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: Container(
                        padding: EdgeInsets.all(15.0),
                        height: SizeConfig.blockSizeHorizontal * 42,
                        width: SizeConfig.blockSizeVertical * 45,
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(25.0)),
                            color: Theme.of(context).backgroundColor,
                            boxShadow: [
                              BoxShadow(color: Colors.grey, blurRadius: 2.5),
                            ]),
                        child: TextField(
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          controller: myController,
                          decoration: InputDecoration(
                              border: InputBorder.none, hintText: 'Enter...'),
                          onChanged: (text) {
                            description = myController.text;
                          },
                        ),
                      )),
                  RaisedButton(
                    child: Text(
                      'Clear',
                      style: TextStyle(color: Theme.of(context).accentColor),
                    ),
                    elevation: 2.4,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                    onPressed: () {
                      setState(() {
                        myController.text = "";
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
}
