// lib/env/env.dart
import 'package:envied/envied.dart';
part 'env.g.dart';

@Envied(path: '.env')
final class Env {
  @EnviedField(varName: 'SUPABASE_URL', useConstantCase: true)
  static const String supabaseUrl = _Env.supabaseUrl;

  @EnviedField(varName: 'SUPABASE_ANON_KEY', useConstantCase: true)
  static const String supabaseAnonKey = _Env.supabaseAnonKey;
}
