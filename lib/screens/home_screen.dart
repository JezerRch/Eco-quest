import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'game_screen.dart';
import 'ranking_screen.dart';
import 'achievements_screen.dart';

class HomeScreen extends StatefulWidget {
  final String userName;
  const HomeScreen({super.key, required this.userName});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // --- CONSTANTES DE CONFIGURAÇÃO ---
  final List<Map<String, dynamic>> listaDeFases = [
    {'id': 1, 'label': 'PRAIA', 'align': Alignment.centerLeft, 'padding': 40.0},
    {'id': 2, 'label': 'FLORESTA', 'align': Alignment.centerRight, 'padding': 40.0},
    {'id': 3, 'label': 'CIDADE', 'align': Alignment.center, 'padding': 0.0},
    {'id': 4, 'label': 'ESCOLA', 'align': Alignment.centerLeft, 'padding': 60.0},
    {'id': 5, 'label': 'RIO', 'align': Alignment.centerRight, 'padding': 60.0},
    {'id': 6, 'label': 'USINA', 'align': Alignment.center, 'padding': 0.0},
    {'id': 7, 'label': 'RESERVA', 'align': Alignment.centerLeft, 'padding': 30.0},
  ];

  final List<Map<String, dynamic>> listaDeTemas = [
    {'id': 'padrao', 'nome': 'Clássico Ambiental', 'cores': [Color(0xFF81D4FA), Color(0xFF2E7D32)], 'preco': 0},
    {'id': 'crepusculo', 'nome': 'Crepúsculo Roxo', 'cores': [Color(0xFF4527A0), Color(0xFFB71C1C)], 'preco': 500},
    {'id': 'oceano', 'nome': 'Profundezas Azuis', 'cores': [Color(0xFF0D47A1), Color(0xFF00BCD4)], 'preco': 800},
    {'id': 'deserto', 'nome': 'Vale Dourado', 'cores': [Color(0xFFFFB300), Color(0xFFE65100)], 'preco': 1200},
  ];

  // --- LÓGICA AUXILIAR ---
  String _obterTitulo(int nivel) {
    if (nivel <= 2) return "Recrutinha Ambiental";
    if (nivel <= 5) return "Protetor Local";
    if (nivel <= 8) return "Agente Ecológico";
    if (nivel <= 12) return "Guardião da Terra";
    return "Mestre da Sustentabilidade";
  }

  // --- MODAL DE PERFIL ---
  void _mostrarPerfil(Map<String, dynamic> dados, int nivel) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("MEU PERFIL", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircleAvatar(radius: 40, backgroundColor: Colors.green, child: Icon(Icons.person, size: 50, color: Colors.white)),
            const SizedBox(height: 15),
            Text(dados['nome'].toString().toUpperCase(), style: const TextStyle(color: Colors.yellowAccent, fontSize: 20, fontWeight: FontWeight.bold)),
            Text(_obterTitulo(nivel), style: const TextStyle(color: Colors.white70, fontSize: 14)),
            const Divider(color: Colors.white24, height: 30),
            _rowInfoPerfil("Experiência Total:", "${dados['xp']} XP"),
            _rowInfoPerfil("Moedas Acumuladas:", "💰 ${dados['moedas']}"),
            _rowInfoPerfil("Fases Liberadas:", "${(dados['fases_liberadas'] as List).length} / 7"),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("FECHAR", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)))
        ],
      ),
    );
  }

  Widget _rowInfoPerfil(String label, String valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white60, fontSize: 12)),
          Text(valor, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
        ],
      ),
    );
  }

  // --- LOJA DE FUNDOS ---
  void _abrirLoja(String docId, int moedasAtuais, List<dynamic> comprados, String ativo) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text("LOJA DE FUNDOS", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
            const Divider(color: Colors.white24),
            Expanded(
              child: ListView.builder(
                itemCount: listaDeTemas.length,
                itemBuilder: (context, index) {
                  var tema = listaDeTemas[index];
                  bool jaComprado = comprados.contains(tema['id']);
                  bool estaAtivo = ativo == tema['id'];
                  return ListTile(
                    leading: CircleAvatar(child: Container(decoration: BoxDecoration(shape: BoxShape.circle, gradient: LinearGradient(colors: tema['cores'])))),
                    title: Text(tema['nome'], style: const TextStyle(color: Colors.white)),
                    subtitle: Text(jaComprado ? "Adquirido" : "💰 ${tema['preco']}", style: TextStyle(color: Colors.grey[400])),
                    trailing: ElevatedButton(
                      onPressed: () async {
                        if (jaComprado) {
                          await FirebaseFirestore.instance.collection('jogadores').doc(docId).update({'tema_ativo': tema['id']});
                        } else if (moedasAtuais >= tema['preco']) {
                          await FirebaseFirestore.instance.collection('jogadores').doc(docId).update({
                            'moedas': moedasAtuais - tema['preco'],
                            'temas_comprados': FieldValue.arrayUnion([tema['id']]),
                            'tema_ativo': tema['id']
                          });
                        }
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: estaAtivo ? Colors.green : Colors.blueGrey),
                      child: Text(estaAtivo ? "USANDO" : (jaComprado ? "EQUIPAR" : "COMPRAR")),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('jogadores').where('nome', isEqualTo: widget.userName).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) return const Center(child: CircularProgressIndicator());

          var doc = snapshot.data!.docs.first;
          var dados = doc.data() as Map<String, dynamic>;
          String docId = doc.id;
          int xpTotal = dados['xp'] ?? 0;
          int moedas = dados['moedas'] ?? 0;
          List<dynamic> liberadas = List.from(dados['fases_liberadas'] ?? [1]);
          String temaAtivoId = dados['tema_ativo'] ?? 'padrao';
          List<dynamic> temasComprados = dados['temas_comprados'] ?? ['padrao'];
          var temaAtual = listaDeTemas.firstWhere((t) => t['id'] == temaAtivoId, orElse: () => listaDeTemas[0]);
          int nivelCalculado = (xpTotal ~/ 100) + 1;

          return Container(
            decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: List<Color>.from(temaAtual['cores']))),
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 220), // Ajustado para o novo header com nome
                      Text(_obterTitulo(nivelCalculado).toUpperCase(), style: const TextStyle(fontSize: 13, letterSpacing: 2, color: Colors.yellowAccent, fontWeight: FontWeight.bold)),
                      const Text("MISSÕES AMBIENTAIS", style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: Colors.white)),
                      const SizedBox(height: 40),
                      ...listaDeFases.map((fase) => _buildMissionNode(fase, liberadas, docId, xpTotal, nivelCalculado, moedas)).toList(),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
                _buildHeader(dados, nivelCalculado, xpTotal, moedas, docId, temasComprados, temaAtivoId),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMissionNode(Map<String, dynamic> fase, List<dynamic> liberadas, String docId, int xp, int nivel, int moedas) {
    bool isUnlocked = liberadas.contains(fase['id']);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Align(
        alignment: fase['align'],
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: fase['padding']),
          child: GestureDetector(
            onTap: () {
              if (isUnlocked) {
                Navigator.push(context, MaterialPageRoute(builder: (context) => GameScreen(faseId: fase['id'], docId: docId, xpAtual: xp, nivelAtual: nivel, moedasAtuais: moedas)));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Fase bloqueada!")));
              }
            },
            child: Column(
              children: [
                Container(
                  width: 85, height: 85,
                  decoration: BoxDecoration(color: isUnlocked ? Colors.white : Colors.black26, shape: BoxShape.circle, border: Border.all(color: isUnlocked ? Colors.orangeAccent : Colors.white30, width: 5), boxShadow: [if (isUnlocked) const BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 5))]),
                  child: Icon(isUnlocked ? Icons.play_arrow_rounded : Icons.lock_outline, color: isUnlocked ? Colors.green : Colors.white38, size: 50),
                ),
                const SizedBox(height: 8),
                Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4), decoration: BoxDecoration(color: Colors.black38, borderRadius: BorderRadius.circular(10)), child: Text(fase['label'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(Map<String, dynamic> dados, int nivel, int xpTotal, int moedas, String docId, List<dynamic> comprados, String ativo) {
    double percentual = (xpTotal % 100) / 100.0;
    return Positioned(
      top: 0, left: 0, right: 0,
      child: Container(
        padding: const EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 15),
        decoration: BoxDecoration(color: Colors.black.withOpacity(0.8), borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30))),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => _mostrarPerfil(dados, nivel),
                  child: Row(
                    children: [
                      const CircleAvatar(backgroundColor: Colors.green, radius: 18, child: Icon(Icons.person, size: 20, color: Colors.white)),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.userName.toUpperCase(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                          Text("NÍVEL $nivel", style: const TextStyle(color: Colors.yellowAccent, fontSize: 11, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white24)),
                  child: Row(children: [const Text("💰 "), Text("$moedas", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))]),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Stack(
              children: [
                Container(width: double.infinity, height: 8, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(10))),
                Container(width: (MediaQuery.of(context).size.width - 40) * percentual.clamp(0.0, 1.0), height: 8, decoration: BoxDecoration(gradient: const LinearGradient(colors: [Colors.yellow, Colors.orange]), borderRadius: BorderRadius.circular(10))),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildHeaderActionButton(icon: Icons.military_tech, color: Colors.blueAccent, label: "CONQUISTAS", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AchievementsScreen(xpTotal: xpTotal)))),
                _buildHeaderActionButton(icon: Icons.palette, color: Colors.pinkAccent, label: "LOJA", onTap: () => _abrirLoja(docId, moedas, comprados, ativo)),
                _buildHeaderActionButton(icon: Icons.emoji_events, color: Colors.amber, label: "RANKING", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const RankingScreen()))),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderActionButton({required IconData icon, required Color color, required String label, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: color.withOpacity(0.15), shape: BoxShape.circle, border: Border.all(color: color, width: 1.5)), child: Icon(icon, color: color, size: 22)),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}