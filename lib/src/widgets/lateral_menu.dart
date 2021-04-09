import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:star_wars_app/src/provider/status_model.dart';

class LateralMenu extends StatefulWidget {
  @override
  _LateralMenuState createState() => _LateralMenuState();
}

class _LateralMenuState extends State<LateralMenu> {
  @override
  Widget build(BuildContext context) {
    final statusProvider = Provider.of<StatusModel>(context);
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
              ListTile(
                leading: Icon(
                  Icons.wifi,
                  color: Colors.white,
                ),
                title: Text(
                  'Online',
                  style: TextStyle(fontSize: 18),
                ),
                trailing: Switch.adaptive(
                  value: statusProvider.status,
                  activeColor: Color(0xffC0BAF7),
                  activeTrackColor: Color(0xff504F61),
                  onChanged: (bool value) {
                    setState(() {
                      final statusProvider =
                          Provider.of<StatusModel>(context, listen: false);
                      statusProvider.status = value;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
