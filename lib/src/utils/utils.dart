import 'package:flutter/material.dart';

void showAlert(
    {BuildContext context,
    String title,
    String message,
    IconData icon,
    Color titleColor = Colors.white,
    Color iconColor = Colors.white}) {
  showDialog(
      barrierColor: Color(0xff322948).withOpacity(0.5),
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Color(0xff13112B),
          title: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(color: titleColor),
          ),
          content: Container(
            height: 120,
            child: Column(
              children: [
                Icon(
                  icon,
                  color: iconColor,
                  size: 50,
                ),
                SizedBox(
                  height: 15,
                ),
                Text(message)
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
