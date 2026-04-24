import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:ui'; // Necessário para o efeito de desfoque (Blur)

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
        _corFundo = const Color(0xFF81D4FA); // Azul vibrante
        _itensDaFase = [
          {'emoji': '🥤', 'tipo': 'plastico', 'nome': 'Copo de Plástico'},
          {'emoji': '🍾', 'tipo': 'vidro', 'nome': 'Garrafa de Vidro'},
        ];
        break;
      case 2:
        _tituloFase = "RESERVA FLORESTAL";
        _corFundo = const Color(0xFFA5D6A7); // Verde floresta
        _itensDaFase = [
          {'emoji': '📰', 'tipo': 'papel', 'nome': 'Jornal Velho'},
          {'emoji': '🥫', 'tipo': 'metal', 'nome': 'Lata de Conserva'},
          {'emoji': '📦', 'tipo': 'papel', 'nome': 'Caixa de Papelão'},
        ];
        break;
      case 3:
        _tituloFase = "RECICLAGEM URBANA";
        _corFundo = const Color(0xFFB0BEC5); // Cinzento urbano
        _itensDaFase = [
          {'emoji': '📺', 'tipo': 'plastico', 'nome': 'Sucata Eletrônica'},
          {'emoji': '🧴', 'tipo': 'plastico', 'nome': 'Frasco de Amaciante'},
          {'emoji': '🍷', 'tipo': 'vidro', 'nome': 'Taça Quebrada'},
          {'emoji': '🖇️', 'tipo': 'metal', 'nome': 'Clipes de Metal'},
        ];
        break;
      default:
        _tituloFase = "MISSÃO AVANÇADA";
        _corFundo = const Color(0xFFFFCC80); // Laranja suave
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
    try { await _audioPlayer.play(AssetSource('sounds/$nomeArquivo')); } catch (e) {
      debugPrint("Som não encontrado: $e");
    }
  }

  void _dispararFeedback(String tipo, String lixeira) {
    setState(() { _feedbackTipo = tipo; _lixeiraAnimando = lixeira; });
    _tocarSom(tipo == "acerto" ? 'acerto.mp3' : 'erro.mp3');
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) setState(() { _feedbackTipo = ""; _lixeiraAnimando = ""; });
    });
  }

  void _responder(String tipoSelecionado) {
    if (_faseConcluida || _vidas <= 0) return;
    String tipoCorreto = _itensDaFase[_itemAtualIndex]['tipo'];

    if (tipoSelecionado == tipoCorreto) {
      _dispararFeedback("acerto", tipoSelecionado);
      Future.delayed(const Duration(milliseconds: 400), () {
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
      });
    } else {
      _dispararFeedback("erro", tipoSelecionado);
      setState(() {
        _vidas--;
        if (_vidas <= 0) Future.delayed(const Duration(milliseconds: 400), _perderJogo);
      });
    }
  }

  // ... (As funções _mostrarCuriosidade, _perderJogo, _comprarVidas e _ganharFase permanecem exatamente iguais)
  void _mostrarCuriosidade(String nomeItem, VoidCallback aoFechar) {
    final dados = _dadosItens[nomeItem];
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Row(
          children: [
            Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.green.shade100, shape: BoxShape.circle), child: const Icon(Icons.eco, color: Colors.green)),
            const SizedBox(width: 12),
            const Text("VOCÊ SABIA?", style: TextStyle(fontWeight: FontWeight.w900, color: Colors.black87)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(nomeItem, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.green)),
            const Divider(height: 24),
            Text(dados?['info'] ?? "Este item é reciclável!", style: const TextStyle(fontSize: 15, color: Colors.black87, height: 1.4)),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.blueGrey.shade50, borderRadius: BorderRadius.circular(12)),
              child: Row(
                children: [
                  const Icon(Icons.timer_outlined, size: 22, color: Colors.blueGrey),
                  const SizedBox(width: 8),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(color: Colors.black87, fontSize: 13),
                        children: [
                          const TextSpan(text: "Decomposição:\n", style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(text: dados?['tempo'] ?? "Desconhecido", style: const TextStyle(color: Colors.blueGrey)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              onPressed: () { Navigator.pop(context); aoFechar(); },
              child: const Text("CONTINUAR", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text("SEM VIDAS! 💔", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w900)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("O planeta precisa de ti! Tenta a fase novamente ou recupera as tuas vidas.", textAlign: TextAlign.center),
            const SizedBox(height: 20),
            Container(padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20), decoration: BoxDecoration(color: Colors.amber.shade100, borderRadius: BorderRadius.circular(20)), child: Text("💰 Saldo: $_moedasLocais", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.amber.shade900, fontSize: 16))),
          ],
        ),
        actions: [
          Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.amber[800], padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  onPressed: _moedasLocais >= 1000 ? _comprarVidas : null,
                  icon: const Icon(Icons.shopping_cart, color: Colors.white),
                  label: const Text("COMPRAR 3 VIDAS (💰 1000)", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () { Navigator.pop(context); Navigator.pop(context); },
                child: const Text("SAIR PARA O MAPA", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<void> _comprarVidas() async {
    if (_moedasLocais >= 1000) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int moedasAtuais = prefs.getInt('moedas') ?? 0;
      if (moedasAtuais >= 1000) {
        await prefs.setInt('moedas', moedasAtuais - 1000);
        setState(() { _vidas = 3; _moedasLocais -= 1000; _mostrarMensagemSucesso = true; });
        if (context.mounted) Navigator.pop(context);
        Future.delayed(const Duration(seconds: 2), () { if (mounted) setState(() => _mostrarMensagemSucesso = false); });
      }
    }
  }

  Future<void> _ganharFase() async {
    if (_faseConcluida) return;
    _tocarSom('vitoria.mp3');
    setState(() => _faseConcluida = true);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int xpSalvo = prefs.getInt('xp') ?? 0;
    int moedasSalvas = prefs.getInt('moedas') ?? 0;
    await prefs.setInt('xp', xpSalvo + 20);
    await prefs.setInt('moedas', moedasSalvas + 50);
    List<String> fasesLiberadas = prefs.getStringList('fases_liberadas') ?? ['1'];
    String proximaFaseId = (widget.faseId + 1).toString();
    if (!fasesLiberadas.contains(proximaFaseId)) {
      fasesLiberadas.add(proximaFaseId);
      await prefs.setStringList('fases_liberadas', fasesLiberadas);
    }
    _mostrarPopupVitoria();
  }

  void _mostrarPopupVitoria() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Column(
          children: [
            Icon(Icons.star_rounded, color: Colors.amber, size: 60),
            SizedBox(height: 10),
            Text("Fase Concluída!", style: TextStyle(fontWeight: FontWeight.w900, color: Colors.black87)),
          ],
        ),
        content: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.green.shade200)),
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Recompensas:", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
              SizedBox(height: 10),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                Text("⭐ +20 XP", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text("💰 +50", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ]),
            ],
          ),
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              onPressed: () { Navigator.pop(context); Navigator.pop(context); },
              child: const Text("CONTINUAR A JORNADA", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
      body: Container(
        // Fundo com Gradiente bonito
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [_corFundo, Colors.white],
            stops: const [0.3, 1.0],
          ),
        ),
        child: Stack(
          children: [
            _buildHeader(),

            // Centro do Jogo
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Título da Fase num Pill (Cápsula)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      _tituloFase,
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Colors.blueGrey.shade800, letterSpacing: 1.5)
                    ),
                  ),
                  const SizedBox(height: 20),

                  // O Cartão do Item a ser reciclado
                  Text(itemAtual['nome'], style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: Colors.black87)),
                  const SizedBox(height: 6),
                  const Text("(Toca na lixeira correta ou arrasta o item)", style: TextStyle(fontSize: 13, color: Colors.black54, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 30),

                  // Cartão Flutuante Draggable
                  Draggable<String>(
                    data: itemAtual['tipo'],
                    feedback: Material(
                      color: Colors.transparent,
                      child: _buildItemCard(itemAtual['emoji'], isDragging: true)
                    ),
                    childWhenDragging: Opacity(
                      opacity: 0.3,
                      child: _buildItemCard(itemAtual['emoji'])
                    ),
                    child: _buildItemCard(itemAtual['emoji']),
                  ),
                ],
              ),
            ),

            // Lixeiras Coloridas em Baixo
            Positioned(
              bottom: 40, left: 0, right: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildBin('papel', const [Color(0xFF42A5F5), Color(0xFF1E88E5)], 'PAPEL', Icons.description_outlined),
                    _buildBin('plastico', const [Color(0xFFEF5350), Color(0xFFE53935)], 'PLÁSTICO', Icons.local_drink_outlined),
                    _buildBin('metal', const [Color(0xFFFFCA28), Color(0xFFFFB300)], 'METAL', Icons.settings_outlined),
                    _buildBin('vidro', const [Color(0xFF66BB6A), Color(0xFF43A047)], 'VIDRO', Icons.wine_bar_outlined),
                  ],
                ),
              ),
            ),

            // Mensagem de Sucesso (Comprar Vidas)
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
                          color: Colors.black87,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 15, spreadRadius: 2)],
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.favorite, color: Colors.redAccent),
                            SizedBox(width: 10),
                            Text("Vidas restauradas!", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                          ],
                        ),
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

  // Novo Widget: O Cartão do Item
  Widget _buildItemCard(String emoji, {bool isDragging = false}) {
    return Container(
      width: 160,
      height: 160,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDragging ? 0.2 : 0.1),
            blurRadius: isDragging ? 25 : 15,
            offset: Offset(0, isDragging ? 15 : 8),
          )
        ],
        border: Border.all(color: Colors.grey.shade100, width: 2),
      ),
      child: Center(
        child: Text(emoji, style: TextStyle(fontSize: isDragging ? 90 : 80)),
      ),
    );
  }

  // Novo Widget: As Lixeiras Premium
  Widget _buildBin(String tipo, List<Color> cores, String label, IconData icon) {
    bool estaAnimando = _lixeiraAnimando == tipo;
    bool foiAcerto = _feedbackTipo == "acerto";

    return DragTarget<String>(
      onAcceptWithDetails: (details) => _responder(tipo),
      builder: (context, candidates, rejects) {
        bool isHovered = candidates.isNotEmpty; // Efeito visual se arrastar por cima

        return GestureDetector(
          onTap: () => _responder(tipo),
          child: AnimatedScale(
            scale: estaAnimando || isHovered ? 1.1 : 1.0,
            duration: const Duration(milliseconds: 150),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: 80,
              height: estaAnimando ? 110 : 100,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: estaAnimando
                    ? (foiAcerto ? [Colors.greenAccent, Colors.green] : [Colors.redAccent, Colors.red])
                    : cores,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: cores.last.withValues(alpha: 0.4),
                    blurRadius: 10,
                    offset: const Offset(0, 5)
                  )
                ],
                border: Border.all(color: Colors.white.withValues(alpha: 0.5), width: 1.5),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    estaAnimando ? (foiAcerto ? Icons.check_circle : Icons.cancel) : icon,
                    color: Colors.white,
                    size: 32
                  ),
                  const SizedBox(height: 8),
                  Text(label, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Novo Header com Glassmorphism
  Widget _buildHeader() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Container de Progresso (Efeito de Vidro)
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.6)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("PROGRESSO ${_itemAtualIndex + 1}/${_itensDaFase.length}", style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 11, color: Colors.black87)),
                      const SizedBox(height: 6),
                      Container(
                        width: 110, height: 8,
                        decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.circular(10)),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: (_acertos / _itensDaFase.length).clamp(0.01, 1.0),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(colors: [Colors.greenAccent, Colors.green]),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: const [BoxShadow(color: Colors.green, blurRadius: 4)]
                            )
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Corações (Vidas)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: List.generate(3, (index) {
                  return AnimatedScale(
                    scale: index < _vidas ? 1.0 : 0.8,
                    duration: const Duration(milliseconds: 300),
                    child: Icon(
                      index < _vidas ? Icons.favorite : Icons.favorite_border,
                      color: index < _vidas ? Colors.redAccent : Colors.black26,
                      size: 26
                    ),
                  );
                }),
              ),
            ),

            // Botão Fechar
            Container(
              decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.5), shape: BoxShape.circle),
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close, color: Colors.black87),
                visualDensity: VisualDensity.compact,
              ),
            ),
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