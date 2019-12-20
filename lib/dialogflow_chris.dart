import 'package:flutter/material.dart';
import 'package:flutter_dialogflow/dialogflow_v2.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  String msj = "";
  String respuesta = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( title: Text("Dialogflow by Chris"),),
      body: ListView(
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: <Widget>[
                new Flexible(
                  child: TextField(
                    decoration: InputDecoration(hintText: "escribir msj"),
                    onChanged: (String cad) => setState(()=> msj = cad),
                  ),
                ),
                new IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _enviarMensaje,
                )
              ],
            ),
          ),
          Text(respuesta)
        ],
      )
    );
  }


  void _enviarMensaje() async {
    print("Tu mensaje es $msj");
    AuthGoogle authGoogle =
        await AuthGoogle(fileJson: "assets/credentials.json")
            .build();
    Dialogflow dialogflow =
        Dialogflow(authGoogle: authGoogle, language: Language.spanish);
    AIResponse response = await dialogflow.detectIntent(msj);
    print(response.getMessage()); // la respuesta traida de dialogflow
    setState(() {
      respuesta = response.getMessage();
    });
  }
}