import 'package:flutter/material.dart';

enum AchievementDifficulty { facil, media, dificil, muitoDificil }

class AchievementModel {
  final String id;
  final String titulo;
  final String descricao;
  final IconData imagem;
  final AchievementDifficulty dificuldade;
  final bool oculta;
  final int progressoAtual;
  final int progressoMeta;
  final double percentualGlobal;
  final int? jogadoresDesbloquearam;
  final int? jogadoresTotal;
  final DateTime? dataDesbloqueio;
  final bool exibirBarraProgresso;

  const AchievementModel({
    required this.id,
    required this.titulo,
    required this.descricao,
    required this.imagem,
    required this.dificuldade,
    required this.oculta,
    required this.progressoAtual,
    required this.progressoMeta,
    required this.percentualGlobal,
    this.jogadoresDesbloquearam,
    this.jogadoresTotal,
    this.dataDesbloqueio,
    this.exibirBarraProgresso = true,
  });

  bool get desbloqueada => progressoAtual >= progressoMeta;
  bool get possuiProgresso => exibirBarraProgresso && progressoMeta > 1;

  String get dataDesbloqueioLabel {
    if (dataDesbloqueio == null) return '--/--/----';
    final d = dataDesbloqueio!;
    final dia = d.day.toString().padLeft(2, '0');
    final mes = d.month.toString().padLeft(2, '0');
    final ano = d.year.toString();
    return '$dia/$mes/$ano';
  }

  String get percentualGlobalLabel {
    if (jogadoresDesbloquearam != null &&
        jogadoresTotal != null &&
        jogadoresTotal! > 0) {
      final valor = (jogadoresDesbloquearam! / jogadoresTotal!) * 100;
      return '${valor.toStringAsFixed(0)}%';
    }

    if (percentualGlobal < 0) return '--%';
    return '${percentualGlobal.toStringAsFixed(0)}%';
  }
}

class AchievementPalette {
  final Color background;
  final Color border;
  final Color icon;
  final Color title;
  final Color subtitle;

  const AchievementPalette({
    required this.background,
    required this.border,
    required this.icon,
    required this.title,
    required this.subtitle,
  });
}

class AchievementColors {
  static const AchievementPalette bloqueada = AchievementPalette(
    background: Color(0xFF4A4A4A),
    border: Color(0xFF8A8A8A),
    icon: Color(0xFFC4C4C4),
    title: Color(0xFFE5E5E5),
    subtitle: Color(0xFFCDCDCD),
  );

  static const AchievementPalette facil = AchievementPalette(
    background: Color(0xFFE9F7EF),
    border: Color(0xFF2E7D32),
    icon: Color(0xFF1B5E20),
    title: Color(0xFF144D17),
    subtitle: Color(0xFF2E5A31),
  );

  static const AchievementPalette media = AchievementPalette(
    background: Color(0xFFE8F1FF),
    border: Color(0xFF1565C0),
    icon: Color(0xFF0D47A1),
    title: Color(0xFF0B3D8A),
    subtitle: Color(0xFF285E9B),
  );

  static const AchievementPalette dificil = AchievementPalette(
    background: Color(0xFFFFF3E0),
    border: Color(0xFFF57C00),
    icon: Color(0xFFE65100),
    title: Color(0xFF8A3A00),
    subtitle: Color(0xFFAD5A13),
  );

  static const AchievementPalette muitoDificil = AchievementPalette(
    background: Color(0xFFFFF8E1),
    border: Color(0xFFFFC107),
    icon: Color(0xFFFF8F00),
    title: Color(0xFF7A5200),
    subtitle: Color(0xFF966A00),
  );

  static AchievementPalette forState({
    required bool desbloqueada,
    required AchievementDifficulty dificuldade,
  }) {
    if (!desbloqueada) return bloqueada;

    switch (dificuldade) {
      case AchievementDifficulty.facil:
        return facil;
      case AchievementDifficulty.media:
        return media;
      case AchievementDifficulty.dificil:
        return dificil;
      case AchievementDifficulty.muitoDificil:
        return muitoDificil;
    }
  }
}
