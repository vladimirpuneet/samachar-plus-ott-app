# WhatsApp OTP Web Testing Guide

## Overview
This guide provides comprehensive instructions for testing the WhatsApp OTP authentication functionality on the Samachar Plus OTT App web server. Since the macOS build has Xcode issues, we're using the web implementation for testing.

## Current Status
- ✅ Flutter web server is running at `http://localhost:8080`
- ✅ Supabase authentication service is configured
- ✅ WhatsApp Business API is set up
- ✅ All authentication screens are implemented

## WhatsApp OTP Authentication Flow

### 1. System Architecture
```
Phone Input → OTP Request → WhatsApp API → OTP Verification → Supabase Auth
```

### 2. Key Components
- **WhatsAppOtpService**: Handles WhatsApp Business API integration
- **SupabaseAuthService**: Manages user authentication and storage
- **AuthProvider**: State management for authentication
- **PhoneInputScreen**: Collects 10-digit Indian mobile numbers
- **OtpVerificationScreen**: Handles 6-digit OTP verification

## Testing Instructions

### Step 1: Access the Web Application
1. Open your web browser
2. Navigate to: `http://localhost:8080`
3. You should see the Samachar Plus OTT app interface

### Step 2: Navigate to Authentication
1. Look for a profile or sign-in button in the app
2. Or directly navigate to: `http://localhost:8080/phone`
3. You should see the phone input screen

### Step 3: Test Phone Input Screen

#### Valid Test Cases:
- **Test Number**: `9876543210` (10-digit Indian mobile)
- **Expected Behavior**: 
  - Form validation passes
  - App checks if user exists in Supabase
  - Sends OTP via WhatsApp Business API
  - Navigates to OTP verification screen

#### Invalid Test Cases:
- **Test Number**: `123456789` (9 digits) - Should show validation error
- **Test Number**: `12345678901` (11 digits) - Should show validation error
- **Test Number**: `123456789a` (non-numeric) - Should show validation error

### Step 4: Test OTP Verification Screen

#### New User Flow:
1. Enter a new phone number (not previously registered)
2. You'll be prompted for your full name
3. Enter the 6-digit OTP received via WhatsApp
4. Complete the name field
5. Click "Create Account"
6. Should successfully authenticate and navigate to home

#### Existing User Flow:
1. Enter a phone number that's already registered
2. Enter the 6-digit OTP received via WhatsApp
3. Click "Sign In"
4. Should successfully authenticate and navigate to home

### Step 5: Test OTP Resend Functionality
1. On OTP verification screen
2. Click "Resend OTP" button
3. Should show 30-second countdown
4. After countdown, should be able to resend OTP
5. New OTP should arrive via WhatsApp

## What to Expect During Testing

### WhatsApp OTP Message Format
You should receive a WhatsApp message like:
```
Your OTP for Samachar Plus is: 123456. Valid for 5 minutes.
```

### Success Indicators
- ✅ Phone number validation works correctly
- ✅ OTP is sent via WhatsApp within seconds
- ✅ 6-digit OTP input accepts only numbers
- ✅ Auto-focus moves to next field
- ✅ OTP verification succeeds
- ✅ User authentication state updates
- ✅ Navigation to home screen works
- ✅ Resend OTP functionality works

### Error Scenarios to Test
1. **Invalid OTP**: Enter wrong 6-digit code
2. **Expired OTP**: Wait 5+ minutes before entering
3. **Network Issues**: Disconnect internet during process
4. **Invalid Phone**: Test with international numbers

## Browser Console Testing

### Open Developer Tools
1. Right-click on the app → "Inspect" or press F12
2. Go to "Console" tab
3. Monitor for any error messages

### Expected Console Logs
- WhatsApp API call success/failure
- Supabase authentication events
- Navigation routing logs
- Any JavaScript errors

## Test Data for Manual Testing

### Indian Mobile Numbers for Testing
```
9876543210
9988776655
8765432109
9001234567
7890123456
```

### OTP Testing
- The system generates random 6-digit OTPs
- Each OTP expires after 5 minutes
- Only one OTP can be active per phone number at a time

## Troubleshooting

### Common Issues and Solutions

#### 1. "Failed to send OTP"
- Check if WhatsApp Business API credentials are valid
- Verify phone number format (10 digits, no country code needed)
- Ensure WhatsApp is linked to the phone number

#### 2. "Invalid or expired OTP"
- Check if OTP has expired (5-minute window)
- Ensure you're entering the exact 6-digit code
- Try requesting a new OTP

#### 3. App Not Loading
- Verify web server is running: `http://localhost:8080`
- Check Flutter console for compilation errors
- Try hard refresh (Ctrl+F5)

#### 4. Supabase Connection Issues
- Check internet connection
- Verify Supabase URL and API key in `lib/env.dart`
- Check browser network tab for API call failures

## Automated Testing Commands

### Check Web Server Status
```bash
curl -I http://localhost:8080
```

### View Flutter Logs
```bash
# In the terminal running flutter run
# Press 'r' for hot reload
# Press 'R' for hot restart
# Press 'q' to quit
```

### Test API Endpoints
```bash
# Test if app responds
curl http://localhost:8080

# Check specific routes
curl http://localhost:8080/phone
curl http://localhost:8080/otp
```

## Security Considerations

### WhatsApp API Security
- Access tokens are stored in `whatsapp_otp_service.dart`
- In production, move to environment variables
- Consider rate limiting for OTP requests

### OTP Security
- 6-digit numeric codes
- 5-minute expiration
- Single-use verification
- Server-side validation

### User Data Protection
- Phone numbers stored in Supabase
- User profiles in `public_users` table
- Authentication tokens managed by Supabase

## Performance Testing

### Load Testing
1. Test with multiple phone numbers simultaneously
2. Monitor WhatsApp API rate limits
3. Check Supabase connection pooling
4. Measure OTP delivery times

### Browser Compatibility
- Test in Chrome, Firefox, Safari, Edge
- Check mobile responsive design
- Verify PWA functionality (if implemented)

## Next Steps

After successful testing:
1. Document any issues found
2. Test edge cases and error scenarios
3. Performance optimization if needed
4. Consider adding email authentication as backup
5. Implement user profile management features

## Support Information

### Key Files to Reference
- `lib/services/whatsapp_otp_service.dart` - WhatsApp integration
- `lib/services/supabase_auth_service.dart` - Authentication logic
- `lib/providers/auth_provider.dart` - State management
- `lib/screens/phone_input_screen.dart` - Phone input UI
- `lib/screens/otp_verification_screen.dart` - OTP verification UI

### Configuration Files
- `lib/env.dart` - Supabase configuration
- `pubspec.yaml` - Dependencies

For any issues during testing, check the browser console and Flutter terminal output for detailed error messages.