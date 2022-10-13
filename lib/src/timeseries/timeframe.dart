import 'package:flutter/foundation.dart';
import 'package:ml_linalg/linalg.dart';
import '../types.dart';

// ignore: avoid_classes_with_only_static_members
/// A time frame
class TimeFrame {
  /// Populate data to now at a time interval
  static Map<DateTime, num> populateToNow(
      {@required Map<DateTime, num> dataset,
      @required Duration timePeriod,
      num value = 0}) {
    final _d = dataset.keys;
    _d.toList().sort((a, b) => a.compareTo(b));
    var date = _d.last;
    final now = DateTime.now();
    final data = dataset;
    print("DATA START $data");
    while (date.isBefore(now)) {
      date = date.add(timePeriod);
      data[date] = value;
    }
    print("DATA END $data");
    return data;
  }

  /// Resample a dataset by a time period
  static List<DateTime> resample(
      {@required List<DateTime> dataset, @required Duration timePeriod}) {
    final ds = <DateTime>[];
    _splitFromDuration(dataset, timePeriod).forEach((subSerie) {
      final startDate = subSerie.keys.toList().first;
      final endDate = subSerie.keys.toList()[subSerie.keys.toList().length - 1];
      final date = _midDate(startDate, endDate);
      ds.add(date);
    });
    return ds;
  }
}

DateTime _midDate(DateTime startDate, DateTime endDate) {
  final offset = endDate.difference(startDate) ~/ 2;
  return endDate.subtract(offset);
}

List<Map<DateTime, DateTime>> _splitFromDuration(
    List<DateTime> dataset, Duration timePeriod) {
  final res = <Map<DateTime, DateTime>>[];
  final startDate = dataset[0];
  var nextDate = startDate.add(timePeriod);
  var subSerie = <DateTime, DateTime>{};
  for (var date in dataset) {
    switch (date.isBefore(nextDate)) {
      case true:
        subSerie[date] = date;
        break;
      case false:
        res.add(subSerie);
        subSerie = {date: date};
        nextDate = date.add(timePeriod);
    }
  }
  return res;
}
