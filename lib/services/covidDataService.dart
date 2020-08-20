import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CovidDataService {
  /// Covid cases in Finland by gender
  /// Map consists of keys `"female"`, `"male"`, and `"total"`
  Map<String, int> totalCasesByGender;

  /// Covid cases in Finland by days. The last element of  the list is the newest, so last is todays cases.
  List<int> totalCasesByDay;

  /// Covid cases in Finland by age groups.
  /// Is a map, in which keys are strings describing the age range ("10-20", "40-50", "80-" etc...)
  /// and values are numbers of cases in that age range.
  Map<String, int> totalCasesByAge;

  CovidDataService() {
    refreshData();
  }

  Future<bool> refreshData() async {
    print("updating total cases by gender");
    bool aUpdated = await _getTotalCasesByGender();
    print("updating total cases by age");
    bool bUpdated = await _getTotalCasesByAge();
    print("updating total cases by day");
    bool cUpdated = await _getTotalCasesByDay();

    return aUpdated || bUpdated || cUpdated;
  }

  Future<bool> _getTotalCasesByGender() async {
    String url =
        "https://sampo.thl.fi/pivot/prod/fi/epirapo/covid19case/fact_epirapo_covid19case.json?column=sex-444328";

    http.Response response = await http.get(url);

    print(response.statusCode);

    if (response.statusCode == 200) {
      try {
        Map<String, dynamic> data = json.decode(response.body);

        print("data: $data");

        Map<String, dynamic> values = data["dataset"]["value"];
        print("values: $values");

        print(values.keys.length);

        Map<String, int> output = Map<String, int>();

        values.keys.forEach((key) {
          if (key == "0") {
            output["female"] = int.parse(values[key]);
          } else if (key == "1") {
            output["male"] = int.parse(values[key]);
          } else {
            output["total"] = int.parse(values[key]);
          }
        });

        if (totalCasesByGender != null) {
          bool updated = false;
          totalCasesByGender.forEach((key, value) {
            if (output[key] != value) {
              updated = true;
            }
          });

          if (!updated) {
            return false;
          }
        }

        totalCasesByGender = output;
        return true;
      } catch (e) {
        print(e.toString());
      }
    }
    return false;
  }

  Future<bool> _getTotalCasesByDay() async {
    String url =
        "https://sampo.thl.fi/pivot/prod/fi/epirapo/covid19case/fact_epirapo_covid19case.json?column=dateweek2020010120201231-443702L";

    http.Response response = await http.get(url);

    print(response.statusCode);

    if (response.statusCode == 200) {
      try {
        Map<String, dynamic> data = json.decode(response.body);

        Map<String, dynamic> values = data["dataset"]["value"];
        List<int> output = List<int>();
        values.values.forEach((e) => output.add(int.parse(e)));

        if (totalCasesByDay != null) {
          if (output.length == totalCasesByDay.length) {
            return false;
          }
        }
        totalCasesByDay = output;

        return true;
      } catch (e) {
        print(e.toString());
      }
    }

    return false;
  }

  Future<bool> _getTotalCasesByAge() async {
    String url =
        "https://sampo.thl.fi/pivot/prod/fi/epirapo/covid19case/fact_epirapo_covid19case.json?column=ttr10yage-444309";

    http.Response response = await http.get(url);

    print(response.statusCode);

    if (response.statusCode == 200) {
      try {
        Map<String, dynamic> data = json.decode(response.body);

        Map<String, dynamic> values = data["dataset"]["value"];

        Map<String, int> output = Map<String, int>();

        values.keys.forEach(
          (key) {
            String newKey = null;
            switch (key) {
              case "0":
                newKey = "0-10";
                break;
              case "1":
                newKey = "10-20";
                break;
              case "2":
                newKey = "20-30";
                break;
              case "3":
                newKey = "30-40";
                break;

              case "4":
                newKey = "40-50";
                break;
              case "5":
                newKey = "50-60";
                break;
              case "6":
                newKey = "60-70";
                break;
              case "7":
                newKey = "70-80";
                break;
              case "8":
                newKey = "80-";
                break;
            }

            if (newKey != null) {
              output[newKey] = int.parse(values[key]);
            }
          },
        );
        if (totalCasesByAge != null) {
          bool updated = false;
          totalCasesByAge.forEach((key, value) {
            if (output[key] != value) {
              updated = true;
            }
          });

          if (!updated) {
            return false;
          }
        }
        totalCasesByAge = output;
        return true;
      } catch (e) {
        print(e.toString());
      }
    }

    return false;
  }
}
