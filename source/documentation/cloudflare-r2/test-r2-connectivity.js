#!/usr/bin/env node

/**
 * Cloudflare R2 Connectivity Test Script
 * 
 * This script tests the connection to your R2 buckets
 * Run this after completing Phase 1 setup
 * 
 * Usage:
 * node test-r2-connectivity.js
 */

import { S3Client, ListBucketsCommand, HeadBucketCommand } from '@aws-sdk/client-s3';

// Configuration
const config = {
  accountId: '1286e312335b0937a7f25cc5fd3ba923',
  region: 'auto',
  endpoint: 'https://1286e312335b0937a7f25cc5fd3ba923.r2.cloudflarestorage.com',
  buckets: ['news-media', 'profile-images', 'temporary-uploads']
};

// Note: This is a template - you'll need to update with your actual credentials
const credentials = {
  accessKeyId: process.env.R2_ACCESS_KEY_ID || 'YOUR_ACCESS_KEY_ID',
  secretAccessKey: process.env.R2_SECRET_ACCESS_KEY || 'YOUR_SECRET_ACCESS_KEY'
};

const s3Client = new S3Client({
  region: config.region,
  endpoint: config.endpoint,
  credentials: credentials,
  forcePathStyle: true
});

async function testR2Connection() {
  console.log('🚀 Testing Cloudflare R2 Connection...');
  console.log('Account ID:', config.accountId);
  console.log('Endpoint:', config.endpoint);
  console.log('');

  try {
    // Test 1: List buckets
    console.log('📋 Test 1: Listing buckets...');
    const listResponse = await s3Client.send(new ListBucketsCommand({}));
    console.log('✅ Available buckets:', listResponse.Buckets?.map(b => b.Name));
    
    // Test 2: Check required buckets
    console.log('');
    console.log('🔍 Test 2: Checking required buckets...');
    for (const bucketName of config.buckets) {
      try {
        await s3Client.send(new HeadBucketCommand({ Bucket: bucketName }));
        console.log(`✅ ${bucketName}: EXISTS`);
      } catch (error) {
        console.log(`❌ ${bucketName}: MISSING or NO ACCESS`);
      }
    }

    console.log('');
    console.log('🎯 Connection Test Complete!');
    console.log('');
    console.log('Next Steps:');
    console.log('1. If all buckets show ✅, proceed to Phase 2');
    console.log('2. If any bucket shows ❌, create missing buckets in Cloudflare Dashboard');
    console.log('3. Update environment variables with actual API credentials');

  } catch (error) {
    console.error('❌ Connection Failed:', error.message);
    console.log('');
    console.log('Troubleshooting:');
    console.log('1. Verify API credentials are correct');
    console.log('2. Check account ID and endpoint URL');
    console.log('3. Ensure R2 is enabled in your Cloudflare account');
    console.log('4. Verify API token has proper permissions');
  }
}

// Test with example credentials (will fail until updated)
console.log('⚠️  IMPORTANT: Update this script with your actual R2 credentials');
console.log('   Set environment variables: R2_ACCESS_KEY_ID and R2_SECRET_ACCESS_KEY');
console.log('');

// Run the test
testR2Connection();