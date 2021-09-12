import 'package:flutter/material.dart';

class DrawerTile extends StatelessWidget {
  final IconData icon;
  final String text;
  final PageController controller;
  final int page;

  DrawerTile(this.icon, this.text, this.controller,this.page);

  @override
  Widget build(BuildContext context) {
    //Material porque vai ter efeito visual quando for clicado no icone, ex: fica com cor difente na aba em que está
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: (){
          //fecha o navigator assim que clica em qual pagina ir
          Navigator.of(context).pop();
          controller.jumpToPage(page);
        },
        child: Container(
          height: 60,
          child: Row(
            children: [
              Icon(
                icon,
                size: 32,
                //round pra fica como inteiro
                color: controller.page!.round() == page ? Theme.of(context).primaryColor : Colors.grey[700],
              ),
              SizedBox(width: 32,),
              Text(text,style: TextStyle(fontSize: 16,color: controller.page == page ? Theme.of(context).primaryColor : Colors.grey[700],),)
            ],
          ),
        ),
      ),
    );
  }
}
