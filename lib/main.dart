

import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'package:audioplayers/audioplayers.dart';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_downloader/flutter_downloader.dart';






void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(
      debug: true // optional: set false to disable printing logs to console
  );

  runApp(MyApp());

}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(



        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'MP3 Downloader'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);



  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String urll="";
  AudioPlayer advancedPlayer = AudioPlayer();
  int progress = 0;
  ReceivePort _receivePort = ReceivePort();
  bool  visibility = false;
  TextEditingController myController = TextEditingController();
  static downloadingCallback(id, status, progress) {
    ///Looking up for a send port
    SendPort? sendPort = IsolateNameServer.lookupPortByName("downloading");

    ///ssending the data
    sendPort!.send([id, status, progress]);
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    ///register a send port for the other isolates
    IsolateNameServer.registerPortWithName(_receivePort.sendPort, "downloading");


    ///Listening for the data is comming other isolataes
    _receivePort.listen((message) {
      setState(() {
        progress = message[2];
      });

      print(progress);
    });


    FlutterDownloader.registerCallback(downloadingCallback);
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Center(child:Text(widget.title) ,),
      ),
      body: SingleChildScrollView(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(



          children: <Widget>[

            Container(
              margin: EdgeInsets.symmetric(vertical: 20.0),
              child:Text("$progress"+"%", style: TextStyle(fontSize: 40),),
            ),



            Container(
              margin: EdgeInsets.symmetric(vertical: 20.0),
              height: 200.0,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.all(10.0),
                    width: 160.0,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/hh.jpg"),
                        fit: BoxFit.cover,
                      ),),

                  ),
                  Container(
                    margin: const EdgeInsets.all(10.0),
                    width: 160.0,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/mp3.jpg"),
                        fit: BoxFit.cover,
                      ),),
                  ),
                  Container(
                    margin: const EdgeInsets.all(10.0),
                    width: 160.0,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/image.jpg"),
                        fit: BoxFit.cover,
                      ),),
                  ),
                  Container(
                    margin: const EdgeInsets.all(10.0),
                    width: 160.0,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/mpp3.jpg"),


                        fit: BoxFit.cover,
                      ),),
                  ),
                  Container(
                    margin: const EdgeInsets.all(10.0),
                    width: 160.0,
                    decoration: BoxDecoration(
                      image: DecorationImage(

                        image: AssetImage("assets/images/images.jpg"),
                        fit: BoxFit.cover,
                      ),),
                  ),
                ],
              ),
            ),
            TextField(
              onChanged: (value) {
                //Do something with the user input.
              },
              controller: myController,
              decoration: InputDecoration(
                hintText: 'Enter a URL.',


                contentPadding:
                EdgeInsets.symmetric(vertical: 4.0, horizontal: 30.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                  BorderSide(color: Colors.lightBlueAccent, width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                ),

              ),
            ),

            new  Container(
              margin: const EdgeInsets.only(top: 10.0),
              child :

              RaisedButton(
                color: Colors.blue, // background
                textColor: Colors.white,

                // foreground
                onPressed: () async{
                  await telecharger();



                },



                child: Text('downlowd'),
              ),

            ),


            if(progress==100)
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    InkWell(
                      onTap: ()async {
                        await advancedPlayer.pause();
                      },
                      child: Container(  margin: const EdgeInsets.all(20.0),
                        width: 50.0,
                        height: 50,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/images/pause.png"),


                            fit: BoxFit.cover,
                          ),),),),
                    InkWell(
                      onTap: ()async {
                        await advancedPlayer.play(urll);
                      },
                      child: Container(margin: const EdgeInsets.all(20.0),
                        width: 50.0,
                        height: 50,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/images/play.png"),


                            fit: BoxFit.cover,
                          ),),),
                    ),
                  ],
                ),
              )


            //______________________________________

          ],

        ),

      ),
    );
    // This trailing comma makes auto-formatting nicer for build methods.

  }
  Future <void> telecharger() async {
    final status = await Permission.storage.request();

    if (status.isGranted) {
      final externalDir = await getExternalStorageDirectory();


      final id = await FlutterDownloader.enqueue(
        url: myController.text.toString(),
        savedDir: externalDir!.path,
        fileName: "download",
        showNotification: true,
        openFileFromNotification: true,

      );

      urll=externalDir.path+'/download';



    } else {
      print("Permission deined");
    }

  }  }


