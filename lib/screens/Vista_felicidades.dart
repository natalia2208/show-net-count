import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'dart:ui';
import '../providers/dinamiColor_provider.dart';
import '../screens/contexto_screen.dart';
import '../screens/terminal_scren.dart';

class VistaFelicidades extends StatefulWidget {
  final Map<String, dynamic> faccion;

  const VistaFelicidades({super.key, required this.faccion});

  @override
  State<VistaFelicidades> createState() => _VistaFelicidadesState();
}

class _VistaFelicidadesState extends State<VistaFelicidades> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _scaleAnimation;
  Timer? _navTimer;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _navTimer = Timer(const Duration(seconds: 5), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ContextoScreen()),
      );
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _navTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String nombreFaccion = widget.faccion['nombre'] ?? 'AGENTE';
    final String imageUrl = widget.faccion['images'] ?? '';

    return Scaffold(
      backgroundColor: const Color(0xFF020202),
      body: Consumer<DinamiColorProvider>(
        builder: (context, provider, child) {
          final Color colorDinamico = provider.themeColor;

          return Stack(
            children: [
              Positioned.fill(
                child: Center(
                  child: Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: colorDinamico.withAlpha(50),
                    ),
                  ),
                ),
              ),
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
                child: Container(color: Colors.transparent),
              ),
              
              SafeArea(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "INICIALIZANDO PROTOCOLOS...",
                        style: TextStyle(color: Colors.white38, fontSize: 10, letterSpacing: 3),
                      ),
                      const SizedBox(height: 40),
                      
                      ScaleTransition(
                        scale: _scaleAnimation,
                        child: Container(
                          width: 180,
                          height: 180,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: colorDinamico, width: 3),
                            boxShadow: [
                              BoxShadow(color: colorDinamico.withAlpha(100), blurRadius: 20, spreadRadius: 5),
                            ],
                            image: DecorationImage(
                              image: AssetImage(imageUrl),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 50),
                      
                      Text(
                        "FELICIDADES",
                        style: TextStyle(
                          color: colorDinamico, 
                          fontSize: 16, 
                          fontFamily: 'Courier', 
                          fontWeight: FontWeight.bold,
                          letterSpacing: 4
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "PERTENECES A LA FACCIÓN\n$nombreFaccion",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white, 
                          fontSize: 22, 
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      
                      const SizedBox(height: 60),
                      
                      SizedBox(
                        width: 150,
                        child: LinearProgressIndicator(
                          backgroundColor: Colors.white12,
                          color: colorDinamico,
                          minHeight: 2,
                        ),
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        "SINCRONIZANDO VISTAS...",
                        style: TextStyle(color: Colors.white54, fontSize: 8, letterSpacing: 1),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}