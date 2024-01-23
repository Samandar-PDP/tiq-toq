import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:tiktok_reels/repository/video_repository.dart';
import 'package:video_player/video_player.dart';

import '../model/video.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePage();
}

class _HomePage extends ConsumerState<HomePage> {
  late VideoPlayerController _controller;
  bool _isClicked = false;
  bool _showAnim = false;

  @override
  void initState() {
    _setVideo(
        "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4");
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _setVideo(String link) {
    _controller = VideoPlayerController.networkUrl(Uri.parse(link))
      ..initialize().then((value) {
        setState(() {});
      });
    _controller.play();
  }

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(videoDataProvider);
    return Scaffold(
        body: data.when(data: (videoData) {
      return _successField(videoData);
    }, error: (context, s) {
      return Center(child: Text(s.toString()));
    }, loading: () {
      return const Center(child: CircularProgressIndicator());
    }));
  }

  Widget _successField(List<Videos> videos) {
    return SafeArea(
        child: GestureDetector(
          onDoubleTap: () async {
            setState(() {
              _showAnim = true;
            });
            await Future.delayed(const Duration(seconds: 1));
            setState(() {
              _showAnim = false;
            });
          },
          child: Stack(
            children: [
              PageView.builder(
                scrollDirection: Axis.vertical,
                itemCount: videos.length,
                onPageChanged: (index) {
                  _setVideo(videos[index].videoFiles?[3].link ?? "");
                },
                itemBuilder: (context, index) {
                  return AspectRatio(
                    aspectRatio: 9 / 16,
                    child: VideoPlayer(_controller),
                  );
                },
              ),
              Positioned(
                bottom: 40,
                right: 10,
                child: Column(
                  children: [
                    IconButton(onPressed: () {
                      setState(() {
                        _isClicked = !_isClicked;
                      });
                    }, icon: Icon(
                      _isClicked ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
                      color: _isClicked ? Colors.red : Colors.white,
                    )),
                    Text("324323"),
                    const SizedBox(height: 10),
                    IconButton(onPressed: () {
                      _showComment();
                    }, icon: const Icon(CupertinoIcons.chat_bubble_text, color: Colors.white,)),
                    Text("4566"),
                    const SizedBox(height: 10),
                    IconButton(onPressed: () {}, icon: const Icon(CupertinoIcons.paperplane, color: Colors.white,)),
                    Text("12"),
                    const SizedBox(height: 10),
                    IconButton(onPressed: () {}, icon: const Icon(CupertinoIcons.ellipsis_vertical, color: Colors.white,)),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
              if(_showAnim)
                Center(
                  child: Lottie.asset('assets/json/like.json'),
                )
            ],
          ),
        )
    );
  }
  _showComment() {
    showModalBottomSheet(context: context, builder: (context) => Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Divider()
        ],
      ),
    ));
  }
}
