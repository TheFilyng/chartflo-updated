import 'package:flutter/foundation.dart';
import 'package:ml_linalg/linalg.dart';
import 'dart:collection';
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

  static Map<DateTime, List<num>> resample(
      {@required Map<DateTime, List<num>> dataset,
      @required Duration timePeriod,
      ResampleMethod resampleMethod = ResampleMethod.mean}) {
    final ds = <DateTime, List<num>>{};
    _splitFromDuration(dataset, timePeriod).forEach((subSerie) {
      final startDate = subSerie.first.keys.toList().first;
      final endDate = subSerie.last.keys.toList().first;
      // resample numbers
      final row = subSerie
          .map<List<double>>((row) =>
              row[row.keys.toList()[0]].map((e) => e.toDouble()).toList())
          .toList();
      List<num> value;
      switch (resampleMethod) {
        case ResampleMethod.mean:
          for (var vals in row) {
            var average = Vector.fromList(vals).mean();
            value.add(average);
          }
          break;
        case ResampleMethod.sum:
          for (var vals in row) {
            var average = Vector.fromList(vals).sum();
            value.add(average);
          }
          break;
      }
      final date = _midDate(startDate, endDate);
      ds[date] = value;
    });
    return ds;
  }
}

DateTime _midDate(DateTime startDate, DateTime endDate) {
  final offset = endDate.difference(startDate) ~/ 2;
  return endDate.subtract(offset);
}

List<List<Map<DateTime, List<num>>>> _splitFromDuration(
    Map<DateTime, List<num>> dataset, Duration timePeriod) {
  final res = <List<Map<DateTime, List<num>>>>[];
  final startDate = dataset.keys.toList()[0];
  var nextDate = startDate.add(timePeriod);
  var subSerie = <Map<DateTime, List<num>>>[];
  dataset.forEach((date, value) {
    final record = <DateTime, List<num>>{date: value};
    switch (date.isBefore(nextDate)) {
      case true:
        subSerie.add(record);
        break;
      case false:
        res.add(subSerie);
        subSerie = <Map<DateTime, List<num>>>[record];
        nextDate = date.add(timePeriod);
    }
  });
  return res;
}
