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
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  final Map<String, Map<String, String>> _dadosItens = {
    'Copo de PlÃ¡stico': {'info': 'PlÃ¡sticos se quebram em microplÃ¡sticos que poluem o oceano.', 'tempo': '200 a 450 anos'},
    'Garrafa de Vidro': {'info': 'O vidro Ã© 100% reciclÃ¡vel e pode ser reutilizado infinitamente.', 'tempo': 'Indeterminado (mais de 4 mil anos)'},
    'Jornal Velho': {'info': 'Reciclar papel economiza muita Ã¡gua e energia na produÃ§Ã£o.', 'tempo': '2 a 6 semanas'},
    'Lata de Conserva': {'info': 'O aÃ§o reciclado volta para a indÃºstria como peÃ§as de carro ou novas latas.', 'tempo': '10 a 100 anos'},
    'Caixa de PapelÃ£o': {'info': 'A reciclagem de 1 tonelada de papel evita o corte de 20 Ã¡rvores.', 'tempo': '3 a 6 meses'},
    'Sucata EletrÃ´nica': {'info': 'Possui metais como ouro e cobre que podem ser recuperados.', 'tempo': 'Indeterminado e altamente poluente'},
    'Frasco de Amaciante': {'info': 'Este plÃ¡stico (PEAD) Ã© muito valorizado no mercado de reciclagem.', 'tempo': 'AtÃ© 450 anos'},
    'TaÃ§a Quebrada': {'info': 'Vidros domÃ©sticos tÃªm temperatura de fusÃ£o diferente de garrafas.', 'tempo': '4 mil anos'},
    'Clipes de Metal': {'info': 'Pequenos objetos metÃ¡licos devem ser agrupados para nÃ£o se perderem.', 'tempo': '10 a 100 anos'},
    'Bateria Velha': {'info': 'ContÃ©m substÃ¢ncias quÃ­micas que podem causar doenÃ§as graves.', 'tempo': '100 a 500 anos'},
    'Revista Antiga': {'info': 'O papel das revistas pode ser transformado em novos cadernos.', 'tempo': '4 a 6 meses'},
    'Frasco de RemÃ©dio': {'info': 'Vidros de remÃ©dio nunca devem ser descartados com o lixo comum.', 'tempo': '4 mil anos'},
    'Sacola PlÃ¡stica': {'info': 'Ã‰ um dos itens que mais causa morte de animais marinhos.', 'tempo': '10 a 20 anos'},
    'Talher de AlumÃ­nio': {'info': 'Reciclar alumÃ­nio gasta apenas 5% da energia de extrair o minÃ©rio.', 'tempo': '200 a 500 anos'},
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

  // VariÃ¡veis para controle de moedas e mensagem central
  late int _moedasLocais;
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
    _configurarFase();
    _inicioPergunta = DateTime.now();
  }

  void _configurarFase() {
    switch (widget.faseId) {
      case 1:
        _tituloFase = "LIMPEZA NA PRAIA";
        _corFundo = const Color(0xFFE1F5FE);
        _itensDaFase = [
          {'emoji': 'PL', 'tipo': 'plastico', 'nome': 'Copo de Plastico'},
          {'emoji': 'VD', 'tipo': 'vidro', 'nome': 'Garrafa de Vidro'},
        ];
        break;
      case 2:
        _tituloFase = "RESERVA FLORESTAL";
        _corFundo = const Color(0xFFE8F5E9);
        _itensDaFase = [
          {'emoji': 'PP', 'tipo': 'papel', 'nome': 'Jornal Velho'},
          {'emoji': 'MT', 'tipo': 'metal', 'nome': 'Lata de Conserva'},
          {'emoji': 'CX', 'tipo': 'papel', 'nome': 'Caixa de Papelao'},
        ];
        break;
      case 3:
        _tituloFase = "RECICLAGEM URBANA";
        _corFundo = const Color(0xFFF5F5F5);
        _itensDaFase = [
          {'emoji': 'EL', 'tipo': 'plastico', 'nome': 'Sucata Eletronica'},
          {'emoji': 'AM', 'tipo': 'plastico', 'nome': 'Frasco de Amaciante'},
          {'emoji': 'TQ', 'tipo': 'vidro', 'nome': 'Taca Quebrada'},
          {'emoji': 'CL', 'tipo': 'metal', 'nome': 'Clipes de Metal'},
        ];
        break;
      default:
        _tituloFase = "MISSÃƒO AVANÃ‡ADA";
        _corFundo = const Color(0xFFFFF3E0);
        _itensDaFase = [
          {'emoji': 'BV', 'tipo': 'metal', 'nome': 'Bateria Velha'},
          {'emoji': 'RV', 'tipo': 'papel', 'nome': 'Revista Antiga'},
          {'emoji': 'FR', 'tipo': 'vidro', 'nome': 'Frasco de Remedio'},
          {'emoji': 'SC', 'tipo': 'plastico', 'nome': 'Sacola Plastica'},
          {'emoji': 'TA', 'tipo': 'metal', 'nome': 'Talher de Aluminio'},
        ];
    }
  }

  void _tocarSom(String nomeArquivo) async {
    if (kIsWeb && nomeArquivo == 'vitoria.mp3') return;
    try { await _audioPlayer.play(AssetSource('sounds/$nomeArquivo')); } catch (e) {}
  }

  void _dispararFeedback(String tipo, String lixeira) {
    setState(() { _feedbackTipo = tipo; _lixeiraAnimando = lixeira; });
    _tocarSom(tipo == "acerto" ? 'acerto.mp3' : 'erro.mp3');
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) setState(() { _feedbackTipo = ""; _lixeiraAnimando = ""; });
    });
  }

  void _mostrarCuriosidade(String nomeItem, VoidCallback aoFechar) {
    final dados = _dadosItens[nomeItem];
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [Icon(Icons.eco, color: Colors.green), SizedBox(width: 10), Text("VOCÃŠ SABIA?")],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(nomeItem, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const Divider(),
            const SizedBox(height: 10),
            Text(dados?['info'] ?? "Este item Ã© reciclÃ¡vel!"),
            const SizedBox(height: 15),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                const Icon(Icons.timer_outlined, size: 20, color: Colors.blueGrey),
                const SizedBox(width: 5),
                const Text("DecomposiÃ§Ã£o: ", style: TextStyle(fontWeight: FontWeight.bold)),
                Text(dados?['tempo'] ?? "Desconhecido"),
              ],
            ),
          ],
        ),
        actions: [
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
              onPressed: () { Navigator.pop(context); aoFechar(); },
              child: const Text("CONTINUAR", style: TextStyle(color: Colors.white)),
            ),
          )
        ],
      ),
    );
  }

  void _perderJogo() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("SEM VIDAS!", textAlign: TextAlign.center),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("O planeta precisa de vocÃª! Tente a fase novamente ou recupere suas vidas."),
            const SizedBox(height: 20),
            Text("Saldo atual: M$ $_moedasLocais", style: const TextStyle(fontWeight: FontWeight.bold)),
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
                  label: const Text("COMPRAR 3 VIDAS (M$ 1000)", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () { Navigator.pop(context); Navigator.pop(context); },
                child: const Text("SAIR PARA O MAPA", style: TextStyle(color: Colors.grey)),
              ),
            ],
          )
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

        Navigator.pop(context); // Fecha o diÃ¡logo de erro

        // Esconde a mensagem central apÃ³s 2 segundos
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
    _tocarSom('vitoria.mp3');
    final xpAntes = widget.xpAtual;
    final xpDepois = xpAntes + 20;
    final conquistasNovas = _obterConquistasDesbloqueadasNaPartida(
      xpAntes: xpAntes,
      xpDepois: xpDepois,
      faseConcluida: widget.faseId,
    );

    final doc = await FirebaseFirestore.instance.collection('jogadores').doc(widget.docId).get();
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

    await FirebaseFirestore.instance.collection('jogadores').doc(widget.docId).update(update);
    setState(() => _faseConcluida = true);
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

  void _mostrarPopupVitoria() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("PARABENS!"),
        content: Text("VocÃª concluiu a fase $_tituloFase!"),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () { Navigator.pop(context); Navigator.pop(context); },
              child: const Text("IR PARA O MAPA"),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_itensDaFase.isEmpty) return const Scaffold();
    var itemAtual = _itensDaFase[_itemAtualIndex];

    return Scaffold(
      backgroundColor: _corFundo,
      body: Stack(
        children: [
          _buildHeader(),

          // Centro do Jogo
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(_tituloFase, style: TextStyle(fontSize: 18, color: Colors.grey[700], letterSpacing: 2)),
                const SizedBox(height: 10),
                Text(itemAtual['nome'], style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87)),
                const SizedBox(height: 60),
                Draggable<String>(
                  data: itemAtual['tipo'],
                  feedback: Material(color: Colors.transparent, child: Text(itemAtual['emoji'], style: const TextStyle(fontSize: 100))),
                  childWhenDragging: Opacity(opacity: 0.2, child: Text(itemAtual['emoji'], style: const TextStyle(fontSize: 80))),
                  child: Text(itemAtual['emoji'], style: const TextStyle(fontSize: 80)),
                ),
              ],
            ),
          ),

          // Lixeiras
          Positioned(
            bottom: 50, left: 0, right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildBin('papel', Colors.blue, 'PAPEL'),
                _buildBin('plastico', Colors.red, 'PLÃSTICO'),
                _buildBin('metal', Colors.amber, 'METAL'),
                _buildBin('vidro', Colors.green, 'VIDRO'),
              ],
            ),
          ),

          // --- MENSAGEM DE SUCESSO CENTRALIZADA ---
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
                        color: Colors.black.withOpacity(0.85),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
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

  Widget _buildBin(String tipo, Color cor, String label) {
    bool estaAnimando = _lixeiraAnimando == tipo;
    bool foiAcerto = _feedbackTipo == "acerto";
    return DragTarget<String>(
      onAccept: (dado) async {
        if (dado == tipo) {
          final respondeuRapido = DateTime.now().difference(_inicioPergunta).inSeconds < 5;
          _dispararFeedback("acerto", tipo);
          _mostrarCuriosidade(_itensDaFase[_itemAtualIndex]['nome'], () async {
            setState(() {
              _acertos++;
              _sequenciaAcertos++;
              if (respondeuRapido) {
                _respostasRapidas++;
              }
              if (_itemAtualIndex < _itensDaFase.length - 1) {
                _itemAtualIndex++;
                _inicioPergunta = DateTime.now();
              } else {
                _ganharFase();
              }
            });
            await FirebaseFirestore.instance.collection('jogadores').doc(widget.docId).update({
              'sequencia_acertos': _sequenciaAcertos,
              'perguntas_respondidas': FieldValue.increment(1),
              'respostas_rapidas': _respostasRapidas,
            });
            await _registrarSequenciaVerdeSeNecessario();
            await _registrarVelocidadeSolarSeNecessario();
            await _registrarMestreReciclagemSeNecessario();
          });
        } else {
          _dispararFeedback("erro", tipo);
          setState(() {
            _vidas--;
            _sequenciaAcertos = 0;
            _errouNaFase = true;
            if (_vidas <= 0) _perderJogo();
          });
          await FirebaseFirestore.instance.collection('jogadores').doc(widget.docId).update({
            'sequencia_acertos': 0,
            'perguntas_respondidas': FieldValue.increment(1),
            'respostas_rapidas': _respostasRapidas,
          });
          await _registrarMestreReciclagemSeNecessario();
        }
      },
      builder: (context, candidates, rejects) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: estaAnimando ? 85 : 75,
          height: 105,
          decoration: BoxDecoration(
            color: estaAnimando ? (foiAcerto ? Colors.green : Colors.red) : cor,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(estaAnimando ? (foiAcerto ? Icons.check : Icons.close) : Icons.delete_outline, color: Colors.white, size: 30),
              Text(label, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
            ],
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
                    child: Container(decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(5))),
                  ),
                ),
              ],
            ),
            Row(
              children: List.generate(3, (index) {
                return Icon(index < _vidas ? Icons.favorite : Icons.favorite_border, color: Colors.red, size: 28);
              }),
            ),
            IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _registrarMestreReciclagemSeNecessario() async {
    final doc = await FirebaseFirestore.instance.collection('jogadores').doc(widget.docId).get();
    final dados = doc.data() ?? {};
    final perguntasRespondidas = dados['perguntas_respondidas'] ?? 0;
    final conquistasDatas = Map<String, dynamic>.from(dados['conquistas_datas'] ?? {});
    final jaTemData = conquistasDatas['mestre_reciclagem'] != null;
    if (jaTemData || perguntasRespondidas < 20) return;

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
}

