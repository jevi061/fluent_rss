import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef MenuItemTapCallback = void Function();

class MenuItem extends StatelessWidget {
  IconData iconData;
  String title;
  String subtitle;
  MenuItemTapCallback? onTap;
  MenuItem(
      {Key? key,
      required this.iconData,
      required this.title,
      required this.subtitle,
      this.onTap})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Card(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(
                iconData,
                color: Colors.blue,
              ),
              SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    subtitle,
                  )
                ],
              )
            ],
          ),
        ),
      ),
      onTap: onTap,
    );
  }
}
