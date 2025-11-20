import 'package:flutter_riverpod/flutter_riverpod.dart';

class Character {
  final String name;
  final String image;
  final String birthday;

  Character({
    required this.name, 
    required this.image, 
    required this.birthday
    });
}
class KarakterNotifier  extends StateNotifier<List<Character>> {
  final Ref ref;

  KarakterNotifier(this.ref) : super([]);
}

final characterProvider = StateNotifierProvider<KarakterNotifier, List<Character>>(
  (ref) => KarakterNotifier(ref),
);