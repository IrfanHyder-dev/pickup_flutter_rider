import 'package:get/get.dart';
import 'available_languages/en_us.dart';
import 'available_languages/ur_pk.dart';


class Languages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': EnLanguage().language,
        'ur_PK': UrLanguage().language,
      };
}
