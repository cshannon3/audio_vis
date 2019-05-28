import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:a/Shared/scales.dart';

enum ControllerEvent{
  NEWREADING,
  NONE
}

class MainController extends ChangeNotifier{
  final EventChannel stream;
  final int refreshTime;
 
  ControllerEvent _currentEvent =ControllerEvent.NONE;

 // EventChannel eventChannel;
  List noteFreqs = new List<int>.filled(12, 0, growable: false);
  List keySums = new List<double>.filled(12, 0.0, growable: false);
  int rootnote = 0;
  List<int> _currentScale = buildscalenoteslist(0, 0);
  int _maxTraceLength = 300;
  List _trace = [];
  double maxval = 55.0;
  double minval = 75.0;
  double closestnote  = 0.0;
  double difference = 0;
  
  int readings = 0;
  int key = 0;
  bool inKey = false;
  Color _traceColor = Colors.white;

  Timer timer;
  Stopwatch stopwatch = Stopwatch();

  MainController({this.stream, this.refreshTime});
  
  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }

  ControllerEvent get currentEvent=>_currentEvent;
  List get trace => _trace;
  Color get traceColor => _traceColor;
  int get maxTraceLength => _maxTraceLength;


  void clearEvent(){
    _currentEvent = ControllerEvent.NONE;
  }

  void clearFreqs(){
    noteFreqs = new List<int>.filled(12, 0, growable: false);
  }

  void startCollecting(){
    timer = new Timer.periodic(Duration(milliseconds: refreshTime), callback);
  }
  
  void callback(Timer timer) {
    stream.receiveBroadcastStream().listen(_getPitch);
  }

  
  void relativeToKey(double midiVal){
      closestnote = midiVal%12;
      difference = 0;
      int i = 1;
    while (i<7 && (closestnote> _currentScale[i])  ){
        i+=1;
    }
    if ((closestnote- _currentScale[i-1]).abs() > (closestnote-_currentScale[i]).abs()){
          difference = closestnote - _currentScale[i];
          closestnote= _currentScale[i].toDouble();
      
    }else{
        difference = closestnote - _currentScale[i-1];
        closestnote= _currentScale[i-1].toDouble();  
    }
    noteFreqs[(closestnote%12).floor()]=noteFreqs[(closestnote%12).floor()]+1;
    readings+=1;
    //print(noteFreqs);
    if (midiVal<minval){minval=midiVal;}
    else if (midiVal>maxval){maxval=midiVal;}
    
    _trace.add(midiVal);
  }


  void allNotes(double midiVal){
    closestnote =(midiVal%12).roundToDouble();

    difference =closestnote -(midiVal%12);    
    noteFreqs[closestnote.floor()%12]=noteFreqs[closestnote.floor()%12]+1;
    readings+=1;
   // print(noteFreqs);
    if (midiVal<minval){minval=midiVal;}
    else if (midiVal>maxval){maxval=midiVal;}
    
    _trace.add(midiVal);
  }

  void _getPitch(pitch) {
    if (pitch != -1) {
      double midiVal = freqToMidi(pitch);
      
     // print(midiVal);
      if (midiVal>40.0 && midiVal<75.0){
        if (inKey){relativeToKey(midiVal);}

        else{allNotes(midiVal);}
      }
    }
    else if (_trace.length>1){double o = _trace.last;_trace.add(o);}
    
    if (_trace.length >= _maxTraceLength){ _trace.removeAt(0);}

    if (readings==50){
      readings=0;
      getNoteProbability();
      //noteFreqs = new List<int>.filled(12, 0, growable: false);
    }

    _currentEvent = ControllerEvent.NEWREADING;
  
    notifyListeners();
  }

  
  void getNoteProbability() {
    double max = 0.0;

    List mostCommon = [0, 2, 4];
    for (int i = 0; i<keySums.length; i++){
      double keySum =  0.0;
      List<int> scale =buildscalenoteslist(i, 0);
      int rootTriadMin = noteFreqs[scale[0]]; // lowest val in major triad

      for (int j = 0; j < 12; j++) {
        int n = noteFreqs[j];
        if (scale.contains(j)){
          keySum += n *scaleMult[scale.indexOf(j)];
          if (mostCommon.contains(scale.indexOf(j)) && n<rootTriadMin){rootTriadMin=n;}
        }else{
          keySum -= 5*n;
        }
        
        
        //scaleMult[j] * n;
      }
      print(rootTriadMin);
      print(notenames[i]);
      //keySum+=3*rootTriadMin;
      if (keySum>max){max=keySum;key=i;}
      keySums[i] = keySum;// * generalKeyFreq[i];
    }

    /*for (int i = 0; i<keySums.length; i++){
      List<int> scale =buildscalenoteslist(i, 0);
      
     // keySums[i]+= keySums[scale[2]]+keySums[scale[4]];
      if (keySums[i]>max){max=keySums[i];key=i;}
    }*/



  print(getKey());
  print(noteFreqs);
  print(notenames);
  print(keySums);

}

String getCurrentNote(){
    return notenames[closestnote.round()];
  }
String getDifference(){
    return difference.toStringAsFixed(3);
  }
String getKey(){
  return notenames[key];
}


}

/*
http://www.hooktheory.com/blog/i-analyzed-the-chords-of-1300-popular-songs-for-patterns-this-is-what-i-found/

biased towards common keys ( % of songs that use each key)
C/am 26
G/em  12
Eb /cm 10 
F/dm 9
D/bm  8
A/f#m  8
E /c#m 7
Db/bbm  7
Bb/gm  5
Ab/fm  4
B /g#m 3
F#/d#m  3



Chord Use
I 68%
ii 26%
iii 17%
IV 73%
V 73%
vi 56%
other 0% *just for multiplier

next Step would be to add progression probablilty

*/