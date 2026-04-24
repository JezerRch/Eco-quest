import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RankingScreen extends StatefulWidget {
  const RankingScreen({super.key});

  @override
  State<RankingScreen> createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  List<Map<String, dynamic>> rankingData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRanking();
  }

  Future<void> _loadRanking() async {
    // jogador local
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userName = prefs.getString('user_name') ?? "Você";
    int userXp = prefs.getInt('xp') ?? 0;

    // Dados Mockados
    List<Map<String, dynamic>> jogadores = [
      {'nome': 'Maria.Eco', 'xp': 1520, 'isMe': false},
      {'nome': 'João Silva', 'xp': 1100, 'isMe': false},
      {'nome': 'Ana Natureza', 'xp': 850, 'isMe': false},
      {'nome': 'Pedro Henrique', 'xp': 600, 'isMe': false},
      {'nome': 'Luiza_Verde', 'xp': 450, 'isMe': false},
      {'nome': 'Bia SalvaMundo', 'xp': 300, 'isMe': false},
      {'nome': 'Carlos_Edu', 'xp': 150, 'isMe': false},
      {'nome': 'Bot_Reciclador', 'xp': 50, 'isMe': false},
      {'nome': '$userName (Você)', 'xp': userXp, 'isMe': true},
    ];

    // Ordena a lista pelo XP (do maior para o menor)
    jogadores.sort((a, b) => b['xp'].compareTo(a['xp']));

    setState(() {
      rankingData = jogadores;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ranking Global (Simulado)"),
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
        child: isLoading
            ? const Center(child: CircularProgressIndicator(color: Colors.white))
            : ListView.builder(
                itemCount: rankingData.length,
                itemBuilder: (context, index) {
                  var dados = rankingData[index];
                  int nivel = (dados['xp'] ~/ 100) + 1;
                  bool isMe = dados['isMe'];

                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    // Destaca o card do usuário com uma cor diferente
                    color: isMe ? Colors.yellow.shade100 : Colors.white.withOpacity(0.9),
                    elevation: isMe ? 5 : 1,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: _getPosColor(index),
                        child: Text("${index + 1}º", style: const TextStyle(color: Colors.white)),
                      ),
                      title: Text(
                        dados['nome'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isMe ? Colors.green.shade800 : Colors.black87,
                        )
                      ),
                      subtitle: Text("Nível $nivel"),
                      trailing: Text(
                        "${dados['xp']} XP",
                        style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }

  Color _getPosColor(int index) {
    if (index == 0) return Colors.amber; // Ouro
    if (index == 1) return const Color(0xFFBDBDBD); // Prata
    if (index == 2) return const Color(0xFF8D6E63); // Bronze
    return Colors.blueAccent;
  }
}