import 'package:flutter/material.dart';
import 'package:star_wars_app/src/pages/personaje_detalle_page.dart';
import 'package:star_wars_app/src/pages/personajes_page.dart';

Map<String, WidgetBuilder> getApplicationRoutes() {
  return <String, WidgetBuilder>{
    'characters': (BuildContext context) => PersonajesPage(),
    'characterDetail': (BuildContext context) => PersonajeDetallePage(),
  };
}
