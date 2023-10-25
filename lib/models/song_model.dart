class Song {
  final String title;
  final String description;
  final String url;
  final String coverUrl;

  Song(
      {required this.title,
      required this.description,
      required this.url,
      required this.coverUrl});

  static List<Song> songs = [
    Song(
      title: 'Rilex',
      description: 'Rilex',
      url: 'assets/music/rilex.mp3',
      coverUrl: 'assets/images/rilex.svg',
    ),
    Song(
      title: 'Calm',
      description: 'Calm',
      url: 'assets/music/calm.mp3',
      coverUrl: 'assets/images/calm.svg',
    ),
    Song(
      title: 'Sleep',
      description: 'Sleep',
      url: 'assets/music/sleep.mp3',
      coverUrl: 'assets/images/sleep.svg',
    )
  ];
}
