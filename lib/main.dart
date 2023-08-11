import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(const MyApp());
}

// class MyApp extends StatefulWidget {
//   const MyApp({super.key});
//
//   @override
//   _MyAppState createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> {
//   AudioPlayer player = AudioPlayer();
//
//   @override
//   void initState() {
//     super.initState();
//     player.setReleaseMode(ReleaseMode.loop);
//   }
//
//   void playAudio() async {
//     await player.play(AssetSource("assets/meant_to_be.mp3"));
//   }
//
//   void pauseAudio() {
//     player.pause();
//   }
//
//   void stopAudio() {
//     player.stop();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text("Audio Player"),
//         ),
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Text("Audio Player"),
//               TextButton(
//                   onPressed: playAudio,
//                   child: const Text("Play")
//               ),
//               TextButton(
//                   onPressed: pauseAudio,
//                   child: const Text("Pause")
//               ),
//               TextButton(
//                   onPressed: stopAudio,
//                   child: const Text("Stop")
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AudioPlayer player = AudioPlayer();

  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  String formatTime(int seconds) {
    return '${(Duration(seconds: seconds))}'.split('.')[0].padLeft(8, '0');
  }

  @override
  void initState() {
    super.initState();
    // player.setVolume(1.0);

    player.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying = state == PlayerState.playing;
      });
    });

    player.onDurationChanged.listen((newDuration) {
      setState(() {
        duration = newDuration;
      });
    });

    player.onPositionChanged.listen((newPosition) {
      setState(() {
        position = newPosition;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorSchemeSeed: const Color(0xff6750a4),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Audio Player'),
          leading: const Icon(Icons.music_note_rounded, size: 35, color: Colors.black38,),

        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    'assets/images/meant_to_be.png',
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Slider(
                min: 0,
                max: duration.inSeconds.toDouble(),
                value: position.inSeconds.toDouble(),
                onChanged: (value) {
                  final position = Duration(seconds: value.toInt());
                  player.seek(position);
                  player.resume();
                },
              ),
              Container(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(formatTime(position.inSeconds)),
                    Text(formatTime((duration - position).inSeconds)),
                  ],
                ),
              ),
              const SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 40,
                    child: IconButton(
                      icon: Icon(
                        isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                      ),
                      iconSize: 50,
                      onPressed: (){
                          if(isPlaying)
                          {
                            player.pause();
                          }
                          else{
                            player.play(AssetSource('meant_to_be.mp3'));
                          }
                      },
                    ),
                  ),
                  const SizedBox(width: 20,),
                  CircleAvatar(
                    radius: 30,
                    child: IconButton(
                      icon:const Icon(Icons.stop_rounded),
                      iconSize: 30,
                      onPressed: (){
                          player.stop();
                      },
                    ),
                  ),
                ],
              ),
              // ElevatedButton(
              //   onPressed: (){
              //     player.play(AssetSource('meant_to_be.mp3'));
              //   },
              //   child: const Text('Play'),
              // ),
              // ElevatedButton(
              //     onPressed: (){
              //       setState(() {
              //         player.pause();
              //       });
              //     },
              //     child: const Text('Pause')
              // ),
              // ElevatedButton(
              //     onPressed: (){
              //       setState(() {
              //         player.stop();
              //       });
              //     },
              //     child: const Text('Stop')
              // ),

            ],
          )
          // Column(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     const Text('Play'),
          //     TextButton(
          //       onPressed: () {
          //         player.play(
          //           AssetSource('assets/audio/meant_to_be.mp3'),
          //         );
          //       },
          //       child: const Text('Play Audio'),
          //     ),
          //     const Text('Pause'),
          //     TextButton(
          //       onPressed: () {
          //         player.pause();
          //       },
          //       child: const Text('Pause Audio'),
          //     ),
          //     const Text('Stop'),
          //     TextButton(
          //       onPressed: () {
          //         player.stop();
          //       },
          //       child: const Text('Stop Audio'),
          //     ),
          //   ],
          // ),
        ),
      ),
    );
  }
}