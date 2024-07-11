import 'package:study_app/models/app_card.dart';

void validateConsistency(List<AppCard> cards) {
  if (cards.isEmpty) return;

  for (var attribute in AppCard.attributes) {
    var firstValue = _getAttributeValue(cards.first, attribute);
    for (var card in cards) {
      var cardValue = _getAttributeValue(card, attribute);
      if ((firstValue != null) != (cardValue != null)) {
        throw Exception('Inconsistent $attribute attribute');
      }
    }
  }
}

dynamic _getAttributeValue(AppCard card, String attribute) {
  switch (attribute) {
    case 'kanji':
      return card.kanji;
    case 'hiragana':
      return card.hiragana;
    case 'romanji':
      return card.romanji;
    case 'english':
      return card.english;
    case 'italian':
      return card.italian;
    case 'french':
      return card.french;
    case 'german':
      return card.german;
    case 'spanish':
      return card.spanish;
    default:
      return null;
  }
}
