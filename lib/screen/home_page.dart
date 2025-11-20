import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:list_anime/data/data_karakter.dart';
import '../data/data_anime.dart';
import '../data/data_seiyuu.dart';
// import '../data/data_karakter.dart';
import '../widget/anime_card.dart';
import '../widget/karakter_card.dart';
import '../widget/seiyuu_card.dart';

final birthdayScrollProvider = StateProvider<double>((ref) => 0.0);
final male = characterList.where((c) => c['gender'] == 'Male').toList();
final female = characterList.where((c) => c['gender'] == 'Female').toList();
final laki = seiyuuList.where((d) => d['genderSeiyuu'] == 'Male').toList();
final perempuan = seiyuuList.where((d) => d['genderSeiyuu'] == 'Female').toList();

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class Menu extends StatelessWidget {
  final List<String> menus = [
    "All",
    "Anime",
    "Karakter",
    "Seiyuu",
  ];

  Menu({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: menus.length,
        padding: const EdgeInsets.only(left: 4),
        itemBuilder: (context, index) {
          final bool isSelected = index == 0;

          return Container(
            margin: const EdgeInsets.only(right: 10),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: isSelected ? Colors.white : Colors.black.withOpacity(0.25),
              borderRadius: BorderRadius.circular(20),
            ),

            child: Text(
              menus[index],
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.black : Colors.white,
              ),
            ),
          );
        },
      ),
    );
  }
}
class _HomePageState extends ConsumerState<HomePage> with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget buildList(String title, Widget child) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          SizedBox(height: 160, child: child),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // final birthday = ref.watch(birthdayScrollProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7FB),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: const BoxDecoration(
            color: Color(0xFFD5EBFF),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Center(
                child: Text(
                  "Anime List",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // const SizedBox(height: 10),
              // Menu(),
              // const SizedBox(height: 10),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: const [
                      Text(
                        "Setsuna Yuki",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),

                      Text(
                        "Setsuna@gmail.com",
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(width: 10),
                  const CircleAvatar(
                    radius: 18,
                    backgroundImage: NetworkImage(
                      "image/karakter/Setsuna.jpeg"
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),

            Menu(),

            const SizedBox(height: 12),
            buildList(
              "Anime",
              ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: animeList.length,
                itemBuilder: (context, index) => AnimeCard(anime: animeList[index]),
              ),
            ),
            buildList(
              "Karakter Laki-Laki",
              ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: male.length,
                itemBuilder: (context, index) =>
                  CharacterCard(character: male[index]),
              ),
            ),
            buildList(
              "Karakter Perempuan",
              ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: female.length,
                itemBuilder: (context, index) =>
                  CharacterCard(character: female[index]),
              ),
            ),
            buildList(
              "Seiyuu Laki-Laki",
              ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: laki.length,
                itemBuilder: (context, index) =>
                  SeiyuuCard(seiyuu: laki[index]),
              ),
            ),
            buildList(
              "Seiyuu Perempuan",
              ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: perempuan.length,
                itemBuilder: (context, index) =>
                  SeiyuuCard(seiyuu: perempuan[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
