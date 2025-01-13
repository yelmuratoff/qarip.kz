import 'package:envied/envied.dart';
part 'env.g.dart';

@Envied(path: '.env')
final class Env {
  @EnviedField(varName: 'FOLDER_ID', useConstantCase: true)
  static const String folderId = _Env.folderId;

  @EnviedField(varName: 'API_KEY', useConstantCase: true)
  static const String apiKey = _Env.apiKey;

  @EnviedField(varName: 'SERVICE_EMAIL', useConstantCase: true)
  static const String serviceEmail = _Env.serviceEmail;

  @EnviedField(varName: 'SERVICE_CLIENT_ID', useConstantCase: true)
  static const String serviceClientId = _Env.serviceClientId;

  @EnviedField(varName: 'SERVICE_PRIVATE_KEY', useConstantCase: true)
  static const String servicePrivateKey = _Env.servicePrivateKey;
}
