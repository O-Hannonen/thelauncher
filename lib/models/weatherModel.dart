class WeatherModel {
  String iconUrl;
  num degrees;
  num feelsLike;
  num tempMin;
  num tempMax;
  num humidity;

  WeatherModel({
    this.iconUrl,
    this.degrees,
    this.feelsLike,
    this.tempMax,
    this.humidity,
    this.tempMin,
  });

  bool isEqualTo({WeatherModel other}) {
    return other != null &&
        iconUrl == other.iconUrl &&
        degrees == other.degrees &&
        feelsLike == other.feelsLike &&
        tempMin == other.tempMin &&
        tempMax == other.tempMax &&
        humidity == other.humidity;
  }
}
