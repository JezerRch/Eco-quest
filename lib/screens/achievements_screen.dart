import 'package:flutter/material.dart';

class AchievementsScreen extends StatelessWidget {
  final int xpTotal;
  const AchievementsScreen({super.key, required this.xpTotal});

  List<Map<String, dynamic>> get conquistas => [
    {'titulo': 'Recruta Atento',      'desc': 'Começou sua jornada ambiental',          'xpReq': 0,    'icon': Icons.eco,              'cor': Colors.green},
    {'titulo': 'Primeira Missão',     'desc': 'Completou a primeira fase',               'xpReq': 20,   'icon': Icons.flag,             'cor': Colors.teal},
    {'titulo': 'Guardião das Águas',  'desc': 'Explorou 3 ambientes diferentes',         'xpReq': 60,   'icon': Icons.waves,            'cor': Colors.blue},
    {'titulo': 'Lixeiro Pro',         'desc': 'Completou 5 missões ambientais',          'xpReq': 100,  'icon': Icons.delete_outline,   'cor': Colors.cyan},
    {'titulo': 'Amigo das Árvores',   'desc': 'Chegou a 7 missões concluídas',          'xpReq': 140,  'icon': Icons.terrain,          'cor': Colors.lightGreen},
    {'titulo': 'Herói da Cidade',     'desc': 'Completou todas as 10 missões',          'xpReq': 200,  'icon': Icons.location_city,    'cor': Colors.orange},
    {'titulo': 'Campeão Ecológico',   'desc': 'Acumulou 500 XP de experiência',         'xpReq': 500,  'icon': Icons.military_tech,    'cor': Colors.deepOrange},
    {'titulo': 'Mestre Planetário',   'desc': 'Atingiu 1000 XP — verdadeiro mestre!',  'xpReq': 1000, 'icon': Icons.public,           'cor': Colors.amber},
  ];

  @override
  Widget build(BuildContext context) {
    final int desbloqueados = conquistas.where((c) => xpTotal >= (c['xpReq'] as int)).length;

    return Scaffold(
      backgroundColor: const Color(0xFF0D3B2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D3B2E),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Row(
          children: [
            Icon(Icons.military_tech, color: Colors.amber, size: 22),
            SizedBox(width: 8),
            Text("CONQUISTAS", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 1)),
          ],
        ),
      ),
      body: Column(
        children: [
          // Progresso geral
          Container(
            margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1B5E20), Color(0xFF004D40)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Text("🏆", style: TextStyle(fontSize: 32)),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "$desbloqueados / ${conquistas.length} conquistas",
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      const SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: desbloqueados / conquistas.length,
                          minHeight: 8,
                          backgroundColor: Colors.white12,
                          valueColor: const AlwaysStoppedAnimation<Color>(Colors.amber),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text("$xpTotal XP acumulado", style: const TextStyle(color: Colors.white38, fontSize: 11)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Lista de conquistas
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
              itemCount: conquistas.length,
              itemBuilder: (context, index) {
                final item = conquistas[index];
                final bool desbloqueado = xpTotal >= (item['xpReq'] as int);
                final Color cor = item['cor'] as Color;
                final int faltam = (item['xpReq'] as int) - xpTotal;

                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: desbloqueado ? Colors.white.withOpacity(0.08) : Colors.black26,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: desbloqueado ? cor.withValues(alpha: 0.5) : Colors.white10,
                      width: 1.5,
                    ),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: Container(
                      width: 48, height: 48,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: desbloqueado ? cor.withOpacity(0.2) : Colors.white10,
                      ),
                      child: Icon(
                        item['icon'] as IconData,
                        size: 26,
                        color: desbloqueado ? cor : Colors.white24,
                      ),
                    ),
                    title: Text(
                      (item['titulo'] as String).toUpperCase(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: desbloqueado ? Colors.white : Colors.white38,
                        letterSpacing: 0.5,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 2),
                        Text(
                          item['desc'] as String,
                          style: TextStyle(color: desbloqueado ? Colors.white54 : Colors.white24, fontSize: 12),
                        ),
                        if (!desbloqueado) ...[
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.lock_outline, size: 12, color: Colors.orangeAccent),
                              const SizedBox(width: 4),
                              Text("Faltam $faltam XP", style: const TextStyle(color: Colors.orangeAccent, fontSize: 11, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ],
                      ],
                    ),
                    trailing: desbloqueado
                        ? Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(shape: BoxShape.circle, color: cor.withOpacity(0.2)),
                            child: Icon(Icons.check_circle, color: cor, size: 22),
                          )
                        : null,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
