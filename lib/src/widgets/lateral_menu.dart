import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:star_wars_app/src/models/status_model.dart';

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
                padding: EdgeInsets.all(20),
                child: Text(
                  'STAR WARS',
                  style: TextStyle(color: Colors.white, fontSize: 25),
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
                  activeColor: Color(0xff7C76B8),
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
