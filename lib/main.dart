import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shadownet/providers/mision_provider.dart';
import 'package:shadownet/screens/contexto_screen.dart';
import 'providers/auth_provider.dart';
import 'screens/auth_screen.dart';
import 'providers/dinamiColor_provider.dart';
import 'screens/VistaFacciones.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => MisionProvider()),
        ChangeNotifierProvider(create:(_)=> DinamiColorProvider()),
      ],
      child: const ShadowNetApp(),
    ),  
  );
}

class ShadowNetApp extends StatelessWidget {
  const ShadowNetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3:true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: DinamiColorProvider().themeColor,
          // brighness:Brightness.dark,
        ),
        fontFamily: 'Urbanist',
      ),

      themeMode: ThemeMode.dark,
      home: Consumer<AuthProvider>(
        builder: (context, provider, child) {
          if (provider.isAuthenticated) {
            return const VistaFacciones();  
          } else {
            return const AuthScreen(); 
          }
        },
      ),
    );
  }
}
