// Any list of music related stuff that might be accessed by multiple widgets

import 'dart:math';

import 'package:flutter/material.dart';

List<String> notenames = [
  "C",
  "C#",
  "D",
  "D#",
  "E",
  "F",
  "F#",
  "G",
  "G#",
  "A",
  "A#",
  "B",
  "C"
];
List<int> sharps = [1, 3, 6, 8, 10];
List<int> majorscale = [0, 2, 4, 5, 7, 9, 11, 12, 14, 16, 17, 19, 21, 23, 24];
List<List<int>> scales = [
  [0, 2, 4, 5, 7, 9, 11, 12, 14, 16, 17, 19, 21, 23, 24], // major Scale
  [0, 2, 3, 5, 7, 8, 10, 12, 14, 15, 17, 19, 20, 22, 24], // minor Scale
  [0, 2, 3, 5, 7, 8, 11, 12, 14, 15, 17, 19, 20, 23, 24], // harmonic
  [0, 2, 3, 5, 7, 9, 11, 12, 14, 15, 17, 19, 21, 23, 24], // melodic
  [0, 2, 3, 5, 6, 7, 11, 12, 14, 15, 17, 18, 19, 23, 24], // Blues scale
];

List generalKeyFreq = [2.6, 0.7, 0.8, 1.0, 0.7, 0.9, 0.3, 1.2, 0.4, 0.8, 0.5, 0.3];
List scaleMult = [3.0, 1.5, 1.25, 3.0, 3.0, 2.0, 1.1];


double freqToMidi(double freq){
    return((12/log(2)) * log(freq/27.5) + 21);
  }
Color getColor(double tnote) {
  return Color.lerp(Colors.red, Colors.blue, tnote / 12);
}
Color getAccuracyColor(double difference) {
  difference = difference.abs();
  if (difference>2.0){difference=2.0;}
  return Color.lerp(Colors.green, Colors.red,  difference / 2.0);
}

List<int> buildscalenoteslist(int _root, int _currentscale) {
  List<int> scale = [];
  for (int i = 0; i < 7; i++) {
    scale.add((_root + scales[_currentscale][i]) % 12);
  }
  return scale;
}
