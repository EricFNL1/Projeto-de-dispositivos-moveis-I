import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:task_list/models/tarefa.dart';
import 'package:intl/intl.dart';

class CardTarefa extends StatelessWidget {
  const CardTarefa({super.key, required this.tarefa, required this.deletar});

  final Tarefa tarefa;
  final Function(Tarefa) deletar;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const DrawerMotion(),
          extentRatio: 0.25,
          children: [
            SlidableAction(
              label: 'Delete',
              backgroundColor: Colors.red,
              icon: Icons.delete_forever,
              borderRadius: BorderRadius.circular(10),
              onPressed: (context) {
                deletar(tarefa);
              },
            ),
          ],
        ),

        child: Container(
          decoration: BoxDecoration(
              color: Colors.grey, borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  DateFormat("dd/MM/yyyy - HH:mm").format(tarefa.dataHora),
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
                Text(
                  tarefa.titulo,
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
