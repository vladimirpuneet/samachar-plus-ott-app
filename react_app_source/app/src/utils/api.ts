import supabase from '../lib/supabaseClient';
import type { UserProfile, LiveChannel, Video } from '../types';
// import { Notification } from '@repo/common/src/types';

// --- Live Channels ---
export const fetchLiveChannels = async (): Promise<LiveChannel[]> => {
    try {
        const { data, error } = await supabase
            .from('live_channels')
            .select('*')
            .order('name');
        
        if (error) {
            console.warn('live_channels table not found, returning empty array:', error);
            return [];
        }
        return data || [];
    } catch (error) {
        console.warn('Error fetching live channels:', error);
        return [];
    }
};

// --- Report Broken Link ---
export const reportBrokenLink = async (channel: LiveChannel): Promise<void> => {
    try {
        const { error } = await supabase
            .from('reported_links')
            .insert({
                channel_id: channel.id,
                channel_name: channel.name,
                reported_at: new Date().toISOString(),
            });
        
        if (error) {
            console.warn('reported_links table not found, cannot report broken link:', error);
        }
    } catch (error) {
        console.warn('Error reporting broken link:', error);
    }
};

// --- Profile Management ---

// 1. Get User Profile from the 'public_users' table
export const getUserProfile = async (uid: string): Promise<UserProfile | null> => {
    const { data, error } = await supabase
        .from('public_users')
        .select('*')
        .eq('id', uid)
        .single();
    
    if (error && error.code !== 'PGRST116') throw error; // PGRST116 = no rows returned
    return data;
};

// 2. Create or Update User Profile (Upsert) in the 'public_users' table
export const updateUserProfile = async (uid: string, data: Partial<UserProfile>): Promise<void> => {
    const dataWithTimestamps = {
        ...data,
        updated_at: new Date().toISOString(),
    };

    const { error } = await supabase
        .from('public_users')
        .upsert({ id: uid, ...dataWithTimestamps });
    
    if (error) throw error;
};

// 3. Subscribe to user profile changes in the 'public_users' table
export const onUserProfileChange = (uid: string, callback: (profile: UserProfile | null) => void): (() => void) => {
    const subscription = supabase
        .channel('public_users_changes')
        .on('postgres_changes',
            { event: '*', schema: 'public', table: 'public_users', filter: `id=eq.${uid}` },
            (payload) => {
                callback(payload.new as UserProfile);
            }
        )
        .subscribe();

    return () => {
        supabase.removeChannel(subscription);
    };
};

// --- Video News ---
export const fetchVideos = async (): Promise<Video[]> => {
    try {
        const { data, error } = await supabase
            .from('videos')
            .select('*')
            .order('uploaded_at', { ascending: false })
            .limit(50);
        
        if (error) {
            console.warn('videos table not found, returning empty array:', error);
            return [];
        }
        return data || [];
    } catch (error) {
        console.warn('Error fetching videos:', error);
        return [];
    }
};

export const fetchVideoById = async (id: string): Promise<Video | null> => {
    try {
        const { data, error } = await supabase
            .from('videos')
            .select('*')
            .eq('id', id)
            .single();
        
        if (error) {
            if (error.code === 'PGRST116') {
                console.warn('Video not found:', id);
                return null;
            }
            console.warn('Error fetching video:', error);
            return null;
        }
        return data;
    } catch (error) {
        console.warn('Error fetching video by ID:', error);
        return null;
    }
};

// --- User Notifications (Placeholder) ---

// export const fetchNotifications = (userId: string, callback: (notifications: Notification[]) => void): (() => void) => {
//     // Placeholder function - notifications functionality removed
//     return () => {};
// };

// export const markNotificationsAsRead = async (userId: string, notificationIds: string[]): Promise<void> => {
//     // Placeholder function - notifications functionality removed
// };

// export const markAllNotificationsAsRead = async (userId: string): Promise<void> => {
//     // Placeholder function - notifications functionality removed
// };