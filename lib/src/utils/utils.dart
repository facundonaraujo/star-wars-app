import 'package:flutter/material.dart';

void showAlert(
    {BuildContext context,
    String titulo,
    String mensaje,
    IconData icono,
    Color colorTitulo = Colors.white}) {
  showDialog(
      barrierColor: Color(0xff322948).withOpacity(0.5),
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Color(0xff13112B),
          title: Text(
            titulo,
            textAlign: TextAlign.center,
            style: TextStyle(color: colorTitulo),
          ),
          content: Container(
            height: 100,
            child: Column(
              children: [
                Icon(
                  icono,
                  color: Colors.greenAccent,
                  size: 50,
                ),
                SizedBox(
                  height: 15,
                ),
                Text(mensaje)
              ],
            ),
          ),
          actions: [
            FlatButton(
                onPressed: () => Navigator.of(context).pop(), child: Text('Ok'))
          ],
        );
      });
}
