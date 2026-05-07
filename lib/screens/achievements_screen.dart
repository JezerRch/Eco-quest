import 'package:flutter/material.dart';

class AchievementsScreen extends StatelessWidget {
  final int xpTotal;
  const AchievementsScreen({super.key, required this.xpTotal});

  static const List<Map<String, dynamic>> _conquistas = [
    {'titulo': 'Recrutinha Ambiental',   'desc': 'Deu o primeiro passo na sua jornada verde',          'xpReq': 0,    'icon': Icons.eco_rounded,              'cor': Color(0xFF43A047)},
    {'titulo': 'Primeira Missão',        'desc': 'Completou a primeira fase com sucesso',               'xpReq': 20,   'icon': Icons.flag_rounded,             'cor': Color(0xFF26A69A)},
    {'titulo': 'Guardião das Águas',     'desc': 'Limpou ao menos três ambientes diferentes',          'xpReq': 60,   'icon': Icons.waves_rounded,            'cor': Color(0xFF1E88E5)},
    {'titulo': 'Lixeiro Profissional',   'desc': 'Acumulou 100 XP de experiência ambiental',           'xpReq': 100,  'icon': Icons.delete_outline_rounded,   'cor': Color(0xFF00ACC1)},
    {'titulo': 'Amigo da Floresta',      'desc': 'Chegou à fase 7 sem desistir',                       'xpReq': 140,  'icon': Icons.park_rounded,             'cor': Color(0xFF7CB342)},
    {'titulo': 'Detetive Ambiental',     'desc': 'Identificou 30 tipos de resíduos',                   'xpReq': 200,  'icon': Icons.search_rounded,           'cor': Color(0xFF8E24AA)},
    {'titulo': 'Caçador de Combos',      'desc': 'Alcançou combos incríveis durante o jogo',           'xpReq': 280,  'icon': Icons.local_fire_department_rounded, 'cor': Color(0xFFF4511E)},
    {'titulo': 'Herói da Cidade',        'desc': 'Completou todas as 10 missões ambientais',           'xpReq': 380,  'icon': Icons.location_city_rounded,    'cor': Color(0xFFFF8F00)},
    {'titulo': 'Mestre das Lixeiras',    'desc': 'Nunca mais errou a separação do lixo',              'xpReq': 500,  'icon': Icons.recycling_rounded,        'cor': Color(0xFF039BE5)},
    {'titulo': 'Campeão Ecológico',      'desc': 'Acumulou 700 XP de experiência total',              'xpReq': 700,  'icon': Icons.military_tech_rounded,    'cor': Color(0xFFE53935)},
    {'titulo': 'Lenda Verde',            'desc': 'Uma referência na preservação ambiental',            'xpReq': 850,  'icon': Icons.workspace_premium_rounded,'cor': Color(0xFF00897B)},
    {'titulo': 'Mestre Planetário',      'desc': 'Atingiu 1000 XP — o máximo da jornada!',           'xpReq': 1000, 'icon': Icons.public_rounded,           'cor': Color(0xFFFDD835)},
  ];

  @override
  Widget build(BuildContext context) {
    final desbloqueados = _conquistas.where((c) => xpTotal >= (c['xpReq'] as int)).length;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0A1628), Color(0xFF0D2610)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context, desbloqueados),
              _buildProgresso(desbloqueados),
              Expanded(child: _buildLista()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, int desbloqueados) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.08),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
              ),
              child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18),
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'CONQUISTAS',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 20, letterSpacing: 1.5),
                ),
                Text(
                  'Desbloqueie todas completando as missões',
                  style: TextStyle(color: Colors.white38, fontSize: 11),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.amber.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.amber.withValues(alpha: 0.35)),
            ),
            child: Row(
              children: [
                const Icon(Icons.emoji_events_rounded, color: Colors.amber, size: 16),
                const SizedBox(width: 5),
                Text(
                  '$desbloqueados/${_conquistas.length}',
                  style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgresso(int desbloqueados) {
    final pct = desbloqueados / _conquistas.length;
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1B5E20), Color(0xFF004D40)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.green.withValues(alpha: 0.2), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Text('🏆', style: TextStyle(fontSize: 26)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '$desbloqueados de ${_conquistas.length} conquistas',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    Text(
                      '${(pct * 100).toInt()}%',
                      style: const TextStyle(color: Colors.yellowAccent, fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: pct,
                    minHeight: 8,
                    backgroundColor: Colors.white.withValues(alpha: 0.12),
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.amber),
                  ),
                ),
                const SizedBox(height: 5),
                Text('$xpTotal XP acumulado', style: const TextStyle(color: Colors.white38, fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLista() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
      itemCount: _conquistas.length,
      itemBuilder: (_, index) {
        final item = _conquistas[index];
        final desbloqueado = xpTotal >= (item['xpReq'] as int);
        final cor = item['cor'] as Color;
        final faltam = (item['xpReq'] as int) - xpTotal;

        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: desbloqueado
                ? cor.withValues(alpha: 0.08)
                : Colors.white.withValues(alpha: 0.03),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: desbloqueado ? cor.withValues(alpha: 0.4) : Colors.white.withValues(alpha: 0.06),
              width: 1.5,
            ),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            leading: Container(
              width: 48, height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: desbloqueado ? cor.withValues(alpha: 0.18) : Colors.white.withValues(alpha: 0.06),
              ),
              child: Icon(
                item['icon'] as IconData,
                size: 24,
                color: desbloqueado ? cor : Colors.white.withValues(alpha: 0.2),
              ),
            ),
            title: Text(
              (item['titulo'] as String).toUpperCase(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: desbloqueado ? Colors.white : Colors.white.withValues(alpha: 0.3),
                letterSpacing: 0.4,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 2),
                Text(
                  item['desc'] as String,
                  style: TextStyle(
                    color: desbloqueado ? Colors.white54 : Colors.white.withValues(alpha: 0.18),
                    fontSize: 11,
                  ),
                ),
                if (!desbloqueado) ...[
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(Icons.lock_outline_rounded, size: 11, color: Colors.orangeAccent),
                      const SizedBox(width: 4),
                      Text(
                        'Faltam $faltam XP',
                        style: const TextStyle(color: Colors.orangeAccent, fontSize: 10, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ],
              ],
            ),
            trailing: desbloqueado
                ? Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(shape: BoxShape.circle, color: cor.withValues(alpha: 0.15)),
                    child: Icon(Icons.check_circle_rounded, color: cor, size: 22),
                  )
                : Container(
                    padding: const EdgeInsets.all(5),
                    child: Text(
                      '${item['xpReq']} XP',
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.2), fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
          ),
        );
      },
    );
  }
}
