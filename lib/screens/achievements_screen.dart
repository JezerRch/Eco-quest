import 'package:flutter/material.dart';

import '../models/achievement_model.dart';

class AchievementsScreen extends StatelessWidget {
  final int xpTotal;
  final bool praiaConcluida;
  final int diasJogados;
  final bool consumidorConsciente;
  final bool sequenciaVerdeDesbloqueada;
  final DateTime? dataPrimeiroPasso;
  final DateTime? dataMaoNaMassa;
  final DateTime? dataConsumidorConsciente;
  final DateTime? dataSequenciaVerde;
  final bool semDesperdicioDesbloqueada;
  final bool ecoInvestidorDesbloqueada;
  final int mestreReciclagemProgresso;
  final bool mestreReciclagemDesbloqueada;
  final DateTime? dataSemDesperdicio;
  final DateTime? dataEcoInvestidor;
  final DateTime? dataMestreReciclagem;
  final int temasComprados;
  final int totalTemas;
  final int nivelAtual;
  final int respostasRapidas;
  final DateTime? dataColecionadorTemas;
  final DateTime? dataNivelRaiz;
  final DateTime? dataVelocidadeSolar;
  final DateTime? dataLendaSustentavel;

  const AchievementsScreen({
    super.key,
    required this.xpTotal,
    required this.praiaConcluida,
    required this.diasJogados,
    required this.consumidorConsciente,
    required this.sequenciaVerdeDesbloqueada,
    this.dataPrimeiroPasso,
    this.dataMaoNaMassa,
    this.dataConsumidorConsciente,
    this.dataSequenciaVerde,
    required this.semDesperdicioDesbloqueada,
    required this.ecoInvestidorDesbloqueada,
    required this.mestreReciclagemProgresso,
    required this.mestreReciclagemDesbloqueada,
    this.dataSemDesperdicio,
    this.dataEcoInvestidor,
    this.dataMestreReciclagem,
    required this.temasComprados,
    required this.totalTemas,
    required this.nivelAtual,
    required this.respostasRapidas,
    this.dataColecionadorTemas,
    this.dataNivelRaiz,
    this.dataVelocidadeSolar,
    this.dataLendaSustentavel,
  });

  List<AchievementModel> get conquistas => [
    AchievementModel(
      id: 'primeiro_passo',
      titulo: 'Primeiro Passo',
      descricao: 'Completar a 1a fase.',
      imagem: Icons.rocket_launch,
      dificuldade: AchievementDifficulty.facil,
      oculta: false,
      progressoAtual: praiaConcluida ? 1 : 0,
      progressoMeta: 1,
      percentualGlobal: 92,
      dataDesbloqueio: dataPrimeiroPasso,
      exibirBarraProgresso: false,
    ),
    AchievementModel(
      id: 'mao_na_massa',
      titulo: 'Mao na Massa',
      descricao: 'Jogar por 3 dias diferentes.',
      imagem: Icons.calendar_month,
      dificuldade: AchievementDifficulty.facil,
      oculta: false,
      progressoAtual: diasJogados.clamp(0, 3),
      progressoMeta: 3,
      percentualGlobal: 79,
      dataDesbloqueio: dataMaoNaMassa,
    ),
    AchievementModel(
      id: 'consumidor_consciente',
      titulo: 'Consumidor Consciente',
      descricao: 'Comprar o primeiro item na loja.',
      imagem: Icons.shopping_bag,
      dificuldade: AchievementDifficulty.facil,
      oculta: false,
      progressoAtual: consumidorConsciente ? 1 : 0,
      progressoMeta: 1,
      percentualGlobal: 68,
      dataDesbloqueio: dataConsumidorConsciente,
      exibirBarraProgresso: false,
    ),
    AchievementModel(
      id: 'sequencia_verde',
      titulo: 'Sequencia Verde',
      descricao: 'Acertar 5 perguntas seguidas.',
      imagem: Icons.bolt,
      dificuldade: AchievementDifficulty.media,
      oculta: false,
      progressoAtual: sequenciaVerdeDesbloqueada ? 1 : 0,
      progressoMeta: 1,
      percentualGlobal: 51,
      dataDesbloqueio: dataSequenciaVerde,
      exibirBarraProgresso: false,
    ),
    AchievementModel(
      id: 'sem_desperdicio',
      titulo: 'Sem Desperdicio',
      descricao: 'Finalizar 1 fase sem errar.',
      imagem: Icons.done_all,
      dificuldade: AchievementDifficulty.media,
      oculta: false,
      progressoAtual: semDesperdicioDesbloqueada ? 1 : 0,
      progressoMeta: 1,
      percentualGlobal: 42,
      dataDesbloqueio: dataSemDesperdicio,
      exibirBarraProgresso: false,
    ),
    AchievementModel(
      id: 'eco_investidor',
      titulo: 'Eco Investidor',
      descricao: 'Acumular 500 moedas pela primeira vez.',
      imagem: Icons.savings,
      dificuldade: AchievementDifficulty.media,
      oculta: false,
      progressoAtual: ecoInvestidorDesbloqueada ? 1 : 0,
      progressoMeta: 1,
      percentualGlobal: 33,
      dataDesbloqueio: dataEcoInvestidor,
      exibirBarraProgresso: false,
    ),
    AchievementModel(
      id: 'mestre_reciclagem',
      titulo: 'Mestre da Reciclagem',
      descricao: 'Responder 20 perguntas.',
      imagem: Icons.recycling,
      dificuldade: AchievementDifficulty.media,
      oculta: false,
      progressoAtual: mestreReciclagemDesbloqueada ? 20 : mestreReciclagemProgresso,
      progressoMeta: 20,
      percentualGlobal: 28,
      dataDesbloqueio: dataMestreReciclagem,
    ),
    AchievementModel(
      id: 'guardiao_praia',
      titulo: 'Guardiao da Praia',
      descricao: 'Completar todas as missoes da Praia.',
      imagem: Icons.waves,
      dificuldade: AchievementDifficulty.dificil,
      oculta: false,
      progressoAtual: xpTotal,
      progressoMeta: 1100,
      percentualGlobal: 21,
      dataDesbloqueio: xpTotal >= 1100 ? DateTime(2026, 5, 9) : null,
    ),
    AchievementModel(
      id: 'defensor_floresta',
      titulo: 'Defensor da Floresta',
      descricao: 'Completar todas as missoes da Floresta.',
      imagem: Icons.forest,
      dificuldade: AchievementDifficulty.dificil,
      oculta: false,
      progressoAtual: xpTotal,
      progressoMeta: 1300,
      percentualGlobal: 16,
      dataDesbloqueio: xpTotal >= 1300 ? DateTime(2026, 5, 9) : null,
    ),
    AchievementModel(
      id: 'colecionador_temas',
      titulo: 'Colecionador de Temas',
      descricao: 'Obter todos os temas disponiveis na loja.',
      imagem: Icons.palette,
      dificuldade: AchievementDifficulty.dificil,
      oculta: false,
      progressoAtual: temasComprados.clamp(0, totalTemas),
      progressoMeta: totalTemas,
      percentualGlobal: 12,
      dataDesbloqueio: dataColecionadorTemas,
    ),
    AchievementModel(
      id: 'nivel_raiz',
      titulo: 'Nivel Raiz',
      descricao: 'Alcancar nivel 10.',
      imagem: Icons.park,
      dificuldade: AchievementDifficulty.dificil,
      oculta: false,
      progressoAtual: nivelAtual.clamp(0, 10),
      progressoMeta: 10,
      percentualGlobal: 10,
      dataDesbloqueio: dataNivelRaiz,
    ),
    AchievementModel(
      id: 'velocidade_solar',
      titulo: 'Velocidade Solar',
      descricao: 'Responder 10 perguntas em menos de 5 segundos.',
      imagem: Icons.sunny,
      dificuldade: AchievementDifficulty.muitoDificil,
      oculta: false,
      progressoAtual: respostasRapidas.clamp(0, 10),
      progressoMeta: 10,
      percentualGlobal: 8,
      dataDesbloqueio: dataVelocidadeSolar,
    ),
    AchievementModel(
      id: 'top_ranking',
      titulo: 'Top do Ranking',
      descricao: 'Entrar no Top 3 do ranking.',
      imagem: Icons.leaderboard,
      dificuldade: AchievementDifficulty.muitoDificil,
      oculta: true,
      progressoAtual: xpTotal,
      progressoMeta: 2600,
      percentualGlobal: 5,
    ),
    AchievementModel(
      id: 'lenda_sustentavel',
      titulo: 'Lenda Sustentavel',
      descricao: 'Alcancar nivel 25.',
      imagem: Icons.workspace_premium,
      dificuldade: AchievementDifficulty.muitoDificil,
      oculta: false,
      progressoAtual: nivelAtual.clamp(0, 25),
      progressoMeta: 25,
      percentualGlobal: 3,
      dataDesbloqueio: dataLendaSustentavel,
    ),
    AchievementModel(
      id: 'eco_master_supremo',
      titulo: 'Eco Master Supremo',
      descricao: 'Concluir todas as conquistas anteriores.',
      imagem: Icons.emoji_events,
      dificuldade: AchievementDifficulty.muitoDificil,
      oculta: true,
      progressoAtual: xpTotal,
      progressoMeta: 3500,
      percentualGlobal: 1,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final total = conquistas.length;
    final desbloqueadas = conquistas.where((c) => c.desbloqueada).length;
    final listaAlcancadas = conquistas.where((c) => c.desbloqueada).toList();
    final listaBloqueadas = conquistas.where((c) => !c.desbloqueada).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('MINHAS CONQUISTAS'),
        backgroundColor: const Color(0xFF2E7D32),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF2E7D32), Color(0xFF1B5E20)],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildResumoHeader(total: total, desbloqueadas: desbloqueadas),
            const SizedBox(height: 12),
            _buildSecaoTitulo('Conquistas Alcancadas', listaAlcancadas.length),
            const SizedBox(height: 8),
            if (listaAlcancadas.isEmpty)
              _buildSecaoVazia('Nenhuma conquista alcancada ainda.')
            else
              ...listaAlcancadas.map((item) => _buildConquistaCard(item)),
            const SizedBox(height: 6),
            _buildSecaoTitulo('Conquistas Bloqueadas', listaBloqueadas.length),
            const SizedBox(height: 8),
            if (listaBloqueadas.isEmpty)
              _buildSecaoVazia('Voce desbloqueou tudo!')
            else
              ...listaBloqueadas.map((item) => _buildConquistaCard(item)),
          ],
        ),
      ),
    );
  }

  Widget _buildResumoHeader({
    required int total,
    required int desbloqueadas,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        children: [
          _buildResumoItem('Alcancadas', '$desbloqueadas/$total'),
          _buildResumoItem('Bloqueadas', '${total - desbloqueadas}'),
        ],
      ),
    );
  }

  Widget _buildResumoItem(String label, String value) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.w600,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecaoTitulo(String titulo, int quantidade) {
    return Row(
      children: [
        Text(
          titulo,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            fontSize: 15,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.white24,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            '$quantidade',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 11,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSecaoVazia(String mensagem) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white24),
      ),
      child: Text(
        mensagem,
        style: const TextStyle(
          color: Colors.white70,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildConquistaCard(AchievementModel item) {
    final exibicaoOculta = item.oculta && !item.desbloqueada;
    final paleta = AchievementColors.forState(
      desbloqueada: item.desbloqueada,
      dificuldade: item.dificuldade,
    );
    final progressoPercentual = item.progressoMeta > 0
        ? (item.progressoAtual / item.progressoMeta).clamp(0.0, 1.0)
        : 0.0;
    final progressoFaltante =
        (item.progressoMeta - item.progressoAtual).clamp(0, item.progressoMeta);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: paleta.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: paleta.border, width: 2),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.65),
            ),
            child: Icon(
              exibicaoOculta ? Icons.help_outline : item.imagem,
              size: 30,
              color: paleta.icon,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        exibicaoOculta ? 'Conquista Oculta' : item.titulo,
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                          color: paleta.title,
                        ),
                      ),
                    ),
                    _buildDificuldadeChip(item, paleta, exibicaoOculta),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  exibicaoOculta
                      ? '??? Continue jogando para revelar este segredo.'
                      : item.descricao,
                  style: TextStyle(
                    color: paleta.subtitle,
                    fontSize: 13,
                  ),
                ),
                if (item.possuiProgresso && !item.desbloqueada && !exibicaoOculta) ...[
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      minHeight: 9,
                      value: progressoPercentual,
                      backgroundColor: Colors.black12,
                      valueColor: AlwaysStoppedAnimation<Color>(paleta.border),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Faltam $progressoFaltante para desbloquear (${item.progressoAtual}/${item.progressoMeta})',
                    style: TextStyle(
                      color: paleta.subtitle,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
                if (item.desbloqueada) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.event_available,
                        size: 14,
                        color: paleta.subtitle,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Desbloqueada em ${item.dataDesbloqueioLabel}',
                        style: TextStyle(
                          color: paleta.subtitle,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                item.percentualGlobalLabel,
                style: TextStyle(
                  color: paleta.title,
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                'players',
                style: TextStyle(
                  color: paleta.subtitle,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Icon(
                item.desbloqueada ? Icons.check_circle : Icons.lock,
                color: item.desbloqueada ? paleta.border : paleta.icon,
                size: 20,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDificuldadeChip(
    AchievementModel item,
    AchievementPalette paleta,
    bool exibicaoOculta,
  ) {
    final texto = exibicaoOculta
        ? 'SECRETA'
        : switch (item.dificuldade) {
            AchievementDifficulty.facil => 'FACIL',
            AchievementDifficulty.media => 'MEDIA',
            AchievementDifficulty.dificil => 'DIFICIL',
            AchievementDifficulty.muitoDificil => 'MUITO DIFICIL',
          };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: paleta.border.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: paleta.border.withValues(alpha: 0.35)),
      ),
      child: Text(
        texto,
        style: TextStyle(
          color: paleta.title,
          fontSize: 10,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
