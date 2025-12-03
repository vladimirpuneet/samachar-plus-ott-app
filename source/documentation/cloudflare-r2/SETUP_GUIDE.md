# Cloudflare R2 Setup Guide

> **Last Updated**: 2025-12-02 13:26:39 IST

## Prerequisites

Your Cloudflare R2 Account Details:
- **Account ID**: `1286e312335b0937a7f25cc5fd3ba923`
- **S3 API Endpoint**: `https://1286e312335b0937a7f25cc5fd3ba923.r2.cloudflarestorage.com`

## Phase 1: R2 Bucket Structure Setup

### 1.1 Create Required Buckets

In your Cloudflare Dashboard, create the following buckets:

#### Primary Buckets
- **`news-media`** - For news articles images and videos
- **`profile-images`** - For user profile pictures
- **`temporary-uploads`** - For temporary file storage during processing

#### Step-by-Step Bucket Creation

1. **Navigate to Cloudflare Dashboard**
   - Go to [Cloudflare Dashboard](https://dash.cloudflare.com)
   - Select your account
   - Navigate to "R2 Object Storage"

2. **Create `news-media` Bucket**
   - Click "Create a bucket"
   - Bucket name: `news-media`
   - Click "Create bucket"
   - Note: Copy the bucket name exactly as shown

3. **Create `profile-images` Bucket**
   - Repeat the process with bucket name: `profile-images`

4. **Create `temporary-uploads` Bucket**
   - Repeat the process with bucket name: `temporary-uploads`

### 1.2 Generate API Credentials

1. **Go to R2 > Manage R2 API tokens**
   - In your Cloudflare Dashboard
   - Navigate to "R2 Object Storage"
   - Click "Manage R2 API tokens"

2. **Create API Token**
   - Click "Create API token"
   - Token name: `NNI-Project-Token`
   - Permissions:
     - Account: Read
     - Account R2 Storage: Read, Write
     - Buckets: Select specific buckets
     - Permissions: Read, Write, Delete

3. **Copy Credentials**
   - Copy the `Access Key ID`
   - Copy the `Secret Access Key`
   - **⚠️ IMPORTANT**: Save these securely - you won't see them again

### 1.3 Configure CORS Policies

For each bucket, configure CORS:

```json
{
  "CORSRules": [
    {
      "AllowedOrigins": [
        "*"
      ],
      "AllowedMethods": [
        "GET",
        "PUT",
        "POST",
        "HEAD",
        "DELETE"
      ],
      "AllowedHeaders": [
        "*"
      ],
      "MaxAgeSeconds": 3000
    }
  ]
}
```

#### Apply CORS to Each Bucket:

1. **Select bucket in Cloudflare Dashboard**
2. **Go to Settings > CORS**
3. **Paste the JSON configuration**
4. **Save changes**

### 1.4 Set Up Public Access

1. **For each bucket:**
   - Go to Settings > Public access
   - Enable "Allow public access"
   - This makes files readable without authentication

### 1.5 Test Connectivity

Once buckets are created, we'll test the setup using a script.

## Next Steps

After completing this phase, we'll move to:
- Phase 2: Database Schema & Backend Setup
- Phase 3: Admin/CMS Package Integration
- Phase 4: NNI Mobile App (Separate Repository)

**Note**: NNI mobile app has been moved to a separate repository at `/Users/pahadtv./Desktop/coding/nni-reporter-app` for independent development.

## Troubleshooting

### Common Issues
- **Bucket names must be lowercase and unique**
- **API tokens are only shown once - save them immediately**
- **CORS errors**: Ensure origins are properly configured
- **Permission denied**: Check bucket permissions and API token scope

### Need Help?
If you encounter issues:
1. Double-check bucket names and permissions
2. Verify API credentials are correct
3. Test with a simple curl command first
4. Check Cloudflare R2 documentation