import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'registration_screen.dart';
import 'home_screen.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  double _progresso = 0.0;
  String _statusText = 'Preparando as sementes da aventura...';

  @override
  void initState() {
    super.initState();
    _iniciarCarregamento();
  }

  Future<void> _iniciarCarregamento() async {
    for (int i = 0; i <= 100; i++) {
      await Future.delayed(const Duration(milliseconds: 45));
      if (!mounted) return;
      setState(() {
        _progresso = i / 100.0;
        if (i == 20) _statusText = 'Alinhando os painéis solares...';
        if (i == 50) _statusText = 'Calibrando a energia eólica...';
        if (i == 80) _statusText = 'Semeando energia positiva...';
        if (i == 95) _statusText = 'Quase lá...';
      });
    }
    await Future.delayed(const Duration(milliseconds: 400));
    _verificarUsuario();
  }

  Future<void> _verificarUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    final nomeSalvo = prefs.getString('user_name');
    if (!mounted) return;
    if (nomeSalvo != null && nomeSalvo.isNotEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen(userName: nomeSalvo)),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const RegistrationScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final altura = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background_eco.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withValues(alpha: 0.1),
                Colors.black.withValues(alpha: 0.6),
              ],
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                top: altura * 0.16,
                child: Column(
                  children: [
                    const Text(
                      'ECO',
                      style: TextStyle(
                        fontSize: 56,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFFB2FF59),
                        letterSpacing: 8,
                        shadows: [
                          Shadow(color: Colors.black54, offset: Offset(3, 3), blurRadius: 12),
                        ],
                      ),
                    ),
                    const Text(
                      'QUEST',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 12,
                        shadows: [
                          Shadow(color: Colors.black54, offset: Offset(2, 2), blurRadius: 8),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 60,
                left: 32,
                right: 32,
                child: Column(
                  children: [
                    Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFF0D2010),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: const Color(0xFFB2FF59), width: 2.5),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF76FF03).withValues(alpha: 0.3),
                            blurRadius: 16,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          FractionallySizedBox(
                            widthFactor: _progresso,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(28),
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF76FF03), Color(0xFF2E7D32)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                            ),
                          ),
                          Center(
                            child: Text(
                              '${(_progresso * 100).toInt()}%',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 18,
                                shadows: [Shadow(color: Colors.black, blurRadius: 6)],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _statusText,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.italic,
                        shadows: [Shadow(color: Colors.black, blurRadius: 6)],
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
