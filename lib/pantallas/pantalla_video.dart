
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class PantallaVideo extends StatefulWidget {
  final String urlVideo;

  const PantallaVideo({super.key, required this.urlVideo});

  @override
  State<PantallaVideo> createState() => _PantallaVideoState();
}

class _PantallaVideoState extends State<PantallaVideo> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();

    if (widget.urlVideo.startsWith('http')) {
      _controller = VideoPlayerController.networkUrl(Uri.parse(widget.urlVideo));
    } else {
      _controller = VideoPlayerController.asset(widget.urlVideo);
    }

    _controller.initialize().then((_) {
      setState(() {
        _isInitialized = true;
      });
      _controller.play();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
      } else {
        _controller.play();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Video')),
      body: _isInitialized
          ? Column(
        children: [
          Expanded(
            child: Center(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _controller.value.size.width,
                  height: _controller.value.size.height,
                  child: VideoPlayer(_controller),
                ),
              ),
            ),
          ),
          VideoProgressIndicator(
            _controller,
            allowScrubbing: true,
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(
                  _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                ),
                onPressed: _togglePlayPause,
                iconSize: 40,
              ),
            ],
          ),
        ],
      )
          : Center(child: CircularProgressIndicator()),
    );
  }
}

