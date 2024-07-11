// kanji.dart
class AppCard {
  final String? symbol;
  final String? kanji;
  final String? hiragana;
  final String? romanji;
  final String? english;
  final String? italian;
  final String? french;
  final String? german;
  final String? spanish;

  static const List<String> attributes = [
    'symbol',
    'kanji',
    'hiragana',
    'romanji',
    'english',
    'italian',
    'french',
    'german',
    'spanish',
  ];

  AppCard({
    this.symbol,
    this.kanji,
    this.hiragana,
    this.romanji,
    this.english,
    this.italian,
    this.french,
    this.german,
    this.spanish,
  }) : assert(
          [
                symbol,
                kanji,
                hiragana,
                romanji,
                english,
                italian,
                french,
                german,
                spanish
              ].where((element) => element != null).length >=
              2,
          'At least two fields must be non-null',
        );


  List<String> getNonNullAttributes() {
    List<String> attributes = [];
    if (symbol != null) attributes.add('symbol');
    if (kanji != null) attributes.add('kanji');
    if (hiragana != null) attributes.add('hiragana');
    if (romanji != null) attributes.add('romanji');
    if (english != null) attributes.add('english');
    if (italian != null) attributes.add('italian');
    if (french != null) attributes.add('french');
    if (german != null) attributes.add('german');
    if (spanish != null) attributes.add('spanish');
    return attributes;
  }

  String getAttributeValue(String attribute) {
    switch (attribute) {
      case 'symbol':
        return symbol ?? '';
      case 'kanji':
        return kanji ?? '';
      case 'hiragana':
        return hiragana ?? '';
      case 'romanji':
        return romanji ?? '';
      case 'english':
        return english ?? '';
      case 'italian':
        return italian ?? '';
      case 'french':
        return french ?? '';
      case 'german':
        return german ?? '';
      case 'spanish':
        return spanish ?? '';
      default:
        return '';
    }
  }

}
