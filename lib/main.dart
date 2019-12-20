import 'dart:async';
import 'package:flutter/material.dart';
import 'package:speech_recognition/speech_recognition.dart';
import 'package:flutter_dialogflow/dialogflow_v2.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'player_widget.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Asistente",
      theme: ThemeData(primarySwatch: Colors.green),
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
  FlutterTts hablar = new FlutterTts();
  bool _estaDisponible = false;
  bool _estaEscuchando = false;
  String contenido = "";
  String respuesta = "";
  Widget cuerpo;

  @override
  void initState(){
    super.initState();
    reproducirMusica();
    initSpeechRecognizer();
  }

  void initSpeechRecognizer(){
    print("iniciando speech recognizer");
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
      appBar: AppBar( title: Text("Asistente Personal"), ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.mic),
        onPressed: iniciarSpeech,
      ),
      body: ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10),
            child: Text(
              contenido,
              style: TextStyle(
                color: Colors.lime,
                fontStyle: FontStyle.italic,
                fontSize: 30
              ),
            ),
          ),
          cuerpo,
        ],
      ),
    );
  }


  iniciarSpeech(){            // -------------- Aqui iniciamos el Speech al presionar el icono de Voz
    print("boton de escuchar presionado");
    if( _estaDisponible && !_estaEscuchando){
       print("entro!!");
       _speechRecognition
      .listen(locale: "es_ES")
      .then((result) => print(result) );
      }
    Timer(Duration(seconds: 5),(){    // ------------ Ponemos un temporizador predeterminado
      _enviarMensaje();
    });
  }

  void _enviarMensaje() async {       // -------------------- Enviamos el msj cuando termine el temporizador y lo guardamos en la variable respuesta
    print("entro y tu msj es " + contenido);
    setState(() {
      cuerpo = Text("");
    });
    AuthGoogle authGoogle =
        await AuthGoogle(fileJson: "assets/cred2.json")
            .build();
    Dialogflow dialogflow =
        Dialogflow(authGoogle: authGoogle, language: Language.spanish);
    AIResponse response = await dialogflow.detectIntent(contenido);
    print(response.getMessage()); // la respuesta traida de dialogflow
    setState(() {
      respuesta = response.getMessage();
    });
    reproducirMusica(); // Cambiamos el estado del cuerpo si es un player o simplemente texto
    if( respuesta != ""){  //--------------------------------- Si la respuesta no es un HTTP, entonces dimelo
      String cad = respuesta.substring(0,4);
      if( cad != "http") escuchar(respuesta);
    }
  }

  void reproducirMusica(){
    if( respuesta != ""){
      String cad = respuesta.substring(0,4);
      print("el valor de cad es $cad");
      if( cad == "http") setState(()=> cuerpo = PlayerWidget(url: respuesta,)); 
      else setState(() { cuerpo = Text(
        respuesta,
        style: TextStyle(
          color: Colors.purple,
          fontStyle: FontStyle.italic,
          fontSize: 30
        ),
      );});
    }
  }

  void escuchar(String cad) async{  //------------------------- Texto a Voz
      await hablar.setLanguage("es-Es");
      await hablar.speak(cad);  
  }
}