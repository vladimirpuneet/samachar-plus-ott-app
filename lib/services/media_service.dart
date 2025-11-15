import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:samachar_plus_ott_app/env/env.dart';

/// Media Service for Samachar Plus OTT App
/// 
/// Handles media asset URLs from Supabase media_assets table and Cloudflare R2.
/// Provides simple HTTP(s) URLs for images, videos, and thumbnails.
/// 
/// TODO in next iteration: Remove Firebase Storage SDK dependency
class MediaService {
  static final MediaService _instance = MediaService._internal();
  static MediaService get instance => _instance;
  
  MediaService._internal();

  final SupabaseClient _client = Supabase.instance.client;

  /// Get media asset URL from Supabase media_assets table
  /// 
  /// Converts media asset references to actual Cloudflare R2 URLs
  Future<String?> getMediaUrl(String assetId, {String assetType = 'image'}) async {
    try {
      if (assetId.isEmpty) return null;
      
      // If it's already a full URL, return as-is
      if (assetId.startsWith('http://') || assetId.startsWith('https://')) {
        return assetId;
      }
      
      // Query Supabase media_assets table
      final response = await _client
          .from('media_assets')
          .select()
          .eq('id', assetId)
          .single()
          .catchError((error) => null);
      
      if (response == null) return null;
      
      // Construct Cloudflare R2 URL
      return _buildR2Url(response['file_path'] ?? assetId, assetType);
    } catch (e) {
      print('Failed to get media URL: $e');
      return null;
    }
  }

  /// Get multiple media URLs for a content item
  /// 
  /// Takes a list of media asset IDs and returns their URLs
  Future<List<String>> getMediaUrls(List<String> assetIds, {String assetType = 'image'}) async {
    if (assetIds.isEmpty) return [];
    
    try {
      final urls = <String>[];
      
      for (final assetId in assetIds) {
        final url = await getMediaUrl(assetId, assetType: assetType);
        if (url != null) {
          urls.add(url);
        }
      }
      
      return urls;
    } catch (e) {
      print('Failed to get media URLs: $e');
      return [];
    }
  }

  /// Get thumbnail URL for an article
  /// 
  /// Special handling for article thumbnails
  Future<String?> getThumbnailUrl(String thumbnailAssetId) async {
    return await getMediaUrl(thumbnailAssetId, assetType: 'thumbnail');
  }

  /// Get video URL for streaming
  /// 
  /// Returns video URL for video player
  Future<String?> getVideoUrl(String videoAssetId) async {
    return await getMediaUrl(videoAssetId, assetType: 'video');
  }

  /// Get logo URL for live channels
  /// 
  /// Returns logo image URL for live channel display
  Future<String?> getLogoUrl(String logoAssetId) async {
    return await getMediaUrl(logoAssetId, assetType: 'logo');
  }

  /// Get article featured image URL
  /// 
  /// Returns the main article image URL
  Future<String?> getFeaturedImageUrl(String imageAssetId) async {
    return await getMediaUrl(imageAssetId, assetType: 'image');
  }

  /// Get multiple article images
  /// 
  /// Returns all article image URLs
  Future<List<String>> getArticleImages(List<String> imageAssetIds) async {
    return await getMediaUrls(imageAssetIds, assetType: 'image');
  }

  /// Build Cloudflare R2 URL
  /// 
  /// Constructs the actual Cloudflare R2 URL from file path and asset type
  String _buildR2Url(String filePath, String assetType) {
    if (Env.r2Endpoint.isEmpty || Env.r2BucketName.isEmpty) {
      // Fallback to placeholder URL or default image
      return 'https://via.placeholder.com/400x300?text=Media+Unavailable';
    }
    
    // Clean the file path
    final cleanPath = filePath.startsWith('/') ? filePath.substring(1) : filePath;
    
    // Build R2 URL
    return '${Env.r2Endpoint}/${Env.r2BucketName}/$cleanPath';
  }

  /// Check if media service is configured
  /// 
  /// Verifies if Supabase and R2 are properly configured
  bool get isConfigured {
    return Env.supabaseUrl.isNotEmpty && 
           Env.supabaseAnonKey.isNotEmpty && 
           Env.r2Endpoint.isNotEmpty && 
           Env.r2BucketName.isNotEmpty;
  }

  /// Get media URL directly (sync method for UI convenience)
  /// 
  /// For cases where async loading is not practical, returns a placeholder or cached URL
  String getMediaUrlSync(String assetId, {String assetType = 'image'}) {
    if (assetId.isEmpty) {
      return _getPlaceholderUrl(assetType);
    }
    
    // If it's already a full URL, return as-is
    if (assetId.startsWith('http://') || assetId.startsWith('https://')) {
      return assetId;
    }
    
    // Build R2 URL directly (best effort)
    return _buildR2Url(assetId, assetType);
  }

  /// Get placeholder URL for missing media
  String _getPlaceholderUrl(String assetType) {
    switch (assetType.toLowerCase()) {
      case 'video':
        return 'https://via.placeholder.com/400x300/1E3A8A/FFFFFF?text=Video+Unavailable';
      case 'logo':
        return 'https://via.placeholder.com/100x100/10B981/FFFFFF?text=Logo';
      case 'thumbnail':
        return 'https://via.placeholder.com/300x200/F59E0B/FFFFFF?text=Thumbnail';
      default:
        return 'https://via.placeholder.com/400x300/6B7280/FFFFFF?text=Image+Unavailable';
    }
  }
}