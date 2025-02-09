import '../models/music.dart';

class MusicOperations {
  MusicOperations._();
  static List<Music> getMusic() {
    return <Music>[
      Music(
          'Emotional Piano Music',
          'https://cdn.pixabay.com/audio/2024/10/29/08-32-50-109_200x200.jpg',
          'SigmaMusicArt',
          'songs/song1.mp3'),
      Music(
          'Inspirational Uplifting Calm Piano',
          'https://cdn.pixabay.com/audio/2024/10/24/22-55-08-52_200x200.jpg',
          'leberchmus',
          'songs/song2.mp3'),
      Music(
          'relaxing piano music',
          'https://cdn.pixabay.com/audio/2024/10/09/10-56-43-251_200x200.jpg',
          'Clavier-Music ',
          'songs/song3.mp3'),
      Music(
          'Tibet',
          'https://cdn.pixabay.com/audio/2024/12/05/13-47-53-576_200x200.jpg',
          'Top-Flow',
          'songs/song4.mp3'),
    ];
  }
}
