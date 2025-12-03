// A channel that is broadcast nationally, categorized by language or topic.
type NationalLiveChannel = {
  id: string;
  name: string;
  logoUrl: string;
  streamUrl: string;
  category: 'NATIONAL';
  subCategory: 'HINDI' | 'ENGLISH' | 'BUSINESS';
};

// A channel that is broadcast regionally, categorized by the state(s) it serves.
type RegionalLiveChannel = {
  id: string;
  name: string;
  logoUrl: string;
  streamUrl: string;
  category: 'REGIONAL';
  subCategory: string[]; // List of states
};

// The generic LiveChannel can be either National or Regional.
export type LiveChannel = NationalLiveChannel | RegionalLiveChannel;

export type Video = {
  id: string;
  title: string;
  thumbnail: string;
  videoUrl: string;
};

export type UserProfile = {
  id: string;
  phone: string;
  name?: string;
  state?: string;
  district?: string;
  preferences: {
    receive_all_news: boolean;
    receive_breaking: boolean;
    receive_state_news: boolean;
    receive_district_news: boolean;
    language: string;
  };
  is_blocked: boolean;
  created_at: string;
  updated_at?: string;
};

export type UserPreferences = {
  categories: string[];
  state: string;
  district: string;
};

export type Notification = {
    id: string;
    title: string;
    body: string;
    timestamp: any;
    isRead: boolean;
    articleId?: string;
};
