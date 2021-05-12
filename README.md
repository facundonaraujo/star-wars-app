# Star Wars App

# Objetivo

El objetivo del presente trabajo es implementar una aplicación mobile en Dart/Flutter.

# Descripción funcional

La aplicación consiste en una herramienta de consulta y reporte, de los personajes de Star Wars que se encuentran invadiendo el planeta Tierra.

El objetivo es que los usuarios al sospechar que están frente a un invasor, realicen la consulta vía la aplicación y en el caso de que sea confirmada la sospecha, se pueda reportar el avistamiento.

Al estar viviendo una invasión y frente a los rumores de que el internet fue intervenido por estos extraterrestres, para brindar la mayor seguridad posible se decidió tener dos opciones de uso, el modo online y el modo offline. Siempre que sea posible, se mantendrá en el modo offline y solo cuando sea necesario se cambiara de modo. En el modo online guardara toda la información, así al cambiar de modo la utiliza. Además, en modo offline no se podrá hacer uso de la función de reporte.

La aplicación consta de 2 pantallas. La primera consiste en una lista/grilla orientada verticalmente, donde se tiene la información más relevante (nombre, altura, peso y sexo) de cada personaje. Al presionar sobre uno, se accederá a la segunda pantalla, donde se mostrará el resto de la información (color de cabello, piel y ojos, el nombre del planeta al que pertenece y el nombre de cada uno de sus vehículos y sus naves espaciales) y el botón que permita emitir el reporte (únicamente en modo online).

Por último, la aplicación tendrá un Navigation Drawer, desde donde se manejara el modo online y offline.

# Descripción técnica

La app cuenta con dos páginas. La primera es la de PersonajesPage en donde se muestra una lista de personajes orientada verticalmente, la cual obtiene la información desde el servicio CharacterService. El servicio utiliza el modelo de Character para mapear la información que llega desde el api.

Cada personaje se muestra en un botón personalizado el cual al apretarlo se accede a la segunda pantalla, PersonajeDetallePage, en donde se visualiza más información acerca del personaje, la cual una parte de la información se pasa como argumento desde la primera pantalla y la otra se obtiene a través de CharacterDetailService donde se obtienen las naves espaciales, el planeta y vehículos utilizando los modelos de Starship, Planet y Vehicle respectivamente y si está en el modo online se visualiza un botón para reportar un avistamiento. El cual llama al servicio ReportService donde envía la información, utilizando el modelo de Report, al api de reporte.

La aplicación cuenta con 2 modos, Online y Offline. Para cambiar de modo se utiliza un Navigation Drawer que se ubica en la pantalla de PersonajesPage. Para notificar visualmente al usuario que se cambió de modo en el appbar de la pantalla de PersonajesPage se encuentra un icono el cual cambia dependiendo del modo que se encuentre activo. Para cambiar de modo y que se informe el cambio en las distintas pantallas se utiliza el manejador de estados Bloc y se lo almacena en el storage utilizando Hydrated Bloc, para que la próxima vez que se inicie la app recuerde en qué modo se había dejado.

En el modo online se realizan las consultas a los respectivos servicios y guardan los personajes y sus detalles en el storage mediante Hydrated Bloc para luego poder ser utilizados en el modo offline ya que en el modo offline no se realizan consultas a las api, solo se realizan en el modo online.

La app consta con un tema personalizado inspirado en la paleta de colores de las películas de Star Wars

![PaletaDeColoresStarWarsApp](https://github.com/facundonaraujo/star-wars-app/raw/master/assets/PaletaDeColoresStarWarsApp.jpg)

Tambien se incluyo un buscador de personajes en donde se utiliza un IconButton en el appbar de PersonajesPage el cual al apretar se abre un SearchDelegate en el cual si esta en el modo online se utiliza el SearchService donde se obttiene los personajes cuyo nombre coincida con la búsqueda, se los mapea con el modelo de Character y se dibuja la lista de personajes que coincidan con la búsqueda con el widget de PersonajesList. En el caso de estar en modo offline se busca entre los personajes guardados en el storage de Hydrated Bloc con la condición de que algún carácter de la búsqueda coincida en el campo de nombre, luego se dibuja la lista de personajes que coincidan con la búsqueda con el widget de PersonajesList.

En el modo offline solo van a aparecer los personajes que se hayan previsualizado en el modo online, es decir que a medida que se vaya cargando la lista en el modo offline se guarda en el bloc y se va a poder previsualizar en el modo offline. Se tuvo que hacer de esta manera debido que la api trae los personajes paginados y no una lista completa. Por lo que si se quisiera obtener la lista completa se deberían hacer muchas consultas debido a la gran cantidad de personajes y eso aumentaría considerablemente el tiempo de carga de la app.

# Preview App

Cambiar de modo

![pantallas1-2](https://github.com/facundonaraujo/star-wars-app/raw/master/assets/pantallas1-2.jpg)

Lista de personajes

![pantallas3-4](https://github.com/facundonaraujo/star-wars-app/raw/master/assets/pantallas3-4.jpg)

Modo online / Modo Offline

![pantallas5-6](https://github.com/facundonaraujo/star-wars-app/raw/master/assets/pantallas5-6.jpg)

Realizar Reporte

![pantallas7-8](https://github.com/facundonaraujo/star-wars-app/raw/master/assets/pantallas7-8.jpg)

Realizar Búsqueda

![pantallas9-10](https://github.com/facundonaraujo/star-wars-app/raw/master/assets/pantallas9-10.jpg)

# Anexo

## APIS

### CharacterService

- People:GET [http://swapi.dev/api/people/](http://swapi.dev/api/people/)

### CharacterDetailService

- Planets:GET [http://swapi.dev/api/planets/](http://swapi.dev/api/planets/)
- Vehicles:GET [http://swapi.dev/api/vehicles](http://swapi.dev/api/vehicles)
- Starships:GET [http://swapi.dev/api/starships/](http://swapi.dev/api/starships/)

### SearchService

- Planets:GET [https://swapi.dev/api/people/?search=](https://swapi.dev/api/people/?search=)

### ReportService

- Report: POST [https://jsonplaceholder.typicode.com/posts](https://jsonplaceholder.typicode.com/posts)

## UTILES

Pagina que se utilizo para hacer los modelos

- [https://app.quicktype.io/](https://app.quicktype.io/)

## DEPENDECIAS

Dependencias utilizadas en el proyecto

- [cupertino_icons](https://pub.dev/packages/cupertino_icons) - Versión: ^1.0.0
- [http](https://pub.dev/packages/http) - Versión: ^0.13.3
- [animate_do](https://pub.dev/packages/animate_do) - Versión: ^2.0.0
- [bloc](https://pub.dev/packages/bloc) - Versión: ^7.0.0
- [flutter_bloc](https://pub.dev/packages/flutter_bloc) - Versión: ^7.0.0
- [hydrated_bloc](https://pub.dev/packages/hydrated_bloc) - Versión: ^7.0.0
- [path_provider](https://pub.dev/packages/path_provider) - Versión: ^2.0.1

## FLUTTER

Versión de flutter utilizada **2.0.4**

## DART

Versión de Dart utilizada **2.12.3**

## Run App

Ejecutar en la raiz del proyecto:

- Flutter pub get
- Flutter run