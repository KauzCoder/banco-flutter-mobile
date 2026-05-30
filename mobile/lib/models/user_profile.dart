class UserProfile {
  const UserProfile({
    required this.id,
    required this.nome,
    required this.email,
    required this.telefone,
    required this.fotoPerfil,
    required this.cpf,
    required this.dataCriacao,
    required this.dataNascimentoDia,
    required this.dataNascimentoMes,
    required this.dataNascimentoAno,
  });

  final String id;
  final String nome;
  final String email;
  final String telefone;
  final String fotoPerfil;
  final String? cpf;
  final DateTime? dataCriacao;
  final String dataNascimentoDia;
  final String dataNascimentoMes;
  final String dataNascimentoAno;

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id']?.toString() ?? '',
      nome: json['nome']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      telefone: json['telefone']?.toString() ?? '',
      fotoPerfil: json['fotoPerfil']?.toString() ?? '',
      cpf: json['cpf']?.toString(),
      dataCriacao: DateTime.tryParse(json['dataCriacao']?.toString() ?? ''),
      dataNascimentoDia: json['dataNascimentoDia']?.toString() ?? '',
      dataNascimentoMes: json['dataNascimentoMes']?.toString() ?? '',
      dataNascimentoAno: json['dataNascimentoAno']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'telefone': telefone,
      'fotoPerfil': fotoPerfil,
      'cpf': cpf,
      'dataCriacao': dataCriacao?.toIso8601String(),
      'dataNascimentoDia': dataNascimentoDia,
      'dataNascimentoMes': dataNascimentoMes,
      'dataNascimentoAno': dataNascimentoAno,
    };
  }

  UserProfile copyWith({
    String? id,
    String? nome,
    String? email,
    String? telefone,
    String? fotoPerfil,
    String? cpf,
    DateTime? dataCriacao,
    String? dataNascimentoDia,
    String? dataNascimentoMes,
    String? dataNascimentoAno,
  }) {
    return UserProfile(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      email: email ?? this.email,
      telefone: telefone ?? this.telefone,
      fotoPerfil: fotoPerfil ?? this.fotoPerfil,
      cpf: cpf ?? this.cpf,
      dataCriacao: dataCriacao ?? this.dataCriacao,
      dataNascimentoDia: dataNascimentoDia ?? this.dataNascimentoDia,
      dataNascimentoMes: dataNascimentoMes ?? this.dataNascimentoMes,
      dataNascimentoAno: dataNascimentoAno ?? this.dataNascimentoAno,
    );
  }
}
