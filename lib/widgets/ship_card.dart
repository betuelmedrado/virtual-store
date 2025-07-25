
import 'package:flutter/material.dart';


class ShipCard extends StatelessWidget {
  const ShipCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Card(
        margin: EdgeInsets.all(0.8) ,
        child: ExpansionTile(
          title: Text('Calcular Frete'),
          leading: Icon(Icons.location_on),
          trailing: Icon(Icons.add),
          children: [
            TextFormField(
              decoration: InputDecoration(
                hintText: 'Digite seu CEP',
                border: OutlineInputBorder()
              ),
            ),
          ],
        ),
      ),
    );
  }
}
