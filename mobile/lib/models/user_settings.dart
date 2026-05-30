class UserSettings {
  const UserSettings({
    required this.id,
    required this.userId,
    required this.biometriaAtiva,
    required this.idioma,
    required this.notificacoesAtivas,
    required this.temaEscuro,
  });

  final String id;
  final String userId;
  final bool biometriaAtiva;
  final String idioma;
  final bool notificacoesAtivas;
  final bool temaEscuro;

  factory UserSettings.fromJson(Map<String, dynamic> json) {
    return UserSettings(
      id: json['id']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      biometriaAtiva: json['biometriaAtiva'] == true,
      idioma: json['idioma']?.toString() ?? 'pt-BR',
      notificacoesAtivas: json['notificacoesAtivas'] != false,
      temaEscuro: json['temaEscuro'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'biometriaAtiva': biometriaAtiva,
      'idioma': idioma,
      'notificacoesAtivas': notificacoesAtivas,
      'temaEscuro': temaEscuro,
    };
  }

  UserSettings copyWith({
    String? id,
    String? userId,
    bool? biometriaAtiva,
    String? idioma,
    bool? notificacoesAtivas,
    bool? temaEscuro,
  }) {
    return UserSettings(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      biometriaAtiva: biometriaAtiva ?? this.biometriaAtiva,
      idioma: idioma ?? this.idioma,
      notificacoesAtivas: notificacoesAtivas ?? this.notificacoesAtivas,
      temaEscuro: temaEscuro ?? this.temaEscuro,
    );
  }
}
