import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController _nomeController = TextEditingController();
  bool _carregando = false;

  @override
  void dispose() {
    _nomeController.dispose();
    super.dispose();
  }

  Future<void> _registrarJogador() async {
    final nome = _nomeController.text.trim();
    if (nome.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, digite seu nome!'),
          backgroundColor: Colors.orangeAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    setState(() => _carregando = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_name', nome);
      await prefs.setInt('moedas', 0);
      await prefs.setInt('nivel', 1);
      await prefs.setInt('xp', 0);
      await prefs.setString('tema_ativo', 'padrao');
      await prefs.setStringList('fases_liberadas', ['1']);
      await prefs.setStringList('temas_comprados', ['padrao']);
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen(userName: nome)),
      );
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro ao salvar dados. Tente novamente.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/registration.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withValues(alpha: 0.15),
                Colors.black.withValues(alpha: 0.55),
              ],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: 90,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    const Text(
                      'BEM-VINDO AO',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 3,
                        shadows: [Shadow(color: Colors.black54, offset: Offset(2, 2), blurRadius: 8)],
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'ECOQUEST',
                      style: TextStyle(
                        color: Color(0xFFB2FF59),
                        fontSize: 64,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2,
                        shadows: [
                          Shadow(color: Colors.black, offset: Offset(4, 4), blurRadius: 12),
                          Shadow(color: Color(0xFF76FF03), offset: Offset(0, 0), blurRadius: 20),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.35),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Recicle. Aprenda. Salve o planeta.',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                          shadows: [Shadow(color: Colors.black, blurRadius: 4)],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 50,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 32),
                      padding: const EdgeInsets.fromLTRB(24, 28, 24, 28),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(32),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.4),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 20,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'QUAL É O SEU NOME, HERÓI?',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                              shadows: [Shadow(color: Colors.black54, blurRadius: 4)],
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: _nomeController,
                            textAlign: TextAlign.center,
                            textCapitalization: TextCapitalization.characters,
                            style: const TextStyle(
                              color: Color(0xFF1B5E20),
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                            decoration: InputDecoration(
                              hintText: 'DIGITE AQUI...',
                              hintStyle: TextStyle(color: Colors.grey[400], fontSize: 18),
                              filled: true,
                              fillColor: Colors.white.withValues(alpha: 0.95),
                              contentPadding: const EdgeInsets.symmetric(vertical: 18),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    GestureDetector(
                      onTap: _carregando ? null : _registrarJogador,
                      child: AnimatedScale(
                        scale: _carregando ? 0.92 : 1.0,
                        duration: const Duration(milliseconds: 120),
                        child: Container(
                          width: 260,
                          height: 75,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFF9800), Color(0xFFE64A19)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(40),
                            border: Border.all(color: Colors.white, width: 3.5),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.orange.withValues(alpha: 0.4),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                              const BoxShadow(color: Colors.black38, blurRadius: 8, offset: Offset(0, 4)),
                            ],
                          ),
                          child: Center(
                            child: _carregando
                                ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 3)
                                : const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'JOGAR',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 32,
                                          fontWeight: FontWeight.w900,
                                          letterSpacing: 2,
                                          shadows: [Shadow(color: Colors.black38, offset: Offset(2, 2))],
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Icon(Icons.play_arrow_rounded, color: Colors.white, size: 38),
                                    ],
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
