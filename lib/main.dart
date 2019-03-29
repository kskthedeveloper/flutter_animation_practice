import 'package:flutter/material.dart';
import 'package:flutter_custom_slider/wave_slider.dart';

void main() => runApp(MaterialApp(
      home: WaveApp(),
    ));

class WaveApp extends StatefulWidget {
  @override
  _WaveAppState createState() => _WaveAppState();
}

class _WaveAppState extends State<WaveApp> {
  int _age = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wave Slider'),
      ),
      body: Container(
        padding: EdgeInsets.all(32.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Select your age',
                style: TextStyle(
                  fontSize: 45,
                ),
              ),
              WaveSlider(
                onChanged: (double val) {
                  setState(() {
                    _age = (val * 100).round();
                  });
                },
                onChangedStart: (double val) {
                  setState(() {
                    _age = (val * 100).round();
                  });
                },
              ),
              SizedBox(
                height: 50.0,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                mainAxisAlignment: MainAxisAlignment.end,
                textBaseline: TextBaseline.alphabetic,
                children: <Widget>[
                  SizedBox(
                    width: 15.0,
                  ),
                  Text(
                    _age.toString(),
                    style: TextStyle(fontSize: 45),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Text(
                    'YEARS',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: Container(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
