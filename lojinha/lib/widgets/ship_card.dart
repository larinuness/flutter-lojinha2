import 'package:flutter/material.dart';

class ShipCard extends StatelessWidget {
  const ShipCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      //expansionTile é uma tile que vai se expandir quando clicada e mostrar o restante do conteúdo
      child: ExpansionTile(
        title: Text(
          'Calcular Frete',
          textAlign: TextAlign.start,
          style:
              TextStyle(fontWeight: FontWeight.w500, color: Colors.grey[700]),
        ),
        //ícone da parte esquerda
        leading: Icon(Icons.location_on),
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(), hintText: 'Digite seu CEP'),
              //texto inicial que o TextFormField vai ter
              //quando abrir vai colocar o código de cupom que tá aplicado ou deixar em branco
              initialValue: '',
              //quando digitar o cupom e pressionar o concluído vai aplicar esse cupom
              onFieldSubmitted: (text) {},
            ),
          )
        ],
      ),
    );
  }
}