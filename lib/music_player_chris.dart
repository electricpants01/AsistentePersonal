import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'player_widget.dart';

typedef void OnError(Exception exception);

const kUrl1 = 'http://i3.songcloud.cc/download/a80c04016556fca3ed26c9a627a108b141c0f791/aJOTlE1K90k/3574264e2e6903b8.mp3?s=descargatump3.org';
const kUrl2 = 'https://luan.xyz/files/audio/nasa_on_a_mission.mp3';
const kUrl3 = 'http://bbcmedia.ic.llnwd.net/stream/bbcmedia_radio1xtra_mf_p';
String myUrl = "";

void main() {
  runApp(new MaterialApp(home: new ExampleApp()));
}

class ExampleApp extends StatefulWidget {
  @override
  _ExampleAppState createState() => new _ExampleAppState();
}

class _ExampleAppState extends State<ExampleApp> {

  Widget remoteUrl() {
    return SingleChildScrollView(
      child: _tab(children: [
        Text(
          'Sample 1 ($kUrl1)',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        PlayerWidget(url: myUrl),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("player"),),
      body: ListView(
        children: <Widget>[
          Row(
            children: <Widget>[
              RaisedButton(
                child: Text("Escuchar Musica"),
                onPressed: ()=> setState(() => myUrl = kUrl1),
              ),
              RaisedButton(
                child: Text("Parar !"),
                onPressed: ()=> setState(() => myUrl = ""),
              ),
            ],
          ),
          ( myUrl == "" ) ? Text("Se paro la musica") : PlayerWidget(url: myUrl,)
        ],
      )
    );
  }
}

class _tab extends StatelessWidget {
  final List<Widget> children;

  const _tab({Key key, this.children}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: children.map((w) => Container(child: w, padding: EdgeInsets.all(6.0))).toList(),
        ),
      ),
    );
  }
}
