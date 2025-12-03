# Samachar Plus - App

This is the main user-facing application for both mobile and web. It's the primary portal for consuming news content, including live TV streams, regional news, and breaking news updates.

## Tech Stack

- **Framework:** React 18 + TypeScript
- **Build Tool:** Vite
- **Styling:** Tailwind CSS
- **Routing:** React Router v6
- **Live Streaming:** HLS.js for video streaming
- **UI Components:** Custom components with Material-UI inspiration
- **Backend:** Supabase (PostgreSQL + Auth + Storage + Edge Functions)
- **Authentication:** Supabase Auth with Phone OTP (MSG91 integration)
- **Real-time:** Supabase Realtime for live updates

## Key Features

### News Consumption
- **Live TV Streaming**: HLS.js based video player for live news channels
- **Regional News**: Location-based news feeds with 7000+ Indian locations
- **National News**: Aggregated national news coverage
- **Breaking News**: Real-time breaking news alerts and updates

### User Experience
- **Mobile-First Design**: Optimized for mobile web experience
- **Offline Support**: IndexedDB for news caching and offline reading
- **Push Notifications**: Real-time notifications for breaking news
- **User Profiles**: Personalized news feeds and preferences

### Content Discovery
- **Category-Based Filtering**: Politics, Sports, Entertainment, etc.
- **Search Functionality**: Find specific news and topics
- **Location-Based Filtering**: News from specific states/districts
- **Trending Topics**: Popular and trending news stories

## Architecture

### Frontend Architecture
- **Component-Based**: Reusable React components
- **State Management**: React Context API for global state
- **Real-time Updates**: Supabase Realtime subscriptions
- **Performance Optimized**: Code splitting and lazy loading

### Backend Integration
- **Supabase Database**: PostgreSQL with 7000+ Indian locations
- **Authentication**: Phone-based OTP verification via MSG91
- **File Storage**: Cloudflare R2 for media files and thumbnails
- **Edge Functions**: Serverless functions for custom business logic

### Live Streaming
- **HLS Protocol**: HTTP Live Streaming for reliable video delivery
- **Adaptive Bitrate**: Automatic quality adjustment based on connection
- **Error Handling**: Robust stream failure recovery
- **Full-Screen Support**: Immersive video experience

## Getting Started

### Prerequisites
- Node.js 18+
- Supabase account and project
- MSG91 SMS service account

### Installation
```bash
cd packages/app
npm install
```

### Environment Setup
Create `.env` file with:
```env
VITE_SUPABASE_URL=https://your-project.supabase.co
VITE_SUPABASE_ANON_KEY=your-anon-key
VITE_MSG91_AUTH_KEY=your-msg91-auth-key
VITE_R2_PUBLIC_URL=https://your-r2-bucket.r2.cloudflarestorage.com
```

### Development
```bash
npm run dev
```
Access at: `http://localhost:3000`

### Build for Production
```bash
npm run build
npm run preview
```

## Project Structure

```
packages/app/
├── src/
│   ├── components/        # Reusable UI components
│   ├── screens/          # Main application screens
│   ├── hooks/            # Custom React hooks
│   ├── icons/            # SVG icon components
│   ├── utils/            # Utility functions and helpers
│   └── lib/              # External service clients
├── public/               # Static assets
└── package.json         # Dependencies and scripts
```

## Core Components

### Video & Media
- **LiveVideoPlayer**: HLS.js integration for live streaming
- **VideoPlayerModal**: Full-screen video experience
- **NewsCard**: Reusable news item display component
- **Carousel**: Image and content carousels

### Navigation & UI
- **BottomNavigationBar**: Main app navigation
- **Header**: App header with search and notifications
- **SwipeableWrapper**: Touch-friendly interactions
- **ErrorBoundary**: Graceful error handling

### Data Management
- **IndexedDB**: Offline news storage and caching
- **UserSession**: Persistent user preferences
- **Real-time Sync**: Live news updates and notifications

## Authentication System

### Phone Verification
- **MSG91 Integration**: SMS OTP verification for phone numbers
- **Supabase Auth**: Secure authentication and session management
- **Profile Creation**: User profile setup with location preferences

### User Management
- **Location Preferences**: State and district-based news filtering
- **Category Preferences**: Personalized news categories
- **Notification Settings**: Customizable notification preferences

## Content Features

### News Types
- **Live TV**: Streaming news channels
- **Breaking News**: Real-time urgent updates
- **Regional News**: Location-specific news coverage
- **National News**: Country-wide news aggregation
- **Category News**: Themed news collections

### User Interactions
- **Bookmarking**: Save articles for later reading
- **Sharing**: Share news on social media platforms
- **Comments**: User engagement on published content
- **Rating**: News quality and relevance feedback

## Performance Optimizations

### Frontend
- **Code Splitting**: Route-based lazy loading
- **Image Optimization**: Lazy loading and compression
- **Caching**: Service worker and IndexedDB caching
- **Bundle Optimization**: Tree shaking and minification

### Backend
- **Database Indexing**: Optimized PostgreSQL queries
- **CDN Distribution**: Cloudflare R2 global content delivery
- **Edge Computing**: Supabase Edge Functions for low latency
- **Real-time Efficiency**: Optimized subscription management

## Integration Points

### External Services
- **MSG91**: SMS verification and notifications
- **Cloudflare R2**: Media file storage and CDN
- **HLS Streams**: Live TV channel streaming
- **Social Platforms**: Content sharing integration

### Internal Services
- **CMS Integration**: Content management system connectivity
- **Admin Portal**: User management and analytics
- **Supabase Database**: Unified data layer across all applications

## Documentation

- [Complete Architecture Overview](../README.md#-applications)
- [App Context Guide](../documentation/context.md)
- [Local Setup Guide](../documentation/LOCAL_SETUP_GUIDE.md)
- [Flutter Migration Plan](./FLUTTER_MIGRATION_PLAN.md)

## Mobile App Development

This React web app serves as the foundation for mobile app development. See the [Flutter Migration Plan](./FLUTTER_MIGRATION_PLAN.md) for our mobile development strategy.

## Support

For issues and questions:
1. Check [Main Documentation](../documentation/INDEX.md)
2. Review browser console for errors
3. Verify Supabase connection and authentication
4. Check MSG91 SMS service status

---

**Backend Migration**: This package was migrated from Firebase to Supabase in 2025.  
**Last Updated**: November 27, 2025  
**Version**: 2.0.0 (Supabase Migration Complete)
