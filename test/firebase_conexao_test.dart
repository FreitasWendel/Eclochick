import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

const projectId = 'testeprototipo-74ae9';
const rtdbUrl = 'https://$projectId-default-rtdb.firebaseio.com';

Future<int?> statusHttp(
  String url, {
  Duration timeout = const Duration(seconds: 10),
}) async {
  final client = HttpClient()..connectionTimeout = timeout;
  try {
    final req = await client.getUrl(Uri.parse(url));
    final resp = await req.close().timeout(timeout);
    await resp.drain<void>();
    return resp.statusCode;
  } catch (_) {
    return null; 
  } finally {
    client.close(force: true);
  }
}

void main() {
  group('1. Configuração do Firebase (offline)', () {
    late Map<String, dynamic> services;
    late Map<String, dynamic> firebaseJson;

    setUpAll(() {
      services = jsonDecode(
        File('android/app/google-services.json').readAsStringSync(),
      ) as Map<String, dynamic>;
      firebaseJson = jsonDecode(
        File('firebase.json').readAsStringSync(),
      ) as Map<String, dynamic>;
    });

    test('google-services.json tem o project_id esperado', () {
      expect(services['project_info']['project_id'], projectId);
    });                                                                                                                                                                                     

    test('firebase.json (flutterfire) usa o mesmo projeto', () {
      final id = firebaseJson['flutter']['platforms']['android']['default']
          ['projectId'];
      expect(id, projectId);
    });                                                                                                                                                                                     

    test('firebase_url aponta para o Realtime Database do projeto', () {
      expect(services['project_info']['firebase_url'], rtdbUrl);
    });                                                                                                                                                                                                       

    test('pacote do app (com.example.eclochick) está registrado', () {
      final pacotes = (services['client'] as List)
          .map((c) => c['client_info']['android_client_info']['package_name'])
          .toList();
      expect(pacotes, contains('com.example.eclochick'));
    });                                                                                                                                                                                           
  });                                                                                                                                                           

  
  const endpoints = <(String, String, List<int>)>[
    ('Realtime Database (raiz)', '$rtdbUrl/.json', [200, 401, 403]),
    (
      'Realtime Database (consulta rasa)',
      '$rtdbUrl/.json?shallow=true',
      [200, 401, 403]
    ),
  ];

  group('2. Resposta real do Firebase (online, parametrizado)', () {
    for (final (nome, url, aceitos) in endpoints) {
      test('$nome responde com status $aceitos', () async {
        final status = await statusHttp(url);

        expect(
          status,
          isNotNull,
          reason: 'SEM RESPOSTA do Firebase em $url '
              '(verifique a internet ou se o projeto existe)',
        );
        expect(
          aceitos,
          contains(status),
          reason: 'O Firebase respondeu, mas com status inesperado: $status',
        );
      });                                                                                                                     
    }
  });                                                                                                                           
  group('3. Controle negativo: detecta quando NÃO há resposta', () {
    test('host inexistente retorna null (sem resposta)', () async {
      final status = await statusHttp(
        'https://nao-existe.firebase-invalido.invalid/.json',
        timeout: const Duration(seconds: 5),
      );
      expect(status, isNull);
    });                                                                                                                                                 
  });                                                                                                                                                                                                                                                                 
}
