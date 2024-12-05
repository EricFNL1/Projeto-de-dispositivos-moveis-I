import 'dart:convert';
import 'package:task_list/models/tarefa.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListaRepositorio{

  ListaRepositorio() {
    SharedPreferences.getInstance().then((value) => sharedPreferences = value);
  }
  late SharedPreferences sharedPreferences;

  Future<List<Tarefa>> recuperarLista() async{
    sharedPreferences = await SharedPreferences.getInstance();
    final String jsonString = sharedPreferences.getString('task_list') ?? '[]';
    print("retorno:");
    print(jsonString);
    final List jsonDecoded = jsonDecode(jsonString) as List;
    return jsonDecoded.map((e) => Tarefa.fromJson(e)).toList();
  }

  void salvarLista(List<Tarefa> lista){
    final String jsonString = jsonEncode(lista);
    print("gravando:");
    print(jsonString);
    sharedPreferences.setString('task_list',jsonString);
  }

}
