import 'package:http/http.dart' as http;

class HomeControlService {
  static const String toggleLights = 'toggle_lights';
  static const String lightsOff = 'lights_off';
  static const String lightsOn = 'lights_on';
  static const String movieLights = 'movie_lights';
  static const String normalLights = 'normal_lights';

  Future<bool> triggerWebHooks({String function}) async {
    String url =
        'https://maker.ifttt.com/trigger/$function/with/key/drVQ8S_c3rTQZyLPsHX-NJ';

    http.Response response = await http.post(url);

    return response.statusCode == 200;
  }
}
