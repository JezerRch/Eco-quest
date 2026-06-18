import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'registration_screen.dart';
import 'home_screen.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  double _progresso = 0.0;
  String _statusText = "Preparando as sementes da aventura...";

  @override
  void initState() {
    super.initState();
    _iniciarSimulacaoCarregamento();
  }

  Future<void> _iniciarSimulacaoCarregamento() async {
    // Aumentando de 1 em 1% para um movimento bem mais fluido e lento
    for (int i = 0; i <= 100; i++) {
      // 50 milissegundos * 100 passos = 5 segundos de carregamento total
      // Se quiser ainda mais lento, aumente o valor de '50'
      await Future.delayed(Duration(milliseconds: 50));

      if (!mounted) return;

      setState(() {
        _progresso = i / 100.0;

        // Ajuste dos textos de status baseados na nova escala de 100
        if (i == 20) _statusText = "Alinhando os painéis solares...";
        if (i == 50) _statusText = "Calibrando a energia eólica...";
        if (i == 80) _statusText = "Semeando energia positiva...";
      });
    }

    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;
    await precacheImage(const AssetImage('assets/background_eco.jpg'), context);
    if (!mounted) return;
    await precacheImage(const AssetImage('assets/background_eco1.png'), context);
    if (!mounted) return;
    await precacheImage(const AssetImage('assets/registration.jpg'), context);

    await _verificarUsuario();
  }

  Future<void> _verificarUsuario() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? nomeSalvo = prefs.getString('user_name');
    if (!mounted) return;

    if (nomeSalvo != null && nomeSalvo.isNotEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen(userName: nomeSalvo)),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => RegistrationScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background_eco.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // --- TEXTO EM CIMA DA CABEÇA DO ROBÔ ---
            Positioned(
              top: MediaQuery.of(context).size.height * 0.18, // Posicionamento dinâmico
              child: Text(
                "RECARREGANDO\nENERGIAS...",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w900, // CORRIGIDO: de .black para .w900
                  color: Colors.white,
                  shadows: [
                    Shadow(color: Colors.greenAccent, offset: Offset(2, 2), blurRadius: 2),
                    Shadow(color: Colors.black45, offset: Offset(3, 3), blurRadius: 10),
                  ],
                ),
              ),
            ),

            // --- BARRA E STATUS NA PARTE INFERIOR ---
            Positioned(
              bottom: 60,
              left: 30,
              right: 30,
              child: Column(
                children: [
                  // BARRA ESTILIZADA
                  Container(
                    height: 45,
                    decoration: BoxDecoration(
                      color: Color(0xFF1B300B), // Fundo bem escuro para contraste
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: Color(0xFFB2FF59), width: 3),
                      boxShadow: [
                        BoxShadow(color: Colors.black54, blurRadius: 8, offset: Offset(0, 4))
                      ],
                    ),
                    child: Stack(
                      children: [
                        // O preenchimento com Gradiente
                        FractionallySizedBox(
                          widthFactor: _progresso,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: LinearGradient(
                                colors: [Color(0xFF76FF03), Color(0xFF33691E)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                          ),
                        ),
                        // Texto da porcentagem
                        Center(
                          child: Text(
                            "${(_progresso * 100).toInt()}%",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              shadows: [Shadow(color: Colors.black, blurRadius: 4)],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 15),
                  Text(
                    _statusText,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.italic,
                      shadows: [Shadow(color: Colors.black, blurRadius: 4)],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}