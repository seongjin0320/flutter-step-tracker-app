import 'dart:io';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class DataLogger {
  final List<String> _lines = [
    'timestamp,accel_x,accel_y,accel_z,gyro_x,gyro_y,gyro_z',
  ];

  void logSensorData({
    required List<double> accel,
    required List<double> gyro,
  }) {
    final timestamp = DateFormat(
      "yyyy-MM-ddTHH:mm:ss.SSS",
    ).format(DateTime.now());
    final line =
        '$timestamp,${accel[0]},${accel[1]},${accel[2]},${gyro[0]},${gyro[1]},${gyro[2]}';
    _lines.add(line);
  }

  Future<File> saveToCsv(String filename) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$filename.csv');

    if (await file.exists()) {
      await file.delete();
      print('🗑️ 기존 로그 파일 삭제됨');
    }

    print('📁 CSV 저장 위치: ${file.path}');
    final result = await file.writeAsString(_lines.join('\n'));

    // ✅ 저장 후 메모리 상의 로그도 초기화
    clear();

    return result;
  }

  Future<File?> getSavedFile(String filename) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$filename.csv');
    return file.existsSync() ? file : null;
  }

  void clear() {
    _lines.clear();
    _lines.add('timestamp,accel_x,accel_y,accel_z,gyro_x,gyro_y,gyro_z');
  }
}
