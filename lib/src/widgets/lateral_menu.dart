import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:star_wars_app/src/bloc/status_bloc/statusmode_bloc.dart';

class LateralMenu extends StatefulWidget {
  @override
  _LateralMenuState createState() => _LateralMenuState();
}

class _LateralMenuState extends State<LateralMenu> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 0,
      child: Container(
        color: Color(0xff13112B),
        child: SafeArea(
          top: true,
          bottom: false,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(40),
                child: Image(
                  image: AssetImage('assets/star-wars-logo.png'),
                ),
              ),
              BlocBuilder<StatusmodeBloc, StatusmodeState>(
                builder: (context, state) {
                  var status =
                      (state.statusMode != null) ? state.statusMode : false;
                  // Se obtiene el estado de la app
                  // El cual se asigna como valor al Switch
                  return ListTile(
                    leading: Icon(
                      Icons.wifi,
                      color: Colors.white,
                    ),
                    title: Text(
                      'Online',
                      style: TextStyle(fontSize: 18),
                    ),
                    trailing: Switch.adaptive(
                      value: status,
                      activeColor: Color(0xffC0BAF7),
                      activeTrackColor: Color(0xff504F61),
                      onChanged: (bool value) {
                        // Cuando se cambia el valor del Switch se lo guarda en el bloc
                        setState(() {
                          BlocProvider.of<StatusmodeBloc>(context)
                              .add(ChangeStatusMode(value));
                        });
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
