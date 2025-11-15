import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'SUPABASE_URL')
  static const String supabaseUrl = _Env.supabaseUrl;

  @EnviedField(varName: 'SUPABASE_ANON_KEY')
  static const String supabaseAnonKey = _Env.supabaseAnonKey;

  @EnviedField(varName: 'R2_ENDPOINT')
  static const String r2Endpoint = _Env.r2Endpoint;

  @EnviedField(varName: 'R2_BUCKET_NAME')
  static const String r2BucketName = _Env.r2BucketName;

  @EnviedField(varName: 'ENVIRONMENT')
  static const String environment = _Env.environment;
}