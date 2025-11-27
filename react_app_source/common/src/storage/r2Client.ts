/**
 * Cloudflare R2 Storage Client
 * 
 * Provides a unified interface for media uploads to Cloudflare R2
 * with path conventions and media_assets table integration.
 */

interface R2UploadResult {
  url: string;
  fileName: string;
  fileSize: number;
  mimeType: string;
}

interface MediaAssetData {
  content_id: string;
  media_type: 'image' | 'video' | 'thumbnail' | 'attachment';
  url: string;
  file_name: string;
  file_size: number;
  mime_type: string;
  alt_text?: string;
  processing_status?: 'pending' | 'processing' | 'completed' | 'failed';
}

export interface R2Config {
  accountId: string;
  accessKeyId: string;
  secretAccessKey: string;
  bucketName: string;
  publicUrl: string;
  endpoint?: string;
}

// Check if R2 is configured and enabled
export const isR2Configured = (config: R2Config): boolean => {
  return !!(config.accountId && 
           config.accessKeyId && 
           config.secretAccessKey && 
           config.bucketName && 
           config.publicUrl);
};

// Generate path for R2 storage based on content and media type
export const generateR2Path = (
  contentId: string, 
  mediaType: 'image' | 'video' | 'thumbnail' | 'attachment', 
  fileName: string
): string => {
  const timestamp = Date.now();
  const cleanFileName = fileName.replace(/[^a-zA-Z0-9.-]/g, '_');
  return `content/${contentId}/${mediaType}s/${timestamp}-${cleanFileName}`;
};

// Generate public URL for R2 object
export const generateR2PublicUrl = (path: string, config: R2Config): string => {
  const baseUrl = config.publicUrl.replace(/\/$/, '');
  return `${baseUrl}/${path}`;
};

// Upload file to R2 and return result
export const uploadToR2 = async (
  config: R2Config,
  contentId: string,
  file: File,
  mediaType: 'image' | 'video' | 'thumbnail' | 'attachment'
): Promise<R2UploadResult> => {
  if (!isR2Configured(config)) {
    throw new Error('Cloudflare R2 is not properly configured');
  }

  const path = generateR2Path(contentId, mediaType, file.name);
  const publicUrl = generateR2PublicUrl(path, config);

  try {
    // Using fetch API to upload to R2 S3-compatible API
    const uploadUrl = `https://${config.accountId}.r2.cloudflarestorage.com/${config.bucketName}/${path}`;
    
    const response = await fetch(uploadUrl, {
      method: 'PUT',
      headers: {
        'Authorization': `Bearer ${config.accessKeyId}`,
        'X-Amz-Date': new Date().toISOString().replace(/[:-]|\.\d{3}/g, '').slice(0, 15) + 'Z',
        'Content-Type': file.type,
      },
      body: file,
    });

    if (!response.ok) {
      throw new Error(`R2 upload failed: ${response.status} ${response.statusText}`);
    }

    return {
      url: publicUrl,
      fileName: file.name,
      fileSize: file.size,
      mimeType: file.type,
    };
  } catch (error) {
    console.error('R2 upload error:', error);
    throw new Error(`Failed to upload file to R2: ${error instanceof Error ? error.message : 'Unknown error'}`);
  }
};

// Delete file from R2
export const deleteFromR2 = async (config: R2Config, fileUrl: string): Promise<boolean> => {
  if (!isR2Configured(config)) {
    throw new Error('Cloudflare R2 is not properly configured');
  }

  try {
    // Extract path from public URL
    const publicUrlBase = config.publicUrl.replace(/\/$/, '');
    const path = fileUrl.replace(publicUrlBase + '/', '');
    
    const deleteUrl = `https://${config.accountId}.r2.cloudflarestorage.com/${config.bucketName}/${path}`;
    
    const response = await fetch(deleteUrl, {
      method: 'DELETE',
      headers: {
        'Authorization': `Bearer ${config.accessKeyId}`,
      },
    });

    return response.ok || response.status === 204; // 204 No Content is also successful for DELETE
  } catch (error) {
    console.error('R2 delete error:', error);
    return false;
  }
};

// Save media asset metadata to Supabase media_assets table
export const saveMediaAsset = async (assetData: MediaAssetData, supabaseClient: any): Promise<string> => {
  const { data, error } = await supabaseClient
    .from('media_assets')
    .insert([assetData])
    .select('id')
    .single();

  if (error) {
    console.error('Error saving media asset:', error);
    throw new Error(`Failed to save media asset: ${error.message}`);
  }

  return data.id;
};

// Upload multiple files to R2 and save metadata
export const uploadFilesToR2 = async (
  config: R2Config,
  contentId: string,
  files: FileList,
  mediaType: 'image' | 'video' | 'thumbnail' | 'attachment' = 'image',
  supabaseClient: any
): Promise<{images: string[], videos: string[], mediaAssetIds: string[]}> => {
  const images: string[] = [];
  const videos: string[] = [];
  const mediaAssetIds: string[] = [];

  try {
    // Upload each file to R2
    for (let i = 0; i < files.length; i++) {
      const file = files[i];
      const uploadResult = await uploadToR2(config, contentId, file, mediaType);
      
      // Save metadata to media_assets table
      const assetId = await saveMediaAsset({
        content_id: contentId,
        media_type: mediaType,
        url: uploadResult.url,
        file_name: uploadResult.fileName,
        file_size: uploadResult.fileSize,
        mime_type: uploadResult.mimeType,
        processing_status: 'completed', // R2 uploads are immediate
      }, supabaseClient);

      mediaAssetIds.push(assetId);

      // Categorize by media type for compatibility
      if (uploadResult.mimeType.startsWith('video/')) {
        videos.push(uploadResult.url);
      } else {
        images.push(uploadResult.url);
      }
    }

    // Update content to mark as having media
    await supabaseClient
      .from('content')
      .update({ has_media: true })
      .eq('id', contentId);

    return { images, videos, mediaAssetIds };
  } catch (error) {
    console.error('Error uploading files to R2:', error);
    throw error;
  }
};

// Legacy Firebase Storage interface (for backward compatibility)
export interface FirebaseUploadResult {
  images: string[];
  videos: string[];
}

export interface FirebaseStorageClient {
  uploadFiles: (files: FileList) => Promise<FirebaseUploadResult>;
}

// DEPRECATED: Firebase Storage wrapper - kept for rollback compatibility
export const getFirebaseStorageClient = (): FirebaseStorageClient => {
  console.warn('DEPRECATED: Firebase Storage is deprecated. Please migrate to Cloudflare R2.');
  
  return {
    uploadFiles: async (files: FileList): Promise<FirebaseUploadResult> => {
      // Return empty arrays as Firebase Storage is temporarily disabled
      console.log('Firebase Storage upload bypassed - plan limitations');
      return { images: [], videos: [] };
    }
  };
};

// Create a helper function for creating R2 config from environment variables
export const createR2Config = (
  env: Record<string, string | undefined>
): R2Config | null => {
  const config = {
    accountId: env.VITE_R2_ACCOUNT_ID,
    accessKeyId: env.VITE_R2_ACCESS_KEY_ID,
    secretAccessKey: env.VITE_R2_SECRET_ACCESS_KEY,
    bucketName: env.VITE_R2_BUCKET_NAME,
    publicUrl: env.VITE_R2_PUBLIC_URL,
    endpoint: `https://${env.VITE_R2_ACCOUNT_ID}.r2.cloudflarestorage.com`,
  };

  return isR2Configured(config as R2Config) ? config as R2Config : null;
};

// Toggle between R2 and Firebase storage
export const getStorageClient = (
  useR2: boolean,
  r2Config: R2Config | null,
  supabaseClient: any
): FirebaseStorageClient => {
  if (useR2 && r2Config) {
    return {
      uploadFiles: async (files: FileList): Promise<FirebaseUploadResult> => {
        // Create a temporary content ID for upload
        const tempContentId = `temp-${Date.now()}`;
        
        const result = uploadFilesToR2(
          r2Config,
          tempContentId,
          files,
          'image', // Default media type
          supabaseClient
        );
        
        return result;
      }
    };
  }
  
  // Fallback to Firebase
  return getFirebaseStorageClient();
};