import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RankingScreen extends StatelessWidget {
  final String? currentUserName;
  const RankingScreen({super.key, this.currentUserName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D3B2E),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('jogadores')
            .orderBy('xp', descending: true)
            .limit(20)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator(color: Colors.greenAccent));
          }

          final jogadores = snapshot.data!.docs;

          return CustomScrollView(
            slivers: [
              _buildAppBar(context),
              if (jogadores.isNotEmpty) _buildPodium(jogadores),
              _buildList(jogadores),
            ],
          );
        },
      ),
    );
  }

  SliverAppBar _buildAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 80,
      pinned: true,
      backgroundColor: const Color(0xFF0D3B2E),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: const FlexibleSpaceBar(
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.emoji_events, color: Colors.amber, size: 22),
            SizedBox(width: 8),
            Text(
              "RANKING GLOBAL",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 1),
            ),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildPodium(List<QueryDocumentSnapshot> jogadores) {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        padding: const EdgeInsets.fromLTRB(8, 24, 8, 0),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1B5E20), Color(0xFF004D40)],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            const Text("🏆 PÓDIO", style: TextStyle(color: Colors.amber, fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 2)),
            const SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // 2º lugar
                Expanded(child: _buildPodiumItem(jogadores, 1, 90, Colors.grey.shade400, "🥈")),
                // 1º lugar
                Expanded(child: _buildPodiumItem(jogadores, 0, 130, Colors.amber, "🥇")),
                // 3º lugar
                Expanded(child: _buildPodiumItem(jogadores, 2, 70, Colors.brown.shade300, "🥉")),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPodiumItem(List<QueryDocumentSnapshot> jogadores, int index, double height, Color color, String medal) {
    if (index >= jogadores.length) return const SizedBox();
    final dados = jogadores[index].data() as Map<String, dynamic>;
    final nome = dados['nome'] ?? "Anônimo";
    final xp = dados['xp'] ?? 0;
    final nivel = (xp ~/ 100) + 1;
    final bool isCurrentUser = currentUserName != null && nome == currentUserName;

    return Column(
      children: [
        Text(medal, style: const TextStyle(fontSize: 28)),
        const SizedBox(height: 6),
        CircleAvatar(
          radius: 24,
          backgroundColor: isCurrentUser ? Colors.yellowAccent : color.withOpacity(0.3),
          child: Text(
            nome.isNotEmpty ? nome[0].toUpperCase() : "?",
            style: TextStyle(color: isCurrentUser ? Colors.black : Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          nome.length > 10 ? "${nome.substring(0, 9)}…" : nome,
          style: TextStyle(
            color: isCurrentUser ? Colors.yellowAccent : Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 11,
          ),
          textAlign: TextAlign.center,
        ),
        Text("Nv $nivel", style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w600)),
        Text("$xp XP", style: const TextStyle(color: Colors.white70, fontSize: 10)),
        const SizedBox(height: 8),
        Container(
          height: height,
          decoration: BoxDecoration(
            color: color.withOpacity(0.25),
            border: Border(top: BorderSide(color: color, width: 2)),
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
          ),
          child: Center(
            child: Text(
              "${index + 1}º",
              style: TextStyle(color: color, fontWeight: FontWeight.w900, fontSize: 22),
            ),
          ),
        ),
      ],
    );
  }

  SliverList _buildList(List<QueryDocumentSnapshot> jogadores) {
    final restantes = jogadores.length > 3 ? jogadores.sublist(3) : <QueryDocumentSnapshot>[];

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          if (index == 0) {
            return const Padding(
              padding: EdgeInsets.fromLTRB(20, 24, 20, 8),
              child: Text("CLASSIFICAÇÃO", style: TextStyle(color: Colors.white54, fontSize: 11, letterSpacing: 2, fontWeight: FontWeight.bold)),
            );
          }
          final i = index - 1;
          if (i >= restantes.length) return const SizedBox(height: 20);

          final dados = restantes[i].data() as Map<String, dynamic>;
          final nome = dados['nome'] ?? "Anônimo";
          final xp = dados['xp'] ?? 0;
          final nivel = (xp ~/ 100) + 1;
          final posicao = i + 4;
          final bool isCurrentUser = currentUserName != null && nome == currentUserName;

          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: isCurrentUser ? Colors.yellowAccent.withOpacity(0.15) : Colors.white.withOpacity(0.06),
              borderRadius: BorderRadius.circular(14),
              border: isCurrentUser ? Border.all(color: Colors.yellowAccent.withOpacity(0.5)) : null,
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              leading: Container(
                width: 36, height: 36,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    "$posicaoº",
                    style: TextStyle(
                      color: isCurrentUser ? Colors.yellowAccent : Colors.white60,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
              title: Text(
                nome,
                style: TextStyle(
                  color: isCurrentUser ? Colors.yellowAccent : Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              subtitle: Text("Nível $nivel", style: const TextStyle(color: Colors.white38, fontSize: 12)),
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.greenAccent.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "$xp XP",
                  style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ),
            ),
          );
        },
        childCount: restantes.length + 2,
      ),
    );
  }
}
