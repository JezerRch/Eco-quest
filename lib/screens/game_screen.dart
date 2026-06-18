import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:audioplayers/audioplayers.dart';

class GameScreen extends StatefulWidget {
  final int faseId;
  final String docId;
  final int xpAtual;
  final int nivelAtual;
  final int moedasAtuais;
  final int sequenciaAcertosAtual;
  final bool sequenciaVerdeJaDesbloqueada;
  final int respostasRapidasAtual;
  final bool velocidadeSolarJaDesbloqueada;
  final int perguntasRespondidasAtual;
  final bool mestreReciclagemJaDesbloqueada;

  const GameScreen({
    super.key,
    required this.faseId,
    required this.docId,
    required this.xpAtual,
    required this.nivelAtual,
    required this.moedasAtuais,
    required this.sequenciaAcertosAtual,
    required this.sequenciaVerdeJaDesbloqueada,
    required this.respostasRapidasAtual,
    required this.velocidadeSolarJaDesbloqueada,
    required this.perguntasRespondidasAtual,
    required this.mestreReciclagemJaDesbloqueada,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  late Timer _timer;
  int _segundosRestantes = 12;
  bool _isMuted = false;

  final Map<String, Map<String, String>> _dadosItens = {
    'Copo de Plástico': {
      'info': 'Plásticos se quebram em microplásticos que poluem o oceano.',
      'tempo': '200 a 450 anos',
    },
    'Garrafa de Vidro': {
      'info': 'O vidro é 100% reciclável e pode ser reutilizado infinitamente.',
      'tempo': 'Indeterminado (mais de 4 mil anos)',
    },
    'Jornal Velho': {
      'info': 'Reciclar papel economiza muita água e energia na produção.',
      'tempo': '2 a 6 semanas',
    },
    'Lata de Conserva': {
      'info': 'O aço reciclado volta para a indústria como peças de carro ou novas latas.',
      'tempo': '10 a 100 anos',
    },
    'Caixa de Papelão': {
      'info': 'A reciclagem de 1 tonelada de papel evita o corte de 20 árvores.',
      'tempo': '3 a 6 meses',
    },
    'Sucata Eletrônica': {
      'info': 'Possui metais como ouro e cobre que podem ser recuperados.',
      'tempo': 'Indeterminado e altamente poluente',
    },
    'Frasco de Amaciante': {
      'info': 'Este plástico (PEAD) é muito valorizado no mercado de reciclagem.',
      'tempo': 'Até 450 anos',
    },
    'Taça Quebrada': {
      'info': 'Vidros domésticos têm temperatura de fusão diferente de garrafas.',
      'tempo': '4 mil anos',
    },
    'Clipes de Metal': {
      'info': 'Pequenos objetos metálicos devem ser agrupados para não se perderem.',
      'tempo': '10 a 100 anos',
    },
    'Bateria Velha': {
      'info': 'Contém substâncias químicas que podem causar doenças graves.',
      'tempo': '100 a 500 anos',
    },
    'Revista Antiga': {
      'info': 'O papel das revistas pode ser transformado em novos cadernos.',
      'tempo': '4 a 6 meses',
    },
    'Frasco de Remédio': {
      'info': 'Vidros de remédio nunca devem ser descartados com o lixo comum.',
      'tempo': '4 mil anos',
    },
    'Sacola Plástica': {
      'info': 'É um dos itens que mais causa morte de animais marinhos.',
      'tempo': '10 a 20 anos',
    },
    'Talher de Alumínio': {
      'info': 'Reciclar alumínio gasta apenas 5% da energia de extrair o minério.',
      'tempo': '200 a 500 anos',
    },
    'Lápis Usado': {
      'info': 'O grafite do lápis é mineral, mas o corpo de madeira é reciclável com papel.',
      'tempo': '2 a 6 meses (madeira)',
    },
    'Caixinha de Suco': {
      'info': 'Embalagem Tetra Pak é feita de papel, plástico e alumínio — precisa de descarte especial.',
      'tempo': 'Até 100 anos sem reciclagem',
    },
    'Garrafa Pet': {
      'info': 'Uma garrafa PET pode virar fibra polar para casacos e outros produtos.',
      'tempo': '400 a 500 anos',
    },
    'Caneta Velha': {
      'info': 'Canetas são feitas de plástico e podem ser descartadas em coletores especiais.',
      'tempo': '450 anos',
    },
    'Linha de Pesca': {
      'info': 'Linhas de pesca matam animais marinhos ao se enrolarem em pescoços e nadadeiras.',
      'tempo': '600 anos',
    },
    'Lata no Rio': {
      'info': 'Uma lata no rio libera substâncias que contaminam a água por anos.',
      'tempo': '10 a 100 anos',
    },
    'Garrafa no Rio': {
      'info': 'Garrafas de vidro no rio fragmentam e machucam animais aquáticos.',
      'tempo': 'Mais de 1 milhão de anos',
    },
    'Isopor': {
      'info': 'O isopor (EPS) demora muito para se decompor e nunca vira adubo.',
      'tempo': 'Mais de 5.000 anos',
    },
    'Fio de Cobre': {
      'info': 'O cobre é um metal nobre altamente valorizado para reciclagem industrial.',
      'tempo': 'Indeterminado (não se degrada)',
    },
    'Tambor de Metal': {
      'info': 'Tambores industriais podem conter resíduos perigosos e precisam de descarte especializado.',
      'tempo': 'Centenas de anos',
    },
    'Frasco Químico': {
      'info': 'Frascos de produtos químicos precisam ser descartados em pontos específicos — nunca no lixo comum.',
      'tempo': '450 anos',
    },
    'Lâmpada Usada': {
      'info': 'Lâmpadas fluorescentes têm mercúrio — descarte obrigatório em pontos de coleta.',
      'tempo': 'Indeterminado (vidro + metal + mercúrio)',
    },
    'Papelão Industrial': {
      'info': 'O papelão industrial é um dos materiais mais reciclados do mundo.',
      'tempo': '2 a 4 meses',
    },
    'Folha de Papel': {
      'info': 'Uma tonelada de papel reciclado poupa 20 árvores e 50% de energia.',
      'tempo': '2 a 6 semanas',
    },
    'Pote de Vidro': {
      'info': 'O vidro é reciclável infinitas vezes sem perder qualidade.',
      'tempo': 'Mais de 1 milhão de anos',
    },
    'Colher de Metal': {
      'info': 'Metais como alumínio e aço são completamente recicláveis e retornam ao ciclo industrial.',
      'tempo': '100 a 500 anos',
    },
  };

  late List<Map<String, dynamic>> _itensDaFase;
  late String _tituloFase;
  late Color _corFundo;

  int _acertos = 0;
  int _sequenciaAcertos = 0;
  int _respostasRapidas = 0;
  int _vidas = 3;
  int _itemAtualIndex = 0;
  bool _faseConcluida = false;
  bool _errouNaFase = false;
  String _feedbackTipo = "";
  String _lixeiraAnimando = "";

  late int _moedasLocais;
  late int _perguntasRespondidas;
  late bool _mestreReciclagemRegistrada;
  bool _mostrarMensagemSucesso = false;
  bool _sequenciaVerdeRegistrada = false;
  bool _velocidadeSolarRegistrada = false;
  DateTime _inicioPergunta = DateTime.now();

  @override
  void initState() {
    super.initState();
    _moedasLocais = widget.moedasAtuais;
    _sequenciaAcertos = widget.sequenciaAcertosAtual;
    _respostasRapidas = widget.respostasRapidasAtual;
    _sequenciaVerdeRegistrada = widget.sequenciaVerdeJaDesbloqueada;
    _velocidadeSolarRegistrada = widget.velocidadeSolarJaDesbloqueada;
    _perguntasRespondidas = widget.perguntasRespondidasAtual;
    _mestreReciclagemRegistrada = widget.mestreReciclagemJaDesbloqueada;
    _configurarFase();
    _inicioPergunta = DateTime.now();
    _iniciarTimer();
  }

  void _iniciarTimer() {
    _segundosRestantes = 12;
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) { t.cancel(); return; }
      setState(() {
        _segundosRestantes--;
      });
      if (_segundosRestantes <= 0) {
        t.cancel();
        _handleTimeOut();
      }
    });
  }

  void _reiniciarTimer() {
    _timer.cancel();
    _iniciarTimer();
  }

  void _handleTimeOut() {
    if (_faseConcluida) return;
    _dispararFeedback("erro", "");
    setState(() {
      _vidas--;
      _sequenciaAcertos = 0;
      _errouNaFase = true;
    });
    if (_vidas <= 0) {
      _perderJogo();
    }
  }

  void _configurarFase() {
    switch (widget.faseId) {
      case 1:
        _tituloFase = "LIMPEZA NA PRAIA";
        _corFundo = const Color(0xFFE1F5FE);
        _itensDaFase = [
          {'emoji': '🥤', 'tipo': 'plastico', 'nome': 'Copo de Plástico'},
          {'emoji': '🍾', 'tipo': 'vidro', 'nome': 'Garrafa de Vidro'},
        ];
        break;
      case 2:
        _tituloFase = "RESERVA FLORESTAL";
        _corFundo = const Color(0xFFE8F5E9);
        _itensDaFase = [
          {'emoji': '📰', 'tipo': 'papel', 'nome': 'Jornal Velho'},
          {'emoji': '🥫', 'tipo': 'metal', 'nome': 'Lata de Conserva'},
          {'emoji': '📦', 'tipo': 'papel', 'nome': 'Caixa de Papelão'},
        ];
        break;
      case 3:
        _tituloFase = "RECICLAGEM URBANA";
        _corFundo = const Color(0xFFF5F5F5);
        _itensDaFase = [
          {'emoji': '💻', 'tipo': 'metal', 'nome': 'Sucata Eletrônica'},
          {'emoji': '🧴', 'tipo': 'plastico', 'nome': 'Frasco de Amaciante'},
          {'emoji': '🥂', 'tipo': 'vidro', 'nome': 'Taça Quebrada'},
          {'emoji': '📎', 'tipo': 'metal', 'nome': 'Clipes de Metal'},
        ];
        break;
      case 4:
        _tituloFase = "ESCOLA";
        _corFundo = const Color(0xFFE3F2FD);
        _itensDaFase = [
          {'emoji': '✏️', 'tipo': 'papel', 'nome': 'Lápis Usado'},
          {'emoji': '🧃', 'tipo': 'papel', 'nome': 'Caixinha de Suco'},
          {'emoji': '🍶', 'tipo': 'plastico', 'nome': 'Garrafa Pet'},
          {'emoji': '🖊️', 'tipo': 'plastico', 'nome': 'Caneta Velha'},
        ];
        break;
      case 5:
        _tituloFase = "RIO";
        _corFundo = const Color(0xFFE0F7FA);
        _itensDaFase = [
          {'emoji': '🎣', 'tipo': 'plastico', 'nome': 'Linha de Pesca'},
          {'emoji': '🥫', 'tipo': 'metal', 'nome': 'Lata no Rio'},
          {'emoji': '🍾', 'tipo': 'vidro', 'nome': 'Garrafa no Rio'},
          {'emoji': '📦', 'tipo': 'plastico', 'nome': 'Isopor'},
        ];
        break;
      case 6:
        _tituloFase = "USINA";
        _corFundo = const Color(0xFFFFF9C4);
        _itensDaFase = [
          {'emoji': '🔌', 'tipo': 'metal', 'nome': 'Fio de Cobre'},
          {'emoji': '🛢️', 'tipo': 'metal', 'nome': 'Tambor de Metal'},
          {'emoji': '🧪', 'tipo': 'plastico', 'nome': 'Frasco Químico'},
          {'emoji': '💡', 'tipo': 'vidro', 'nome': 'Lâmpada Usada'},
          {'emoji': '📰', 'tipo': 'papel', 'nome': 'Papelão Industrial'},
        ];
        break;
      case 7:
        _tituloFase = "RESERVA";
        _corFundo = const Color(0xFFE8F5E9);
        _itensDaFase = [
          {'emoji': '🌿', 'tipo': 'papel', 'nome': 'Folha de Papel'},
          {'emoji': '🛍️', 'tipo': 'plastico', 'nome': 'Sacola Plástica'},
          {'emoji': '🫙', 'tipo': 'vidro', 'nome': 'Pote de Vidro'},
          {'emoji': '🥄', 'tipo': 'metal', 'nome': 'Colher de Metal'},
        ];
        break;
      default:
        _tituloFase = "MISSÃO AVANÇADA";
        _corFundo = const Color(0xFFFFF3E0);
        _itensDaFase = [
          {'emoji': '🔋', 'tipo': 'metal', 'nome': 'Bateria Velha'},
          {'emoji': '📚', 'tipo': 'papel', 'nome': 'Revista Antiga'},
          {'emoji': '💊', 'tipo': 'vidro', 'nome': 'Frasco de Remédio'},
          {'emoji': '🛍️', 'tipo': 'plastico', 'nome': 'Sacola Plástica'},
          {'emoji': '🍴', 'tipo': 'metal', 'nome': 'Talher de Alumínio'},
        ];
    }
  }

  void _tocarSom(String nomeArquivo) async {
    if (_isMuted) return;
    if (kIsWeb && nomeArquivo == 'vitoria.mp3') return;
    try {
      await _audioPlayer.play(AssetSource('sounds/$nomeArquivo'));
    } catch (e) {}
  }

  void _dispararFeedback(String tipo, String lixeira) {
    setState(() {
      _feedbackTipo = tipo;
      _lixeiraAnimando = lixeira;
    });
    if (tipo == "acerto") _tocarSom('acerto.mp3');
    if (tipo == "erro") _tocarSom('erro.mp3');
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) setState(() { _feedbackTipo = ""; _lixeiraAnimando = ""; });
    });
  }

  void _mostrarCuriosidade(String nomeItem, VoidCallback aoFechar) {
    _timer.cancel();
    final dados = _dadosItens[nomeItem];
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.eco, color: Colors.green),
            SizedBox(width: 10),
            Text("VOCÊ SABIA?"),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(nomeItem, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const Divider(),
            const SizedBox(height: 10),
            Text(dados?['info'] ?? "Este item é reciclável!"),
            const SizedBox(height: 15),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                const Icon(Icons.timer_outlined, size: 20, color: Colors.blueGrey),
                const SizedBox(width: 5),
                const Text("Decomposição: ", style: TextStyle(fontWeight: FontWeight.bold)),
                Text(dados?['tempo'] ?? "Desconhecido"),
              ],
            ),
          ],
        ),
        actions: [
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () { Navigator.pop(context); aoFechar(); },
              child: const Text("CONTINUAR", style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  void _perderJogo() {
    _timer.cancel();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("SEM VIDAS!", textAlign: TextAlign.center),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("O planeta precisa de você! Tente a fase novamente ou recupere suas vidas."),
            const SizedBox(height: 20),
            Text("Saldo atual: M\$ $_moedasLocais", style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.amber[800]),
                  onPressed: _moedasLocais >= 1000 ? _comprarVidas : null,
                  icon: const Icon(Icons.shopping_cart, color: Colors.white),
                  label: const Text(
                    "COMPRAR 3 VIDAS (M\$ 1000)",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () { Navigator.pop(context); Navigator.pop(context); },
                child: const Text("SAIR PARA O MAPA", style: TextStyle(color: Colors.grey)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _comprarVidas() async {
    if (_moedasLocais >= 1000) {
      try {
        await FirebaseFirestore.instance.collection('jogadores').doc(widget.docId).update({
          'moedas': FieldValue.increment(-1000),
        });

        setState(() {
          _vidas = 3;
          _moedasLocais -= 1000;
          _mostrarMensagemSucesso = true;
        });

        Navigator.pop(context);
        _reiniciarTimer();

        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) setState(() => _mostrarMensagemSucesso = false);
        });
      } catch (e) {
        debugPrint("Erro ao comprar vidas: $e");
      }
    }
  }

  Future<void> _ganharFase() async {
    if (_faseConcluida) return;
    _timer.cancel();
    setState(() => _faseConcluida = true);
    _tocarSom('vitoria.mp3');

    final xpAntes = widget.xpAtual;
    final xpDepois = xpAntes + 20;
    final conquistasNovas = _obterConquistasDesbloqueadasNaPartida(
      xpAntes: xpAntes,
      xpDepois: xpDepois,
      faseConcluida: widget.faseId,
    );

    final doc = await FirebaseFirestore.instance
        .collection('jogadores')
        .doc(widget.docId)
        .get();
    final dadosAtual = doc.data() ?? {};
    final conquistasDatas = Map<String, dynamic>.from(dadosAtual['conquistas_datas'] ?? {});

    final update = <String, dynamic>{
      'xp': FieldValue.increment(20),
      'moedas': FieldValue.increment(50),
      'fases_liberadas': FieldValue.arrayUnion([widget.faseId + 1]),
    };
    final novasPorFase = <String>[];

    if (widget.faseId == 1 && conquistasDatas['primeiro_passo'] == null) {
      update['conquistas_datas.primeiro_passo'] = FieldValue.serverTimestamp();
      novasPorFase.add('Primeiro Passo');
    }

    if (!_errouNaFase && conquistasDatas['sem_desperdicio'] == null) {
      update['conquistas_datas.sem_desperdicio'] = FieldValue.serverTimestamp();
      novasPorFase.add('Sem Desperdicio');
    }

    await FirebaseFirestore.instance
        .collection('jogadores')
        .doc(widget.docId)
        .update(update);

    _mostrarNotificacaoConquistas(conquistasNovas);
    _mostrarNotificacaoConquistas(novasPorFase);
    _mostrarPopupVitoria();
  }

  List<String> _obterConquistasDesbloqueadasNaPartida({
    required int xpAntes,
    required int xpDepois,
    required int faseConcluida,
  }) {
    final novas = <String>[];
    final marcosXp = <Map<String, dynamic>>[
      {'nome': 'Guardiao da Praia', 'xp': 1100},
      {'nome': 'Defensor da Floresta', 'xp': 1300},
      {'nome': 'Top do Ranking', 'xp': 2600},
      {'nome': 'Eco Master Supremo', 'xp': 3500},
    ];

    for (final marco in marcosXp) {
      final req = marco['xp'] as int;
      if (xpAntes < req && xpDepois >= req) {
        novas.add(marco['nome'] as String);
      }
    }
    return novas;
  }

  void _mostrarNotificacaoConquistas(List<String> conquistas) {
    if (conquistas.isEmpty || !mounted) return;
    final texto = conquistas.length == 1
        ? 'Conquista desbloqueada: ${conquistas.first}'
        : 'Conquistas desbloqueadas: ${conquistas.join(', ')}';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(texto),
        backgroundColor: Colors.green[700],
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> _registrarSequenciaVerdeSeNecessario() async {
    if (_sequenciaVerdeRegistrada || _sequenciaAcertos < 5) return;
    _sequenciaVerdeRegistrada = true;

    await FirebaseFirestore.instance.collection('jogadores').doc(widget.docId).update({
      'sequencia_verde_desbloqueada': true,
      'sequencia_acertos': _sequenciaAcertos,
      'conquistas_datas.sequencia_verde': FieldValue.serverTimestamp(),
    });

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Conquista desbloqueada: Sequencia Verde'),
        backgroundColor: Colors.green[700],
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> _registrarVelocidadeSolarSeNecessario() async {
    if (_velocidadeSolarRegistrada || _respostasRapidas < 10) return;
    _velocidadeSolarRegistrada = true;

    await FirebaseFirestore.instance.collection('jogadores').doc(widget.docId).update({
      'conquistas_datas.velocidade_solar': FieldValue.serverTimestamp(),
    });

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Conquista desbloqueada: Velocidade Solar'),
        backgroundColor: Colors.green[700],
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> _registrarMestreReciclagemSeNecessario() async {
    if (_mestreReciclagemRegistrada || _perguntasRespondidas < 20) return;
    _mestreReciclagemRegistrada = true;

    await FirebaseFirestore.instance.collection('jogadores').doc(widget.docId).update({
      'conquistas_datas.mestre_reciclagem': FieldValue.serverTimestamp(),
    });

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Conquista desbloqueada: Mestre da Reciclagem'),
        backgroundColor: Colors.green[700],
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _mostrarPopupVitoria() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("PARABÉNS!"),
        content: Text("Você concluiu a fase $_tituloFase!"),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () { Navigator.pop(context); Navigator.pop(context); },
              child: const Text("IR PARA O MAPA"),
            ),
          ),
        ],
      ),
    );
  }

  Color get _timerColor {
    if (_segundosRestantes > 6) return Colors.green;
    if (_segundosRestantes > 3) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    if (_itensDaFase.isEmpty) return const Scaffold();
    final itemAtual = _itensDaFase[_itemAtualIndex];

    return Scaffold(
      backgroundColor: _corFundo,
      body: Stack(
        children: [
          _buildHeader(),

          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(_tituloFase, style: TextStyle(fontSize: 18, color: Colors.grey[700], letterSpacing: 2)),
                const SizedBox(height: 10),
                Text(
                  itemAtual['nome'],
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: _segundosRestantes / 12.0,
                      minHeight: 8,
                      backgroundColor: Colors.black12,
                      valueColor: AlwaysStoppedAnimation<Color>(_timerColor),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$_segundosRestantes s',
                  style: TextStyle(fontSize: 12, color: _timerColor, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 40),
                Draggable<String>(
                  data: itemAtual['tipo'],
                  feedback: Material(
                    color: Colors.transparent,
                    child: Text(itemAtual['emoji'], style: const TextStyle(fontSize: 100)),
                  ),
                  childWhenDragging: Opacity(
                    opacity: 0.2,
                    child: Text(itemAtual['emoji'], style: const TextStyle(fontSize: 80)),
                  ),
                  child: Text(itemAtual['emoji'], style: const TextStyle(fontSize: 80)),
                ),
              ],
            ),
          ),

          Positioned(
            bottom: 50, left: 0, right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildBin('papel', Colors.blue, 'PAPEL'),
                _buildBin('plastico', Colors.red, 'PLÁSTICO'),
                _buildBin('metal', Colors.amber, 'METAL'),
                _buildBin('vidro', Colors.green, 'VIDRO'),
              ],
            ),
          ),

          if (_mostrarMensagemSucesso)
            Center(
              child: TweenAnimationBuilder(
                duration: const Duration(milliseconds: 300),
                tween: Tween<double>(begin: 0.0, end: 1.0),
                builder: (context, double val, child) {
                  return Opacity(
                    opacity: val,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.85),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10)],
                      ),
                      child: const Text(
                        "Vidas restauradas com sucesso!",
                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
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

  Future<void> _handleDrop(String binTipo) async {
    if (_faseConcluida) return;
    _timer.cancel();
    final itemAtual = _itensDaFase[_itemAtualIndex];
    final tipoCorreto = itemAtual['tipo'] as String;

    if (tipoCorreto == binTipo) {
      final respondeuRapido = DateTime.now().difference(_inicioPergunta).inSeconds < 5;
      final isLastItem = _itemAtualIndex >= _itensDaFase.length - 1;
      _dispararFeedback("acerto", binTipo);

      _mostrarCuriosidade(itemAtual['nome'], () async {
        setState(() {
          _acertos++;
          _sequenciaAcertos++;
          if (respondeuRapido) _respostasRapidas++;
          if (!isLastItem) {
            _itemAtualIndex++;
            _inicioPergunta = DateTime.now();
            _reiniciarTimer();
          }
        });

        _perguntasRespondidas++;

        await FirebaseFirestore.instance.collection('jogadores').doc(widget.docId).update({
          'sequencia_acertos': _sequenciaAcertos,
          'perguntas_respondidas': FieldValue.increment(1),
          'respostas_rapidas': _respostasRapidas,
        });

        await _registrarSequenciaVerdeSeNecessario();
        await _registrarVelocidadeSolarSeNecessario();
        await _registrarMestreReciclagemSeNecessario();

        if (isLastItem) _ganharFase();
      });
    } else {
      _dispararFeedback("erro", binTipo);
      setState(() {
        _vidas--;
        _sequenciaAcertos = 0;
        _errouNaFase = true;
      });

      if (_vidas <= 0) {
        _perderJogo();
      } else {
        _reiniciarTimer();
      }

      _perguntasRespondidas++;

      await FirebaseFirestore.instance.collection('jogadores').doc(widget.docId).update({
        'sequencia_acertos': 0,
        'perguntas_respondidas': FieldValue.increment(1),
        'respostas_rapidas': _respostasRapidas,
      });

      await _registrarMestreReciclagemSeNecessario();
    }
  }

  Widget _buildBin(String tipo, Color cor, String label) {
    final bool estaAnimando = _lixeiraAnimando == tipo;
    final bool foiAcerto = _feedbackTipo == "acerto";

    return DragTarget<String>(
      onAcceptWithDetails: (details) => _handleDrop(tipo),
      builder: (context, candidates, rejects) {
        final bool highlighted = candidates.isNotEmpty;
        return GestureDetector(
          onTap: () => _handleDrop(tipo),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: (estaAnimando || highlighted) ? 85 : 75,
            height: 105,
            decoration: BoxDecoration(
              color: estaAnimando
                  ? (foiAcerto ? Colors.green : Colors.red)
                  : highlighted
                      ? cor.withValues(alpha: 0.7)
                      : cor,
              borderRadius: BorderRadius.circular(15),
              border: highlighted ? Border.all(color: Colors.white, width: 2) : null,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  estaAnimando ? (foiAcerto ? Icons.check : Icons.close) : Icons.delete_outline,
                  color: Colors.white,
                  size: 30,
                ),
                Text(label, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("ITEM ${_itemAtualIndex + 1}/${_itensDaFase.length}", style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                Container(
                  width: 100, height: 8,
                  decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.circular(5)),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: (_acertos / _itensDaFase.length).clamp(0.01, 1.0),
                    child: Container(
                      decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(5)),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: List.generate(3, (index) {
                return Icon(
                  index < _vidas ? Icons.favorite : Icons.favorite_border,
                  color: Colors.red,
                  size: 28,
                );
              }),
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    setState(() => _isMuted = !_isMuted);
                  },
                  icon: Icon(_isMuted ? Icons.volume_off : Icons.volume_up),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }
}
