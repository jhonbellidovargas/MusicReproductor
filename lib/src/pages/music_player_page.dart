import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:music_player/src/helpers/helpers.dart';
import 'package:music_player/src/models/audioplayer_model.dart';
import 'package:music_player/src/widgets/custom_Appbar.dart';
import 'package:animate_do/animate_do.dart';
import 'package:provider/provider.dart';
class MusicPlayerPage extends StatelessWidget {
   
  const MusicPlayerPage({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Background(),
          Column(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              CustomAppbar(),
              ImagenDiscoDuracion(),
              TituloPlay(),
              Expanded(
                child: Lyrics()
              )
            ],
          ),
        ],
      ),
    );
  }
}

class Background extends StatelessWidget {
  const Background({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: size.height * 0.8,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(60.0),
        ),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.center,
          colors: [
            Color(0xff33333E),
            Color(0xff201E28),
          ],
        ),
      ),
    );
  }
}

class ImagenDiscoDuracion extends StatelessWidget {
  const ImagenDiscoDuracion({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 70.0),
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: const [
          ImagenDisco(),
          SizedBox(width: 20.0),
          BarraProgreso(),
        ],
      ),
    );
  }
}

class BarraProgreso extends StatelessWidget {
  const BarraProgreso({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final estilo = TextStyle(color: Colors.white.withOpacity(0.4));
    final audioPlayerModel = Provider.of<AudioPlayerModel>(context);
    final porcentaje = audioPlayerModel.porcentaje;
    return Container(
      child: Column(
        children: [
          Text(
            audioPlayerModel.songTotalDuration,
            style: estilo,
          ),
          const SizedBox(
            height: 10.0,
          ),
          Stack(
            children: [
              Container(
                width: 3.0,
                height: 230.0,
                color: Colors.white.withOpacity(0.1),
              ),
              Positioned(
                bottom: 0.0,
                child: Container(
                  width: 3.0,
                  height: 230.0 * porcentaje,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10.0,
          ),
          Text(
            audioPlayerModel.currentSecond,
            style: estilo,
          ),
        ],
      )
    );
  }
}

class ImagenDisco extends StatelessWidget {
  const ImagenDisco({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final audioPlayerModel = Provider.of<AudioPlayerModel>(context);
    return Container(
      width: 250.0,
      height: 250.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(200.0),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          colors: [
            Color(0xff484750),
            Color(0xff1E1C24),
          ],
        ),
      ),
      padding: const EdgeInsets.all(20.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(200.0),
        child: Stack(
          alignment: Alignment.center,
          children: [
            SpinPerfect(
              duration: const Duration(seconds: 10),
              infinite: true,
              manualTrigger: true,
              controller: (animationController) => audioPlayerModel.controller = animationController,
              child: const Image(
                image: AssetImage('assets/aurora.jpg'),
              ),
            ),
            Container(
              width: 25.0,
              height: 25.0,
              decoration: const BoxDecoration(
                color: Colors.black38,
                borderRadius: BorderRadius.all(
                  Radius.circular(100.0),
                ),
              ),
            ),
            Container(
              width: 18.0,
              height: 18.0,
              decoration: const BoxDecoration(
                color: Color(0xff1C1C25),
                borderRadius: BorderRadius.all(
                  Radius.circular(100.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TituloPlay extends StatefulWidget {
  const TituloPlay({
    Key? key,
  }) : super(key: key);

  @override
  State<TituloPlay> createState() => _TituloPlayState();
}

class _TituloPlayState extends State<TituloPlay> with SingleTickerProviderStateMixin{
  bool isPlaying = false;
  bool firstTime = true;
  late AnimationController playAnimation;

  final assetsAudioPlayer = AssetsAudioPlayer();

  @override
  void initState() {
    playAnimation = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    super.initState();
  }

  @override
  void dispose() {
    playAnimation.dispose();
    super.dispose();
  }

  void open() {
    final audioPlayerModel = Provider.of<AudioPlayerModel>(context, listen: false);
    assetsAudioPlayer.open(
      Audio('assets/breaking_benjamin-far_away.mp3'),
      autoStart: true,
      showNotification: true,
    );
    assetsAudioPlayer.currentPosition.listen((duration) {
      audioPlayerModel.current = duration;
    });
    assetsAudioPlayer.current.listen((playingAudio) {
      audioPlayerModel.songDuration = playingAudio!.audio.duration;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      margin: const EdgeInsets.only(top: 40.0),
      child: Row(
        children: [
          Column(
            children: [
              Text(
                'Far Away',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 30.0,
                ),
              ),
              Text(
                'Breaking Benjamin ',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 15.0,
                ),
              ),
            ],
          ),
          const Spacer(),
          FloatingActionButton(
            //backgroundColor: Colors.green,
            backgroundColor: const Color(0xffF8CB51),
            child: AnimatedIcon(
              icon: AnimatedIcons.play_pause,
              progress: playAnimation,
            ),
            onPressed: () {
              final audioPlayerModel = Provider.of<AudioPlayerModel>(context, listen: false);
              if (isPlaying) {
                playAnimation.reverse();
                isPlaying = false;
                audioPlayerModel.controller?.stop();
              } else {
                playAnimation.forward();
                isPlaying = true;
                audioPlayerModel.controller?.repeat();
              }

              if (firstTime) {
                firstTime = false;
                open();
              } else {
                assetsAudioPlayer.playOrPause();
              }
            },
          ),
        ],
      )
    );
  }
}

class Lyrics extends StatelessWidget {
  const Lyrics({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final lyrics = getLyrics();
    final size = MediaQuery.of(context).size;
    return Container(
      //height: size.height * 0.20,
      margin: const EdgeInsets.only(top: 40.0),
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: ListWheelScrollView(
        physics: const BouncingScrollPhysics(),
        itemExtent: 42.0,
        diameterRatio: 1.5,
        children: lyrics
          .map((e) => Text(
            e,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white.withOpacity(0.6),
            ),
          ))
          .toList(),
      )
    );
  }
}