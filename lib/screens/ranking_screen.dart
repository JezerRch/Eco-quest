import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RankingScreen extends StatefulWidget {
  const RankingScreen({super.key});

  @override
  State<RankingScreen> createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  List<Map<String, dynamic>> _ranking = [];
  bool _carregando = true;
  int _posicaoUsuario = 0;

  @override
  void initState() {
    super.initState();
    _carregarRanking();
  }

  Future<void> _carregarRanking() async {
    final prefs = await SharedPreferences.getInstance();
    final nomeUsuario = prefs.getString('user_name') ?? 'Você';
    final xpUsuario = prefs.getInt('xp') ?? 0;

    final jogadores = <Map<String, dynamic>>[
      {'nome': 'Maria Eco',     'xp': 1520, 'eu': false},
      {'nome': 'João Silva',    'xp': 1100, 'eu': false},
      {'nome': 'Ana Natureza',  'xp': 850,  'eu': false},
      {'nome': 'Pedro Henrique','xp': 600,  'eu': false},
      {'nome': 'Luiza Verde',   'xp': 450,  'eu': false},
      {'nome': 'Bia SalvaMundo','xp': 300,  'eu': false},
      {'nome': 'Carlos Edu',    'xp': 150,  'eu': false},
      {'nome': 'Bot Reciclador','xp': 50,   'eu': false},
      {'nome': nomeUsuario,     'xp': xpUsuario, 'eu': true},
    ];

    jogadores.sort((a, b) => (b['xp'] as int).compareTo(a['xp'] as int));

    final posicao = jogadores.indexWhere((j) => j['eu'] == true) + 1;

    setState(() {
      _ranking = jogadores;
      _posicaoUsuario = posicao;
      _carregando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0A1628), Color(0xFF0A1E0F)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildCabecalho(),
              if (_carregando)
                const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(color: Color(0xFF76FF03), strokeWidth: 3),
                  ),
                )
              else ...[
                if (_ranking.length >= 3) _buildPodio(),
                Expanded(child: _buildLista()),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCabecalho() {
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
                  'RANKING GLOBAL',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 20, letterSpacing: 1.5),
                ),
                Text(
                  'Os maiores eco-guerreiros',
                  style: TextStyle(color: Colors.white38, fontSize: 11),
                ),
              ],
            ),
          ),
          if (_posicaoUsuario > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFFDC830).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFFDC830).withValues(alpha: 0.4)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.emoji_events_rounded, color: Color(0xFFFDC830), size: 15),
                  const SizedBox(width: 4),
                  Text(
                    '${_posicaoUsuario}º lugar',
                    style: const TextStyle(color: Color(0xFFFDC830), fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPodio() {
    final primeiro = _ranking[0];
    final segundo = _ranking[1];
    final terceiro = _ranking[2];

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 20, 16, 4),
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _itemPodio(segundo, 2, 88, const Color(0xFFBDBDBD)),
          _itemPodio(primeiro, 1, 120, const Color(0xFFFDC830)),
          _itemPodio(terceiro, 3, 72, const Color(0xFF8D6E63)),
        ],
      ),
    );
  }

  Widget _itemPodio(Map<String, dynamic> jogador, int posicao, double alturaColuna, Color cor) {
    final euSou = jogador['eu'] as bool;
    final inicialNome = (jogador['nome'] as String).substring(0, 1).toUpperCase();
    final primeiroNome = (jogador['nome'] as String).split(' ').first;
    final nivel = ((jogador['xp'] as int) ~/ 100) + 1;

    return Column(
      children: [
        if (posicao == 1)
          const Text('👑', style: TextStyle(fontSize: 26))
        else
          const SizedBox(height: 26),
        const SizedBox(height: 6),
        Container(
          width: 54, height: 54,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: cor.withValues(alpha: 0.15),
            border: Border.all(color: cor, width: 2.5),
            boxShadow: [BoxShadow(color: cor.withValues(alpha: 0.3), blurRadius: 10)],
          ),
          child: Center(
            child: Text(
              inicialNome,
              style: TextStyle(color: cor, fontSize: 22, fontWeight: FontWeight.w900),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          primeiroNome,
          style: TextStyle(
            color: euSou ? const Color(0xFF76FF03) : Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          'Nv. $nivel',
          style: TextStyle(color: cor.withValues(alpha: 0.8), fontSize: 10),
        ),
        Text(
          '${jogador['xp']} XP',
          style: TextStyle(color: cor, fontSize: 11, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 8),
        Container(
          width: 68,
          height: alturaColuna,
          decoration: BoxDecoration(
            color: cor.withValues(alpha: 0.12),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
            border: Border.all(color: cor.withValues(alpha: 0.35), width: 1.5),
          ),
          child: Center(
            child: Text(
              '$posicao',
              style: TextStyle(
                color: cor,
                fontSize: posicao == 1 ? 30 : 24,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLista() {
    final restante = _ranking.length > 3 ? _ranking.sublist(3) : <Map<String, dynamic>>[];
    if (restante.isEmpty) return const SizedBox();

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      itemCount: restante.length,
      itemBuilder: (_, index) {
        final jogador = restante[index];
        final posicao = index + 4;
        final euSou = jogador['eu'] as bool;
        final nivel = ((jogador['xp'] as int) ~/ 100) + 1;
        final inicialNome = (jogador['nome'] as String).substring(0, 1).toUpperCase();

        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: euSou
                ? const Color(0xFF76FF03).withValues(alpha: 0.07)
                : Colors.white.withValues(alpha: 0.04),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: euSou
                  ? const Color(0xFF76FF03).withValues(alpha: 0.4)
                  : Colors.white.withValues(alpha: 0.06),
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 36, height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.07),
                ),
                child: Center(
                  child: Text(
                    '$posicao',
                    style: const TextStyle(color: Colors.white54, fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                width: 36, height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blueAccent.withValues(alpha: 0.15),
                  border: Border.all(
                    color: euSou
                        ? const Color(0xFF76FF03).withValues(alpha: 0.6)
                        : Colors.blueAccent.withValues(alpha: 0.3),
                  ),
                ),
                child: Center(
                  child: Text(
                    inicialNome,
                    style: TextStyle(
                      color: euSou ? const Color(0xFF76FF03) : Colors.blueAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      jogador['nome'] as String,
                      style: TextStyle(
                        color: euSou ? const Color(0xFF76FF03) : Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    Text('Nível $nivel', style: const TextStyle(color: Colors.white38, fontSize: 10)),
                  ],
                ),
              ),
              Text(
                '${jogador['xp']} XP',
                style: TextStyle(
                  color: euSou ? const Color(0xFF76FF03) : Colors.white54,
                  fontWeight: FontWeight.w900,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
