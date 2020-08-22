import 'package:webfeed/webfeed.dart';
import 'package:http/http.dart' as http;

class SchoolLunchService {
  static const String url =
      "https://ruokalistatkoulutjapaivakodit.arkea.fi/rss/2/1/79be4e48-b6ad-e711-a207-005056820ad4";

  SchoolLunchService() {
    refreshList();
  }

  List<String> weeksMeals;

  Future<bool> refreshList() async {
    bool refreshed = await _getWeeksMeals();

    return refreshed;
  }

  Future<bool> _getWeeksMeals() async {
    try {
      http.Response response = await http.get(url);

      response.body;

      RssFeed feed = RssFeed.parse(response.body);

      List<String> meals = List<String>();

      feed.items.forEach(
        (RssItem item) {
          String meal = item.description;
          String primaryMeal = trimLunch(meal);

          meal = meal.substring(meal.indexOf("Kasvislounas:"));
          String secondaryMeal = trimLunch(meal);
          meals.add("$primaryMeal\n$secondaryMeal");
        },
      );

      bool changed = false;
      if (weeksMeals != null) {
        meals.forEach((m) {
          int index = meals.indexOf(m);

          if (index >= weeksMeals.length || weeksMeals[index] != m) {
            changed = true;
          }
        });
      } else {
        changed = true;
      }
      if (!changed) {
        return false;
      }
      weeksMeals = meals;
      return true;
    } catch (e) {}

    return false;
  }

  String trimLunch(String input) {
    for (int i = input.indexOf(",") - 1; i >= 0; i--) {
      if (input[i] != " ") {
        continue;
      }
      return input.substring(0, i);
    }
    return null;
  }
}
