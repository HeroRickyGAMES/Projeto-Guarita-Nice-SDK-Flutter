import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:guarita_nice_sdk_flutter/snackBar.dart';


//Programado por HeroRickyGAMES

var socket;
bool conectado = false;

String mapearMarca(int codigo) {
  const marcas = {
    0x00: "AUDI", 0x01: "BMW", 0x02: "CHEVROLET", 0x03: "CHRYSLER",
    0x04: "CITROEN", 0x05: "FERRARI", 0x06: "FIAT", 0x07: "FORD",
    0x08: "GM", 0x09: "HONDA", 0x0A: "HYUNDAI", 0x0B: "IMPORTADO",
    0x0C: "JAGUAR", 0x0D: "JEEP", 0x0E: "KIA", 0x0F: "LAMBORGHINI",
    0x10: "LAND ROVER", 0x11: "MAZDA", 0x12: "MERCEDES", 0x13: "MITSUBISHI",
    0x14: "MOTO", 0x15: "NISSAN", 0x16: "VEICULO", 0x17: "PEUGEOT",
    0x18: "PORSCHE", 0x19: "RENAULT", 0x1A: "SUBARU", 0x1B: "SUZUKI",
    0x1C: "TOYOTA", 0x1D: "VOLKSWAGEN", 0x1E: "VOLVO", 0x1F: "SEM VEICULO"
  };
  return marcas[codigo] ?? "Desconhecido";
}

/// Mapeia os tipos de dispositivo
String mapearTipoDispositivo(int tipo) {
  switch (tipo) {
    case 1: return "RF";
    case 2: return "TA";
    case 3: return "CT";
    case 5: return "BM";
    case 6: return "TP";
    case 7: return "SN";
    default: return "Desconhecido";
  }
}

String mapearCor(int codigo) {
  const cores = {
    0x00: "AMARELO", 0x01: "AZUL", 0x02: "BEGE", 0x03: "BRANCO",
    0x04: "CINZA", 0x05: "DOURADO", 0x06: "FANTASIA", 0x07: "GRENA",
    0x08: "LARANJA", 0x09: "MARROM", 0x0A: "PRATA", 0x0B: "PRETO",
    0x0C: "ROSA", 0x0D: "ROXO", 0x0E: "VERDE", 0x0F: "VERMELHO"
  };
  return cores[codigo] ?? "Desconhecido";
}

int contadorDispositivos = 0; // Conta os dispositivos lidos
const int maxDispositivos = 10; // Defina um limite para evitar loop infinito
late StreamSubscription subscription;

int cbDispTotipoDisp(int cbValor) {
  switch (cbValor) {
    case 0:
      return 0x01; // Controle TX (RF)
    case 1:
      return 0x02; // TAG Ativo (TA)
    case 2:
      return 0x03; // Cartão (CT/CTW)
    case 3:
      return 0x05; // Biometria (BM)
    case 4:
      return 0x06; // TAG Passivo (TP/UHF)
    case 5:
      return 0x07; // Senha (SN)
    default:
      return 0x01; // Valor padrão (Controle TX)
  }
}

botaoConectar(context, String ip, int port) async {
  try{
    socket = await Socket.connect(ip, port, timeout: Duration(seconds: 2));
    print('Conectado ao servidor: ${socket.remoteAddress.address}:${socket.remotePort}');
    showSnack(context, 'Conectado ao servidor: ${socket.remoteAddress.address}:${socket.remotePort}');
    conectado = true;
  }catch(e){
    showSnack(context, 'Erro de comunicação TCP $e');
    print('Erro de comunicação TCP $e');
  }
}

botaoDesconectar(context) async {
  await socket.close();
  showSnack(context, 'Desconectado!');
  conectado = false;
}

/// Conecta ao servidor e envia comandos conforme o relé e tipo de dispositivo.
Future<void> connectAndSend(String ip, int port, String rele, bool gerarEvento, int tipoDispIndex, int can) async {
  try {
    print('Conectado ao servidor: ${socket.remoteAddress.address}:${socket.remotePort}');

    int tipoDisp = tipoDispIndex; // Converte o índice para tipo de dispositivo

    List<int> lFrame;

    switch (rele) {
    // Comando 1 - 0x00 + 0x0D + <tipo_disp> + <num_disp> + <num_saida> + <gera_evt> + <cs>
      case "1":
        lFrame = List.filled(6, 0);
        lFrame[0] = 0x00;
        lFrame[1] = 0x0D;
        lFrame[2] = tipoDisp;
        lFrame[3] = can;
        lFrame[4] = 0x01;
        lFrame[5] = gerarEvento ? 0x01 : 0x00;
        enviarComando(socket, Uint8List.fromList(lFrame));
        break;
      case "2":
      // Comando 1 - 0x00 + 0x0D + <tipo_disp> + <num_disp> + <num_saida> + <gera_evt> + <cs>
        lFrame = List.filled(6, 0);
        lFrame[0] = 0x00;
        lFrame[1] = 0x0D;
        lFrame[2] = tipoDisp;
        lFrame[3] = can;
        lFrame[4] = 0x02;
        lFrame[5] = gerarEvento ? 0x01 : 0x00;
        enviarComando(socket, Uint8List.fromList(lFrame));
        break;
      case "3":
      // Comando 1 - 0x00 + 0x0D + <tipo_disp> + <num_disp> + <num_saida> + <gera_evt> + <cs>
        lFrame = List.filled(6, 0);
        lFrame[0] = 0x00;
        lFrame[1] = 0x0D;
        lFrame[2] = tipoDisp;
        lFrame[3] = can;
        lFrame[4] = 0x03;
        lFrame[5] = gerarEvento ? 0x01 : 0x00;
        enviarComando(socket, Uint8List.fromList(lFrame));
        break;
      case "4":
      // Comando 1 - 0x00 + 0x0D + <tipo_disp> + <num_disp> + <num_saida> + <gera_evt> + <cs>
        lFrame = List.filled(6, 0);
        lFrame[0] = 0x00;
        lFrame[1] = 0x0D;
        lFrame[2] = tipoDisp;
        lFrame[3] = can;
        lFrame[4] = 0x04;
        lFrame[5] = gerarEvento ? 0x01 : 0x00;
        enviarComando(socket, Uint8List.fromList(lFrame));
        break;
      case "5":
        // Comando 2 - 0x00 + 0x5C + <tipo_disp> + <num_disp> + <rele> + <gerar_evt> + tempo + <cs>
        List<int> lFrame = List.filled(7, 0);
        lFrame[0] = 0x00;
        lFrame[1] = 0x5C;
        lFrame[2] = tipoDisp;
        lFrame[3] = can;
        lFrame[4] = 0x05;
        lFrame[5] = 0x01;
        lFrame[6] = 0x01;
        enviarComando(socket, Uint8List.fromList(lFrame));
        break;

      case "6":

      // Comando 2 - 0x00 + 0x5C + <tipo_disp> + <num_disp> + <rele> + <gerar_evt> + tempo + <cs>
        List<int> lFrame = List.filled(7, 0);
        lFrame[0] = 0x00;
        lFrame[1] = 0x5C;
        lFrame[2] = tipoDisp;
        lFrame[3] = can;
        lFrame[4] = 0x06;
        lFrame[5] = 0x01;
        lFrame[6] = 0x01;
        enviarComando(socket, Uint8List.fromList(lFrame));
        break;
      case "7":

      // Comando 2 - 0x00 + 0x5C + <tipo_disp> + <num_disp> + <rele> + <gerar_evt> + tempo + <cs>
        List<int> lFrame = List.filled(7, 0);
        lFrame[0] = 0x00;
        lFrame[1] = 0x5C;
        lFrame[2] = tipoDisp;
        lFrame[3] = can;
        lFrame[4] = 0x07;
        lFrame[5] = 0x01;
        lFrame[6] = 0x01;
        enviarComando(socket, Uint8List.fromList(lFrame));
        break;
      case "8":

      // Comando 2 - 0x00 + 0x5C + <tipo_disp> + <num_disp> + <rele> + <gerar_evt> + tempo + <cs>
        List<int> lFrame = List.filled(7, 0);
        lFrame[0] = 0x00;
        lFrame[1] = 0x5C;
        lFrame[2] = tipoDisp;
        lFrame[3] = can;
        lFrame[4] = 0x08;
        lFrame[5] = 0x01;
        lFrame[6] = 0x01;
        enviarComando(socket, Uint8List.fromList(lFrame));
        break;

      default:
        print('Relé não suportado');
    }
    print('Conexão encerrada.');
  } catch (e) {
    print('Erro ao conectar: $e');
  }
}

void enviarComandoControle(Socket socket, Uint8List comando) {
  print("Enviando comando...");
  socket.add(comando);
  socket.flush();
  print("Comando enviado para o socket.");
  socket.listen((Uint8List data) {
    print("Resposta recebida: ${data.map((b) => b.toRadixString(16).padLeft(2, '0')).join(' ')}");
    socket.done;

  }, onError: (error) {
    print("Erro na comunicação: $error");
  }, onDone: () {
    print("Conexão encerrada pelo servidor.");
  });
}

/// Envia o comando via socket com cálculo do checksum.
void enviarComando(Socket socket, Uint8List frameHex) {
  print("Enviando comando...");
  int tamFrameHex = frameHex.length;
  List<int> frameEnvioHex = List.filled(tamFrameHex + 1, 0);

  // Calcula checksum
  for (int i = 0; i < tamFrameHex; i++) {
    frameEnvioHex[i] = frameHex[i];
    frameEnvioHex[tamFrameHex] += frameHex[i];
  }

  print("Comando enviado: ${frameHex.map((b) => b.toRadixString(16).padLeft(2, '0')).join('-')}");

  // Checksum apenas para frames com 2 bytes ou mais
  int bytesParaEnviar = tamFrameHex;
  if (tamFrameHex > 1) bytesParaEnviar++;

  if (socket != null) {
    socket.add(Uint8List.fromList(frameEnvioHex.sublist(0, bytesParaEnviar)));
    print("Frame enviado: ${frameEnvioHex.sublist(0, bytesParaEnviar).map((b) => b.toRadixString(16).padLeft(2, '0')).join('-')}");
  }
}

/// Calcula o checksum do frame.
int calculateChecksum(List<int> data) {
  int checksum = 0;
  for (var b in data) {
    checksum += b;
  }
  return checksum & 0xFF;
}


void enviarComandoAuxiliar(Socket socket, Uint8List frameHex, {bool adicionarChecksumExtra = false}) {
  print("Enviando comando...");
  int tamFrameHex = frameHex.length;
  List<int> frameEnvioHex = List.filled(tamFrameHex + 1, 0);

  // Copia o frame original e calcula checksum extra, se necessário
  for (int i = 0; i < tamFrameHex; i++) {
    frameEnvioHex[i] = frameHex[i];
    if (adicionarChecksumExtra) {
      frameEnvioHex[tamFrameHex] += frameHex[i]; // Soma para checksum
    }
  }

  print("Comando enviado (sem checksum extra): ${frameHex.map((b) => b.toRadixString(16).padLeft(2, '0')).join('-')}");

  int bytesParaEnviar = tamFrameHex;
  if (adicionarChecksumExtra && tamFrameHex > 1) {
    bytesParaEnviar++;
    print("Checksum extra adicionado: ${frameEnvioHex[tamFrameHex].toRadixString(16).padLeft(2, '0')}");
  }

  socket.add(Uint8List.fromList(frameEnvioHex.sublist(0, bytesParaEnviar)));
  print("Frame enviado: ${frameEnvioHex.sublist(0, bytesParaEnviar).map((b) => b.toRadixString(16).padLeft(2, '0')).join('-')}");
}

//Controles

CadastrarControle(){
  int opcao = 0x00; // Exemplo: Cadastrar
  List<int> frameDisp = List.filled(39, 0);

  // Definir valores no frame conforme exemplo
  frameDisp[0] = 0x11;
  frameDisp[1] = 0xBC; //<BC>
  frameDisp[2] = 0x4E; //<4E>
  frameDisp[3] = 0xCF; //<CF>
  frameDisp[4] = 0x02;
  frameDisp[5] = 0x5A;
  // Configuração dos receptores
  frameDisp[10] = 0x00;
  List<bool> receptores = [true, true, false, false, false, false, false, false];
  for (int i = 0; i < 8; i++) {
    if (receptores[i]) {
      frameDisp[10] |= (0x01 << i);
    }
  }
  frameDisp[14] = 0x8F; // Começa "00001"
  frameDisp.setRange(15, 20, "00001".codeUnits); // Inserindo identificação
  frameDisp[29] = 0x1F;
  frameDisp[30] = 0x00;

  // Criando frame final
  List<int> lFrame = [0x00, 0x43, opcao] + frameDisp;


  // Enviar o frame
  enviarComando(socket, Uint8List.fromList(lFrame));
}

Future<List<int>> receberResposta(ultimoFrame) {
  final completer = Completer<List<int>>();
  List<int> buffer = [];

  socket.listen((data) {
    buffer.addAll(data);

    // Aqui você pode adicionar alguma lógica para verificar se toda a resposta foi recebida
    if (buffer.isNotEmpty) {
      if (!completer.isCompleted) {
        completer.complete(buffer);
      }
    }
  }, onError: (error) {
    if (!completer.isCompleted) {
      completer.completeError(error);
    }
  }, onDone: () {
    if (!completer.isCompleted) {
      completer.complete(buffer);
    }
  });

  return completer.future;
}

ouvirControles(ultimoFrame) async {
  socket.listen((data) {
    if (data.isEmpty) return;

    print("Recebido: ${data.map((b) => b.toRadixString(16).padLeft(2, '0')).join(' ')}");

    if (data.length == 42 && data[0] == 0x00 && data[1] == 0x46) {
      // Extraímos os 39 bytes do dispositivo
      List<int> frameDisp = data.sublist(2, 41);
      processarDispositivo(frameDisp);

      // Solicitar a identificação após processar o dispositivo
      Future.delayed(Duration(milliseconds: 500), () {
        solicitarIdentificacao(socket);
      });
    } else if (data.length >= 43 && data[0] == 0x00 && data[1] == 0x03) {
      // Resposta da identificação
      String rotulo1 = String.fromCharCodes(data.sublist(2, 22)).trim();
      String rotulo2 = String.fromCharCodes(data.sublist(22, 42)).trim();

      print("\n==== Identificação ====");
      print("Identificação: '${rotulo1.isNotEmpty ? rotulo1 : rotulo2}'");
    } else if (data[0] == 0xFF) {
      print("Erro no frame, reenviando...");
      Future.delayed(Duration(milliseconds: 500), () {
        enviarComando(socket, Uint8List.fromList(ultimoFrame));
      });
    }
  }).onError((error) {
    print("Erro na comunicação: $error");
  });
}

/// Solicita a identificação do dispositivo.
void solicitarIdentificacao(Socket socket) {
  List<int> frame = [0x00, 0x03];
  int checksum = calculateChecksum(frame);
  frame.add(checksum);

  print("Solicitando Identificação...");
  socket.add(Uint8List.fromList(frame));
  socket.flush();
}

ListarControles(){
  List<int> primeiroFrame = [0x00, 0x46]; // 0x00 + 0x46
  enviarComando(socket, Uint8List.fromList(primeiroFrame));

  // Aguarda resposta e processa
  ouvirControles(primeiroFrame);
}

void processarDispositivo(List<int> frame) {
  if (frame.length != 39) {
    print("Erro: Frame de dispositivo inválido!");
    return;
  }

  int tipoDisp = frame[0];
  int serial3 = frame[1];
  int serial2 = frame[2];
  int serial1 = frame[3];
  int serial0 = frame[4];
  int marcaVeiculo = frame[31];
  int corVeiculo = frame[32];
  String placa = String.fromCharCodes(frame.sublist(33)).trim();

  String marca = mapearMarca(marcaVeiculo);
  String cor = mapearCor(corVeiculo);
  int serial = (serial3 << 24) | (serial2 << 16) | (serial1 << 8) | serial0;

  print("\n==== Dispositivo Encontrado ====");
  print("Tipo: ${mapearTipoDispositivo(tipoDisp)}");
  print("Serial: $serial");
  print("Marca: $marca");
  print("Cor: $cor");
  print("Placa: $placa");
}

void pararListener() {
  subscription.cancel();
  print("Listener parado.");
}