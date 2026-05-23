# ShadowNet

Aplicación Flutter de misión geolocalizada con estética de terminal encubierta. El tema visual se adapta al color dominante de las imágenes de equipo, y la interfaz está modelada con un árbol de **Semantics** pensado para lectores de pantalla y navegación por voz.

---

## Tema dinámico: `seedColor`

### Arquitectura

El color de la aplicación no está fijado en el diseño: se deriva del arte de cada operativo definido en `data/mision.json` (bloque `equipos`). La cadena es la siguiente:

```
mision.json → DinamiColorProvider → PaletteGenerator → themeColor → ColorScheme.fromSeed
```

`DinamiColorProvider` (`lib/providers/dinamiColor_provider.dart`) es un `ChangeNotifier` registrado en el árbol de `Provider` desde `main.dart`. Carga el JSON una sola vez, expone la lista de equipos y mantiene el color activo en `_themeColor`.

### Extracción con `palette_generator`

Cuando se invoca `getColor(int index)` con un índice válido del array `equipos`, el proveedor toma la URL o ruta de la imagen (`equipos[index]['image']`) y ejecuta `_extractDominantColor` de forma asíncrona:

1. **Entrada de imagen** — Se usa `PaletteGenerator.fromImageProvider` con un `NetworkImage` apuntando al recurso del equipo. La muestra se reduce a `Size(200, 200)` para acelerar el análisis sin perder la esencia cromática del asset.

2. **Selección del tono** — El paquete `palette_generator` descompone la imagen en una paleta Material Design (vibrant, muted, light/dark). El color semilla se elige con una cascada de prioridad que favorece tonos vivos y legibles en UI:

   | Orden | Swatch |
   |------:|--------|
   | 1 | `vibrantColor` |
   | 2 | `dominantColor` |
   | 3 | `lightVibrantColor` |
   | 4 | `darkVibrantColor` |
   | 5 | `lightMutedColor` |
   | 6 | `darkMutedColor` |
   | 7 | `Colors.blue` (reserva si la paleta viene vacía) |

3. **Resiliencia** — Si la descarga o el análisis fallan, se aplica `Colors.deepPurple` como color de contingencia. En ambos casos, `notifyListeners()` en el bloque `finally` propaga el cambio a los widgets suscritos.

4. **Valor inicial** — Antes de cualquier extracción, el tema arranca con un gris azulado fijo (`Color.fromARGB(221, 144, 160, 195)`).

### Material 3 y `seedColor`

En `ShadowNetApp`, el tema usa **Material 3** (`useMaterial3: true`) y construye el esquema con:

```dart
ColorScheme.fromSeed(seedColor: themeColor)
```

`fromSeed` genera automáticamente primarios, secundarios, contenedores y variantes de superficie a partir de un único color semilla, manteniendo contraste accesible según las guías de Material Design. Cada cambio de equipo —y por tanto de imagen— puede reorientar toda la identidad cromática de la app sin redefinir tokens manualmente.

---

## Árbol de Semantics

La UI prioriza el estilo visual, pero el árbol semántico paralelo traduce esa experiencia a etiquetas, regiones vivas y acciones comprensibles para **TalkBack**, **VoiceOver** y herramientas de inspección de accesibilidad.

### Principios aplicados

| Patrón | Uso en ShadowNet |
|--------|------------------|
| `Semantics` + `label` / `hint` | Sustituyen texto decorativo o críptico por descripciones en español claro |
| `button: true` + `onTap` | Zonas interactivas amplias o controles sin depender solo del widget hijo |
| `liveRegion: true` | Anuncia cambios de estado sin que el usuario reenfoque manualmente |
| `MergeSemantics` | Agrupa etiqueta + valor en un solo nodo (p. ej. «Estado:» + coordenadas) |
| `ExcludeSemantics` | Oculta ornamentos, duplicados visuales o animaciones puramente decorativas |



## dependencias relevantes

| Paquete | Rol |
|---------|-----|
| `provider` | Estado global (`AuthProvider`, `MisionProvider`, `DinamiColorProvider`) |
| `palette_generator` | Extracción de paleta y color semilla desde imágenes |
| `geolocator` | Permisos y posición para la lógica de misión |
| `local_auth` | Autenticación biométrica en `AuthScreen` |

---

## Ejecución

```bash
flutter pub get
flutter run
```

