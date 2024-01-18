import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_reels/model/video.dart';
import 'package:tiktok_reels/network/api_service.dart';

final apiProvider = Provider<ApiService>((ref) => ApiService());

final videoDataProvider = FutureProvider<List<Videos>>((ref) async {
  return ref.watch(apiProvider).getVideos();
});