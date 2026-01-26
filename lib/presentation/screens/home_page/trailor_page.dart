import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class FullScreenTrailerPage extends StatefulWidget {
  final String? trailerUrl;

  const FullScreenTrailerPage({
    super.key,
    required this.trailerUrl,
  });

  @override
  State<FullScreenTrailerPage> createState() =>
      _FullScreenTrailerPageState();
}

class _FullScreenTrailerPageState extends State<FullScreenTrailerPage> {
  YoutubePlayerController? _controller;
  bool _isTrailerAvailable = true;

  @override
  void initState() {
    super.initState();

    // /// Enter true fullscreen
    // SystemChrome.setEnabledSystemUIMode(
    //   SystemUiMode.immersiveSticky,
    // );

    if (widget.trailerUrl == null || widget.trailerUrl!.isEmpty) {
      _isTrailerAvailable = false;
      return;
    }

    final videoId =
        YoutubePlayer.convertUrlToId(widget.trailerUrl!);

    if (videoId == null) {
      _isTrailerAvailable = false;
      return;
    }

    _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        forceHD: true,
        hideControls: false,
        enableCaption: false,
        disableDragSeek: false,
      ),
    );
  }

  @override
  void dispose() {
    /// Restore system UI
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge,
    );

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.black,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );

    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: WillPopScope(
        onWillPop: () async {
          Navigator.pop(context);
          return false;
        },
        child: _isTrailerAvailable
            ? YoutubePlayerBuilder(
                onExitFullScreen: () {
                  /// Extra safety
                  SystemChrome.setEnabledSystemUIMode(
                    SystemUiMode.edgeToEdge,
                  );
                },
                player: YoutubePlayer(
                  controller: _controller!,
                  showVideoProgressIndicator: true,
                  progressIndicatorColor: Colors.red,
                  progressColors: const ProgressBarColors(
                    playedColor: Colors.red,
                    handleColor: Colors.redAccent,
                  ),
                ),
                builder: (context, player) {
                  return Center(child: player);
                },
              )
            : _noTrailerView(context),
      ),
    );
  }

  Widget _noTrailerView(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.videocam_off_rounded,
              color: Colors.white54,
              size: 64,
            ),
            SizedBox(height: 16),
            Text(
              'Sorry, no trailer available for this movie',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
