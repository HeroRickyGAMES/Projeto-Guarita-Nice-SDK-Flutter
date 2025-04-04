import 'package:flutter/material.dart';
import 'package:guarita_nice_sdk_flutter/connectAndSendDart.dart';

String ip = "";
int porta = 9000;
bool bnts = true;
bool controles = false;

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Guarita Nice SDK',
      theme: ThemeData(
        brightness: Brightness.dark, // Tema escuro
        primarySwatch: Colors.blueGrey,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Guarita Nice SDK Desenvolvido por HeroRickyGAMES'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    ElevatedButton(
                        onPressed: (){
                          setState(() {
                            bnts = true;
                            controles = false;
                          });
                        },
                        child: Text('Botões')
                    ),
                    ElevatedButton(
                        onPressed: (){
                          setState(() {
                            bnts = false;
                            controles = true;
                          });
                        },
                        child: Text('Controles')
                    ),
                  ],
                ),
                ConnectionSection(),
                SizedBox(height: 20),
                if(bnts == true)
                OutputControlSection(),
                if(controles == true)
                  Controles()
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Controles extends StatefulWidget {
  const Controles({super.key});

  @override
  State<Controles> createState() => _ControlesState();
}

class _ControlesState extends State<Controles> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: ElevatedButton(
              onPressed: (){
                CadastrarControle();
              },
              child: Text('Testar e cadastrar')),
        ),
        Center(
          child: ElevatedButton(
              onPressed: (){
                ListarControles();
              },
              child: Text('Listar controles')),
        ),
      ],
    );
  }
}


class ConnectionSection extends StatefulWidget {
  @override
  State<ConnectionSection> createState() => _ConnectionSectionState();
}

class _ConnectionSectionState extends State<ConnectionSection> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Conexão', style: TextStyle(fontWeight: FontWeight.bold)),
            Row(
              children: [
                Radio(value: true, groupValue: true, onChanged: (_) {}),
                Text('TCP/IP (Guarita/Conversor SERVER)'),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (value){
                      setState(() {
                        ip = value;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Endereço IP',
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    onChanged: (value){
                      setState(() {
                        porta = int.parse(value);
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Porta TCP',
                      hintText: '9000',
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if(conectado == false){
                    botaoConectar(context, ip, porta);
                  }else{
                    botaoDesconectar(context);
                  }

                },
                child: conectado == true ? Text('Desconectar') : Text('Conectar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OutputControlSection extends StatefulWidget {
  @override
  State<OutputControlSection> createState() => _OutputControlSectionState();
}

class _OutputControlSectionState extends State<OutputControlSection> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Acionar Saídas', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Row(
              children: [
                DropdownButton<String>(
                  value: 'TX (RF)',
                  dropdownColor: Colors.grey[900],
                  items: ['TX (RF)', 'Outra Opção'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (_) {},
                ),
                SizedBox(width: 10),
                DropdownButton<String>(
                  value: '1',
                  dropdownColor: Colors.grey[900],
                  items: ['1', '2', '3'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (_) {},
                ),
                Spacer(),
                Checkbox(value: true, onChanged: (_) {}),
                Text('Gerar evento?'),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: () async {
                  connectAndSend('177.140.6.126', 9000, "1", true, 01, 0);
                }, child: Text('Relé 1')),
                ElevatedButton(onPressed: () {
                  connectAndSend('177.140.6.126', 9000, "2", true, 01, 0);
                }, child: Text('Relé 2')),
                ElevatedButton(onPressed: () {
                  connectAndSend('177.140.6.126', 9000, "3", true, 01, 0);
                }, child: Text('Relé 3')),
                ElevatedButton(onPressed: () {
                  connectAndSend('177.140.6.126', 9000, "4", true, 01, 0);
                }, child: Text('Relé 4')),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Reles auxiliares'),
                Container(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(onPressed: () async {
                        connectAndSend('177.140.6.126', 9000, "5", true, 01, 0);
                      }, child: Text('Relé 5')),
                      ElevatedButton(onPressed: () async {
                        connectAndSend('177.140.6.126', 9000, "6", true, 01, 0);
                      }, child: Text('Relé 6')),
                      ElevatedButton(onPressed: () async {
                        connectAndSend('177.140.6.126', 9000, "7", true, 01, 0);
                      }, child: Text('Relé 7')),
                      ElevatedButton(onPressed: () async {
                        connectAndSend('177.140.6.126', 9000, "8", true, 01, 0);
                      }, child: Text('Relé 8')),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
