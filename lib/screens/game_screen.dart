import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:audioplayers/audioplayers.dart';

class GameScreen extends StatefulWidget {
  final int faseId;
  final String docId;
  final int xpAtual;
  final int nivelAtual;
  final int moedasAtuais;

  const GameScreen({
    super.key,
    required this.faseId,
    required this.docId,
    required this.xpAtual,
    required this.nivelAtual,
    required this.moedasAtuais
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  final Map<String, Map<String, String>> _dadosItens = {
    'Copo de Plástico': {'info': 'Plásticos se quebram em microplásticos que poluem o oceano.', 'tempo': '200 a 450 anos'},
    'Garrafa de Vidro': {'info': 'O vidro é 100% reciclável e pode ser reutilizado infinitamente.', 'tempo': 'Indeterminado (mais de 4 mil anos)'},
    'Jornal Velho': {'info': 'Reciclar papel economiza muita água e energia na produção.', 'tempo': '2 a 6 semanas'},
    'Lata de Conserva': {'info': 'O aço reciclado volta para a indústria como peças de carro ou novas latas.', 'tempo': '10 a 100 anos'},
    'Caixa de Papelão': {'info': 'A reciclagem de 1 tonelada de papel evita o corte de 20 árvores.', 'tempo': '3 a 6 meses'},
    'Sucata Eletrônica': {'info': 'Possui metais como ouro e cobre que podem ser recuperados.', 'tempo': 'Indeterminado e altamente poluente'},
    'Frasco de Amaciante': {'info': 'Este plástico (PEAD) é muito valorizado no mercado de reciclagem.', 'tempo': 'Até 450 anos'},
    'Taça Quebrada': {'info': 'Vidros domésticos têm temperatura de fusão diferente de garrafas.', 'tempo': '4 mil anos'},
    'Clipes de Metal': {'info': 'Pequenos objetos metálicos devem ser agrupados para não se perderem.', 'tempo': '10 a 100 anos'},
    'Bateria Velha': {'info': 'Contém substâncias químicas que podem causar doenças graves.', 'tempo': '100 a 500 anos'},
    'Revista Antiga': {'info': 'O papel das revistas pode ser transformado em novos cadernos.', 'tempo': '4 a 6 meses'},
    'Frasco de Remédio': {'info': 'Vidros de remédio nunca devem ser descartados com o lixo comum.', 'tempo': '4 mil anos'},
    'Sacola Plástica': {'info': 'É um dos itens que mais causa morte de animais marinhos.', 'tempo': '10 a 20 anos'},
    'Talher de Alumínio': {'info': 'Reciclar alumínio gasta apenas 5% da energia de extrair o minério.', 'tempo': '200 a 500 anos'},
  };

  late List<Map<String, dynamic>> _itensDaFase;
  late String _tituloFase;
  late Color _corFundo;

  int _acertos = 0;
  int _vidas = 3;
  int _itemAtualIndex = 0;
  bool _faseConcluida = false;
  String _feedbackTipo = "";
  String _lixeiraAnimando = "";

  // Variáveis para controle de moedas e mensagem central
  late int _moedasLocais;
  bool _mostrarMensagemSucesso = false;

  @override
  void initState() {
    super.initState();
    _moedasLocais = widget.moedasAtuais;
    _configurarFase();
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
          {'emoji': '📺', 'tipo': 'plastico', 'nome': 'Sucata Eletrônica'},
          {'emoji': '🧴', 'tipo': 'plastico', 'nome': 'Frasco de Amaciante'},
          {'emoji': '🍷', 'tipo': 'vidro', 'nome': 'Taça Quebrada'},
          {'emoji': '🖇️', 'tipo': 'metal', 'nome': 'Clipes de Metal'},
        ];
        break;
      default:
        _tituloFase = "MISSÃO AVANÇADA";
        _corFundo = const Color(0xFFFFF3E0);
        _itensDaFase = [
          {'emoji': '🔋', 'tipo': 'metal', 'nome': 'Bateria Velha'},
          {'emoji': '🗞️', 'tipo': 'papel', 'nome': 'Revista Antiga'},
          {'emoji': '🧪', 'tipo': 'vidro', 'nome': 'Frasco de Remédio'},
          {'emoji': '🛍️', 'tipo': 'plastico', 'nome': 'Sacola Plástica'},
          {'emoji': '🥄', 'tipo': 'metal', 'nome': 'Talher de Alumínio'},
        ];
    }
  }

  void _tocarSom(String nomeArquivo) async {
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
          children: [Icon(Icons.eco, color: Colors.green), SizedBox(width: 10), Text("VOCÊ SABIA?")],
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
        title: const Text("SEM VIDAS! 💔", textAlign: TextAlign.center),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("O planeta precisa de você! Tente a fase novamente ou recupere suas vidas."),
            const SizedBox(height: 20),
            Text("Saldo atual: 💰 $_moedasLocais", style: const TextStyle(fontWeight: FontWeight.bold)),
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
                  label: const Text("COMPRAR 3 VIDAS (💰 1000)", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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

        Navigator.pop(context); // Fecha o diálogo de erro

        // Esconde a mensagem central após 2 segundos
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
    await FirebaseFirestore.instance.collection('jogadores').doc(widget.docId).update({
      'xp': FieldValue.increment(20),
      'moedas': FieldValue.increment(50),
      'fases_liberadas': FieldValue.arrayUnion([widget.faseId + 1]),
    });
    setState(() => _faseConcluida = true);
    _mostrarPopupVitoria();
  }

  void _mostrarPopupVitoria() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("🌟 PARABÉNS!"),
        content: Text("Você concluiu a fase $_tituloFase!"),
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
                _buildBin('plastico', Colors.red, 'PLÁSTICO'),
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
      onAccept: (dado) {
        if (dado == tipo) {
          _dispararFeedback("acerto", tipo);
          _mostrarCuriosidade(_itensDaFase[_itemAtualIndex]['nome'], () {
            setState(() {
              _acertos++;
              if (_itemAtualIndex < _itensDaFase.length - 1) {
                _itemAtualIndex++;
              } else {
                _ganharFase();
              }
            });
          });
        } else {
          _dispararFeedback("erro", tipo);
          setState(() {
            _vidas--;
            if (_vidas <= 0) _perderJogo();
          });
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
}