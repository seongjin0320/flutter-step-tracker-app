import 'dart:async';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'sensor_service.dart';
import 'data_logger.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final SensorService _sensorService = SensorService();
  final DataLogger _dataLogger = DataLogger();
  bool _collecting = false;
  Timer? _loggingTimer;

  List<double>? _lastAccel;
  List<double>? _lastGyro;

  @override
  void dispose() {
    _loggingTimer?.cancel();
    super.dispose();
  }

  void _toggleCollection() {
    setState(() {
      _collecting = !_collecting;
    });

    if (_collecting) {
      _loggingTimer = Timer.periodic(const Duration(milliseconds: 100), (_) {
        setState(() {
          // Simulated mock data for testing
          _lastAccel = [
            0.0 + (0.5 - (1.0 * (DateTime.now().millisecond % 100) / 100)),
            0.1,
            9.8,
          ];
          _lastGyro = [0.02, 0.01, 0.0];
        });

        if (_lastAccel != null && _lastGyro != null) {
          _dataLogger.logSensorData(accel: _lastAccel!, gyro: _lastGyro!);
        }
      });
    } else {
      _loggingTimer?.cancel();
      _shareLogFile();
    }
  }

  void _shareLogFile() async {
    final file = await _dataLogger.saveToCsv('sensor_log');
    print('✅ 로그 파일 저장됨: ${file.path}');
  }

  void _exportLogFile() async {
    final file = await _dataLogger.getSavedFile('sensor_log');
    if (file != null && await file.exists()) {
      Share.shareXFiles([XFile(file.path)], text: '센서 로그 파일 공유');
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('저장된 로그 파일이 없습니다.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Step Tracker')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _collecting ? '센서 수집 중입니다' : '센서 수집을 시작하려면 아래 버튼을 눌러주세요',
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            if (_collecting && _lastAccel != null && _lastGyro != null) ...[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                      '가속도: x=${_lastAccel![0].toStringAsFixed(2)}, y=${_lastAccel![1].toStringAsFixed(2)}, z=${_lastAccel![2].toStringAsFixed(2)}',
                    ),
                    Text(
                      '자이로: x=${_lastGyro![0].toStringAsFixed(2)}, y=${_lastGyro![1].toStringAsFixed(2)}, z=${_lastGyro![2].toStringAsFixed(2)}',
                    ),
                  ],
                ),
              ),
            ],
            ElevatedButton(
              onPressed: _toggleCollection,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(220, 60),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                textStyle: const TextStyle(fontSize: 20),
                backgroundColor: _collecting ? Colors.red : null,
              ),
              child: Text(_collecting ? '센서 수집 중지' : '센서 수집 시작'),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _exportLogFile,
              icon: const Icon(Icons.share),
              label: const Text('로그 파일 내보내기'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleCollection,
        child: Icon(_collecting ? Icons.stop : Icons.play_arrow),
      ),
    );
  }
}
