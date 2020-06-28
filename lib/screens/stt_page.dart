import 'package:flutter/material.dart';

import '../sizeconfig.dart';

class SpeechToTextPage extends StatefulWidget {
  @override
  _SpeechToTextPageState createState() => _SpeechToTextPageState();
}

class _SpeechToTextPageState extends State<SpeechToTextPage> {

 String resultText;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: Column(
          children: <Widget>[
            Container(
              height: SizeConfig.blockSizeHorizontal * 20,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: Center(child: Text('Speech To Text',style: TextStyle(color: Theme.of(context).backgroundColor),)),
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
                          onPressed: () {}
                        ),
                        FloatingActionButton(
                            child: Icon(Icons.mic,color: Theme.of(context).accentColor,),
                            mini: true,
                            backgroundColor: Colors.white,
                            onPressed: () {}
                        ),
                        FloatingActionButton(
                            child: Icon(Icons.stop,color: Theme.of(context).accentColor,),
                            mini: true,
                            backgroundColor: Colors.white,
                            onPressed: () {}
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: Container(
                        height: SizeConfig.blockSizeHorizontal * 46,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(25.0)),
                            color: Theme.of(context).backgroundColor,
                            boxShadow: [
                              BoxShadow(color: Colors.grey, blurRadius: 2.5),
                            ]),
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
