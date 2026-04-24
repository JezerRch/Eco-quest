import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Removido o cloud_firestore
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
  bool _isLoading = true;

  // Variáveis de estado locais
  int xpTotal = 0;
  int moedas = 0;
  List<int> fasesLiberadas = [1];
  String temaAtivoId = 'padrao';
  List<String> temasComprados = ['padrao'];

  final List<Map<String, dynamic>> listaDeFases = [
    {'id': 1,  'label': 'PRAIA',       'emoji': '🏖️', 'align': Alignment.centerLeft,  'padding': 40.0},
    {'id': 2,  'label': 'FLORESTA',    'emoji': '🌲', 'align': Alignment.centerRight, 'padding': 40.0},
    {'id': 3,  'label': 'CIDADE',      'emoji': '🏙️', 'align': Alignment.center,      'padding': 0.0},
    {'id': 4,  'label': 'ESCOLA',      'emoji': '🏫', 'align': Alignment.centerLeft,  'padding': 60.0},
    {'id': 5,  'label': 'RIO',         'emoji': '🏞️', 'align': Alignment.centerRight, 'padding': 60.0},
    {'id': 6,  'label': 'USINA',       'emoji': '⚡', 'align': Alignment.center,      'padding': 0.0},
    {'id': 7,  'label': 'RESERVA',     'emoji': '🌿', 'align': Alignment.centerLeft,  'padding': 30.0},
    {'id': 8,  'label': 'MONTANHA',    'emoji': '🏔️', 'align': Alignment.centerRight, 'padding': 50.0},
    {'id': 9,  'label': 'OCEANO',      'emoji': '🌊', 'align': Alignment.center,      'padding': 0.0},
    {'id': 10, 'label': 'SUSTENTÁVEL', 'emoji': '🌍', 'align': Alignment.centerLeft,  'padding': 40.0},
  ];

  final List<Map<String, dynamic>> listaDeTemas = [
    {'id': 'padrao',    'nome': 'Clássico Ambiental', 'cores': [Color(0xFF81D4FA), Color(0xFF2E7D32)], 'preco': 0},
    {'id': 'crepusculo','nome': 'Crepúsculo Roxo',    'cores': [Color(0xFF4527A0), Color(0xFFB71C1C)], 'preco': 500},
    {'id': 'oceano',    'nome': 'Profundezas Azuis',  'cores': [Color(0xFF0D47A1), Color(0xFF00BCD4)], 'preco': 800},
    {'id': 'deserto',   'nome': 'Vale Dourado',       'cores': [Color(0xFFFFB300), Color(0xFFE65100)], 'preco': 1200},
  ];

  @override
  void initState() {
    super.initState();
    _carregarDadosLocais();
  }

  // Função para carregar os dados offline
  Future<void> _carregarDadosLocais() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      xpTotal = prefs.getInt('xp') ?? 0;
      moedas = prefs.getInt('moedas') ?? 0;
      temaAtivoId = prefs.getString('tema_ativo') ?? 'padrao';
      temasComprados = prefs.getStringList('temas_comprados') ?? ['padrao'];

      // Converte a lista de strings salva no cache para inteiros
      List<String> fasesStr = prefs.getStringList('fases_liberadas') ?? ['1'];
      fasesLiberadas = fasesStr.map((e) => int.tryParse(e) ?? 1).toList();

      _isLoading = false;
    });
  }

  String _obterTitulo(int nivel) {
    if (nivel <= 2)  return "Recrutinha Ambiental";
    if (nivel <= 5)  return "Protetor Local";
    if (nivel <= 8)  return "Agente Ecológico";
    if (nivel <= 12) return "Guardião da Terra";
    if (nivel <= 18) return "Guardião do Planeta";
    return "Mestre da Sustentabilidade";
  }

  void _mostrarPerfil(int nivel) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("MEU PERFIL", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.green.withOpacity(0.2)),
              child: const Icon(Icons.person, size: 48, color: Colors.greenAccent),
            ),
            const SizedBox(height: 12),
            Text(widget.userName.toUpperCase(), style: const TextStyle(color: Colors.yellowAccent, fontSize: 18, fontWeight: FontWeight.bold)),
            Text(_obterTitulo(nivel), style: const TextStyle(color: Colors.white60, fontSize: 13)),
            const Divider(color: Colors.white12, height: 28),
            _rowInfoPerfil("⭐ Experiência Total:", "$xpTotal XP"),
            _rowInfoPerfil("💰 Moedas Acumuladas:", "$moedas"),
            _rowInfoPerfil("🗺️ Nível:", "$nivel"),
            _rowInfoPerfil("🔓 Fases Desbloqueadas:", "${fasesLiberadas.length} / 10"),
          ],
        ),
        actions: [
          Center(
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("FECHAR", style: TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _rowInfoPerfil(String label, String valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white54, fontSize: 12)),
          Text(valor, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
        ],
      ),
    );
  }

  void _abrirLoja() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A2E),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => StatefulBuilder( // StatefulBuilder para atualizar a tela da loja na hora
        builder: (context, setModalState) {
          return Container(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
            child: Column(
              children: [
                Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2))),
                const SizedBox(height: 16),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.palette, color: Colors.pinkAccent, size: 20),
                    SizedBox(width: 8),
                    Text("LOJA DE TEMAS", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 4),
                Text("💰 $moedas moedas disponíveis", style: const TextStyle(color: Colors.white38, fontSize: 12)),
                const SizedBox(height: 12),
                Expanded(
                  child: ListView.separated(
                    itemCount: listaDeTemas.length,
                    separatorBuilder: (_, __) => const Divider(color: Colors.white10, height: 1),
                    itemBuilder: (context, index) {
                      var tema = listaDeTemas[index];
                      bool jaComprado = temasComprados.contains(tema['id']);
                      bool estaAtivo = temaAtivoId == tema['id'];
                      final cores = List<Color>.from(tema['cores']);

                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                        leading: Container(
                          width: 44, height: 44,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(colors: cores),
                            boxShadow: [BoxShadow(color: cores.last.withOpacity(0.4), blurRadius: 6)],
                          ),
                        ),
                        title: Text(tema['nome'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                        subtitle: Text(
                          jaComprado ? "✅ Adquirido" : "💰 ${tema['preco']}",
                          style: TextStyle(color: jaComprado ? Colors.greenAccent : Colors.white38, fontSize: 12),
                        ),
                        trailing: SizedBox(
                          width: 90,
                          child: ElevatedButton(
                            onPressed: () async {
                              SharedPreferences prefs = await SharedPreferences.getInstance();

                              if (jaComprado) {
                                await prefs.setString('tema_ativo', tema['id']);
                              } else if (moedas >= (tema['preco'] as int)) {
                                // Compra o tema
                                int novasMoedas = moedas - (tema['preco'] as int);
                                await prefs.setInt('moedas', novasMoedas);

                                List<String> novosTemas = List.from(temasComprados)..add(tema['id']);
                                await prefs.setStringList('temas_comprados', novosTemas);
                                await prefs.setString('tema_ativo', tema['id']);
                              }

                              if (context.mounted) Navigator.pop(context);
                              _carregarDadosLocais(); // Atualiza a Home Screen
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: estaAtivo ? Colors.green : (jaComprado ? Colors.blueGrey.shade700 : Colors.pinkAccent),
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            child: Text(
                              estaAtivo ? "USANDO" : (jaComprado ? "EQUIPAR" : "COMPRAR"),
                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        }
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFF1A1A2E),
        body: Center(child: CircularProgressIndicator(color: Colors.greenAccent)),
      );
    }

    final temaAtual = listaDeTemas.firstWhere((t) => t['id'] == temaAtivoId, orElse: () => listaDeTemas[0]);
    final int nivelCalculado = (xpTotal ~/ 100) + 1;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: List<Color>.from(temaAtual['cores']),
          ),
        ),
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 210),
                  Text(
                    _obterTitulo(nivelCalculado).toUpperCase(),
                    style: const TextStyle(fontSize: 12, letterSpacing: 2, color: Colors.yellowAccent, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  const Text("MISSÕES AMBIENTAIS", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.white)),
                  const SizedBox(height: 36),
                  ...listaDeFases.map((fase) => _buildMissionNode(fase, nivelCalculado)),
                  const SizedBox(height: 80),
                ],
              ),
            ),
            _buildHeader(nivelCalculado),
          ],
        ),
      ),
    );
  }

  Widget _buildMissionNode(Map<String, dynamic> fase, int nivel) {
    final bool isUnlocked = fasesLiberadas.contains(fase['id']);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 22),
      child: Align(
        alignment: fase['align'],
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: fase['padding']),
          child: GestureDetector(
            onTap: () {
              if (isUnlocked) {
                // Ao fechar a GameScreen, recarrega os dados caso o jogador tenha ganho XP
                Navigator.push(context, MaterialPageRoute(
                  builder: (_) => GameScreen(
                    faseId: fase['id'],
                    docId: "offline_user", // Como não temos mais firebase, o ID não importa aqui
                    xpAtual: xpTotal,
                    nivelAtual: nivel,
                    moedasAtuais: moedas,
                  ),
                )).then((_) => _carregarDadosLocais());
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text("🔒 Complete a fase anterior para desbloquear!"),
                    backgroundColor: Colors.black87,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                );
              }
            },
            child: Column(
              children: [
                Container(
                  width: 80, height: 80,
                  decoration: BoxDecoration(
                    color: isUnlocked ? Colors.white : Colors.black26,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isUnlocked ? Colors.orangeAccent : Colors.white24,
                      width: 4,
                    ),
                    boxShadow: isUnlocked
                        ? [const BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 4))]
                        : null,
                  ),
                  child: Center(
                    child: isUnlocked
                        ? Text(fase['emoji'], style: const TextStyle(fontSize: 34))
                        : const Icon(Icons.lock_outline, color: Colors.white38, size: 34),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: isUnlocked ? Colors.black45 : Colors.black26,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "${fase['label']}",
                    style: TextStyle(
                      color: isUnlocked ? Colors.white : Colors.white38,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(int nivel) {
    final double percentual = (xpTotal % 100) / 100.0;

    return Positioned(
      top: 0, left: 0, right: 0,
      child: Container(
        padding: const EdgeInsets.only(top: 48, left: 20, right: 20, bottom: 16),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.75),
          borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(28), bottomRight: Radius.circular(28)),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => _mostrarPerfil(nivel),
                  child: Row(
                    children: [
                      Container(
                        width: 40, height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.green.withOpacity(0.3),
                          border: Border.all(color: Colors.greenAccent, width: 1.5),
                        ),
                        child: const Icon(Icons.person, size: 22, color: Colors.greenAccent),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.userName.toUpperCase(),
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          Text("NÍVEL $nivel", style: const TextStyle(color: Colors.yellowAccent, fontSize: 11, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.amber.withOpacity(0.4)),
                  ),
                  child: Row(
                    children: [
                      const Text("💰", style: TextStyle(fontSize: 14)),
                      const SizedBox(width: 4),
                      Text("$moedas", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("XP ${xpTotal % 100}/100", style: const TextStyle(color: Colors.white38, fontSize: 10)),
                    Text("$xpTotal XP total", style: const TextStyle(color: Colors.white38, fontSize: 10)),
                  ],
                ),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: percentual.clamp(0.0, 1.0),
                    minHeight: 7,
                    backgroundColor: Colors.white12,
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.yellowAccent),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildHeaderActionButton(
                  icon: Icons.military_tech,
                  color: Colors.blueAccent,
                  label: "CONQUISTAS",
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AchievementsScreen(xpTotal: xpTotal))),
                ),
                _buildHeaderActionButton(
                  icon: Icons.palette,
                  color: Colors.pinkAccent,
                  label: "LOJA",
                  onTap: _abrirLoja,
                ),
                _buildHeaderActionButton(
                  icon: Icons.emoji_events,
                  color: Colors.amber,
                  label: "RANKING",
                  // AQUI ESTAVA FALTANDO UM PARÊNTESE ))
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const RankingScreen())),
                ),
              ],
            ),
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
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              shape: BoxShape.circle,
              border: Border.all(color: color.withOpacity(0.6), width: 1.5),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}