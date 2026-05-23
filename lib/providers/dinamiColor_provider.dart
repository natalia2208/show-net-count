import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
class DinamiColorProvider extends ChangeNotifier {

  Color _themeColor = const Color.fromARGB(221, 144, 160, 195);
  Color get themeColor => _themeColor;

  List<Map<String, dynamic>> _equipos = [];
  List<Map<String, dynamic>> get equipos => _equipos;

  bool _isLoaded = false;

  Future<void> loadData() async{

    if(_isLoaded) return;
    try {
      final String value = await rootBundle.loadString('data/mision.json');
      final Map<String, dynamic> datos = json.decode(value);

      _equipos = List<Map<String, dynamic>>.from(datos["equipos"]);
      _isLoaded = true;
      notifyListeners();

    } catch (e) {
      print("Error cargando el JSON: $e");
    }
  }

  void getColor(int index){
    if (index < 0 || index >= _equipos.length) return;
    final String imageUrl = _equipos[index]['images'];
    _extractDominantColor(imageUrl);
  }

  Future<void> _extractDominantColor(String images) async {
    try {
      final PaletteGenerator paletteGenerator = await PaletteGenerator.fromImageProvider(
        AssetImage(images)
        , size: Size(200, 200));

      _themeColor = paletteGenerator.vibrantColor?.color ??
                    paletteGenerator.dominantColor?.color ??
                    paletteGenerator.lightVibrantColor?.color ??
                    paletteGenerator.darkVibrantColor?.color ??
                    paletteGenerator.lightMutedColor?.color ??
                    paletteGenerator.darkMutedColor?.color ??
                    Colors.blue;
    } catch (e) {
       _themeColor = Colors.deepPurple;
       print("Error al extraer color, aplicando fallback: $e");
    
    }finally{
      print(_themeColor);
      notifyListeners();
    }
  }
}