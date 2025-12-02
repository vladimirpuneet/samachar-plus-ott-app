# Replication Audit: Samachar Plus OTT

**Date:** December 2, 2025
**Overall Completion:** ~45%

This document outlines the current status of porting the React application to Flutter, highlighting completed features, missing components, and the roadmap for full 1:1 replication.

## 📊 Status Overview

| Feature Area | Status | Completion | Notes |
| :--- | :--- | :--- | :--- |
| **Live TV (National)** | ✅ Done | 100% | Full channel list, logos, playback. |
| **Live TV (Regional)** | ✅ Done | 100% | State-wise grouping, toggle animation. |
| **Video Player** | ✅ Done | 100% | Custom UI, controls, overlay, fullscreen. |
| **Navigation** | ✅ Done | 90% | Bottom nav, slide transitions. |
| **News Feed** | ⚠️ Pending | 10% | Currently a placeholder list. |
| **Profile & Auth** | ⚠️ Pending | 10% | Placeholder UI, no Supabase auth flow. |
| **Notifications** | ❌ Missing | 0% | Not implemented. |
| **Article Details** | ❌ Missing | 0% | Not implemented. |

---

## 🟢 Completed Features (What's Done)

### 1. Live TV & Streaming
- **National/Regional Toggle**: Implemented with custom vertical slide animation.
- **Channel Listing**:
    - Grid layout responsive to screen size.
    - **Zoom-to-Fill Logos**: Channel cards display logos edge-to-edge without text overlays.
    - **Regional Grouping**: Channels grouped by state headers.
- **Video Player**:
    - **1:1 UI Replication**: Custom bottom control bar, floating close button.
    - **Features**: Play/Pause, Mute/Unmute, Fullscreen toggle.
    - **Overlay**: "Report Not Working" button, Channel Name/Subcategory display.
    - **Tech**: Uses `chewie` and `video_player` with custom controls.

### 2. Core UI & Navigation
- **Header**: Custom AppBar with GIF logo.
- **Bottom Navigation**: Custom implementation matching React design.
- **Transitions**: Smooth fade and scale transitions for player; slide transitions for tabs.
- **Theme**: Light/Dark mode support (currently forced Light to match React default).

---

## 🔴 Missing Features (What's Left)

### 1. News Feed (`NewsTab`)
- **Current State**: Displays a dummy list of "Sample News Article".
- **React Logic**: Fetches videos/articles from API/Supabase, displays in a grid (`VideoCard`).
- **To Do**:
    - Create `NewsCard` widget (thumbnail, title, timestamp).
    - Integrate API/Supabase to fetch actual news content.
    - Implement `NewsScreen` layout (Carousels, "Latest from..." sections).

### 2. Authentication & Profile (`ProfileTab`)
- **Current State**: Shows "Guest User" with a dummy "Sign In" button.
- **React Logic**: Supabase Auth (Email/OTP), User Profile management.
- **To Do**:
    - Implement `AuthScreen` (Login/Signup UI).
    - Integrate `supabase_flutter` for actual authentication.
    - Create `ProfileScreen` with user details and preferences.

### 3. Article/Video Details
- **Current State**: Clicking a news item does nothing (shows SnackBar).
- **React Logic**: Opens `ArticleScreen` or plays video.
- **To Do**:
    - Create `ArticleScreen` for reading text news.
    - Create `VideoDetailsScreen` for VOD content.

---

## 🚀 Roadmap: How to Complete

### Phase 1: News Feed Implementation (Next Priority)
1.  **Create `NewsCard` Widget**: Replicate the UI of the news card from React.
2.  **Mock Data / API Integration**: Replace dummy list with actual data structure.
3.  **Build `NewsScreen`**: Implement the grid layout and section headers.

### Phase 2: Authentication & Profile
1.  **Setup Supabase**: Ensure `supabase_flutter` is initialized with correct keys.
2.  **Build `AuthScreen`**: Create the login UI.
3.  **Connect Profile**: Link `ProfileTab` to real user data.

### Phase 3: Polish & Notifications
1.  **Notifications**: Implement local/push notifications.
2.  **Final Polish**: Verify all animations and responsive behavior.

---

## 🛠 Technical Debt / Notes
- **Web Renderer**: Currently using HTML renderer (default). For best performance, `canvaskit` is recommended for production builds.
- **CORS**: Local assets are used for channel logos to avoid CORS issues. Ensure all new images are handled similarly or served with correct headers.
