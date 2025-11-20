import 'package:flutter/material.dart';

class SeiyuuCard extends StatelessWidget {
  final Map<String, String> seiyuu;
  const SeiyuuCard({super.key, required this.seiyuu});

  @override
  Widget build(BuildContext context) {
    final gender = seiyuu['genderSeiyuu'] ?? "Male";
    final bgcolor = gender == "Male"
      ? const Color(0xFFD9EAFD)
      : const Color(0xFFFFD6E7);

    return Container(
      width: 100,
      padding: const EdgeInsets.only(top: 6, bottom: 8),
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        color: bgcolor,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [

          const SizedBox(height: 3),

          CircleAvatar(
            backgroundImage: NetworkImage(
              seiyuu['image']!
            ),
            radius: 45,
          ),
          const SizedBox(height: 10),
          Text(
            seiyuu['name']!,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.bold
            )
          ),
        ],
      ),
    );
  }
}
