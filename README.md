# Argentris

Argentris es una reinterpretacion argentina y original de un juego de bloques para Android, creada en Godot.

La estetica usa guiños genericos del imaginario argentino: mate, dulce de leche, tango, potrero, hinchada y celebracion campeona. No usa nombres, retratos, escudos, camisetas oficiales, logos, marcas ni trofeos protegidos.

## Controles PC

- Flechas o `A`/`D`: mover.
- Arriba o `W`: rotar.
- Abajo o `S`: caida suave.
- Espacio: caida rapida.
- Enter: iniciar o reintentar.
- `P` o Escape: pausar.
- `R`: ver publicidad y reiniciar el nivel luego de perder.
- `C`: cambiar personaje.
- `1`: VAR, revierte el tablero al estado previo.
- `2`: Aliento de la hinchada, ralentiza la caida temporalmente.
- `3`: Jugada de potrero, limpia filas bajas ocupadas.

## Controles movil

- Botones en pantalla: mover, girar y caida rapida.
- Tap en el tablero: girar.
- Swipe horizontal: mover.
- Swipe hacia abajo: caida rapida.

## Android

El proyecto incluye un preset inicial de exportacion Android en `export_presets.cfg`.

## Assets

El juego usa los PNG separados de `assets/graphics/` y copias procesadas con canal alfa en `assets/graphics/processed/`.

- `font.png`: logo y fuente bitmap para mensajes del juego.
- `characters.png`: seleccion de personaje entre opciones genericas.
- `menubuttons.png`: iconos de botones de accion.
- `pieces.png`: estilos de piezas por nivel 1 a 6.
- `skins.png`: skins aleatorias desde el nivel 7.
- `trophies.png`: trofeos ganados al subir de nivel.
- `UI.png`: paneles de puntaje, proximo y botones.

Se integraron solo elementos genericos del pack; no se usan personajes con parecidos reconocibles ni referencias a marcas, clubes, federaciones o personas reales.

Las skins y personajes separados viven en:

- `assets/graphics/skins/`: una skin por numero de nivel. Si el nivel supera la cantidad de skins, el juego elige una al azar.
- `assets/graphics/characters/`: personajes seleccionables.
- `assets/graphics/processed/`: copias con canal alfa usadas por Godot.
- `assets/graphics/special_pieces/`: ideas visuales para piezas especiales.
- `assets/graphics/powerups/`: iconos de power-ups.
- `assets/graphics/combo/`: progresion visual de Asado Combo.
- `assets/graphics/effects/`: efectos visuales para combos y eventos.
- `assets/graphics/crowd/`: hinchada y celebraciones.
- `assets/graphics/rewards/`: recompensas y economia.
- `assets/graphics/collectibles/`: figuritas y coleccionables ficticios.

## Publicidad

El juego tiene un overlay de publicidad listo para conectar con AdMob u otro plugin:

- Al subir de nivel, pausa y muestra publicidad antes de continuar.
- Al perder, muestra publicidad y despues reinicia el nivel actual.

Para compilar un APK desde Godot:

1. Instalar las plantillas de exportacion de la version de Godot usada.
2. Configurar Android SDK/JDK en `Editor Settings > Export > Android`.
3. Revisar la firma de debug o release.
4. Exportar el preset `Android`.
