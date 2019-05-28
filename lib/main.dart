import 'package:a/Controllers/main_controller.dart';
import 'package:a/Controllers/ui_controller.dart';
import 'package:a/screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:a/Components/oscilliscope.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //double width = ;
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
      
        primarySwatch: Colors.blue,
      ),
      home: Home(),
    );
  }
}
class Home extends StatefulWidget {
  
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static const stream = const EventChannel('com.example.a/stream');
  UIController uiController;
  MainController controller;

  //UI_Screen _local_screen;

 @override
  void initState() {
    super.initState();
    
    uiController = UIController();
    controller = MainController(stream: stream, refreshTime: 50);
    uiController.addListener((){
    if (uiController.uiEvent == UI_EVENT.NEWSCREEN){
        setState(() {});
      }
    });
    
  }
  
  Widget _getCurrentScreen(){
    
    switch (uiController.currentScreen){
      case UI_Screen.HOMESCREEN:
  
        //return HomeScreen();
        return Osc(controller: controller,);
        break;
      case UI_Screen.GAMESCREEN:
       
        return GameScreen();
        break;
      case UI_Screen.HISTORYSCREEN:
        return HistoryScreen();
    
        break;
      case UI_Screen.SETTINGSSCREEN:
        return SettingsScreen();
       
        break;
    }
    return Container();

  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(title: Text("Music"),),
      body: _getCurrentScreen(),
    );
  }
}