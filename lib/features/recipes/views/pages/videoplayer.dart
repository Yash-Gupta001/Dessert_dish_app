// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

// for YouTube video data
class YouTubeVideo {
  final String title;
  final String videoUrl;
  final String thumbnailUrl;

  YouTubeVideo({required this.title, required this.videoUrl, required this.thumbnailUrl});

  String getVideoId() {
    RegExp regExp = RegExp(
        r"(?:https:\/\/)?(?:www\.)?(?:youtube\.com\/(?:[^\/\n\s]+\/\S+\/|(?:v|e(?:mbed)?)\/|\S*?[?&]v=)|youtu\.be\/)([a-zA-Z0-9_-]{11})");
    Match match = regExp.firstMatch(videoUrl)!;
    return match.group(1)!;
  }
}

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({Key? key}) : super(key: key);

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  final List<YouTubeVideo> videos = [
    YouTubeVideo(
      title: 'Choclate Cake',
      videoUrl: 'https://youtu.be/2XBvw_Ty-C0?si=Q-OnAtqdsGAQ9v0_',
      thumbnailUrl: 'https://www.shutterstock.com/image-photo/chocolate-cake-berries-600nw-394680466.jpg',
    ),

    YouTubeVideo(
      title: 'Strawberry Cake',
      videoUrl: 'https://youtu.be/MimTIyPbvVk?si=uW4cdHnjSASQSrMD',
      thumbnailUrl: 'https://images.unsplash.com/photo-1622621746668-59fb299bc4d7?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8c3RyYXdiZXJyeSUyMGNha2V8ZW58MHx8MHx8fDA%3D',
    ),

    YouTubeVideo(
      title: 'Chocolate Donuts',
      videoUrl: 'https://youtu.be/2csH1iROMK8?si=CajzwsfQCcdzPJ74',
      thumbnailUrl: 'https://t3.ftcdn.net/jpg/05/67/67/74/360_F_567677492_n4ig3xZYStM3tOuteqvs4rYFOfCgZAHI.jpg',
    ),

    YouTubeVideo(
      title: 'Cream Cupcakes',
      videoUrl: 'https://youtu.be/NOoVxIweTw0?si=aulj2Vx0zvr7tBr0',
      thumbnailUrl: 'https://i.pinimg.com/736x/ec/87/1f/ec871f5c4eab588460614a23ec583d0a.jpg',
    ),

    YouTubeVideo(
      title: 'Macaroons',
      videoUrl: 'https://youtu.be/ytpL6X_bpdA?si=a0njxsRlKFfFpyzE',
      thumbnailUrl: 'https://cdn.pixabay.com/photo/2024/03/22/16/47/ai-generated-8650096_640.jpg',
    ),

    YouTubeVideo(
      title: 'Lemon Cheesecake',
      videoUrl: 'https://youtu.be/c0AK3KA4828?si=7CyNDlmLiCYZRGNd',
      thumbnailUrl: 'https://img.freepik.com/free-photo/homemade-newyork-cheesecake-with-lemon-mint-healthy-organic-dessert-top-view_114579-9384.jpg',
    ),

    YouTubeVideo(
      title: 'Fruit Pie',
      videoUrl: 'https://youtu.be/Jrla4pYcavk?si=iGxJZvgZT20tke3H',
      thumbnailUrl: 'https://www.joyofbaking.com/images/facebook/fruittart.jpg',
    ),
  ];

  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedList(
        key: _listKey,
        initialItemCount: videos.length,
        itemBuilder: (context, index, animation) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(animation),
            child: buildItem(context, index),
          );
        },
      ),
    );
  }

  Widget buildItem(BuildContext context, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VideoPlayer(videoUrl: videos[index].videoUrl),
            ),
          );
        },
        child: Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  videos[index].title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.network(
                    videos[index].thumbnailUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
class VideoPlayer extends StatefulWidget {
  final String videoUrl;

  const VideoPlayer({Key? key, required this.videoUrl}) : super(key: key);

  @override
  _VideoPlayerState createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  late YoutubePlayerController _controller;
  bool _isPlayerReady = false;
  bool _isFullscreen = false;
  double _scaleFactor = 1.0;

  @override
  void initState() {
    super.initState();
    final videoId = YoutubePlayer.convertUrlToId(widget.videoUrl);
    if (videoId == null) {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Error'),
            content: const Text('Invalid video URL'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      });
    } else {
      _controller = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(
          autoPlay: true,
          mute: false,
          isLive: false,
          loop: false,
          forceHD: false,
          enableCaption: true,
        ),
      )..addListener(_listener);
    }
  }

  void _listener() {
    if (_controller.value.isFullScreen != _isFullscreen) {
      setState(() {
        _isFullscreen = _controller.value.isFullScreen;
      });

      if (!_controller.value.isFullScreen) {
        SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _isFullscreen
          ? null
          : AppBar(
              title: const Text('Video Player'),
              backgroundColor: Colors.red[700], 
            ),
      body: InteractiveViewer( // Wrap with InteractiveViewer for pinch-to-zoom functionality
        boundaryMargin: const EdgeInsets.all(100),
        minScale: 0.1,
        maxScale: 1.6,
        child: GestureDetector(
          onDoubleTap: _handleDoubleTap,
          child: Center(
            child: _controller != null
                ? YoutubePlayer(
                    controller: _controller,
                    showVideoProgressIndicator: true,
                    progressIndicatorColor: Colors.red, 
                    progressColors: const ProgressBarColors(
                      playedColor: Colors.red, 
                      handleColor: Colors.redAccent, 
                    ),
                    onReady: () {
                      _isPlayerReady = true;
                    },
                    onEnded: (data) {
                      _controller.load(YoutubePlayer.convertUrlToId(widget.videoUrl) ?? '');
                    },
                  )
                : const CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }

  void _handleDoubleTap() {
    // Get current video position
    final currentPosition = _controller.value.position;

    // seek duration 10 seconds
    const seekDuration = Duration(seconds: 10);

    // Check if video is playing
    if (_controller.value.isPlaying) {
      // seek forward by seekDuration
      _controller.seekTo(currentPosition + seekDuration);
    } else {
      //seek backward by seekDuration
      _controller.seekTo(currentPosition - seekDuration);
    }
  }

  @override
  void deactivate() {
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.dispose();
  }
}