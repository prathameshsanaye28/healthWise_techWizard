import 'package:flutter/material.dart';

import '../../models/category.dart';
import '../../models/music.dart';
import '../../services/category_operations.dart';
import '../../services/music_operations.dart';

class Home extends StatelessWidget {
  final Function _miniPlayer;
  Home(this._miniPlayer, {super.key}); // Dart Constructor ShortHand
  // const Home({Key? key}) : super(key: key);
  Widget createCategory(Category category) {
    return Container(
        color: const Color.fromARGB(255, 211, 212, 241),
        child: Row(
          children: [
            const SizedBox(width: 4),
            Image.network(
              category.imageURL,
              fit: BoxFit.cover,
              width: 65,
              height: 65,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                category.name,
                style: const TextStyle(color: Color(0xFF2E4052)),
              ),
            )
          ],
        ));
  }

  List<Widget> createListOfCategories() {
    List<Category> categoryList =
        CategoryOperations.getCategories(); // Rec Data
    // Convert Data to Widget Using map function
    List<Widget> categories = categoryList
        .map((Category category) => createCategory(category))
        .toList();
    return categories;
  }

  Widget createMusic(Music music) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 200,
            width: 200,
            child: InkWell(
              onTap: () {
                _miniPlayer(music, stop: true);
              },
              child: Image.network(
                music.image,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Text(
            music.name,
            style: const TextStyle(color: Color(0xFF2E4052)),
          ),
          Text(music.desc, style: const TextStyle(color: Color(0xFF2E4052)))
        ],
      ),
    );
  }

  Widget createMusicList(String label) {
    List<Music> musicList = MusicOperations.getMusic();
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
                color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 300,
            child: ListView.builder(
              //padding: EdgeInsets.all(5),
              scrollDirection: Axis.horizontal,
              itemBuilder: (ctx, index) {
                return createMusic(musicList[index]);
              },
              itemCount: musicList.length,
            ),
          )
        ],
      ),
    );
  }

  Widget createGrid() {
    return Container(
      padding: const EdgeInsets.all(10),
      height: 280,
      child: GridView.count(
        childAspectRatio: 5 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        crossAxisCount: 2,
        children: createListOfCategories(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
          child: Container(
        child: Column(
          children: [
            const SizedBox(
              height: 5,
            ),
            createGrid(),
            createMusicList('Made for you'),
            createMusicList('Popular PlayList')
          ],
        ),
      )),
    );
  }
}
