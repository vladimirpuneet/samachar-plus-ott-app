// =====================================================
// NEWJ/Samachar Plus - Common Types
// =====================================================
// Shared TypeScript types for all packages
// =====================================================

// =====================================================
// ENUMS
// =====================================================

export enum ContentType {
  REPORT = 'report',
  NEWS = 'news',
  ARTICLE = 'article',
  POST = 'post',
  BULLETIN = 'bulletin'
}

export enum ContentStatus {
  DRAFT = 'draft',
  PENDING_REVIEW = 'pending_review',
  PUBLISHED = 'published',
  REJECTED = 'rejected',
  ARCHIVED = 'archived'
}

export enum MediaType {
  IMAGE = 'image',
  VIDEO = 'video',
  THUMBNAIL = 'thumbnail',
  ATTACHMENT = 'attachment'
}

export enum UserRole {
  ADMIN = 'admin',
  EDITOR = 'editor',
  PUBLISHER = 'publisher',
  CITIZEN = 'citizen',                      // Reporter tier 1 (default)
  REPORTER = 'reporter',                    // Reporter tier 2
  JUNIOR_CORRESPONDENT = 'junior_correspondent', // Reporter tier 3
  SENIOR_CORRESPONDENT = 'senior_correspondent', // Reporter tier 4
  USER = 'user'                             // Public users
}

export enum ReporterTier {
  CITIZEN = 'citizen',                      // Entry-level (default for new signups)
  REPORTER = 'reporter',                    // Standard field reporter
  JUNIOR_CORRESPONDENT = 'junior_correspondent', // Mid-level with expanded coverage
  SENIOR_CORRESPONDENT = 'senior_correspondent'  // Senior-level with full coverage
}

export enum UserType {
  PUBLIC = 'public',
  PRIVATE = 'private'
}

export enum NotificationType {
  NEW_REPORTER_SIGNUP = 'new_reporter_signup',
  REPORTER_APPROVAL_NEEDED = 'reporter_approval_needed',
  REPORTER_TIER_CHANGED = 'reporter_tier_changed',
  NEW_REPORT_SUBMITTED = 'new_report_submitted',
  REPORT_APPROVED = 'report_approved',
  REPORT_REJECTED = 'report_rejected',
  CONTENT_PUBLISHED = 'content_published',
  BREAKING_NEWS = 'breaking_news',
  SYSTEM_ANNOUNCEMENT = 'system_announcement'
}

export enum NotificationStatus {
  PENDING = 'pending',
  SENT = 'sent',
  READ = 'read'
}

export enum AnalyticsEventType {
  PAGE_VIEW = 'page_view',
  CONTENT_VIEW = 'content_view',
  SHARE = 'share',
  LIKE = 'like',
  COMMENT = 'comment',
  REPORT_SUBMISSION = 'report_submission',
  CONTENT_PUBLISH = 'content_publish',
  REPORTER_SIGNUP = 'reporter_signup',
  REPORTER_TIER_CHANGE = 'reporter_tier_change'
}

// =====================================================
// PROFILE TYPES
// =====================================================

export interface Profile {
  id: string;
  name: string;
  phone?: string;
  email?: string;
  
  // Personal Details (Reporters)
  blood_group?: string;
  emergency_contact_name?: string;
  emergency_contact_phone?: string;
  aadhar_number?: string;
  profile_photo?: string;
  aadhar_photo?: string;
  
  // Location Assignment (Reporters)
  assigned_state?: string;
  assigned_district?: string;
  assigned_subdistrict?: string;
  
  // System Fields
  role: UserRole;
  reporter_tier?: ReporterTier; // Only for reporter roles
  user_type: UserType;
  onboarding_complete: boolean;
  authority_signed: boolean;
  is_approved: boolean;
  
  // Preferences
  preferences: {
    categories: string[];
    notifications: boolean;
    location_preferences: {
      state: string;
      district: string;
    };
  };
  
  // Timestamps
  created_at: string;
  updated_at: string;
}

// =====================================================
// CONTENT TYPES
// =====================================================

export interface Content {
  id: string;
  type: ContentType;
  title: string;
  description: string;
  status: ContentStatus;
  
  // Author Information
  source?: string;
  saved_by?: string;
  
  // Content Classification
  tags: string[];
  categories: string[];
  
  // Location Fields
  location_state?: string;
  location_district?: string;
  location_subdistrict?: string;
  happening_at?: string;
  
  // Publishing Fields
  is_breaking: boolean;
  breaking_set_at?: string;
  scheduled_at?: string;
  publish_targets: Record<string, boolean>;
  publish_status: Record<string, string>;
  
  // Thumbnail
  thumbnail?: string;
  
  // Media Flag
  has_media: boolean;
  
  // User Relationships
  created_by?: string;
  approved_by?: string;
  
  // Bulletin Relations
  parent_bulletin_id?: string;
  
  // Timestamps
  created_at: string;
  updated_at: string;
}

// =====================================================
// MEDIA TYPES
// =====================================================

export interface MediaAsset {
  id: string;
  content_id: string;
  type: MediaType;
  
  // File Information
  url: string;
  thumbnail_url?: string;
  file_name?: string;
  file_size?: number;
  mime_type?: string;
  duration?: number;
  
  // Processing Status
  processing_status: 'pending' | 'processing' | 'completed' | 'failed';
  
  // Metadata
  metadata: Record<string, any>;
  alt_text?: string;
  
  // Timestamps
  created_at: string;
  updated_at: string;
}

// =====================================================
// LOCATION TYPES
// =====================================================

export interface Location {
  id: string;
  state: string;
  circuit?: string;
  district: string;
  subdistrict?: string;
  
  // Coverage Management
  is_active: boolean;
  assigned_reporters: Array<{
    id: string;
    tier: ReporterTier;
  }>;
  
  // Timestamps
  created_at: string;
  updated_at: string;
}

// =====================================================
// NOTIFICATION TYPES
// =====================================================

export interface Notification {
  id: string;
  user_id?: string;
  type: NotificationType;
  title: string;
  message: string;
  
  // Targeting
  is_public: boolean;
  target_role?: UserRole;
  
  // Status
  is_read: boolean;
  status: NotificationStatus;
  
  // Data
  data: Record<string, any>;
  
  // Scheduling
  scheduled_at?: string;
  sent_at?: string;
  
  // Timestamps
  created_at: string;
  updated_at: string;
  
  // Legacy fields for backward compatibility
  image?: string;
  timestamp?: any;
  articleId?: string;
  userId?: string;
}

// =====================================================
// ANALYTICS TYPES
// =====================================================

export interface AnalyticsEvent {
  id: string;
  user_id?: string;
  event_type: AnalyticsEventType;
  content_id?: string;
  
  // Event Data
  metadata: Record<string, any>;
  
  // Timestamps
  created_at: string;
}

// =====================================================
// HELPER TYPES
// =====================================================

// Platform access helper
export const PLATFORM_ROLES = {
  NNI: [UserRole.CITIZEN, UserRole.REPORTER, UserRole.JUNIOR_CORRESPONDENT, UserRole.SENIOR_CORRESPONDENT],
  CMS: [UserRole.EDITOR, UserRole.PUBLISHER],
  ADMIN: [UserRole.ADMIN],
  FLUTTER: [UserRole.USER]
} as const;

// Reporter tier progression
export const REPORTER_TIER_PROGRESSION = [
  ReporterTier.CITIZEN,
  ReporterTier.REPORTER,
  ReporterTier.JUNIOR_CORRESPONDENT,
  ReporterTier.SENIOR_CORRESPONDENT
] as const;

// Check if role is reporter
export function isReporterRole(role: UserRole): boolean {
  return (PLATFORM_ROLES.NNI as readonly UserRole[]).includes(role);
}

// Check if role is internal user
export function isInternalRole(role: UserRole): boolean {
  return ([...PLATFORM_ROLES.CMS, ...PLATFORM_ROLES.ADMIN] as UserRole[]).includes(role);
}

// Check if role is admin
export function isAdminRole(role: UserRole): boolean {
  return role === UserRole.ADMIN;
}

// Get next reporter tier
export function getNextReporterTier(currentTier: ReporterTier): ReporterTier | null {
  const currentIndex = REPORTER_TIER_PROGRESSION.indexOf(currentTier);
  if (currentIndex === -1 || currentIndex === REPORTER_TIER_PROGRESSION.length - 1) {
    return null;
  }
  return REPORTER_TIER_PROGRESSION[currentIndex + 1];
}

// Get previous reporter tier
export function getPreviousReporterTier(currentTier: ReporterTier): ReporterTier | null {
  const currentIndex = REPORTER_TIER_PROGRESSION.indexOf(currentTier);
  if (currentIndex <= 0) {
    return null;
  }
  return REPORTER_TIER_PROGRESSION[currentIndex - 1];
}

// =====================================================
// API RESPONSE TYPES
// =====================================================

export interface ApiResponse<T> {
  success: boolean;
  data?: T;
  error?: string;
  message?: string;
}

export interface PaginatedResponse<T> {
  data: T[];
  total: number;
  page: number;
  limit: number;
  hasMore: boolean;
}
