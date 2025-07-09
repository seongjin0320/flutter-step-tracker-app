import 'dart:async';
import 'dart:math';

class SensorService {
  final _random = Random();

  // Mock accelerometer stream
  Stream<List<double>> get accelerometerStream async* {
    while (true) {
      await Future.delayed(const Duration(milliseconds: 100));
      yield [
        _random.nextDouble() * 2 - 1, // x
        _random.nextDouble() * 2 - 1, // y
        9.8 + (_random.nextDouble() * 0.1 - 0.05), // z ~ gravity
      ];
    }
  }

  // Mock gyroscope stream
  Stream<List<double>> get gyroscopeStream async* {
    while (true) {
      await Future.delayed(const Duration(milliseconds: 100));
      yield [
        _random.nextDouble() * 0.1 - 0.05, // x
        _random.nextDouble() * 0.1 - 0.05, // y
        _random.nextDouble() * 0.1 - 0.05, // z
      ];
    }
  }
}
