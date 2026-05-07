import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'game_screen.dart';
import 'ranking_screen.dart';
import 'achievements_screen.dart';

class HomeScreen extends StatefulWidget {
  final String userName;
  const HomeScreen({super.key, required this.userName});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _carregando = true;
  int xpTotal = 0;
  int moedas = 0;
  List<int> fasesLiberadas = [1];
  String temaAtivoId = 'padrao';
  List<String> temasComprados = ['padrao'];

  static const List<Map<String, dynamic>> _fases = [
    {'id': 1,  'label': 'PRAIA',       'emoji': '🏖️', 'align': Alignment.centerLeft,  'padding': 40.0},
    {'id': 2,  'label': 'FLORESTA',    'emoji': '🌲', 'align': Alignment.centerRight, 'padding': 40.0},
    {'id': 3,  'label': 'CIDADE',      'emoji': '🏙️', 'align': Alignment.center,      'padding': 0.0},
    {'id': 4,  'label': 'ESCOLA',      'emoji': '🏫', 'align': Alignment.centerLeft,  'padding': 60.0},
    {'id': 5,  'label': 'RIO',         'emoji': '🏞️', 'align': Alignment.centerRight, 'padding': 60.0},
    {'id': 6,  'label': 'USINA',       'emoji': '⚡',  'align': Alignment.center,      'padding': 0.0},
    {'id': 7,  'label': 'RESERVA',     'emoji': '🌿', 'align': Alignment.centerLeft,  'padding': 30.0},
    {'id': 8,  'label': 'MONTANHA',    'emoji': '🏔️', 'align': Alignment.centerRight, 'padding': 50.0},
    {'id': 9,  'label': 'OCEANO',      'emoji': '🌊', 'align': Alignment.center,      'padding': 0.0},
    {'id': 10, 'label': 'SUSTENTÁVEL', 'emoji': '🌍', 'align': Alignment.centerLeft,  'padding': 40.0},
  ];

  static const List<Map<String, dynamic>> _temas = [
    {'id': 'padrao',     'nome': 'Clássico Ambiental',  'cores': [Color(0xFF81D4FA), Color(0xFF1B5E20)], 'preco': 0},
    {'id': 'crepusculo', 'nome': 'Crepúsculo Roxo',     'cores': [Color(0xFF4527A0), Color(0xFFB71C1C)], 'preco': 500},
    {'id': 'oceano',     'nome': 'Profundezas Azuis',   'cores': [Color(0xFF0D47A1), Color(0xFF00BCD4)], 'preco': 800},
    {'id': 'deserto',    'nome': 'Vale Dourado',         'cores': [Color(0xFFFFB300), Color(0xFFE65100)], 'preco': 1200},
  ];

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      xpTotal = prefs.getInt('xp') ?? 0;
      moedas = prefs.getInt('moedas') ?? 0;
      temaAtivoId = prefs.getString('tema_ativo') ?? 'padrao';
      temasComprados = prefs.getStringList('temas_comprados') ?? ['padrao'];
      final fasesStr = prefs.getStringList('fases_liberadas') ?? ['1'];
      fasesLiberadas = fasesStr.map((e) => int.tryParse(e) ?? 1).toList();
      _carregando = false;
    });
  }

  String _obterTitulo(int nivel) {
    if (nivel <= 2)  return 'Recrutinha Ambiental';
    if (nivel <= 5)  return 'Protetor Local';
    if (nivel <= 8)  return 'Agente Ecológico';
    if (nivel <= 12) return 'Guardião da Terra';
    if (nivel <= 18) return 'Guardião do Planeta';
    return 'Mestre da Sustentabilidade';
  }

  void _mostrarPerfil(int nivel) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF0D2010),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.green.withValues(alpha: 0.15),
                  border: Border.all(color: Colors.greenAccent, width: 2),
                ),
                child: const Icon(Icons.person_rounded, size: 40, color: Colors.greenAccent),
              ),
              const SizedBox(height: 14),
              Text(
                widget.userName.toUpperCase(),
                style: const TextStyle(color: Colors.yellowAccent, fontSize: 20, fontWeight: FontWeight.w900),
              ),
              Text(
                _obterTitulo(nivel),
                style: const TextStyle(color: Colors.white54, fontSize: 13),
              ),
              const SizedBox(height: 20),
              _linhaPerfil('⭐ Experiência Total', '$xpTotal XP'),
              _linhaPerfil('💰 Moedas Acumuladas', '$moedas'),
              _linhaPerfil('🗺️ Nível Atual', '$nivel'),
              _linhaPerfil('🔓 Fases Desbloqueadas', '${fasesLiberadas.length} / 10'),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('FECHAR', style: TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold, letterSpacing: 1)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _linhaPerfil(String rotulo, String valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(rotulo, style: const TextStyle(color: Colors.white54, fontSize: 13)),
          Text(valor, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
        ],
      ),
    );
  }

  void _abrirLoja() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0D1117),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => StatefulBuilder(
        builder: (ctx, setModal) => Container(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            children: [
              Container(
                width: 40, height: 4,
                decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2)),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.pinkAccent.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.palette_rounded, color: Colors.pinkAccent, size: 22),
                  ),
                  const SizedBox(width: 10),
                  const Text('LOJA DE TEMAS', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: 1)),
                ],
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.amber.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
                ),
                child: Text('💰 $moedas moedas disponíveis', style: const TextStyle(color: Colors.amber, fontSize: 12, fontWeight: FontWeight.w600)),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.separated(
                  itemCount: _temas.length,
                  separatorBuilder: (_, __) => const Divider(color: Colors.white10, height: 1),
                  itemBuilder: (ctx, index) {
                    final tema = _temas[index];
                    final jaComprado = temasComprados.contains(tema['id']);
                    final estaAtivo = temaAtivoId == tema['id'];
                    final cores = List<Color>.from(tema['cores'] as List);

                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                      leading: Container(
                        width: 48, height: 48,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(colors: cores),
                          boxShadow: [BoxShadow(color: cores.last.withValues(alpha: 0.5), blurRadius: 8)],
                        ),
                      ),
                      title: Text(
                        tema['nome'] as String,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                      ),
                      subtitle: Text(
                        jaComprado ? '✅ Adquirido' : '💰 ${tema['preco']}',
                        style: TextStyle(
                          color: jaComprado ? Colors.greenAccent : Colors.white38,
                          fontSize: 12,
                        ),
                      ),
                      trailing: SizedBox(
                        width: 95,
                        child: ElevatedButton(
                          onPressed: () async {
                            final prefs = await SharedPreferences.getInstance();
                            if (jaComprado) {
                              await prefs.setString('tema_ativo', tema['id'] as String);
                            } else if (moedas >= (tema['preco'] as int)) {
                              final novasMoedas = moedas - (tema['preco'] as int);
                              await prefs.setInt('moedas', novasMoedas);
                              final novosTemas = List<String>.from(temasComprados)..add(tema['id'] as String);
                              await prefs.setStringList('temas_comprados', novosTemas);
                              await prefs.setString('tema_ativo', tema['id'] as String);
                            }
                            if (ctx.mounted) Navigator.pop(ctx);
                            _carregarDados();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: estaAtivo
                                ? Colors.green.shade700
                                : (jaComprado ? Colors.blueGrey.shade700 : Colors.pinkAccent),
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            elevation: 0,
                          ),
                          child: Text(
                            estaAtivo ? 'USANDO' : (jaComprado ? 'EQUIPAR' : 'COMPRAR'),
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: Colors.white),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_carregando) {
      return const Scaffold(
        backgroundColor: Color(0xFF0A1A0A),
        body: Center(child: CircularProgressIndicator(color: Colors.greenAccent)),
      );
    }

    final temaAtual = _temas.firstWhere(
      (t) => t['id'] == temaAtivoId,
      orElse: () => _temas[0],
    );
    final nivelCalculado = (xpTotal ~/ 100) + 1;
    final coresTema = List<Color>.from(temaAtual['cores'] as List);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: coresTema,
          ),
        ),
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 220),
                  Text(
                    _obterTitulo(nivelCalculado).toUpperCase(),
                    style: const TextStyle(
                      fontSize: 11,
                      letterSpacing: 2.5,
                      color: Colors.yellowAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'MISSÕES AMBIENTAIS',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 1,
                      shadows: [Shadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 3))],
                    ),
                  ),
                  const SizedBox(height: 32),
                  ..._fases.map((fase) => _buildNodoMissao(fase, nivelCalculado)),
                  const SizedBox(height: 90),
                ],
              ),
            ),
            _buildHeader(nivelCalculado),
          ],
        ),
      ),
    );
  }

  Widget _buildNodoMissao(Map<String, dynamic> fase, int nivel) {
    final liberado = fasesLiberadas.contains(fase['id'] as int);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18),
      child: Align(
        alignment: fase['align'] as AlignmentGeometry,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: fase['padding'] as double),
          child: GestureDetector(
            onTap: () {
              if (liberado) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => GameScreen(
                      faseId: fase['id'] as int,
                      xpAtual: xpTotal,
                      nivelAtual: nivel,
                      moedasAtuais: moedas,
                    ),
                  ),
                ).then((_) => _carregarDados());
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('🔒 Complete a fase anterior para desbloquear!'),
                    backgroundColor: Colors.black87,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                );
              }
            },
            child: Column(
              children: [
                Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    color: liberado ? Colors.white : Colors.black.withValues(alpha: 0.35),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: liberado ? Colors.orangeAccent : Colors.white.withValues(alpha: 0.2),
                      width: 3.5,
                    ),
                    boxShadow: liberado
                        ? [
                            BoxShadow(
                              color: Colors.orangeAccent.withValues(alpha: 0.45),
                              blurRadius: 22,
                              spreadRadius: 3,
                            ),
                            const BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 5)),
                          ]
                        : null,
                  ),
                  child: Center(
                    child: liberado
                        ? Text(fase['emoji'] as String, style: const TextStyle(fontSize: 36))
                        : const Icon(Icons.lock_rounded, color: Colors.white30, size: 32),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                  decoration: BoxDecoration(
                    color: liberado
                        ? Colors.black.withValues(alpha: 0.5)
                        : Colors.black.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(14),
                    border: liberado
                        ? Border.all(color: Colors.white.withValues(alpha: 0.12))
                        : null,
                  ),
                  child: Text(
                    fase['label'] as String,
                    style: TextStyle(
                      color: liberado ? Colors.white : Colors.white.withValues(alpha: 0.3),
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                      letterSpacing: 1.2,
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
    final percentual = (xpTotal % 100) / 100.0;

    return Positioned(
      top: 0, left: 0, right: 0,
      child: Container(
        padding: const EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 18),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withValues(alpha: 0.85),
              Colors.black.withValues(alpha: 0.60),
            ],
          ),
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(32),
            bottomRight: Radius.circular(32),
          ),
          border: Border(
            bottom: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
          ),
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
                        width: 42, height: 42,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.green.withValues(alpha: 0.2),
                          border: Border.all(color: Colors.greenAccent, width: 2),
                        ),
                        child: const Icon(Icons.person_rounded, size: 24, color: Colors.greenAccent),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.userName.toUpperCase(),
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          Text(
                            'NÍVEL $nivel',
                            style: const TextStyle(color: Colors.yellowAccent, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                  decoration: BoxDecoration(
                    color: Colors.amber.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.amber.withValues(alpha: 0.35)),
                  ),
                  child: Row(
                    children: [
                      const Text('💰', style: TextStyle(fontSize: 15)),
                      const SizedBox(width: 5),
                      Text(
                        '$moedas',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('XP ${xpTotal % 100}/100', style: TextStyle(color: Colors.white.withValues(alpha: 0.4), fontSize: 10)),
                    Text('$xpTotal XP total', style: TextStyle(color: Colors.white.withValues(alpha: 0.4), fontSize: 10)),
                  ],
                ),
                const SizedBox(height: 5),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: percentual.clamp(0.0, 1.0),
                    minHeight: 8,
                    backgroundColor: Colors.white12,
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.yellowAccent),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _botaoAcao(
                  icon: Icons.military_tech_rounded,
                  cor: Colors.blueAccent,
                  rotulo: 'CONQUISTAS',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => AchievementsScreen(xpTotal: xpTotal)),
                  ),
                ),
                _botaoAcao(
                  icon: Icons.palette_rounded,
                  cor: Colors.pinkAccent,
                  rotulo: 'LOJA',
                  onTap: _abrirLoja,
                ),
                _botaoAcao(
                  icon: Icons.emoji_events_rounded,
                  cor: Colors.amber,
                  rotulo: 'RANKING',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const RankingScreen()),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _botaoAcao({
    required IconData icon,
    required Color cor,
    required String rotulo,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(11),
            decoration: BoxDecoration(
              color: cor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
              border: Border.all(color: cor.withValues(alpha: 0.5), width: 1.5),
            ),
            child: Icon(icon, color: cor, size: 22),
          ),
          const SizedBox(height: 4),
          Text(rotulo, style: TextStyle(color: cor, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
        ],
      ),
    );
  }
}
