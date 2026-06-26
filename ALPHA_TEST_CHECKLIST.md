# Argentris 0.1.0-alpha - Alpha Test Checklist

## PC Debug

1. Abrir el proyecto en Godot 4.6.2 o superior.
2. Confirmar que `project.godot` carga `res://scenes/main.tscn` sin errores de importacion.
3. Ejecutar el juego desde el editor o con `godot --path .`.
4. Presionar Enter o el boton de play para iniciar partida.
5. Verificar que el tablero tenga 10 columnas por 20 filas visibles.
6. Jugar hasta ver piezas I, O, T, S, Z, J y L.
7. Mover piezas a izquierda y derecha con flechas o A/D.
8. Rotar con flecha arriba o W.
9. Usar caida suave con flecha abajo o S.
10. Usar caida rapida con Espacio.
11. Confirmar que la pieza fantasma marca la posicion de caida.
12. Completar una o mas lineas y verificar limpieza, score y contador de lineas.
13. Llegar a nivel 2 limpiando 10 lineas o mas y verificar aumento de nivel.
14. Pausar y reanudar con P o Escape.
15. Provocar game over llenando el tablero y verificar estado final/reinicio.
16. Probar power-ups con 1, 2 y 3 durante una partida activa.
17. Confirmar que no hay errores ni warnings tratados como error en la consola.

## Android Debug

1. Abrir `Project > Export` y seleccionar el preset Android.
2. Confirmar que el preset exporta `build/Argentris.apk`.
3. Exportar APK debug sin errores.
4. Instalar el APK en un dispositivo o emulador Android.
5. Abrir la app y confirmar orientacion vertical.
6. Iniciar partida con el boton tactil de play.
7. Mover piezas con botones tactiles izquierda/derecha.
8. Rotar con boton tactil de giro y con tap sobre el tablero.
9. Usar caida rapida con el boton tactil de caida y swipe hacia abajo.
10. Confirmar que score, lineas, nivel, siguiente pieza, pieza fantasma y power-ups se ven correctamente.
11. Pausar y reanudar con el boton tactil de pausa.
12. Jugar hasta limpiar lineas y confirmar que no aparecen cierres inesperados.
13. Provocar game over y verificar que el flujo de reinicio responde al toque tras la espera.
14. Revisar Logcat y confirmar que no hay errores de runtime de Argentris.

## Smoke Test Final

1. Ejecutar `godot --headless --path . --quit`.
2. Exportar APK debug desde el preset Android.
3. Registrar cualquier diferencia entre PC y Android antes de promover la alpha.
