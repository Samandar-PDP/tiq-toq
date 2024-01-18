import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
        setState(() {

        });
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
      child: PageView.builder(
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
    );
  }
}
