class ApiConstants {
  const ApiConstants._();

  //Nao esquece trocar o IP para o IP da sua maquina, ou hospedar o backend em algum lugar e colocar a URL aqui
  static const String backendBaseUrl = String.fromEnvironment(
    'BACKEND_BASE_URL',
    defaultValue: 'http://192.168.0.4:3000',
  );
  // Endpoints

  static const String loginUrl = '$backendBaseUrl/auth/login';
  static const String registerUrl = '$backendBaseUrl/auth/register';
  static const String refreshUrl = '$backendBaseUrl/auth/refresh';
  static const String meUrl = '$backendBaseUrl/auth/me';
  static const String quotesUrl = '$backendBaseUrl/quotes';
  static const String transfersUrl = '$backendBaseUrl/transfers';

  static const String transferHistoryUrl = '$backendBaseUrl/transfers/history';
  static const String balanceUrl = '$backendBaseUrl/account/balance';
  static const String summaryUrl = '$backendBaseUrl/account/summary';
  static const String pixKeysUrl = '$backendBaseUrl/pix-keys';
  static const String cardsUrl = '$backendBaseUrl/cards';
  static const String userSettingsUrl = '$backendBaseUrl/user-settings';
  static const String healthUrl = '$backendBaseUrl/health';
  static const String awesomeApiLastUrl =
      'https://economia.awesomeapi.com.br/json/last';
}
