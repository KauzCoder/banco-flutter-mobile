class ApiConstants {
  const ApiConstants._();

  static const String backendBaseUrl = 'http://10.0.0.194:3000';

  static const String loginUrl           = '$backendBaseUrl/auth/login';
  static const String registerUrl        = '$backendBaseUrl/auth/register';
  static const String refreshUrl         = '$backendBaseUrl/auth/refresh';
  static const String meUrl             = '$backendBaseUrl/auth/me';
  static const String quotesUrl          = '$backendBaseUrl/quotes';
  static const String transfersUrl       = '$backendBaseUrl/transfers';
  static const String transferHistoryUrl = '$backendBaseUrl/transfers/history';
  static const String balanceUrl         = '$backendBaseUrl/account/balance';
  static const String summaryUrl         = '$backendBaseUrl/account/summary';
  static const String pixKeysUrl         = '$backendBaseUrl/pix-keys';
  static const String userSettingsUrl    = '$backendBaseUrl/user-settings';
  static const String healthUrl          = '$backendBaseUrl/health';
}