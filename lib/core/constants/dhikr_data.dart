// /Users/nawazashraf/Downloads/nawaz/Nawaz2/project/Tasbih & qibla/lib/core/constants/dhikr_data.dart
class DhikrModel {
  const DhikrModel({
    required this.id,
    required this.arabic,
    required this.transliteration,
    required this.meaning,
  });

  final int id;
  final String arabic;
  final String transliteration;
  final String meaning;
}

const List<DhikrModel> dhikrList = <DhikrModel>[
  DhikrModel(
    id: 1,
    arabic: 'سُبْحَانَ اللهِ',
    transliteration: 'SubhanAllah',
    meaning: 'Glory be to Allah',
  ),
  DhikrModel(
    id: 2,
    arabic: 'الْحَمْدُ لِلَّهِ',
    transliteration: 'Alhamdulillah',
    meaning: 'All praise is due to Allah',
  ),
  DhikrModel(
    id: 3,
    arabic: 'اللهُ أَكْبَرُ',
    transliteration: 'Allahu Akbar',
    meaning: 'Allah is the Greatest',
  ),
  DhikrModel(
    id: 4,
    arabic: 'لَا إِلَٰهَ إِلَّا اللَّهُ',
    transliteration: 'La ilaha illallah',
    meaning: 'There is no god but Allah',
  ),
  DhikrModel(
    id: 5,
    arabic: 'أَسْتَغْفِرُ اللَّهَ',
    transliteration: 'Astaghfirullah',
    meaning: 'I seek forgiveness from Allah',
  ),
  DhikrModel(
    id: 6,
    arabic: 'لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ',
    transliteration: 'La hawla wala quwwata illa billah',
    meaning: 'There is no power except with Allah',
  ),
];
