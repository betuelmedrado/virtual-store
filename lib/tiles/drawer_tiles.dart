
import 'package:flutter/material.dart';



class DrawerTiles extends StatelessWidget {

   final IconData icon;
   final String text;
   final PageController controller;
   final int page;

   DrawerTiles(this.icon, this.text, this.controller, this.page, {super.key});


  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: (){
          Navigator.of(context).pop();
          controller.jumpToPage(this.page);
        },
        child: Container(
          padding: EdgeInsets.only(top:11.0, bottom: 11.0),
          child: Row(
            children: [
              Icon(this.icon, size:43, color: controller.page?.round() == this.page ? Theme.of(context).primaryColor : Colors.grey[700]),
              SizedBox(width:38.0),
              Text(this.text, style: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
                color: controller.page?.round() == page ? Theme.of(context).primaryColor : Colors.grey[700],
              )),
            ],
          ),
        ),
      ),
    );
  }
}
