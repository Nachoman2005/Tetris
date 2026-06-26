# Resumen de trabajo - Argentris

Fecha de corte: 2026-06-14

## Resumen general

Argentris paso de ser una primera pagina/prototipo HTML a un proyecto Godot jugable orientado a Android. La idea central quedo definida como un juego de bloques con identidad argentina, estetica pixel art, referencias genericas a mate, potrero, tango, hinchada, asado y celebracion campeona, cuidando no usar nombres, marcas, escudos, camisetas oficiales, rostros ni referencias protegidas.

El estado actual del repositorio esta en `main`, limpio y sincronizado con `origin/main`.

Repositorio remoto:

- `https://github.com/Nachoman2005/Tetris.git`

## Chats y decisiones conversadas

De lo trabajado hasta ahora se desprenden estas decisiones de direccion:

- El juego se llama `Argentris`.
- La experiencia apunta a Android, con soporte tambien para controles de PC durante desarrollo.
- Se eligio Godot como base del juego.
- La identidad visual y narrativa debe ser argentina pero generica, evitando problemas legales o de copyright.
- La monetizacion prevista es con publicidad/recompensas, con un overlay listo para conectar luego con AdMob u otro plugin.
- Se documento una expansion futura con modos, power-ups, progresion cosmetica, album de figuritas, retos diarios, misiones semanales y tienda cosmetica.
- Se priorizo un MVP con modo clasico, puntaje, lineas, combos, estetica argentina, power-ups simples, skins, frases de relator, modo mundial basico y ads recompensados.

## Commits realizados

### `4e560ca` - First commit

Fecha: 2026-04-29

Se creo la primera version del proyecto como una pagina HTML simple:

- Archivo inicial `index.html`.
- Presentacion de `Argentris`.
- Estilo visual inspirado en la bandera argentina.
- Mensaje de posicionamiento: juego de bloques para Android creado con Godot.
- Aclaracion de seguridad legal: sin nombres, rostros, escudos, logos ni marcas reales.

### `928ae1a` - correccion

Fecha: 2026-04-29

Se corrigio el prototipo web inicial:

- Modificacion de `index.html`.
- Ajustes sobre la landing/presentacion inicial del proyecto.

### `8918238` - added assets

Fecha: 2026-06-09

Este fue el commit grande de construccion del proyecto Godot y carga de assets.

Se agrego:

- Proyecto Godot con `project.godot`.
- Escena principal `scenes/main.tscn`.
- Script principal `scripts/main.gd`.
- Preset inicial de exportacion Android en `export_presets.cfg`.
- `README.md` con descripcion, controles, assets, Android y publicidad.
- Documento de ideas `ideas/ARGENTRIS_IDEAS.md`.
- Icono del proyecto.
- Musica en `assets/music/The_Bandoneon_s_Gambit.mp3`.
- Graficos originales y procesados en `assets/graphics/`.
- Sprites/hojas para personajes, skins, piezas, UI, trofeos, power-ups, efectos, hinchada, recompensas, figuritas y combos.
- Imagen `Errores.png`.
- `.gitignore`.

Tambien se actualizo `index.html` para mantener una presentacion web del proyecto.

## Estado funcional actual

El juego ya tiene una base jugable de bloques en Godot:

- Tablero de 10x20.
- Piezas clasicas: I, O, T, S, Z, J y L.
- Movimiento lateral, rotacion, caida suave y caida rapida.
- Colisiones y bloqueo de piezas.
- Limpieza de lineas.
- Sistema de puntaje.
- Progresion de nivel cada 10 lineas.
- Aumento progresivo de velocidad.
- Game over.
- Pausa.
- Pieza fantasma.
- Vista de proxima pieza.
- Controles de teclado.
- Controles tactiles: tap, swipe y botones en pantalla.
- HUD con score, lineas, nivel, power-ups, trofeos y personaje.
- Seleccion/cambio de personaje.
- Skins de bloques por nivel y seleccion aleatoria cuando se superan las skins disponibles.
- Musica de fondo en loop.

## Power-ups implementados

Hay tres power-ups iniciales conectados al gameplay:

- `VAR`: revierte el tablero al estado previo.
- `Aliento de la Hinchada`: ralentiza temporalmente la caida.
- `Jugada de Potrero`: limpia filas bajas ocupadas.

## Identidad visual y assets

El proyecto ya integra assets separados y procesados:

- `assets/graphics/processed/font.png`: logo/fuente bitmap.
- `assets/graphics/processed/UI.png`: paneles y botones.
- `assets/graphics/processed/pieces.png`: piezas.
- `assets/graphics/processed/skins/`: skins numeradas.
- `assets/graphics/processed/characters/`: personajes seleccionables.
- `assets/graphics/processed/trophies.png`: trofeos.
- `assets/graphics/processed/powerups/`: iconos de power-ups.
- `assets/graphics/processed/combo/`: Asado Combo.
- `assets/graphics/processed/effects/`: efectos visuales.
- `assets/graphics/processed/crowd/`: hinchada.
- `assets/graphics/processed/rewards/`: recompensas.
- `assets/graphics/processed/collectibles/`: figuritas.

La estetica se apoya en una paleta celeste/blanca, elementos arcade y referencias argentinas genericas.

## Publicidad y Android

El juego incluye un overlay simulado de publicidad:

- Aparece al subir de nivel.
- Aparece al perder para reiniciar el nivel.
- Tiene contador y accion para continuar.
- Queda preparado para una futura integracion real con AdMob u otro sistema.

La exportacion Android esta configurada con:

- Preset `Android`.
- Paquete `com.nachoman2005.argentris`.
- Version `0.1.0`.
- Orientacion vertical.
- Export path `build/Argentris.apk`.

## Documentacion agregada

### `README.md`

Resume:

- Que es Argentris.
- Controles de PC.
- Controles moviles.
- Notas de Android.
- Assets integrados.
- Publicidad.
- Cuidados legales sobre assets y referencias.

### `ideas/ARGENTRIS_IDEAS.md`

Documenta una vision amplia del producto:

- Piezas especiales argentinas.
- Power-ups.
- Modos de juego.
- Progresion y retencion.
- Eventos durante partida.
- Sistema Asado Combo.
- Barra de Pasion.
- Rival fantasma.
- Retos diarios y misiones semanales.
- Monetizacion sugerida.
- Audio, humor y relator.
- Roadmap por fases.
- Cuidados legales.

## Pull Requests

Se consulto GitHub para listar PRs del repositorio `Nachoman2005/Tetris`.

Resultado:

- No se encontraron pull requests abiertos, cerrados o mergeados.
- El historial visible hasta ahora esta en la rama `main`.
- No hay ramas remotas adicionales aparte de `origin/main`.

## Estado de ramas

Ramas locales/remotas detectadas:

- `main`
- `origin/main`
- `origin/HEAD -> origin/main`

## Pendientes recomendados

Para continuar el proyecto convendria:

- Probar el proyecto en Godot y corregir errores de importacion o runtime si aparecen.
- Revisar textos con caracteres mal codificados en `README.md` e `ideas/ARGENTRIS_IDEAS.md`.
- Conectar publicidad real si se decide monetizar.
- Agregar sonidos FX ademas de musica.
- Pulir UI mobile en distintos tamanos de pantalla.
- Balancear velocidad, puntaje y frecuencia de power-ups.
- Definir si el nombre remoto `Tetris` debe mantenerse o cambiarse a `Argentris`.
- Crear PRs para futuras features, asi el historial quede mas claro que commits directos en `main`.
