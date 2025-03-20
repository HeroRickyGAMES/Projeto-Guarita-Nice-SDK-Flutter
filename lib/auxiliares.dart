import 'dart:io';
import 'dart:typed_data';
import 'dart:async';

import 'connectAndSendDart.dart';

Future<bool> acionaReleAvancado(String tipoDisp, String numDisp, String rele, {int tempo = 1, bool geraEvt = true}) async {
  // 🛠️ Conversão do tipo de dispositivo
  tipoDisp = _converterTipoDisp(tipoDisp);
  print(1);
  if (tipoDisp == '') return false;

  // 🛠️ Validação e formatação do número do dispositivo (CAN)
  numDisp = _validarNumDisp(numDisp);
  if (numDisp == '') return false;
  print(2);
  // 🛠️ Validação e formatação do relé
  rele = _validarRele(rele);
  print(rele);
  if (rele == '') return false;
  print(3);
  // 🛠️ Validação e formatação do tempo
  String tempoHex = _validarTempo(tempo);
  if (tempoHex == '') return false;
  print(4);
  // 🛠️ Converte `geraEvt` para '00' ou '01'
  String geraEvtHex = geraEvt ? '01' : '00';
  print(5);
  // 🔹 Monta a mensagem (frame) a ser enviada
  List<int> lFrame = [
    0x00, // Byte inicial fixo
    0x5C, // Código do comando
    int.parse(tipoDisp, radix: 16), // Tipo do dispositivo
    int.parse(numDisp, radix: 16), // Número do dispositivo (CAN)
    int.parse(rele, radix: 16), // Número do relé
    int.parse(geraEvtHex, radix: 16), // Geração de evento
  ];
  print(6);

  // 🔹 Adiciona checksum intermediário
  lFrame.add(_calculateChecksum(lFrame));
  print(7);
  // 🔹 Adiciona o tempo e checksum final
  lFrame.add(int.parse(tempoHex, radix: 16));
  lFrame.add(_calculateChecksum(lFrame));
  print(8);
  // 🔹 Converte para Uint8List e envia via socket
  return await _enviarComando(Uint8List.fromList(lFrame));
}

/// Envia o comando via socket TCP/IP
Future<bool> _enviarComando(Uint8List comando) async {
  try {
    // Conecta ao receptor no IP e na porta desejada (substitua pelo IP e porta corretos)
    // 🔹 Envia o comando formatado
    print(comando);
    socket.add(comando);
    //await socket.flush();
    print("Comando enviado: ${comando.map((b) => b.toRadixString(16).padLeft(2, '0')).join(' ')}");

    // 🔹 Aguarda resposta do receptor (2 bytes)
    List<int> response = await socket.first.timeout(Duration(seconds: 50));

    print("Resposta: ${response.map((b) => b.toRadixString(16).padLeft(2, '0')).join(' ')}");

    return true;
  } catch (e) {
    print("Erro ao conectar ao receptor: $e");
    return false;
  } finally {
    print('funcionou?');
  }
}

String _converterTipoDisp(String tipo) {
  var mapTipos = {
    '1': '01', '01': '01', 'RF': '01', 'rf': '01', 'TX': '01', 'tx': '01',
    '2': '02', '02': '02', 'TA': '02', 'ta': '02',
    '3': '03', '03': '03', 'CT': '03', 'ct': '03', 'CTW': '03', 'ctw': '03', 'CTWB': '03', 'ctwb': '03',
    '5': '05', '05': '05', 'BM': '05', 'bm': '05', 'BIO': '05', 'bio': '05',
    '6': '06', '06': '06', 'TP': '06', 'tp': '06',
    '7': '07', '07': '07', 'SN': '07', 'sn': '07',
  };
  return mapTipos[tipo] ?? '';
}

String _validarNumDisp(String num) {
  return ['00', '01', '02', '03', '04', '05', '06', '07'].contains(num) ? num : '';
}

String _validarRele(String rele) {
  return ['01', '02', '03', '04', '05', '06', '07', '08', '09'].contains(rele) ? rele : '';
}

String _validarTempo(int tempo) {
  return (tempo >= 0 && tempo <= 255) ? tempo.toRadixString(16).padLeft(2, '0') : '';
}

int _calculateChecksum(List<int> data) {
  return data.reduce((a, b) => a + b) & 0xFF;
}
