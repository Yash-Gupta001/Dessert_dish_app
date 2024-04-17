import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

// Model for YouTube video data
class YouTubeVideo {
  final String title;
  final String videoUrl;

  YouTubeVideo({required this.title, required this.videoUrl});

  // Extracts video ID from YouTube URL
  String getVideoId() {
    RegExp regExp = RegExp(
        r"(?:https:\/\/)?(?:www\.)?(?:youtube\.com\/(?:[^\/\n\s]+\/\S+\/|(?:v|e(?:mbed)?)\/|\S*?[?&]v=)|youtu\.be\/)([a-zA-Z0-9_-]{11})");
    Match match = regExp.firstMatch(videoUrl)!;
    return match.group(1)!;
  }
}

class VideoPlayerScreen extends StatelessWidget {
  VideoPlayerScreen({Key? key}) : super(key: key);

  final List<YouTubeVideo> videos = [
    YouTubeVideo(
      title: 'Video 1',
      videoUrl: 'https://youtu.be/ttIKsnxPrMY?si=j8E5KGTgYGRqP648',
    ),
    
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: ListView.builder(
        itemCount: videos.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(videos[index].title),
            onTap: () {
              // Navigate to video
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VideoPlayer(videoId: videos[index].getVideoId()),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class VideoPlayer extends StatefulWidget {
  final String videoId;

  const VideoPlayer({Key? key, required this.videoId}) : super(key: key);

  @override
  _VideoPlayerState createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: YoutubePlayerFlags(
        autoPlay: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: Center(
        child: YoutubePlayer(
          controller: _controller,
          showVideoProgressIndicator: true,
          progressIndicatorColor: Colors.blueAccent,
          progressColors: ProgressBarColors(
            playedColor: Colors.blue,
            handleColor: Colors.blueAccent,
          ),
          onReady: () {
            // Do something when player is ready.
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
