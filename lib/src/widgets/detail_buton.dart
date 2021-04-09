import 'package:flutter/material.dart';

class DetailButton extends StatelessWidget {
  final String title;
  final String subitle;
  final bool generateCustomSubtitle;
  final Widget customSubtitle;

  DetailButton({
    @required this.title,
    this.subitle = '',
    this.generateCustomSubtitle = false,
    this.customSubtitle,
  });

  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: ClipRect(
        child: Container(
          margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Color(0xff676298),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 30,
              ),
              Text(
                title,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 25,
              ),
              (!generateCustomSubtitle)
                  ? Text(
                      subitle,
                      style: TextStyle(color: Colors.white, fontSize: 22),
                    )
                  : customSubtitle,
              SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
