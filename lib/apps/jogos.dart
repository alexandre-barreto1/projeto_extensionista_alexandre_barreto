import 'dart:developer';

import 'package:flutter/material.dart';

class JogosPage extends StatelessWidget {
  const JogosPage({super.key});

  @override
  Widget build(BuildContext context) => Center(
    child: Container(
        color: Colors.white,
        child: DataTable(columns: const [
          DataColumn(label: Text('Jogo')),
          DataColumn(label: Text('Editar'))
        ], rows: const [
          DataRow(cells: [
            DataCell(Text('teste')),
            DataCell(Text('teste'))
          ]),
          DataRow(cells: [
            DataCell(Text('teste')),
            DataCell(Text('teste'))
          ])
        ])
    )
    );
}


