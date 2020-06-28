import 'package:eme/sizeconfig.dart';
import 'package:eme/widgets/home_widgets.dart';
import 'package:flutter/material.dart';
import 'package:animations/animations.dart';

import 'stt_page.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: Column(
          children: <Widget>[
            Container(
              height: SizeConfig.blockSizeHorizontal * 75,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: Column(
                children: <Widget>[
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 65,left: 30,right: 40),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        textDirection: TextDirection.ltr,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Hello!',style: TextStyle(color: Theme.of(context).backgroundColor,fontSize: 30),),
                          Text('What can I do for you today?',style: TextStyle(color: Theme.of(context).backgroundColor,fontSize: 35),),
                        ],
                      ),
                    ),
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
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: OpenContainer(
                        closedElevation: 2.0,
                        closedShape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(25))),
                        closedColor: Colors.white,
                        closedBuilder: (context, action){
                          return HomeContainer(
                            title: 'Text To Speech',
                            icon: Icons.text_fields,
                          );
                        },
                        openBuilder: (context, action){
                          return SpeechToTextPage();
                        },
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: OpenContainer(
                          closedElevation: 2.0,
                          closedShape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(25))),
                          closedColor: Colors.white,
                          closedBuilder: (context, action){
                            return HomeContainer(
                              title: 'Speech To Text',
                              icon: Icons.record_voice_over,
                            );
                          },
                          openBuilder: (context, action){
                            return SpeechToTextPage();
                          },
                        ),),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: OpenContainer(
                        closedElevation: 2.0,
                        closedShape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(25))),
                        closedColor: Colors.white,
                        closedBuilder: (context, action){
                          return HomeContainer(
                            title: 'TTS via Bluetooth',
                            icon: Icons.translate,
                          );
                        },
                        openBuilder: (context, action){
                          return SpeechToTextPage();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
