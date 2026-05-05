import 'dart:io';

void main() async {
  print('');
  print('===================================================');
  print('🤖 AGENTE GITHUB: Subir Proyecto al Repositorio');
  print('===================================================');
  print('');

  // 1. Comprobar si Git está instalado
  if (!await _runCommand('git', ['--version'], silent: true)) {
    print('❌ Error: No se detectó Git en el sistema. Asegúrate de tener Git instalado.');
    return;
  }

  // 2. Inicializar repositorio si no existe
  var dir = Directory('.git');
  if (!dir.existsSync()) {
    print('📦 Inicializando repositorio local...');
    if (!await _runCommand('git', ['init'])) return;
  } else {
    print('📦 Repositorio local ya existente (.git detectado).');
  }

  // 3. Añadir archivos al staging
  print('\n⏳ Agregando archivos al staging (git add .)...');
  await Process.run('git', ['add', '.'], runInShell: true);

  // 4. Preguntar por el mensaje del Commit
  stdout.write('\n💬 Escribe el mensaje para el commit (Presiona ENTER para usar "Actualización del proyecto"): ');
  String? commitMsg = stdin.readLineSync();
  if (commitMsg == null || commitMsg.trim().isEmpty) {
    commitMsg = 'Actualización del proyecto';
    print('ℹ️ Usando mensaje por defecto: "$commitMsg"');
  } else {
    commitMsg = commitMsg.trim();
  }

  // Aplicar el commit
  var commitEnv = await Process.run('git', ['commit', '-m', commitMsg], runInShell: true);
  if (commitEnv.exitCode != 0) {
    if (commitEnv.stdout.toString().contains('nothing to commit') || commitEnv.stdout.toString().contains('nada para hacer commit')) {
      print('⚠️ No se detectaron cambios nuevos para hacer commit.');
    } else {
      print('⚠️ Mensaje de Git (es posible que ya esté hecho el commit o los archivos ignorados):');
      print(commitEnv.stdout);
    }
  } else {
    print('✅ Commit creado con éxito.');
  }

  // 5. Preguntar por la URL del repositorio
  String? repoUrl;
  while (repoUrl == null || repoUrl.trim().isEmpty) {
    stdout.write('\n🔗 Pega el enlace de tu repositorio de GitHub (.git) y presiona ENTER: ');
    repoUrl = stdin.readLineSync();
  }
  repoUrl = repoUrl.trim();

  // Configurar remoto ("origin")
  var remoteCheck = await Process.run('git', ['remote'], runInShell: true);
  if (remoteCheck.stdout.toString().contains('origin')) {
    print('🔄 Actualizando la URL del remoto existente "origin"...');
    await _runCommand('git', ['remote', 'set-url', 'origin', repoUrl]);
  } else {
    print('➕ Añadiendo el remoto "origin"...');
    await _runCommand('git', ['remote', 'add', 'origin', repoUrl]);
  }

  // 6. Preguntar por la rama
  stdout.write('\n🌿 ¿A qué rama deseas subir el proyecto? (Presiona ENTER para usar la rama par default "main"): ');
  String? rama = stdin.readLineSync();
  if (rama == null || rama.trim().isEmpty) {
    rama = 'main';
  } else {
    rama = rama.trim();
  }

  print('📌 Configurando la rama a "$rama"...');
  await _runCommand('git', ['branch', '-M', rama]);

  // 7. Subir Cambios (Push)
  print('\n🚀 Subiendo el proyecto a GitHub en la rama "$rama"...');
  print('⏳ Por favor espera (esto tomará unos segundos dependido de tu internet)...');
  
  var pushResult = await Process.run('git', ['push', '-u', 'origin', rama], runInShell: true);
  
  if (pushResult.exitCode == 0) {
    print(pushResult.stdout);
    print('\n✅ ¡PROYECTO SUBIDO CON ÉXITO A GITHUB! 🎉');
  } else {
    print('\n❌ Ocurrió un error al intentar subir a GitHub (push falló).');
    print('Detalles del error:');
    print(pushResult.stderr);
    print('\nSugerencias:');
    print('1. Verifica si tienes conexión a internet.');
    print('2. Verifica si el repositorio existe en GitHub.');
    print('3. Verifica que tienes los permisos/credenciales necesarios para subir código.');
    print('4. Si hay conflictos, realiza un pull primero (git pull).');
  }
  
  print('===================================================');
}

/// Función auxiliar para ejecutar procesos de terminal 
Future<bool> _runCommand(String command, List<String> args, {bool silent = false}) async {
  try {
    var result = await Process.run(command, args, runInShell: true);
    if (result.exitCode != 0) {
      if (!silent) {
        print('❌ Error ejecutando: $command ${args.join(' ')}');
        print(result.stderr);
      }
      return false;
    }
    if (!silent && result.stdout.toString().trim().isNotEmpty) {
       print(result.stdout.toString().trim());
    }
    return true;
  } catch (e) {
    if (!silent) print('❌ Excepción al ejecutar comando: $e');
    return false;
  }
}