import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RankingScreen extends StatelessWidget {
  final String userName;
  const RankingScreen({super.key, required this.userName});

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
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('jogadores')
                    .orderBy('xp', descending: true)
                    .limit(20)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) return Center(child: Text('Erro ao carregar ranking: ${snapshot.error}'));
                  if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

                  var jogadores = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: jogadores.length,
                    itemBuilder: (context, index) {
                      var dados = jogadores[index].data() as Map<String, dynamic>;
                      int nivel = (dados['xp'] ?? 0) ~/ 100 + 1;

                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                        color: Colors.white.withValues(alpha: 0.9),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: _getPosColor(index),
                            child: Text("${index + 1}º", style: const TextStyle(color: Colors.white)),
                          ),
                          title: Text(dados['nome'] ?? "Anônimo", style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text("Nível $nivel"),
                          trailing: Text("${dados['xp'] ?? 0} XP", style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            FutureBuilder<QuerySnapshot>(
              future: FirebaseFirestore.instance
                  .collection('jogadores')
                  .orderBy('xp', descending: true)
                  .get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Padding(
                    padding: EdgeInsets.all(12),
                    child: CircularProgressIndicator(),
                  );
                }
                final todos = snapshot.data!.docs;
                final total = todos.length;
                int posicao = -1;
                for (int i = 0; i < todos.length; i++) {
                  final d = todos[i].data() as Map<String, dynamic>;
                  if ((d['nome'] ?? '') == userName) {
                    posicao = i + 1;
                    break;
                  }
                }

                return Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(12),
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white38, width: 1.5),
                  ),
                  child: Text(
                    posicao > 0
                        ? "Sua posição: #$posicao de $total jogadores"
                        : "Você ainda não aparece no ranking",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Color _getPosColor(int index) {
    if (index == 0) return Colors.amber;
    if (index == 1) return Colors.grey;
    if (index == 2) return Colors.brown;
    return Colors.blueAccent;
  }
}
