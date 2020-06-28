import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../sizeconfig.dart';
import 'discovery_page.dart';

class TTSBluetoothPage extends StatefulWidget {
  @override
  _TTSBluetoothPageState createState() => _TTSBluetoothPageState();
}

class _TTSBluetoothPageState extends State<TTSBluetoothPage> {

  //Bluetooth
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;
  BluetoothDevice _bluetoothDevice;
  BluetoothConnection connection;
  String _address = "...";
  String _name = "...";
  String name;

  String arduinoData = 'connect a device to receive data';

  bool isConnected = false;

  Timer _discoverableTimeoutTimer;

  //TTS
  String description = "";
  bool isPlaying = false;
  FlutterTts _flutterTts;

  //initState
  @override
  void initState() {
    super.initState();
    initializeTts();
    FlutterBluetoothSerial.instance.state.then((state) {
      setState(() {
        _bluetoothState = state;
      });
    });

    Future.doWhile(() async {
      if (await FlutterBluetoothSerial.instance.isEnabled) {
        return false;
      }
      await Future.delayed(Duration(milliseconds: 0xDD));
      return true;
    }).then((_) {
      FlutterBluetoothSerial.instance.address.then((address) {
        setState(() {
          _address = address;
        });
      });
    });

    FlutterBluetoothSerial.instance.name.then((name) {
      setState(() {
        _name = name;
      });
    });
  }


  //dispose
  @override
  void dispose() {
    super.dispose();
    myController.dispose();
    super.dispose();
    _flutterTts.stop();
    FlutterBluetoothSerial.instance.setPairingRequestHandler(null);
    _discoverableTimeoutTimer?.cancel();
  }

  void getDataFromArduino() async {
    connection.input.listen((Uint8List data) {
      setState(() {
        arduinoData = '${ascii.decode(data)}';
        description = '${ascii.decode(data)}';
      });
    });
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
                  'TTS via Bluetooth',
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
                  SwitchListTile(
                    title: const Text('Bluetooth'),
                    value: _bluetoothState.isEnabled,
                    onChanged: (bool value) {
                      future() async {
                        if (value) {
                          await FlutterBluetoothSerial.instance
                              .requestEnable()
                              .then((value) {
                            setState(() {
                              value = true;
                              _bluetoothState = BluetoothState.STATE_ON;
                            });
                          });
                        } else {
                          await FlutterBluetoothSerial.instance
                              .requestDisable()
                              .then((value) {
                            setState(() {
                              _bluetoothState = BluetoothState.STATE_OFF;
                              value = false;
                            });
                          });
                        }
                      }

                      future().then((value) {
                        setState(() {});
                      });
                    },
                  ),
                  arduinoData == 'connect a device to receive data' ? RaisedButton(
                    color: Theme.of(context).backgroundColor,
                    elevation: 2.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    child: Text(
                      'Select Device',
                      style: TextStyle(color: Theme.of(context).accentColor),
                    ),
                    onPressed: () async {
                      final BluetoothDevice selectedDevice = await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => DiscoveryPage()));
                      setState(() {
                        _bluetoothDevice = selectedDevice;
                        name = selectedDevice.name;
                      });
                      print(selectedDevice.address);
                      print(selectedDevice.name);
                    },
                  ) : Row(
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
                      SizedBox(width: 5.0,),
                      FloatingActionButton(
                        child: Icon(
                          Icons.stop,
                          color: Theme.of(context).accentColor,
                        ),

                        backgroundColor: Colors.white,
                        onPressed: _stop,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  name != null ? RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    elevation: 2.0,
                    color: Theme.of(context).backgroundColor,
                    child: isConnected
                        ? Text(
                      'Connected',
                      style: TextStyle(color: Theme.of(context).accentColor),
                    )
                        : Text(
                      'Connect',
                      style: TextStyle(color: Theme.of(context).accentColor),
                    ),
                    onPressed: _bluetoothDevice == null
                        ? null
                        : () async {
                      await BluetoothConnection.toAddress(
                          _bluetoothDevice.address)
                          .then((value) {
                        connection = value;
                        setState(() {
                          isConnected = true;
                        });
                        connection.isConnected ? getDataFromArduino() : null;
                      });
                    },
                  ) : Text('Connect to a glove to receive commands'),
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
                      child: Text(description),
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
                        description = '';
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