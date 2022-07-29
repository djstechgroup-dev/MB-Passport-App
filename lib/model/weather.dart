class Weather {
  final double temperature;
  final double rain;
  final double uvi;

  const Weather({
    this.temperature = 70,
    this.rain = 5,
    this.uvi = 5.5,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      temperature: json['current']['temp_f'],
      uvi: json['current']['uv'],
      rain: json['current']['precip_mm'],
    );
  }
}