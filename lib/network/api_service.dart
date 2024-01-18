import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/video.dart';

class ApiService {
  Future<List<Videos>> getVideos() async {
    try {
      final response = await http.get(Uri.parse("https://api.pexels.com/videos/popular"),headers: {
        "Authorization": "563492ad6f91700001000001dc912faa4865445694b8ccc566067984"
      });
      final jsonString = jsonDecode(response.body) as Map<String, dynamic>;
      final video = Video.fromJson(jsonString);
      return video.videos ?? [];
    } catch(e) {
      return [];
    }
  }
}