import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:ui';
import 'dart:math' as math;

class GameScreen extends StatefulWidget {
  final int faseId;
  final int xpAtual;
  final int nivelAtual;
  final int moedasAtuais;

  const GameScreen({
    super.key,
    required this.faseId,
    required this.xpAtual,
    required this.nivelAtual,
    required this.moedasAtuais,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  final AudioPlayer _player = AudioPlayer();
  late AnimationController _bgController;
  late AnimationController _shakeController;
  late AnimationController _comboController;

  late Map<String, dynamic> _fase;
  late List<Map<String, dynamic>> _itens;

  int _acertos = 0;
  int _vidas = 3;
  int _combo = 0;
  int _itemAtual = 0;
  bool _faseConcluida = false;
  String _feedbackTipo = '';
  String _lixeiraAnimando = '';
  late int _moedasLocais;

  static const Map<int, Map<String, dynamic>> _fases = {
    1: {
      'titulo': 'PRAIA DO SOL', 'mascote': '🐢', 'nomeMascote': 'Marina',
      'corFundo': Color(0xFF006994), 'corAcento': Color(0xFF00B4DB),
      'msg': 'A areia precisa brilhar limpa!',
      'itens': [
        {'emoji': '🥤', 'tipo': 'plastico', 'nome': 'Copo Plástico', 'info': 'Vira microplástico no oceano.', 'tempo': '400 anos'},
        {'emoji': '🍾', 'tipo': 'vidro',    'nome': 'Garrafa de Vidro', 'info': 'Muito perigosa escondida na areia.', 'tempo': '4.000 anos'},
        {'emoji': '🛍️', 'tipo': 'plastico', 'nome': 'Saco Plástico', 'info': 'Tartarugas acham que é comida!', 'tempo': '300 anos'},
        {'emoji': '🥫', 'tipo': 'metal',    'nome': 'Lata de Refri', 'info': 'Alumínio é 100% reciclável.', 'tempo': '200 anos'},
        {'emoji': '🩴', 'tipo': 'plastico', 'nome': 'Chinelo Velho', 'info': 'Voa com o vento para a água.', 'tempo': 'Indeterminado'},
      ],
    },
    2: {
      'titulo': 'FLORESTA MÁGICA', 'mascote': '🐒', 'nomeMascote': 'Tito',
      'corFundo': Color(0xFF1B5E20), 'corAcento': Color(0xFF43A047),
      'msg': 'Tira o lixo das minhas árvores!',
      'itens': [
        {'emoji': '📦', 'tipo': 'papel',    'nome': 'Caixa de Fósforo', 'info': 'Risco imenso de incêndios florestais.', 'tempo': '6 meses'},
        {'emoji': '🧻', 'tipo': 'papel',    'nome': 'Papel Sujo', 'info': 'Polui visualmente a natureza.', 'tempo': '4 semanas'},
        {'emoji': '🧴', 'tipo': 'plastico', 'nome': 'Garrafa PET', 'info': 'O sol pode gerar foco de incêndio.', 'tempo': '400 anos'},
        {'emoji': '🍯', 'tipo': 'vidro',    'nome': 'Pote de Geleia', 'info': 'O cheiro doce atrai e prende insetos.', 'tempo': '4.000 anos'},
        {'emoji': '🔋', 'tipo': 'metal',    'nome': 'Pilha Comum', 'info': 'Vaza ácido tóxico no solo.', 'tempo': '500 anos'},
      ],
    },
    3: {
      'titulo': 'CENTRO DA CIDADE', 'mascote': '👧', 'nomeMascote': 'Bia',
      'corFundo': Color(0xFF37474F), 'corAcento': Color(0xFF607D8B),
      'msg': 'Vamos deixar as ruas limpas!',
      'itens': [
        {'emoji': '☕', 'tipo': 'papel',  'nome': 'Copo de Café', 'info': 'Tem plástico na composição interna.', 'tempo': '20 anos'},
        {'emoji': '🔌', 'tipo': 'metal', 'nome': 'Fio Elétrico', 'info': 'O cobre dentro do fio é valiosíssimo.', 'tempo': 'Indeterminado'},
        {'emoji': '🧃', 'tipo': 'papel', 'nome': 'Caixa de Suco', 'info': 'Caixas Tetra Pak são recicláveis.', 'tempo': '100 anos'},
        {'emoji': '🍕', 'tipo': 'papel', 'nome': 'Caixa de Pizza', 'info': 'A parte com gordura não se recicla.', 'tempo': '3 meses'},
        {'emoji': '⚡', 'tipo': 'metal', 'nome': 'Lata de Energético', 'info': 'Vira peças de bicicletas e carros.', 'tempo': '200 anos'},
      ],
    },
    4: {
      'titulo': 'PÁTIO DA ESCOLA', 'mascote': '👦', 'nomeMascote': 'Leo',
      'corFundo': Color(0xFFE65100), 'corAcento': Color(0xFFFF8F00),
      'msg': 'O recreio é hora de reciclar!',
      'itens': [
        {'emoji': '📓', 'tipo': 'papel',    'nome': 'Caderno Usado', 'info': 'Um caderno reciclado salva árvores!', 'tempo': '6 meses'},
        {'emoji': '🖊️', 'tipo': 'plastico', 'nome': 'Caneta Velha', 'info': 'Plástico duro demora séculos.', 'tempo': '400 anos'},
        {'emoji': '🖇️', 'tipo': 'metal',    'nome': 'Clips de Metal', 'info': 'Pequenos metais podem ser fundidos.', 'tempo': '100 anos'},
        {'emoji': '🧪', 'tipo': 'vidro',    'nome': 'Tubo Quebrado', 'info': 'Vidro de laboratório tem descarte especial.', 'tempo': '4.000 anos'},
        {'emoji': '🗞️', 'tipo': 'papel',    'nome': 'Jornal Escolar', 'info': 'Deve ir para a reciclagem, não ao chão.', 'tempo': '6 semanas'},
      ],
    },
    5: {
      'titulo': 'RIO CRISTALINO', 'mascote': '🐟', 'nomeMascote': 'Zé',
      'corFundo': Color(0xFF01579B), 'corAcento': Color(0xFF039BE5),
      'msg': 'Não consigo nadar com tanto lixo!',
      'itens': [
        {'emoji': '🛞', 'tipo': 'plastico', 'nome': 'Pneu Velho', 'info': 'Descarte criminoso! Libera microplásticos.', 'tempo': '600 anos'},
        {'emoji': '🍟', 'tipo': 'plastico', 'nome': 'Saco de Salgadinho', 'info': 'Sufoca os animais no fundo do rio.', 'tempo': '100 anos'},
        {'emoji': '🛢️', 'tipo': 'metal',    'nome': 'Lata de Tinta', 'info': 'Libera produtos químicos perigosos.', 'tempo': '100 anos'},
        {'emoji': '💊', 'tipo': 'vidro',    'nome': 'Frasco de Remédio', 'info': 'Contamina nossa água potável!', 'tempo': '4.000 anos'},
        {'emoji': '📦', 'tipo': 'papel',    'nome': 'Papelão Úmido', 'info': 'Bloqueia a água e causa enchentes.', 'tempo': '3 meses'},
      ],
    },
    6: {
      'titulo': 'USINA DE RECICLAGEM', 'mascote': '🤖', 'nomeMascote': 'Eco-Bot',
      'corFundo': Color(0xFF4A148C), 'corAcento': Color(0xFF7B1FA2),
      'msg': 'Separação avançada ativada!',
      'itens': [
        {'emoji': '🖱️', 'tipo': 'plastico', 'nome': 'Mouse Velho', 'info': 'E-lixo com plástico muito tóxico.', 'tempo': 'Indeterminado'},
        {'emoji': '📺', 'tipo': 'metal',    'nome': 'Placa Mãe', 'info': 'Tem ouro, prata e cobre na composição!', 'tempo': 'Indeterminado'},
        {'emoji': '💡', 'tipo': 'vidro',    'nome': 'Lâmpada Fluorescente', 'info': 'Cuidado: contém mercúrio venenoso.', 'tempo': '4.000 anos'},
        {'emoji': '🗄️', 'tipo': 'papel',    'nome': 'Arquivos Antigos', 'info': 'Prontos a virar novas folhas limpas.', 'tempo': '6 meses'},
        {'emoji': '📱', 'tipo': 'metal',    'nome': 'Celular Antigo', 'info': 'Nunca jogue no lixo comum!', 'tempo': 'Indeterminado'},
      ],
    },
    7: {
      'titulo': 'RESERVA ECOLÓGICA', 'mascote': '🦜', 'nomeMascote': 'Lara',
      'corFundo': Color(0xFF33691E), 'corAcento': Color(0xFF558B2F),
      'msg': 'Proteja meu ninho, por favor!',
      'itens': [
        {'emoji': '⛺', 'tipo': 'plastico', 'nome': 'Lona Rasgada', 'info': 'Sufoca o solo da reserva natural.', 'tempo': '40 anos'},
        {'emoji': '🔦', 'tipo': 'metal',    'nome': 'Lanterna', 'info': 'Aço e pilhas são combinação mortal.', 'tempo': '100 anos'},
        {'emoji': '🗺️', 'tipo': 'papel',    'nome': 'Mapa Turístico', 'info': 'Esquecido na trilha, polui a paisagem.', 'tempo': '3 meses'},
        {'emoji': '🍷', 'tipo': 'vidro',    'nome': 'Garrafa de Vinho', 'info': 'Pode ferir patas de animais silvestres.', 'tempo': '4.000 anos'},
        {'emoji': '🪢', 'tipo': 'plastico', 'nome': 'Corda Sintética', 'info': 'Pássaros podem ficar presos nos fios.', 'tempo': '150 anos'},
      ],
    },
    8: {
      'titulo': 'MONTANHA NEVADA', 'mascote': '🐐', 'nomeMascote': 'Zeca',
      'corFundo': Color(0xFF546E7A), 'corAcento': Color(0xFF90A4AE),
      'msg': 'Faz frio, mas o lixo não congela!',
      'itens': [
        {'emoji': '⛷️', 'tipo': 'metal',    'nome': 'Bastão de Esqui', 'info': 'Feito de alumínio 100% reciclável.', 'tempo': '200 anos'},
        {'emoji': '🧤', 'tipo': 'plastico', 'nome': 'Luva Sintética', 'info': 'Poliéster é plástico derivado do petróleo.', 'tempo': '200 anos'},
        {'emoji': '🍫', 'tipo': 'plastico', 'nome': 'Embalagem de Chocolate', 'info': 'Deixada por alpinistas, o vento espalha.', 'tempo': '100 anos'},
        {'emoji': '🎟️', 'tipo': 'papel',    'nome': 'Ticket de Trem', 'info': 'Papel encerado pode ir para reciclagem.', 'tempo': '1 mês'},
        {'emoji': '🕶️', 'tipo': 'vidro',    'nome': 'Óculos Quebrado', 'info': 'As lentes refletem luz e perturbam a fauna.', 'tempo': '4.000 anos'},
      ],
    },
    9: {
      'titulo': 'OCEANO PROFUNDO', 'mascote': '🐳', 'nomeMascote': 'Azul',
      'corFundo': Color(0xFF00227B), 'corAcento': Color(0xFF1565C0),
      'msg': 'Minha família precisa de mar limpo!',
      'itens': [
        {'emoji': '🎣', 'tipo': 'plastico', 'nome': 'Rede de Pesca', 'info': 'A maior causa de morte de animais marinhos.', 'tempo': '600 anos'},
        {'emoji': '⚓', 'tipo': 'metal',    'nome': 'Ferro Enferrujado', 'info': 'Metais pesados no fundo do mar.', 'tempo': '150 anos'},
        {'emoji': '🧴', 'tipo': 'plastico', 'nome': 'Frasco de Protetor', 'info': 'Químicos e plástico destroem corais.', 'tempo': '450 anos'},
        {'emoji': '🧊', 'tipo': 'plastico', 'nome': 'Isopor', 'info': 'Se desfaz em bolinhas brancas tóxicas.', 'tempo': 'Indeterminado'},
        {'emoji': '🧭', 'tipo': 'vidro',    'nome': 'Bússola Velha', 'info': 'Descarte de vidro deve ser em terra firme.', 'tempo': '4.000 anos'},
      ],
    },
    10: {
      'titulo': 'MUNDO SUSTENTÁVEL', 'mascote': '🌍', 'nomeMascote': 'Terra',
      'corFundo': Color(0xFF827717), 'corAcento': Color(0xFFF57F17),
      'msg': 'O desafio final! Me salve!',
      'itens': [
        {'emoji': '🪫', 'tipo': 'metal',    'nome': 'Bateria de Carro', 'info': 'Lixo químico de perigo máximo!', 'tempo': 'Indeterminado'},
        {'emoji': '🪟', 'tipo': 'vidro',    'nome': 'Vidro de Janela', 'info': 'Reciclagem diferente do vidro comum.', 'tempo': '4.000 anos'},
        {'emoji': '🧾', 'tipo': 'papel',    'nome': 'Recibo Amassado', 'info': 'Papel termal contém BPA tóxico.', 'tempo': '3 meses'},
        {'emoji': '🧸', 'tipo': 'plastico', 'nome': 'Brinquedo Quebrado', 'info': 'Plástico duro dura milênios intacto.', 'tempo': '1.000 anos'},
        {'emoji': '🚲', 'tipo': 'metal',    'nome': 'Corrente de Bicicleta', 'info': 'Totalmente reciclável na siderurgia.', 'tempo': '100 anos'},
      ],
    },
  };

  @override
  void initState() {
    super.initState();
    _moedasLocais = widget.moedasAtuais;
    _carregarFase(widget.faseId);

    _bgController = AnimationController(vsync: this, duration: const Duration(seconds: 8))
      ..repeat(reverse: true);

    _shakeController = AnimationController(vsync: this, duration: const Duration(milliseconds: 280));

    _comboController = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
  }

  void _carregarFase(int id) {
    _fase = Map<String, dynamic>.from(_fases[id] ?? _fases[1]!);
    _itens = List<Map<String, dynamic>>.from(_fase['itens'] as List);
  }

  void _tocarSom(String arquivo) async {
    try {
      await _player.play(AssetSource('sounds/$arquivo'));
    } catch (_) {}
  }

  void _responder(String tipoEscolhido) {
    if (_faseConcluida || _vidas <= 0) return;
    final tipoCorreto = _itens[_itemAtual]['tipo'] as String;

    if (tipoEscolhido == tipoCorreto) {
      HapticFeedback.heavyImpact();
      _tocarSom('acerto.mp3');
      setState(() {
        _feedbackTipo = 'acerto';
        _lixeiraAnimando = tipoEscolhido;
        _combo++;
      });
      _comboController.forward(from: 0.0);

      Future.delayed(const Duration(milliseconds: 320), () {
        setState(() { _feedbackTipo = ''; _lixeiraAnimando = ''; });
        _mostrarCuriosidade(_itens[_itemAtual], () {
          setState(() {
            _acertos++;
            if (_itemAtual < _itens.length - 1) {
              _itemAtual++;
            } else {
              _ganharFase();
            }
          });
        });
      });
    } else {
      HapticFeedback.vibrate();
      _shakeController.forward(from: 0.0);
      _tocarSom('erro.mp3');
      setState(() {
        _feedbackTipo = 'erro';
        _lixeiraAnimando = tipoEscolhido;
        _vidas--;
        _combo = 0;
      });

      Future.delayed(const Duration(milliseconds: 380), () {
        setState(() { _feedbackTipo = ''; _lixeiraAnimando = ''; });
        if (_vidas <= 0) _perderJogo();
      });
    }
  }

  void _mostrarCuriosidade(Map<String, dynamic> item, VoidCallback aoFechar) {
    _mostrarDialogo(
      titulo: 'MANDOU BEM!',
      subtitulo: 'A natureza agradece.',
      emoji: '✨',
      corPrimaria: const Color(0xFF00C9FF),
      corSecundaria: const Color(0xFF92FE9D),
      conteudo: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF00C9FF), Color(0xFF92FE9D)]),
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: const Color(0xFF92FE9D).withValues(alpha: 0.5), blurRadius: 24, spreadRadius: 5)],
            ),
            child: Text(item['emoji'] as String, style: const TextStyle(fontSize: 58)),
          ),
          const SizedBox(height: 18),
          Text(item['nome'] as String, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.black87)),
          const SizedBox(height: 10),
          Text(
            item['info'] as String,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 15, color: Colors.black54, height: 1.45, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 22),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.av_timer_rounded, color: Colors.black87, size: 26),
                const SizedBox(width: 10),
                Text(
                  'Decomposição: ${item['tempo']}',
                  style: const TextStyle(fontWeight: FontWeight.w900, color: Colors.black87, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
      textoBotao: 'CONTINUAR',
      aoConfirmar: aoFechar,
    );
  }

  void _perderJogo() {
    _mostrarDialogo(
      titulo: 'FIM DE JOGO',
      subtitulo: 'As vidas acabaram.',
      emoji: '💔',
      corPrimaria: const Color(0xFFFF416C),
      corSecundaria: const Color(0xFFFF4B2B),
      conteudo: Column(
        children: [
          Text(
            'O mascote ${_fase['nomeMascote']} precisa de você. Concentre-se!',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black87),
          ),
          const SizedBox(height: 22),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.amber.shade50,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.amber.shade300, width: 2),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('💰', style: TextStyle(fontSize: 22)),
                const SizedBox(width: 10),
                Text(
                  'Saldo: $_moedasLocais',
                  style: TextStyle(fontWeight: FontWeight.w900, color: Colors.amber.shade900, fontSize: 18),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          if (_moedasLocais >= 1000)
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber.shade600,
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                elevation: 6,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              ),
              onPressed: _comprarVidas,
              icon: const Icon(Icons.favorite_rounded, color: Colors.white, size: 26),
              label: const Text(
                'COMPRAR 3 VIDAS — 1.000 moedas',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 13),
              ),
            ),
        ],
      ),
      textoBotao: 'VOLTAR AO MAPA',
      aoConfirmar: () => Navigator.pop(context),
    );
  }

  Future<void> _comprarVidas() async {
    final prefs = await SharedPreferences.getInstance();
    final moedasSalvas = prefs.getInt('moedas') ?? 0;
    if (moedasSalvas >= 1000) {
      await prefs.setInt('moedas', moedasSalvas - 1000);
      setState(() { _vidas = 3; _moedasLocais -= 1000; });
      if (mounted) Navigator.pop(context);
    }
  }

  Future<void> _ganharFase() async {
    _tocarSom('acerto.mp3');
    HapticFeedback.vibrate();
    setState(() => _faseConcluida = true);

    final xpGanho = 20 + (_combo * 5);
    final moedasGanhas = 50 + (_combo * 10);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('xp', (prefs.getInt('xp') ?? 0) + xpGanho);
    await prefs.setInt('moedas', (prefs.getInt('moedas') ?? 0) + moedasGanhas);

    final liberadas = prefs.getStringList('fases_liberadas') ?? ['1'];
    if (!liberadas.contains((widget.faseId + 1).toString())) {
      liberadas.add((widget.faseId + 1).toString());
      await prefs.setStringList('fases_liberadas', liberadas);
    }

    _mostrarDialogo(
      titulo: 'VITÓRIA!',
      subtitulo: 'Área 100% Despoluída',
      emoji: '🏆',
      corPrimaria: const Color(0xFFFDC830),
      corSecundaria: const Color(0xFFF37335),
      conteudo: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 15)],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _cardPremio('⭐ XP', '+$xpGanho', Colors.green),
                Container(width: 1.5, height: 50, color: Colors.grey.shade200),
                _cardPremio('💰 MOEDAS', '+$moedasGanhas', Colors.amber.shade700),
              ],
            ),
          ),
          if (_combo > 1)
            Padding(
              padding: const EdgeInsets.only(top: 18),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: Text(
                  '🔥 COMBO INCRÍVEL ×$_combo!',
                  style: TextStyle(color: Colors.orange.shade900, fontWeight: FontWeight.w900, fontSize: 16),
                ),
              ),
            ),
          if (widget.faseId < 10)
            Padding(
              padding: const EdgeInsets.only(top: 14),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: const Text(
                  '🔓 Próxima fase desbloqueada!',
                  style: TextStyle(color: Color(0xFF2E7D32), fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ),
            ),
        ],
      ),
      textoBotao: 'VOLTAR AO MAPA',
      aoConfirmar: () => Navigator.pop(context),
    );
  }

  Widget _cardPremio(String titulo, String valor, Color cor) {
    return Column(
      children: [
        Text(titulo, style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.w900, fontSize: 12)),
        const SizedBox(height: 5),
        Text(valor, style: TextStyle(color: cor, fontWeight: FontWeight.w900, fontSize: 32)),
      ],
    );
  }

  void _mostrarDialogo({
    required String titulo,
    required String subtitulo,
    required String emoji,
    required Color corPrimaria,
    required Color corSecundaria,
    required Widget conteudo,
    required String textoBotao,
    required VoidCallback aoConfirmar,
  }) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.75),
      transitionDuration: const Duration(milliseconds: 450),
      pageBuilder: (_, __, ___) => const SizedBox(),
      transitionBuilder: (ctx, a1, _, __) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10 * a1.value, sigmaY: 10 * a1.value),
          child: ScaleTransition(
            scale: CurvedAnimation(parent: a1, curve: Curves.elasticOut),
            child: AlertDialog(
              backgroundColor: Colors.transparent,
              contentPadding: EdgeInsets.zero,
              elevation: 0,
              content: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.topCenter,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.86,
                    margin: const EdgeInsets.only(top: 50),
                    padding: const EdgeInsets.fromLTRB(24, 68, 24, 24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(36),
                      boxShadow: [BoxShadow(color: corPrimaria.withValues(alpha: 0.3), blurRadius: 40, offset: const Offset(0, 20))],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(titulo, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: Colors.black87, letterSpacing: -0.5)),
                        Text(subtitulo, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: corPrimaria)),
                        const SizedBox(height: 22),
                        conteudo,
                        const SizedBox(height: 26),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [corPrimaria, corSecundaria]),
                            borderRadius: BorderRadius.circular(22),
                            boxShadow: [BoxShadow(color: corPrimaria.withValues(alpha: 0.45), blurRadius: 14, offset: const Offset(0, 7))],
                          ),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              padding: const EdgeInsets.symmetric(vertical: 17),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
                            ),
                            onPressed: () { Navigator.pop(ctx); aoConfirmar(); },
                            child: Text(textoBotao, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 1)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [corPrimaria, corSecundaria]),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 5),
                        boxShadow: [BoxShadow(color: corPrimaria.withValues(alpha: 0.6), blurRadius: 22, offset: const Offset(0, 10))],
                      ),
                      child: Text(emoji, style: const TextStyle(fontSize: 46)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_itens.isEmpty) return const Scaffold();
    final item = _itens[_itemAtual];

    return Scaffold(
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: _bgController,
            builder: (_, __) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [_fase['corFundo'] as Color, _fase['corAcento'] as Color],
                  ),
                ),
                child: Stack(
                  children: List.generate(5, (i) {
                    final moveY = math.sin(_bgController.value * 2 * math.pi + i) * 45;
                    return Positioned(
                      left: 40.0 + (i * 65),
                      top: 80.0 + (i * 110) + moveY,
                      child: ImageFiltered(
                        imageFilter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                        child: Container(
                          width: 70, height: 70,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha: 0.08),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              );
            },
          ),
          AnimatedBuilder(
            animation: _shakeController,
            builder: (_, child) {
              final shake = math.sin(_shakeController.value * 3 * math.pi) * 14;
              return Transform.translate(
                offset: Offset(shake, 0),
                child: child,
              );
            },
            child: SafeArea(
              child: Column(
                children: [
                  _buildHeader(),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildMascote(),
                        _buildItemParaReciclar(item),
                      ],
                    ),
                  ),
                  _buildLixeiras(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(11),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.18),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withValues(alpha: 0.4)),
              ),
              child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
            ),
          ),
          Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4))],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.stars_rounded, color: Colors.amber, size: 18),
                    const SizedBox(width: 6),
                    Text(
                      '$_acertos DE ${_itens.length}',
                      style: TextStyle(fontWeight: FontWeight.w900, color: _fase['corAcento'] as Color, fontSize: 15),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: List.generate(_itens.length, (i) {
                  final concluido = i < _acertos;
                  final atual = i == _itemAtual;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    width: atual ? 16 : 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: concluido
                          ? Colors.greenAccent
                          : (atual ? Colors.white : Colors.white.withValues(alpha: 0.35)),
                    ),
                  );
                }),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withValues(alpha: 0.4)),
            ),
            child: Row(
              children: List.generate(3, (i) {
                return AnimatedScale(
                  scale: i < _vidas ? 1.0 : 0.55,
                  duration: const Duration(milliseconds: 300),
                  child: Icon(
                    i < _vidas ? Icons.favorite_rounded : Icons.heart_broken_rounded,
                    color: i < _vidas ? const Color(0xFFFF416C) : Colors.white38,
                    size: 22,
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMascote() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 20, offset: const Offset(0, 8))],
      ),
      child: Row(
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 2 * math.pi),
            duration: const Duration(seconds: 3),
            builder: (_, val, child) => Transform.translate(
              offset: Offset(0, math.sin(val) * 5),
              child: child,
            ),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: (_fase['corAcento'] as Color).withValues(alpha: 0.18),
                shape: BoxShape.circle,
              ),
              child: Text(_fase['mascote'] as String, style: const TextStyle(fontSize: 46)),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  (_fase['nomeMascote'] as String).toUpperCase(),
                  style: TextStyle(
                    color: _fase['corAcento'] as Color,
                    fontWeight: FontWeight.w900,
                    fontSize: 13,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '"${_fase['msg']}"',
                  style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 15),
                ),
                if (_combo >= 2)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: ScaleTransition(
                      scale: CurvedAnimation(parent: _comboController, curve: Curves.elasticOut),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade100,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.orange.shade300),
                        ),
                        child: Text(
                          '🔥 Combo ×$_combo',
                          style: TextStyle(color: Colors.orange.shade800, fontWeight: FontWeight.w900, fontSize: 12),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemParaReciclar(Map<String, dynamic> item) {
    return Column(
      children: [
        Text(
          item['nome'] as String,
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            shadows: [Shadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 4))],
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.22),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(
            'TOCA ou ARRASTA para reciclar',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 11, letterSpacing: 1),
          ),
        ),
        const SizedBox(height: 32),
        Draggable<String>(
          data: item['tipo'] as String,
          feedback: Material(color: Colors.transparent, child: _cartaoItem(item['emoji'] as String, true)),
          childWhenDragging: Opacity(opacity: 0.3, child: _cartaoItem(item['emoji'] as String, false)),
          onDragStarted: () => HapticFeedback.selectionClick(),
          child: _cartaoItem(item['emoji'] as String, false),
        ),
      ],
    );
  }

  Widget _cartaoItem(String emoji, bool arrastando) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      width: arrastando ? 175 : 155,
      height: arrastando ? 175 : 155,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(42),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: arrastando ? 0.35 : 0.18),
            blurRadius: arrastando ? 32 : 20,
            offset: Offset(0, arrastando ? 18 : 8),
          ),
          BoxShadow(
            color: (_fase['corAcento'] as Color).withValues(alpha: 0.28),
            blurRadius: 36,
            spreadRadius: 4,
          ),
        ],
        border: Border.all(color: Colors.white, width: 4),
      ),
      child: Center(child: Text(emoji, style: TextStyle(fontSize: arrastando ? 95 : 80))),
    );
  }

  Widget _buildLixeiras() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 22, left: 14, right: 14),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(36),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 22),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(36),
              border: Border.all(color: Colors.white.withValues(alpha: 0.35), width: 1.5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _lixeira('papel',   const Color(0xFF1565C0), const Color(0xFF42A5F5), 'PAPEL',   Icons.description_rounded),
                _lixeira('plastico',const Color(0xFFC62828), const Color(0xFFEF5350), 'PLÁSTICO', Icons.local_drink_rounded),
                _lixeira('metal',   const Color(0xFFE65100), const Color(0xFFFFB300), 'METAL',   Icons.settings_rounded),
                _lixeira('vidro',   const Color(0xFF2E7D32), const Color(0xFF66BB6A), 'VIDRO',   Icons.wine_bar_rounded),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _lixeira(String tipo, Color corForte, Color corClara, String rotulo, IconData icone) {
    final animando = _lixeiraAnimando == tipo;
    final acertou = _feedbackTipo == 'acerto';

    return DragTarget<String>(
      onAcceptWithDetails: (_) => _responder(tipo),
      builder: (_, candidatos, __) {
        final hover = candidatos.isNotEmpty;
        if (hover) HapticFeedback.selectionClick();

        return GestureDetector(
          onTap: () => _responder(tipo),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 240),
            curve: Curves.easeOutBack,
            width: animando || hover ? 88 : 78,
            height: animando || hover ? 118 : 102,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: animando
                    ? (acertou ? [Colors.greenAccent, const Color(0xFF2E7D32)] : [Colors.redAccent, Colors.red])
                    : [corClara, corForte],
              ),
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: animando
                      ? (acertou ? Colors.green : Colors.red).withValues(alpha: 0.6)
                      : corForte.withValues(alpha: 0.45),
                  blurRadius: animando ? 24 : 14,
                  offset: const Offset(0, 7),
                  spreadRadius: animando ? 4 : 0,
                ),
              ],
              border: Border.all(color: Colors.white.withValues(alpha: 0.85), width: 2),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  animando ? (acertou ? Icons.verified_rounded : Icons.cancel_rounded) : icone,
                  color: Colors.white,
                  size: animando || hover ? 38 : 30,
                ),
                const SizedBox(height: 7),
                Text(
                  rotulo,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _player.dispose();
    _bgController.dispose();
    _shakeController.dispose();
    _comboController.dispose();
    super.dispose();
  }
}
