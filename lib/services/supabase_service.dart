import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;
import 'env/env.dart';

class SupabaseService {
  static SupabaseService? _instance;
  static SupabaseService get instance => _instance ??= SupabaseService._();

  SupabaseService._();

  SupabaseClient get client => Supabase.instance.client;

  // Auth methods
  Future<AuthResponse> signInWithEmailAndPassword(String email, String password) async {
    return await client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<AuthResponse> createUserWithEmailAndPassword(String email, String password) async {
    return await client.auth.signUp(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    return await client.auth.signOut();
  }

  User? get currentUser => client.auth.currentUser;

  // Database methods
  Future<List<Map<String, dynamic>>> getDocuments(String table, {String? filter, dynamic value}) async {
    if (filter != null && value != null) {
      return await client
          .from(table)
          .select()
          .eq(filter, value)
          .order('created_at', ascending: false);
    }
    return await client
        .from(table)
        .select()
        .order('created_at', ascending: false);
  }

  Future<Map<String, dynamic>?> getDocument(String table, String id) async {
    final response = await client
        .from(table)
        .select()
        .eq('id', id)
        .single()
        .catchError((error) => null);
    
    return response;
  }

  Future<void> setDocument(String table, Map<String, dynamic> data, {String? id}) async {
    if (id != null) {
      data['id'] = id;
    }
    
    // Add timestamps
    data['created_at'] = DateTime.now().toIso8601String();
    data['updated_at'] = DateTime.now().toIso8601String();
    
    await client.from(table).upsert(data);
  }

  Future<void> updateDocument(String table, String id, Map<String, dynamic> data) async {
    data['updated_at'] = DateTime.now().toIso8601String();
    
    await client
        .from(table)
        .update(data)
        .eq('id', id);
  }

  Future<void> deleteDocument(String table, String id) async {
    await client
        .from(table)
        .delete()
        .eq('id', id);
  }

  // Stream real-time data
  Stream<List<Map<String, dynamic>>> streamDocuments(String table, {String? filter, dynamic value}) {
    var query = client.from(table).select();
    
    if (filter != null && value != null) {
      query = query.eq(filter, value);
    }
    
    return query.stream(primaryKey: ['id']).map((event) => event);
  }

  // Storage methods (for Cloudflare R2)
  Future<String> uploadFile(String filePath, {String? bucket, String? path}) async {
    final file = File(filePath);
    final fileName = path ?? file.path.split('/').last;
    final bucketName = bucket ?? 'samachar-plus-media';
    
    // For Cloudflare R2, we'll use the R2 endpoint directly
    if (Env.r2Endpoint.isNotEmpty) {
      return await _uploadToR2(filePath, fileName);
    }
    
    // Fallback to Supabase Storage
    final bytes = await file.readAsBytes();
    final response = await client.storage
        .from(bucketName)
        .uploadBinary(fileName, bytes);
    
    return client.storage.from(bucketName).getPublicUrl(fileName);
  }

  Future<String> uploadFileFromBytes(List<int> bytes, String fileName, {String? bucket}) async {
    final bucketName = bucket ?? 'samachar-plus-media';
    
    // For Cloudflare R2, we'll use the R2 endpoint directly
    if (Env.r2Endpoint.isNotEmpty) {
      return await _uploadToR2FromBytes(bytes, fileName);
    }
    
    // Fallback to Supabase Storage
    await client.storage
        .from(bucketName)
        .uploadBinary(fileName, bytes);
    
    return client.storage.from(bucketName).getPublicUrl(fileName);
  }

  Future<String> getDownloadURL(String path, {String? bucket}) async {
    final bucketName = bucket ?? 'samachar-plus-media';
    
    // For Cloudflare R2
    if (Env.r2Endpoint.isNotEmpty) {
      return '${Env.r2Endpoint}/${Env.r2BucketName}/$path';
    }
    
    // Fallback to Supabase Storage
    return client.storage.from(bucketName).getPublicUrl(path);
  }

  Future<void> deleteFile(String path, {String? bucket}) async {
    final bucketName = bucket ?? 'samachar-plus-media';
    
    // For Cloudflare R2
    if (Env.r2Endpoint.isNotEmpty) {
      await _deleteFromR2(path);
      return;
    }
    
    // Fallback to Supabase Storage
    await client.storage.from(bucketName).remove([path]);
  }

  // Cloudflare R2 specific methods
  Future<String> _uploadToR2(String filePath, String fileName) async {
    final file = File(filePath);
    final bytes = await file.readAsBytes();
    return await _uploadToR2FromBytes(bytes, fileName);
  }

  Future<String> _uploadToR2FromBytes(List<int> bytes, String fileName) async {
    final url = '${Env.r2Endpoint}/${Env.r2BucketName}/$fileName';
    
    final response = await http.put(
      Uri.parse(url),
      headers: {
        'Content-Type': _getContentType(fileName),
      },
      body: bytes,
    );
    
    if (response.statusCode == 200) {
      return '${Env.r2Endpoint}/${Env.r2BucketName}/$fileName';
    } else {
      throw Exception('Failed to upload to R2: ${response.statusCode}');
    }
  }

  Future<void> _deleteFromR2(String fileName) async {
    final url = '${Env.r2Endpoint}/${Env.r2BucketName}/$fileName';
    
    await http.delete(Uri.parse(url));
  }

  String _getContentType(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    switch (extension) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'mp4':
        return 'video/mp4';
      case 'avi':
        return 'video/avi';
      case 'mov':
        return 'video/quicktime';
      case 'pdf':
        return 'application/pdf';
      default:
        return 'application/octet-stream';
    }
  }
}