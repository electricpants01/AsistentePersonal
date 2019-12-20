import 'dart:async';
import 'package:flutter/material.dart';
import 'package:speech_recognition/speech_recognition.dart';


void main() => runApp(MyApp());


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner:  false,
      home: Home(),
    );
  }
}


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  SpeechRecognition _speechRecognition;
  bool _estaDisponible = false;
  bool _estaEscuchando = false;
  String contenido = "";

  @override
  void initState(){
    super.initState();
    initSpeechRecognizer();
  }

  void initSpeechRecognizer(){
    _speechRecognition = new SpeechRecognition();
    _speechRecognition.setAvailabilityHandler(
      ( bool result ) => setState(() => _estaDisponible = result) 
    );
    _speechRecognition.setRecognitionStartedHandler(
      () => setState(()=> _estaEscuchando = true )
    );
    _speechRecognition.setRecognitionResultHandler(
      (String cad ) =>  setState(() => contenido = cad )
    );
    _speechRecognition.setRecognitionCompleteHandler((){
      setState(()=> _estaEscuchando = false ); 
    });
    _speechRecognition.activate().then(
      (result) => setState(() => _estaDisponible = result )
    );

  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Asistente Personal"),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            child: Row(
              children: <Widget>[
                RaisedButton(
                  child: Text("Escuchar"),
                  onPressed: (){
                    print("boton de escuchar presionado");
                    if( _estaDisponible && !_estaEscuchando){
                      print("entro!!");
                      _speechRecognition
                      .listen(locale: 'es_Es')
                      .then((result) => print(result) );
                    }
                  },
                ),
                RaisedButton(
                  child: Text("Parar"),
                  onPressed: (){
                    print("se apreto el boton parar");
                    if( _estaEscuchando ){
                      _speechRecognition.stop().then((result){
                        setState(() {
                          _estaEscuchando = result;
                          contenido = "";
                        });
                      });
                    }
                  },
                ),
              ],
            ),
          ),
          Container(
            child: Text(contenido),
          )
        ],
      )
    );
  }
}