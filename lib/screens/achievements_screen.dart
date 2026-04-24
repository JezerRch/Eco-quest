import 'package:flutter/material.dart';

class AchievementsScreen extends StatelessWidget {
  final int xpTotal;

  const AchievementsScreen({super.key, required this.xpTotal});

  // Lista de conquistas fictícias baseadas em XP
  List<Map<String, dynamic>> get conquistas => [
    {'titulo': 'Recruta Atento', 'desc': 'Começou sua jornada ambiental', 'xpReq': 0, 'icon': Icons.eco},
    {'titulo': 'Lixeiro Pro', 'desc': 'Acertou 10 descartes', 'xpReq': 100, 'icon': Icons.delete_outline},
    {'titulo': 'Guardião das Águas', 'desc': 'Limpou a fase da Praia', 'xpReq': 300, 'icon': Icons.waves},
    {'titulo': 'Amigo das Árvores', 'desc': 'Explorou a Floresta', 'xpReq': 600, 'icon': Icons.terrain},
    {'titulo': 'Herói da Cidade', 'desc': 'Alcançou o nível 10', 'xpReq': 1000, 'icon': Icons.location_city},
    {'titulo': 'Mestre Planetário', 'desc': 'Completou todas as missões', 'xpReq': 2000, 'icon': Icons.public},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("MINHAS CONQUISTAS"),
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
        child: ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: conquistas.length,
          itemBuilder: (context, index) {
            final item = conquistas[index];
            bool desbloqueado = xpTotal >= item['xpReq'];

            return Container(
              margin: const EdgeInsets.only(bottom: 15), // Correção aqui
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: desbloqueado ? Colors.white.withOpacity(0.9) : Colors.black26,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: desbloqueado ? Colors.amber : Colors.white10,
                  width: 2,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    item['icon'],
                    size: 50,
                    color: desbloqueado ? Colors.orange : Colors.grey,
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['titulo'].toUpperCase(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: desbloqueado ? Colors.black87 : Colors.white38,
                          ),
                        ),
                        Text(
                          item['desc'],
                          style: TextStyle(
                            color: desbloqueado ? Colors.black54 : Colors.white24,
                          ),
                        ),
                        if (!desbloqueado)
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(
                              "Faltam ${item['xpReq'] - xpTotal} XP",
                              style: const TextStyle(color: Colors.orangeAccent, fontSize: 12),
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (desbloqueado)
                    const Icon(Icons.check_circle, color: Colors.green),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}