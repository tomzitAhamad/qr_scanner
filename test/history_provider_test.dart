import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:qr_code_scanner/core/providers/history_provider.dart';
import 'package:qr_code_scanner/core/providers/settings_provider.dart';

void main() {
  group('HistoryProvider Tests with Settings Integration', () {
    late SettingsProvider settingsProvider;
    late HistoryProvider historyProvider;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      settingsProvider = await SettingsProvider.create();
      historyProvider = HistoryProvider(settingsProvider);
    });

    test('Adding duplicate items are kept by default in history', () {
      historyProvider.addHistoryItem(data: 'test_data', type: 'Camera');
      historyProvider.addHistoryItem(data: 'test_data', type: 'Camera');

      expect(historyProvider.items.length, 2);
      expect(historyProvider.items[0].data, 'test_data');
      expect(historyProvider.items[1].data, 'test_data');
    });

    test('Respects addScansToHistory setting', () {
      settingsProvider.setAddScansToHistory(true);
      historyProvider.addHistoryItem(data: 'camera_scan', type: 'Camera');
      historyProvider.addHistoryItem(data: 'image_scan', type: 'Image');
      expect(historyProvider.items.length, 2);

      historyProvider.clearHistory();

      settingsProvider.setAddScansToHistory(false);
      historyProvider.addHistoryItem(data: 'camera_scan', type: 'Camera');
      historyProvider.addHistoryItem(data: 'image_scan', type: 'Image');
      expect(historyProvider.items.isEmpty, true);

      historyProvider.addHistoryItem(data: 'generated_qr', type: 'URL');
      expect(historyProvider.items.length, 1);
      expect(historyProvider.items[0].data, 'generated_qr');
    });
  });
}
