# Local Testing Guide for Samachar Plus OTT App

## Prerequisites

Before testing, ensure you have:

1. **Flutter SDK** (v3.0 or higher) installed and configured
2. **Android Studio** or **VS Code** with Flutter extensions
3. **Physical device** or **emulator** for testing

## Setup Instructions

### 1. Navigate to Project Directory
```bash
cd /path/to/your/samachar-plus-ott-app
```

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Generate Environment Files
```bash
dart run build_runner build
```

### 4. Configure Environment Variables
Update your `.env` file with actual credentials:

```bash
# .env
SUPABASE_URL=https://yrmfnwouyzxteswiocmg.supabase.co
SUPABASE_ANON_KEY=your_actual_anon_key_here
R2_ENDPOINT=your_actual_r2_endpoint_here
R2_BUCKET_NAME=your_actual_bucket_name_here
ENVIRONMENT=development
```

### 5. Build and Run
```bash
# For Android
flutter run

# For iOS (on macOS)
flutter run -d ios
```

## Testing Checklist

### ✅ Authentication Testing
- [ ] **App launches** without crashes
- [ ] **Splash screen** displays correctly
- [ ] **Sign up** with new credentials works
- [ ] **Sign in** with existing credentials works
- [ ] **Sign out** functionality works
- [ ] **Auth state persistence** across app restarts

### ✅ News Content Testing
- [ ] **Home feed** loads articles from Supabase
- [ ] **Categories** filter articles correctly
- [ ] **Search** functionality works
- [ ] **Breaking news** displays properly
- [ ] **Real-time updates** work (if data changes in Supabase)

### ✅ Live Channels Testing
- [ ] **Live TV** loads channels from coverage table
- [ ] **Channel logos** display correctly
- [ ] **Stream URLs** work for video playback

### ✅ Media URL Testing
- [ ] **Article images** load from Cloudflare R2
- [ ] **Video content** plays correctly
- [ ] **Thumbnails** display properly
- [ ] **Channel logos** load correctly
- [ ] **Placeholder images** show when media unavailable

### ✅ UI/UX Testing
- [ ] **No visual changes** from original app
- [ ] **Navigation flows** work as expected
- [ ] **Loading states** display properly
- [ ] **Error handling** works gracefully
- [ ] **Responsive design** on different screen sizes

## Debug Mode Testing

### Check Auth Provider Status
```dart
// Add this to any widget for debugging
AuthProvider authProvider = Provider.of<AuthProvider>(context);
print('Authenticated: ${authProvider.isAuthenticated}');
print('Using Supabase: ${authProvider.isUsingSupabase}');
print('User: ${authProvider.user?.email}');
```

### Check News Provider Status
```dart
// Add this to any widget for debugging
NewsProvider newsProvider = Provider.of<NewsProvider>(context);
print('Using Supabase: ${newsProvider.isUsingSupabase}');
print('Articles count: ${newsProvider.articles.length}');
print('Live channels: ${newsProvider.liveChannels.length}');
```

### Check Media Service Configuration
```dart
// Add this for media debugging
MediaService mediaService = MediaService.instance;
print('Media configured: ${mediaService.isConfigured}');
```

## Expected Behavior

### With Supabase Configured
- **Primary**: Uses Supabase for all operations
- **Fallback**: Falls back to Firebase if Supabase unavailable
- **Real-time**: Subscribes to live updates from Supabase
- **Media**: Loads from Cloudflare R2 URLs

### Without Supabase Configuration
- **Primary**: Uses Firebase for all operations
- **Media**: Uses Firebase Storage URLs
- **Warning**: Some features may not work without Supabase

## Troubleshooting

### Common Issues

1. **Build Errors**
   ```bash
   flutter clean
   flutter pub get
   dart run build_runner build --delete-conflicting-outputs
   ```

2. **Supabase Connection Issues**
   - Verify `.env` file exists and has correct values
   - Check Supabase project is accessible
   - Verify anon key is correct

3. **Media Loading Issues**
   - Verify R2 endpoint and bucket name
   - Check media assets exist in Supabase
   - Verify Cloudflare R2 bucket permissions

4. **Authentication Issues**
   - Test with valid Supabase credentials
   - Check user exists in Supabase auth
   - Verify Firebase auth still works as fallback

### Error Handling
The app should gracefully handle:
- Network connectivity issues
- Invalid credentials
- Missing media assets
- Database connection failures

## Success Criteria

✅ **App compiles and runs** without errors
✅ **All UI screens display** correctly
✅ **Authentication works** with both Supabase and Firebase
✅ **News content loads** from appropriate source
✅ **Media displays correctly** from Cloudflare R2
✅ **Real-time updates work** when available
✅ **No breaking changes** to existing functionality

## Performance Testing

Monitor these metrics:
- **App startup time**: Should be similar to original
- **News loading time**: Should be fast with proper caching
- **Media loading**: Should be fast with Cloudflare CDN
- **Memory usage**: Should not increase significantly

## Next Steps After Testing

1. **Verify all functionality works** as expected
2. **Test with real data** in Supabase
3. **Monitor performance** and user experience
4. **Gradually migrate users** to Supabase backend
5. **Plan complete Firebase removal** in next iteration

---

**Ready to test?** Follow the setup instructions and run through the testing checklist. The app should work exactly like the original but now with Supabase + Cloudflare R2 backend!