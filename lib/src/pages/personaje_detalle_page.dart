import 'dart:async';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:star_wars_app/src/bloc/character_detail_bloc/character_detail_bloc.dart';
import 'package:star_wars_app/src/bloc/status_bloc/statusmode_bloc.dart';
import 'package:star_wars_app/src/models/character_detail_model.dart';
import 'package:star_wars_app/src/models/character_model.dart';
import 'package:star_wars_app/src/models/report_model.dart';
import 'package:star_wars_app/src/services/character_detail_service.dart';
import 'package:star_wars_app/src/services/report_service.dart';
import 'package:star_wars_app/src/utils/utils.dart';
import 'package:star_wars_app/src/widgets/detail_buton.dart';

class PersonajeDetallePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Se obtienen el personaje enviado a traves del boton de la lista de personajes
    final Character character = ModalRoute.of(context).settings.arguments;
    final CharacterDetailService characterDetailService =
        new CharacterDetailService();
    return Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: Text(
          character.name,
          style: TextStyle(color: Colors.white, fontSize: 25),
        ),
        elevation: 1,
        backgroundColor: Color(0xff232042),
      ),
      body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: BlocBuilder<StatusmodeBloc, StatusmodeState>(
            builder: (context, state) {
              var status =
                  (state.statusMode != null) ? state.statusMode : false;
              // Se comprueba en que modo esta en la app
              if (status == true) {
                // Si esta en modo online se obtienen las naves, vehiculos y planeta del personaje
                return FutureBuilder(
                  future: characterDetailService.getCharacterDetails(character),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      var provider =
                          BlocProvider.of<CharacterDetailBloc>(context).state;
                      // Se obtiene el estado del bloc de personajes detalles
                      // El cual es una lista en la que se van almacenado los detalles de cada personajes
                      // Si la lista no vuelve vacia se comprueba si el detalle del personaje ya esta en la lista
                      // En el caso de que no este en la lista lo añade al bloc
                      // Para que en el modo offline se visualice
                      if (provider.charactersDetails != null &&
                          provider.charactersDetails.length > 0) {
                        bool isInList = false;
                        CharacterDetail char = snapshot.data;
                        for (CharacterDetail chadet
                            in provider.charactersDetails) {
                          if (chadet.character.url == char.character.url) {
                            isInList = true;
                          }
                        }
                        if (!isInList) {
                          List<CharacterDetail> detChar =
                              provider.charactersDetails;
                          detChar.add(snapshot.data);
                          BlocProvider.of<CharacterDetailBloc>(context)
                              .add(AddCharacterDetail(detChar));
                        }
                      } else {
                        // Si la lista estaba vacia añade el detalle a la lista
                        List<CharacterDetail> detChar = [];
                        detChar.add(snapshot.data);
                        BlocProvider.of<CharacterDetailBloc>(context)
                            .add(AddCharacterDetail(detChar));
                      }

                      return Column(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          // Se construyen los cuadros con la informacion
                          _characterAtributesOnline(character, snapshot.data),
                          // Se construye el boton para enviar la info
                          _reportButton(character, context),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      );
                    } else {
                      // Mientras espera la informacion del servio muestra el logo de star wars animado
                      return Column(
                        children: [
                          SizedBox(
                            height: 250,
                          ),
                          Center(
                              child: Pulse(
                            infinite: true,
                            duration: Duration(milliseconds: 1800),
                            child: Image(
                              image: AssetImage('assets/star-wars-logo.png'),
                              height: 100,
                            ),
                          ))
                        ],
                      );
                    }
                  },
                );
              } else {
                // En el caso de que este en el modo offline se busca en el bloc de CharacterDetailBloc
                return BlocBuilder<CharacterDetailBloc, CharacterDetailState>(
                  builder: (context, state) {
                    if (state.charactersDetails != null &&
                        state.charactersDetails.length > 0) {
                      // Se comprueba si la descripcion del personaje esta en la lista del bloc
                      // Si esta en la lista se construye los cuadros con la informacion obtenida de bloc y con la del personaje
                      bool isInList = false;
                      CharacterDetail characterDetails;
                      for (var characterDetail in state.charactersDetails) {
                        if (characterDetail.character.url == character.url) {
                          isInList = true;
                          characterDetails = characterDetail;
                        }
                      }
                      if (isInList) {
                        return Column(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            _characterAtributesOnline(
                                character, characterDetails),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        );
                      } else {
                        // En el caso de que no este en la lista solo se construyen los cuadros con la informacion del personaje
                        // No de los que traeria del servicio(naves, vehiculos y planeta)
                        return Column(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            _characterAtributesOFFline(character),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        );
                      }
                    } else {
                      return Column(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          _characterAtributesOFFline(character),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      );
                    }
                  },
                );
              }
            },
          )),
    );
  }

  Widget _reportButton(Character character, BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: RaisedButton(
        child: Container(
          alignment: Alignment.center,
          width: double.infinity,
          height: 50,
          margin: EdgeInsets.symmetric(vertical: 5),
          child: Text('Report!', style: TextStyle(fontSize: 24)),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 0.0,
        color: Color(0xffDC584B),
        textColor: Colors.white,
        // Al apretar el boton de reportar se abre un dialog donde se debe confirmar el reporte o cancelarlo
        onPressed: () => showDialog(
            barrierColor: Color(0xff322948).withOpacity(0.5),
            context: context,
            builder: (context) {
              return AlertDialog(
                backgroundColor: Color(0xff13112B),
                title: Text(
                  'Report',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                ),
                content: Container(
                  height: 50,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Are you sure you want to make the report?')
                    ],
                  ),
                ),
                actions: [
                  FlatButton(
                      onPressed: () => Navigator.pop(context, true),
                      textColor: Colors.green[400],
                      child: Text('Report!')),
                  FlatButton(
                      onPressed: () => Navigator.pop(context, false),
                      textColor: Colors.red[400],
                      child: Text('Cancel')),
                ],
              );
            }).then((val) {
          // Se comprueba la respuesta del dialog
          // Si se confirma la creacion del reporte se envia la informacion
          if (val) {
            _sendReport(character, context);
          }
        }),
      ),
    );
  }

  Future<void> _sendReport(
    Character character,
    BuildContext context,
  ) async {
    final ReportService reportService = new ReportService();
    final DateTime now = new DateTime.now();
    // Se envia la informacion del reporte al servicio
    final Report report = new Report(
        characterName: character.name, dateTime: now.toString(), userId: 1);
    Map resp = await reportService.getCharacterDetails(report);
    // Obtiene la respuerta de servicio
    // En el caso de que de que haya enviado correctamente se abre un modal personalizado
    // Informado que el reporte se envio correctamente
    if (resp['ok'] == true) {
      showAlert(
          context: context,
          title: 'Report Sent',
          message: 'The report was sent successfully',
          icon: Icons.check_circle,
          iconColor: Colors.greenAccent);
    } else {
      // En el caso de que de que se haya producido un error al envirse se abre un modal personalizado
      // Informado que el reporte no se puedo enviar
      showAlert(
          context: context,
          title: 'Error',
          message: resp['message'],
          icon: Icons.error,
          titleColor: Colors.red,
          iconColor: Colors.red);
    }
  }

  Widget _characterAtributesOnline(
      Character character, CharacterDetail characterDetails) {
    final startships = Container(
      child: Column(
        children: [
          for (var i = 0; i < characterDetails.startships.length; i++)
            Text(
              characterDetails.startships[i].name,
              style: TextStyle(color: Colors.white, fontSize: 22),
            ),
        ],
      ),
    );
    final vehicles = Container(
      child: Column(
        children: [
          for (var i = 0; i < characterDetails.vehicles.length; i++)
            Text(
              characterDetails.vehicles[i].name,
              style: TextStyle(color: Colors.white, fontSize: 22),
            ),
        ],
      ),
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Table(
            children: [
              TableRow(children: [
                DetailButton(
                  title: 'Hair Color',
                  subitle:
                      '${character.hairColor.substring(0, 1).toUpperCase() + character.hairColor.substring(1, character.hairColor.length)}',
                ),
                DetailButton(
                  title: 'Skin Color',
                  subitle:
                      '${character.skinColor.substring(0, 1).toUpperCase() + character.skinColor.substring(1, character.skinColor.length)}',
                ),
              ]),
              TableRow(children: [
                DetailButton(
                  title: 'Eye Color',
                  subitle:
                      '${character.eyeColor.substring(0, 1).toUpperCase() + character.eyeColor.substring(1, character.eyeColor.length)}',
                ),
                DetailButton(
                  title: 'Homeworld',
                  subitle:
                      '${characterDetails.planet.name.substring(0, 1).toUpperCase() + characterDetails.planet.name.substring(1, characterDetails.planet.name.length)}',
                ),
              ]),
            ],
          ),
          Table(
            children: [
              if (characterDetails.startships.length > 0)
                TableRow(children: [
                  DetailButton(
                    title: 'Startships',
                    generateCustomSubtitle: true,
                    customSubtitle: startships,
                  ),
                ]),
              if (characterDetails.vehicles.length > 0)
                TableRow(children: [
                  DetailButton(
                    title: 'Vehicles',
                    generateCustomSubtitle: true,
                    customSubtitle: vehicles,
                  ),
                ]),
            ],
          ),
        ],
      ),
    );
  }

  Widget _characterAtributesOFFline(Character character) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Table(
            children: [
              TableRow(children: [
                DetailButton(
                  title: 'Hair Color',
                  subitle:
                      '${character.hairColor.substring(0, 1).toUpperCase() + character.hairColor.substring(1, character.hairColor.length)}',
                ),
                DetailButton(
                  title: 'Skin Color',
                  subitle:
                      '${character.skinColor.substring(0, 1).toUpperCase() + character.skinColor.substring(1, character.skinColor.length)}',
                ),
              ]),
              TableRow(children: [
                DetailButton(
                  title: 'Eye Color',
                  subitle:
                      '${character.eyeColor.substring(0, 1).toUpperCase() + character.eyeColor.substring(1, character.eyeColor.length)}',
                ),
                DetailButton(
                  title: 'Homeworld',
                  subitle: 'Unknown',
                ),
              ]),
            ],
          ),
        ],
      ),
    );
  }
}
