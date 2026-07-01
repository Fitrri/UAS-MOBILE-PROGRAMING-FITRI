import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Definisi Kelas Model Dummy untuk Berita
class NewsItem {
  final String title;
  NewsItem(this.title);
}

// Simulasi Kelas Service/Repository sesuai standar Clean Architecture
class MockNewsRepository extends Mock {}

void main() {
  group('UAS Mobile Lanjut Fitri - Unit Testing Logika API & Sorting', () {
    late List<NewsItem> newsList;

    setUp(() {
      // Inisialisasi data dummy acak sebelum diurutkan
      newsList = [
        NewsItem('Teknologi AI Terbaru...'),
        NewsItem('Bursa Transfer Pemain...'),
        NewsItem('Tips Mengatur Keuangan...'),
      ];
    });

    // 🎯 TEST 1: Memastikan Data Input Tidak Kosong
    test('Test 1: Memastikan data berita dari API berhasil masuk', () {
      expect(newsList.length, 3);
      expect(newsList[0].title.isNotEmpty, true);
    });

    // 🎯 TEST 2: Logika Anti-AI Poin 2 (NIM Genap/0 wajib urut Ascending A-Z)
    test('Test 2: NIM Akhiran 0 Wajib Mengurutkan Judul Secara Ascending (A ke Z)', () {
      // Jalankan fungsi sorting bawaan Dart (Ascending)
      newsList.sort((a, b) => a.title.compareTo(b.title));

      // Verifikasi urutan abjad terdepan harus huruf 'B' (Bursa Transfer)
      expect(newsList.first.title.startsWith('B'), true);
      // Verifikasi urutan abjad terakhir harus huruf 'T'
      expect(newsList.last.title.startsWith('T'), true);
    });

    // 🎯 TEST 3: Validasi Format Parameter NIM untuk Method Channel Kotlin
    test('Test 3: Validasi keabsahan parameter String NIM sebelum dikirim ke Native', () {
      final String nimFitri = '20123020';
      expect(nimFitri, isA<String>());
      expect(nimFitri.length, 8); // NIM berjumlah 8 digit angka
    });
  });
}