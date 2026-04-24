import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RankingScreen extends StatelessWidget {
  const RankingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ranking Global"),
        backgroundColor: const Color(0xFF2E7D32),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF81D4FA), Color(0xFF2E7D32)],
          ),
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('jogadores')
              .orderBy('xp', descending: true) // Ordena pelo maior XP
              .limit(20) // Top 20
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

            var jogadores = snapshot.data!.docs;

            return ListView.builder(
              itemCount: jogadores.length,
              itemBuilder: (context, index) {
                var dados = jogadores[index].data() as Map<String, dynamic>;
                int nivel = (dados['xp'] ?? 0) ~/ 100 + 1;

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  color: Colors.white.withOpacity(0.9),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: _getPosColor(index),
                      child: Text("${index + 1}º", style: const TextStyle(color: Colors.white)),
                    ),
                    title: Text(dados['nome'] ?? "Anônimo", style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text("Nível $nivel"),
                    trailing: Text("${dados['xp']} XP", style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Color _getPosColor(int index) {
    if (index == 0) return Colors.amber; // Ouro
    if (index == 1) return Colors.grey;  // Prata
    if (index == 2) return Colors.brown; // Bronze
    return Colors.blueAccent;
  }
}