class EnvConfig {
  EnvConfig._();

  
  static const String environment = String.fromEnvironment('ENV_NAME', defaultValue: 'DEV');
  
  // DATA ASLI FITRI
  static const String namaDepan = String.fromEnvironment('NAMA_DEPAN', defaultValue: 'Fitri');
  static const String nimLengkap = String.fromEnvironment('NIM_ANDA', defaultValue: '20123020');

  static const String baseUrl = String.fromEnvironment(
    'BASE_URL', 
    defaultValue: 'https://newsapi.org/v2/', 
  );

  static bool get isProduction => environment == 'PROD';

  
  static String get appName {
    return isProduction ? 'UTD - $nimLengkap' : 'DEV - $namaDepan';
  }
}