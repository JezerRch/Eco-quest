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
    required this.moedasAtuais,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  // 44 itens únicos — cada fase usa itens exclusivos sem repetição
  final Map<String, Map<String, String>> _dadosItens = {
    // Fase 1
    'Copo de Plástico':     {'info': 'Plásticos se quebram em microplásticos que poluem o oceano.', 'tempo': '200 a 450 anos'},
    'Garrafa de Vidro':     {'info': 'O vidro é 100% reciclável e pode ser reutilizado infinitamente.', 'tempo': 'Mais de 4 mil anos'},
    // Fase 2
    'Jornal Velho':         {'info': 'Reciclar papel economiza muita água e energia na produção.', 'tempo': '2 a 6 semanas'},
    'Lata de Conserva':     {'info': 'O aço reciclado volta para a indústria como novas latas ou peças.', 'tempo': '10 a 100 anos'},
    'Caixa de Papelão':     {'info': 'A reciclagem de 1 tonelada de papel evita o corte de 20 árvores.', 'tempo': '3 a 6 meses'},
    // Fase 3
    'Sucata Eletrônica':    {'info': 'Possui metais como ouro e cobre que podem ser recuperados.', 'tempo': 'Indeterminado e altamente poluente'},
    'Frasco de Amaciante':  {'info': 'Este plástico (PEAD) é muito valorizado no mercado de reciclagem.', 'tempo': 'Até 450 anos'},
    'Taça Quebrada':        {'info': 'Vidros domésticos têm temperatura de fusão diferente de garrafas.', 'tempo': '4 mil anos'},
    'Clipes de Metal':      {'info': 'Pequenos objetos metálicos devem ser agrupados para não se perderem.', 'tempo': '10 a 100 anos'},
    // Fase 4
    'Bateria Velha':        {'info': 'Contém substâncias químicas que podem causar doenças graves.', 'tempo': '100 a 500 anos'},
    'Revista Antiga':       {'info': 'O papel das revistas pode ser transformado em novos cadernos.', 'tempo': '4 a 6 meses'},
    'Régua Plástica':       {'info': 'Plástico rígido leva séculos para se decompor no meio ambiente.', 'tempo': '400 a 500 anos'},
    'Caderno Rascunho':     {'info': 'Reciclar papel economiza 60% de energia em relação à produção nova.', 'tempo': '2 a 6 semanas'},
    // Fase 5
    'Sacola Plástica':      {'info': 'É um dos itens que mais causa morte de animais marinhos.', 'tempo': '10 a 20 anos'},
    'Embalagem de Leite':   {'info': 'Embalagens Tetra Pak são recicláveis em pontos de coleta especiais.', 'tempo': '3 a 6 meses'},
    'Latinha de Alumínio':  {'info': 'O alumínio pode ser reciclado infinitamente sem perder qualidade.', 'tempo': '80 a 100 anos'},
    'Frasco de Remédio':    {'info': 'Vidros de remédio nunca devem ser descartados com o lixo comum.', 'tempo': '4 mil anos'},
    // Fase 6
    'Talher de Alumínio':   {'info': 'Reciclar alumínio gasta apenas 5% da energia de extrair o minério.', 'tempo': '200 a 500 anos'},
    'Lata de Tinta':        {'info': 'Latas de tinta vazias devem ir a ecopontos especializados.', 'tempo': '10 a 100 anos'},
    'Fio de Cobre':         {'info': 'O cobre é altamente valorizado no mercado de reciclagem global.', 'tempo': '50 a 100 anos'},
    'Cabo de Carregador':   {'info': 'O lixo eletrônico cresce 21% ao ano e contém substâncias tóxicas.', 'tempo': 'Indeterminado'},
    'Pote de Vidro':        {'info': 'O vidro é 100% reciclável e pode ser reprocessado infinitamente.', 'tempo': 'Mais de 4 mil anos'},
    // Fase 7
    'Rolo de Papel':        {'info': 'O rolo interno do papel higiênico é 100% reciclável.', 'tempo': '1 a 3 meses'},
    'Frasco de Óleo':       {'info': 'Óleo de cozinha nunca deve ser descartado na pia ou no lixo comum.', 'tempo': 'Até 450 anos'},
    'Parafuso Velho':       {'info': 'Metais ferrosos como aço e ferro têm alta taxa de reciclagem.', 'tempo': '10 a 100 anos'},
    'Lâmpada Queimada':     {'info': 'Lâmpadas fluorescentes contêm mercúrio e exigem descarte especial.', 'tempo': 'Varia (componentes perigosos)'},
    'Embalagem de Manteiga':{'info': 'Potes plásticos devem ser lavados antes de ir para a reciclagem.', 'tempo': '400 a 450 anos'},
    // Fase 8
    'Garrafa de Aço':       {'info': 'O aço é um dos metais mais reciclados do mundo, com taxa de 85%.', 'tempo': '80 a 100 anos'},
    'Caixa de Pizza':       {'info': 'Caixas sem gordura são recicláveis; manchadas vão ao lixo orgânico.', 'tempo': '3 a 6 meses'},
    'Frasco de Perfume':    {'info': 'Frascos de vidro de perfume podem ser reciclados com outros vidros.', 'tempo': 'Mais de 4 mil anos'},
    'Brinquedo de Plástico':{'info': 'Brinquedos velhos podem ser doados ou enviados a pontos de reciclagem.', 'tempo': '200 a 500 anos'},
    'Tampinha de Metal':    {'info': 'Tampinhas metálicas são muito procuradas por catadores e têm alto valor.', 'tempo': '10 a 100 anos'},
    // Fase 9
    'Copo de Vidro':        {'info': 'Copos de vidro devem ser descartados em pontos específicos de coleta.', 'tempo': 'Mais de 4 mil anos'},
    'Pote de Sorvete':      {'info': 'Potes de plástico devem ser lavados antes de ir para a reciclagem seletiva.', 'tempo': '400 a 450 anos'},
    'Lata de Atum':         {'info': 'Latas de metal são 100% recicláveis e têm alta demanda no mercado.', 'tempo': '10 a 100 anos'},
    'Papel de Presente':    {'info': 'Papéis sem brilho são recicláveis; os metalizados e plastificados, não.', 'tempo': '2 a 6 semanas'},
    'CD Velho':             {'info': 'CDs contêm plástico policarbonato e devem ir à coleta de eletrônicos.', 'tempo': 'Mais de 400 anos'},
    'Embalagem de Comprimido':{'info': 'Blisteres de remédio têm alumínio e plástico; verifique como separar.', 'tempo': '400 a 500 anos'},
    // Fase 10
    'Espelho Quebrado':     {'info': 'Espelhos têm revestimento especial e não podem ser reciclados com vidros comuns.', 'tempo': 'Mais de 4 mil anos'},
    'Arquivo de Papel':     {'info': 'Documentos de papel podem ser picotados e reciclados normalmente.', 'tempo': '2 a 6 semanas'},
    'Chave Inglesa':        {'info': 'Ferramentas velhas de metal são aceitas em sucateiros e ecopontos.', 'tempo': '50 a 100 anos'},
    'Lixeira de Plástico':  {'info': 'Mesmo lixeiras plásticas velhas podem ser recicladas corretamente.', 'tempo': '400 a 450 anos'},
    'Pote de Mel':          {'info': 'Potes de vidro de mel devem ser lavados e ter a tampa separada.', 'tempo': 'Mais de 4 mil anos'},
    'Engrenagem de Metal':  {'info': 'Peças metálicas de máquinas velhas podem ser reaproveitadas na indústria.', 'tempo': '50 a 100 anos'},
  };

  late List<Map<String, dynamic>> _itensDaFase;
  late String _tituloFase;
  late Color _corFundo;
  late Color _corDestaque;

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
        _tituloFase = "🏖️ LIMPEZA NA PRAIA";
        _corFundo = const Color(0xFFE1F5FE);
        _corDestaque = const Color(0xFF0288D1);
        _itensDaFase = [
          {'emoji': '🥤', 'tipo': 'plastico', 'nome': 'Copo de Plástico'},
          {'emoji': '🍾', 'tipo': 'vidro',    'nome': 'Garrafa de Vidro'},
        ];
        break;
      case 2:
        _tituloFase = "🌲 RESERVA FLORESTAL";
        _corFundo = const Color(0xFFE8F5E9);
        _corDestaque = const Color(0xFF388E3C);
        _itensDaFase = [
          {'emoji': '📰', 'tipo': 'papel',  'nome': 'Jornal Velho'},
          {'emoji': '🥫', 'tipo': 'metal',  'nome': 'Lata de Conserva'},
          {'emoji': '📦', 'tipo': 'papel',  'nome': 'Caixa de Papelão'},
        ];
        break;
      case 3:
        _tituloFase = "🏙️ RECICLAGEM URBANA";
        _corFundo = const Color(0xFFF5F5F5);
        _corDestaque = const Color(0xFF546E7A);
        _itensDaFase = [
          {'emoji': '📺', 'tipo': 'plastico', 'nome': 'Sucata Eletrônica'},
          {'emoji': '🧴', 'tipo': 'plastico', 'nome': 'Frasco de Amaciante'},
          {'emoji': '🍷', 'tipo': 'vidro',    'nome': 'Taça Quebrada'},
          {'emoji': '🖇️', 'tipo': 'metal',    'nome': 'Clipes de Metal'},
        ];
        break;
      case 4:
        _tituloFase = "🏫 MISSÃO ESCOLA";
        _corFundo = const Color(0xFFFFF9C4);
        _corDestaque = const Color(0xFFF9A825);
        _itensDaFase = [
          {'emoji': '🔋', 'tipo': 'metal',   'nome': 'Bateria Velha'},
          {'emoji': '🗞️', 'tipo': 'papel',   'nome': 'Revista Antiga'},
          {'emoji': '📐', 'tipo': 'plastico', 'nome': 'Régua Plástica'},
          {'emoji': '📓', 'tipo': 'papel',   'nome': 'Caderno Rascunho'},
        ];
        break;
      case 5:
        _tituloFase = "🏞️ SALVE O RIO";
        _corFundo = const Color(0xFFE0F7FA);
        _corDestaque = const Color(0xFF0097A7);
        _itensDaFase = [
          {'emoji': '🛍️', 'tipo': 'plastico', 'nome': 'Sacola Plástica'},
          {'emoji': '🥛', 'tipo': 'papel',    'nome': 'Embalagem de Leite'},
          {'emoji': '🍺', 'tipo': 'metal',    'nome': 'Latinha de Alumínio'},
          {'emoji': '🧪', 'tipo': 'vidro',    'nome': 'Frasco de Remédio'},
        ];
        break;
      case 6:
        _tituloFase = "⚡ USINA VERDE";
        _corFundo = const Color(0xFFF3E5F5);
        _corDestaque = const Color(0xFF7B1FA2);
        _itensDaFase = [
          {'emoji': '🥄', 'tipo': 'metal',   'nome': 'Talher de Alumínio'},
          {'emoji': '🪣', 'tipo': 'metal',   'nome': 'Lata de Tinta'},
          {'emoji': '🔌', 'tipo': 'metal',   'nome': 'Fio de Cobre'},
          {'emoji': '🪫', 'tipo': 'plastico', 'nome': 'Cabo de Carregador'},
          {'emoji': '🫙', 'tipo': 'vidro',   'nome': 'Pote de Vidro'},
        ];
        break;
      case 7:
        _tituloFase = "🌿 ECO RESERVA";
        _corFundo = const Color(0xFFE8EAF6);
        _corDestaque = const Color(0xFF3949AB);
        _itensDaFase = [
          {'emoji': '🧻', 'tipo': 'papel',   'nome': 'Rolo de Papel'},
          {'emoji': '🫗', 'tipo': 'plastico', 'nome': 'Frasco de Óleo'},
          {'emoji': '🔩', 'tipo': 'metal',   'nome': 'Parafuso Velho'},
          {'emoji': '💡', 'tipo': 'vidro',   'nome': 'Lâmpada Queimada'},
          {'emoji': '🧈', 'tipo': 'plastico', 'nome': 'Embalagem de Manteiga'},
        ];
        break;
      case 8:
        _tituloFase = "🏔️ MISSÃO MONTANHA";
        _corFundo = const Color(0xFFF1F8E9);
        _corDestaque = const Color(0xFF558B2F);
        _itensDaFase = [
          {'emoji': '🍶', 'tipo': 'metal',   'nome': 'Garrafa de Aço'},
          {'emoji': '🍕', 'tipo': 'papel',   'nome': 'Caixa de Pizza'},
          {'emoji': '🔮', 'tipo': 'vidro',   'nome': 'Frasco de Perfume'},
          {'emoji': '🎮', 'tipo': 'plastico', 'nome': 'Brinquedo de Plástico'},
          {'emoji': '🪙', 'tipo': 'metal',   'nome': 'Tampinha de Metal'},
        ];
        break;
      case 9:
        _tituloFase = "🌊 MISSÃO OCEANO";
        _corFundo = const Color(0xFFE3F2FD);
        _corDestaque = const Color(0xFF1565C0);
        _itensDaFase = [
          {'emoji': '🥃', 'tipo': 'vidro',   'nome': 'Copo de Vidro'},
          {'emoji': '🍨', 'tipo': 'plastico', 'nome': 'Pote de Sorvete'},
          {'emoji': '🐟', 'tipo': 'metal',   'nome': 'Lata de Atum'},
          {'emoji': '🎁', 'tipo': 'papel',   'nome': 'Papel de Presente'},
          {'emoji': '💿', 'tipo': 'plastico', 'nome': 'CD Velho'},
          {'emoji': '💊', 'tipo': 'plastico', 'nome': 'Embalagem de Comprimido'},
        ];
        break;
      default: // Fase 10
        _tituloFase = "🌍 MESTRE SUSTENTÁVEL";
        _corFundo = const Color(0xFFFFF8E1);
        _corDestaque = const Color(0xFFE65100);
        _itensDaFase = [
          {'emoji': '🪞', 'tipo': 'vidro',   'nome': 'Espelho Quebrado'},
          {'emoji': '📂', 'tipo': 'papel',   'nome': 'Arquivo de Papel'},
          {'emoji': '🔧', 'tipo': 'metal',   'nome': 'Chave Inglesa'},
          {'emoji': '🗑️', 'tipo': 'plastico', 'nome': 'Lixeira de Plástico'},
          {'emoji': '🍯', 'tipo': 'vidro',   'nome': 'Pote de Mel'},
          {'emoji': '⚙️', 'tipo': 'metal',   'nome': 'Engrenagem de Metal'},
        ];
    }
  }

  void _tocarSom(String nomeArquivo) async {
    try {
      await _audioPlayer.play(AssetSource('sounds/$nomeArquivo'));
    } catch (_) {}
  }

  void _dispararFeedback(String tipo, String lixeira) {
    setState(() {
      _feedbackTipo = tipo;
      _lixeiraAnimando = lixeira;
    });
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
        backgroundColor: const Color(0xFFF9FBE7),
        title: const Row(
          children: [
            Icon(Icons.eco, color: Colors.green),
            SizedBox(width: 8),
            Text("VOCÊ SABIA?", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(nomeItem, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.black87)),
            const Divider(),
            const SizedBox(height: 6),
            Text(dados?['info'] ?? "Este item é reciclável!", style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(color: Colors.blueGrey.shade50, borderRadius: BorderRadius.circular(8)),
              child: Row(
                children: [
                  const Icon(Icons.timer_outlined, size: 18, color: Colors.blueGrey),
                  const SizedBox(width: 6),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(color: Colors.black87, fontSize: 13),
                        children: [
                          const TextSpan(text: "Decomposição: ", style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(text: dados?['tempo'] ?? "Desconhecido"),
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
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              ),
              onPressed: () { Navigator.pop(context); aoFechar(); },
              child: const Text("CONTINUAR", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
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
        title: const Text("SEM VIDAS! 💔", textAlign: TextAlign.center, style: TextStyle(fontSize: 20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("O planeta precisa de você! Tente novamente ou recupere suas vidas.", textAlign: TextAlign.center),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(color: Colors.amber.shade50, borderRadius: BorderRadius.circular(10)),
              child: Text("Saldo: 💰 $_moedasLocais", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ],
        ),
        actions: [
          Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber[800],
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: _moedasLocais >= 1000 ? _comprarVidas : null,
                  icon: const Icon(Icons.favorite, color: Colors.white),
                  label: const Text("COMPRAR 3 VIDAS (💰 1000)", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
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
    if (_moedasLocais < 1000) return;
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
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) setState(() => _mostrarMensagemSucesso = false);
      });
    } catch (e) {
      debugPrint("Erro ao comprar vidas: $e");
    }
  }

  Future<void> _ganharFase() async {
    if (_faseConcluida) return;
    _tocarSom('vitoria.mp3');
    final Map<String, dynamic> updates = {
      'xp': FieldValue.increment(20),
      'moedas': FieldValue.increment(50),
    };
    if (widget.faseId < 10) {
      updates['fases_liberadas'] = FieldValue.arrayUnion([widget.faseId + 1]);
    }
    await FirebaseFirestore.instance.collection('jogadores').doc(widget.docId).update(updates);
    setState(() => _faseConcluida = true);
    _mostrarPopupVitoria();
  }

  void _mostrarPopupVitoria() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: const Color(0xFFF1F8E9),
        title: const Text("🌟 PARABÉNS!", textAlign: TextAlign.center, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Fase concluída com sucesso!", textAlign: TextAlign.center, style: TextStyle(fontSize: 15)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _recompensaChip("⭐ +20 XP", Colors.orange),
                const SizedBox(width: 10),
                _recompensaChip("💰 +50", Colors.amber),
              ],
            ),
          ],
        ),
        actions: [
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () { Navigator.pop(context); Navigator.pop(context); },
              child: const Text("IR PARA O MAPA", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _recompensaChip(String label, Color cor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: cor.withOpacity(0.15), border: Border.all(color: cor), borderRadius: BorderRadius.circular(20)),
      child: Text(label, style: TextStyle(color: cor, fontWeight: FontWeight.bold)),
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

          // Item atual
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: _corDestaque.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(_tituloFase, style: TextStyle(fontSize: 14, color: _corDestaque, letterSpacing: 1.5, fontWeight: FontWeight.w600)),
                ),
                const SizedBox(height: 12),
                Text(itemAtual['nome'], style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black87)),
                const SizedBox(height: 8),
                const Text("Arraste para a lixeira correta", style: TextStyle(fontSize: 12, color: Colors.black45)),
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

          // Lixeiras
          Positioned(
            bottom: 40, left: 0, right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildBin('papel',   Colors.blue.shade600,   '📄', 'PAPEL'),
                _buildBin('plastico',Colors.red.shade600,    '🧴', 'PLÁSTICO'),
                _buildBin('metal',   Colors.amber.shade700,  '🔩', 'METAL'),
                _buildBin('vidro',   Colors.green.shade600,  '🍾', 'VIDRO'),
              ],
            ),
          ),

          // Mensagem de sucesso
          if (_mostrarMensagemSucesso)
            Center(
              child: TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 300),
                tween: Tween(begin: 0.0, end: 1.0),
                builder: (context, val, child) => Opacity(
                  opacity: val,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.85),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Text(
                      "❤️ Vidas restauradas!",
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBin(String tipo, Color cor, String emoji, String label) {
    bool estaAnimando = _lixeiraAnimando == tipo;
    bool foiAcerto = _feedbackTipo == "acerto";
    return DragTarget<String>(
      onAcceptWithDetails: (details) {
        final dado = details.data;
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
        final bool hovering = candidates.isNotEmpty;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: estaAnimando ? 82 : (hovering ? 80 : 72),
          height: estaAnimando ? 110 : (hovering ? 108 : 100),
          decoration: BoxDecoration(
            color: estaAnimando
                ? (foiAcerto ? Colors.green.shade600 : Colors.red.shade600)
                : (hovering ? cor.withOpacity(0.8) : cor),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: cor.withOpacity(0.4), blurRadius: 8, offset: const Offset(0, 4))],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                estaAnimando ? (foiAcerto ? '✅' : '❌') : emoji,
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 4),
              Text(label, style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "ITEM ${_itemAtualIndex + 1} / ${_itensDaFase.length}",
                  style: TextStyle(fontWeight: FontWeight.bold, color: _corDestaque, fontSize: 13),
                ),
                const SizedBox(height: 6),
                Container(
                  width: 110, height: 8,
                  decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.circular(5)),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: (_acertos / _itensDaFase.length).clamp(0.01, 1.0),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [_corDestaque.withOpacity(0.7), _corDestaque]),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: List.generate(3, (index) => Padding(
                padding: const EdgeInsets.only(left: 2),
                child: Icon(
                  index < _vidas ? Icons.favorite : Icons.favorite_border,
                  color: Colors.red,
                  size: 26,
                ),
              )),
            ),
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.close),
              style: IconButton.styleFrom(backgroundColor: Colors.black12),
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
