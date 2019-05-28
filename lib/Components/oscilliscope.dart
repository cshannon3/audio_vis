


import 'package:flutter/material.dart';
import 'package:a/Shared/scales.dart';
import 'package:a/Controllers/main_controller.dart';

class Osc extends StatefulWidget {
  final MainController controller;
  const Osc({Key key, this.controller}) : super(key: key);

  @override
  _OscState createState() => _OscState();
}

class _OscState extends State<Osc> {

  @override
  void initState() {
    // TODO: implement initState
    widget.controller.startCollecting();
    widget.controller.addListener((){
      if (widget.controller.currentEvent == ControllerEvent.NEWREADING){
        widget.controller.clearEvent();
        setState(() {
          
        });
      }
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    
    return Column(
      children: <Widget>[
        Container(
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text("Note"),
                  Text("Diff"),
                  Text("Key"),
                  RaisedButton(
                    onPressed: ()=> widget.controller.clearFreqs(),
                    child: Text('Clear'),
                    
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(widget.controller.getCurrentNote()),
                  Text(widget.controller.getDifference()),
                  Text(widget.controller.getKey()),
                  Text("Conf")
                ],
              ),


          ],),
        ),

        Expanded(
          child: Container(
            color: getAccuracyColor(widget.controller.difference),
            padding: EdgeInsets.only(right: 5.0),
            width: double.infinity,
            height: double.infinity,
            //color: Colors.black,
            child: ClipRect(
              child: CustomPaint(
                painter: _TracePainter(
                  dataSet: widget.controller.trace,
                  maxval: widget.controller.maxval,
                  minval: widget.controller.minval,
                  traceColor: widget.controller.traceColor,
                  root: widget.controller.rootnote
                  ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _TracePainter extends CustomPainter {
  final List dataSet;
  final double minval;
  final double maxval;
  final Color traceColor;
  final int root;

  //final double yRange;

  _TracePainter(
      {
      this.minval,
      this.dataSet,
      this.maxval,
      this.root,
      //this.yAxisColor= Colors.green,
      this.traceColor = Colors.white});


  @override
  void paint(Canvas canvas, Size size) {
    final tracePaint = Paint()
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = 2.0
      ..color = traceColor
      ..style = PaintingStyle.stroke;
    
    
    double step = (size.height)/(maxval-minval);
    double freqToHeight(double freq){
      return ((freq-minval)*step);
    }

    // only start plot if dataset has data
     int length = dataSet.length;

      // Create Path and set Origin to first data point
      Path trace = Path();
    
      trace.moveTo(0.0, freqToHeight(dataSet[0].toDouble()));

      // generate trace path
      for (int p = 0; p < length; p++) {
        double plotPoint = freqToHeight(dataSet[p].toDouble());
        //dataSet[p].toDouble();

        trace.lineTo(p.toDouble(), plotPoint);
      }

      // display the trace
      canvas.drawPath(trace, tracePaint);


  double midiroot = root.toDouble()+48.0;
  majorscale.forEach( (f) =>  
    canvas.drawLine(
      Offset(0.0, freqToHeight((midiroot+f))), 
      Offset(size.width, freqToHeight((midiroot+f))), 
      Paint()..color=getColor((f%12).toDouble())
            ..strokeWidth = 1.5
      )
      
  );
  
    }

  @override
  bool shouldRepaint(_TracePainter old) => true;
}
