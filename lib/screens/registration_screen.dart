import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController _nameController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _registrarJogador() async {
    String nome = _nameController.text.trim();

    if (nome.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Por favor, digite seu nome!"),
            backgroundColor: Colors.orangeAccent
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final collection = FirebaseFirestore.instance.collection('jogadores');

      final existing = await collection.where('nome', isEqualTo: nome).limit(1).get();
      if (existing.docs.isNotEmpty) {
        final existingDoc = existing.docs.first;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_name', nome);
        await prefs.setString('user_id', existingDoc.id);
        if (!mounted) return;
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen(userName: nome)));
        return;
      }

      DocumentReference docRef = await collection.add({
        'nome': nome,
        'nome_search': nome.toLowerCase(),
        'moedas': 0,
        'nivel': 1,
        'xp': 0,
        'status': 'ativo',
        'data_criacao': FieldValue.serverTimestamp(),
        'fases_liberadas': [1],
        'tema_ativo': 'padrao',
        'temas_comprados': ['padrao'],
      });

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_name', nome);
      await prefs.setString('user_id', docRef.id);

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen(userName: nome)),
      );
    } on FirebaseException catch (e) {
      debugPrint("Erro Firestore: ${e.code}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro no banco: ${e.message}")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Verifique sua conexão com a internet.")),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
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
            image: AssetImage("assets/registration.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 80,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  const Text(
                    "BEM-VINDO AO",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                      shadows: [Shadow(color: Colors.black, offset: Offset(2, 2), blurRadius: 8)],
                    ),
                  ),
                  const Text(
                    "ECO-BOT",
                    style: TextStyle(
                      color: Color(0xFFB2FF59),
                      fontSize: 60,
                      fontWeight: FontWeight.w900,
                      shadows: [
                        Shadow(color: Colors.black, offset: Offset(4, 4), blurRadius: 10),
                        Shadow(color: Colors.black45, offset: Offset(-1, -1), blurRadius: 2),
                      ],
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
                    margin: const EdgeInsets.symmetric(horizontal: 35),
                    padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(35),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.5), width: 2),
                      boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 15, spreadRadius: 2)],
                    ),
                    child: Column(
                      children: [
                        const Text(
                          "QUAL É O SEU NOME?",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            shadows: [Shadow(color: Colors.black54, blurRadius: 4)],
                          ),
                        ),
                        const SizedBox(height: 15),
                        TextField(
                          controller: _nameController,
                          textAlign: TextAlign.center,
                          textCapitalization: TextCapitalization.characters,
                          style: const TextStyle(
                              color: Color(0xFF1B5E20),
                              fontSize: 22,
                              fontWeight: FontWeight.bold
                          ),
                          decoration: InputDecoration(
                            hintText: "DIGITE AQUI...",
                            hintStyle: TextStyle(color: Colors.grey[500], fontSize: 18),
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
                  const SizedBox(height: 25),
                  GestureDetector(
                    onTap: _isLoading ? null : _registrarJogador,
                    child: AnimatedScale(
                      scale: _isLoading ? 0.9 : 1.0,
                      duration: const Duration(milliseconds: 100),
                      child: Container(
                        width: 270,
                        height: 80,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFF9800), Color(0xFFFF5722)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: BorderRadius.circular(40),
                          border: Border.all(color: Colors.white, width: 4),
                          boxShadow: [
                            BoxShadow(color: Colors.orange.withValues(alpha: 0.3), blurRadius: 12, offset: Offset(0, 6)),
                            const BoxShadow(color: Colors.black45, blurRadius: 8, offset: Offset(0, 4)),
                          ],
                        ),
                        child: Center(
                          child: _isLoading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "JOGAR",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 34,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1.2,
                                  shadows: [Shadow(color: Colors.black38, offset: Offset(2, 2))],
                                ),
                              ),
                              SizedBox(width: 10),
                              Icon(Icons.play_arrow_rounded, color: Colors.white, size: 40),
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
    );
  }
}