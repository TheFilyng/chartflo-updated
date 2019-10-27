import 'dart:math';

/// The generated data
Map<DateTime, num> dataset;

/// Generate random data
Map<DateTime, num> generateData() {
  print("Generating random data");
  final _rng = Random();
  final res = <DateTime, num>{};
  final dateNow = DateTime.now();
  final startDate = DateTime(dateNow.year, dateNow.month, dateNow.day)
      .subtract(const Duration(days: 15));
  var currentDate = startDate;
  while (currentDate.isBefore(dateNow)) {
    final value = _rng.nextInt(100);
    currentDate = currentDate.add(Duration(hours: _rng.nextInt(5)));
    res[currentDate] = value;
  }
  print("Generated ${res.length} datapoints");
  return res;
}
