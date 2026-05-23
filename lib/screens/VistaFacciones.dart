import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:ui';
import '../providers/dinamiColor_provider.dart';
import '../screens/Vista_felicidades.dart';

class VistaFacciones extends StatefulWidget {
  const VistaFacciones({super.key});

  @override
  State<VistaFacciones> createState() => _VistaFaccionesState();
}

class _VistaFaccionesState extends State<VistaFacciones> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DinamiColorProvider>(context, listen: false).loadData();
    });
  }

  void _seleccionarFaccion(int index, Map<String, dynamic> equipoSeleccionado) {
    final provider = Provider.of<DinamiColorProvider>(context, listen: false);
    
    provider.getColor(index);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => VistaFelicidades(faccion: equipoSeleccionado),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color colorFondo = Color(0xFF0A0A0C);

    return Scaffold(
      backgroundColor: colorFondo,
      body: Consumer<DinamiColorProvider>(
        builder: (context, provider, child) {
          if (provider.equipos.isEmpty) {
            return const Center(
              child: Semantics(
                label: "Cargando lista de facciones"
              child: CircularProgressIndicator(color: Colors.white38),
              ),
            );
          }

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "VALIDACIÓN BIOMÉTRICA ACEPTADA",
                    style: TextStyle(
                      color: Color(0xFF76FBFB), 
                      fontSize: 10, 
                      letterSpacing: 2, 
                      fontFamily: 'Courier'
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "SELECCIONA TU FACCIÓN",
                    style: TextStyle(
                      color: Colors.white, 
                      fontSize: 24, 
                      fontWeight: FontWeight.bold, 
                      letterSpacing: 1),
                  ),
                  const SizedBox(height: 30),
                  
                  Expanded(
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: provider.equipos.length,
                      itemBuilder: (context, index) {
                        final equipo = provider.equipos[index];
                        final nombre = equipo['nombre'] ?? 'FACCION_UNKNOWN';
                        final descripcion = equipo['descripcion'] ?? 'Sin datos de registro en el servidor.';
                        final imageUrl = equipo['images'] ?? '';

                        return Semantics(
                          button: true,
                          container: true,
                          label: "Faccion: ${nombre.toString().toUpperCase()}. $descripcion",
                          onTapHint:: "Seleccionar Faccion",
                          child: 
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () => _seleccionarFaccion(index, equipo),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 20),
                            decoration: BoxDecoration(
                              color: const Color(0x0DFFFFFF),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.white.withAlpha(20)),
                            ),
                            child: Row(
                              children: [
                                ExcludeSemantics(
                                  child:
                                ClipRRect(
                                  borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
                                  child: Image.asset(
                                    imageUrl,
                                    width: 100,
                                    height: 120,
                                    fit: BoxFit.cover,
                                    errorBuilder: (c, e, s) => Container(
                                      width: 100, height: 120, color: Colors.black26,
                                      child: const Icon(Icons.broken_image, color: Colors.white24),
                                    ),
                                  ),
                                ),
                                ),
                                Expanded(
                                  child: ExcludeSemantics(

                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          nombre.toString().toUpperCase(),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Courier'
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          descripcion,
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(color: Colors.white54, fontSize: 11),
                                        ),
                                      ],
                                    ),
                                  ),

                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                        ),
                        
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}