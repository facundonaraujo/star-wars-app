import 'package:flutter/material.dart';
import 'package:star_wars_app/src/pages/personaje_detalle_page.dart';
import 'package:star_wars_app/src/pages/personajes_page.dart';

Map<String, WidgetBuilder> getApplicationRoutes() {
  return <String, WidgetBuilder>{
    'personajes': (BuildContext context) => PersonajesPage(),
    'personajeDetalle': (BuildContext context) => PersonajeDetallePage(),
  };
}
