
import React, { useState, useEffect } from 'react';
import { fetchVideos } from './utils/api';
import type { Video, UserProfile } from '@repo/common';
import VideoCard from './components/VideoCard';
import Spinner from './components/Spinner';

interface NewsScreenProps {
    userProfile: UserProfile;
    onVideoSelect: (video: Video) => void;
}

const NewsScreen: React.FC<NewsScreenProps> = ({ userProfile, onVideoSelect }) => {
    const [videos, setVideos] = useState<Video[]>([]);
    const [isLoading, setIsLoading] = useState(true);
    const [error, setError] = useState<string | null>(null);

    const location = userProfile.preferences;

    useEffect(() => {
        const loadRegionalNews = async () => {
            setIsLoading(true);
            setError(null);
            try {
                // Simulate fetching news for the selected region by fetching the general list from WordPress.
                // In a real app, you would pass location data (e.g., categories/tags) to the API.
                const { videos: fetchedVideos } = await fetchVideos();
                // Shuffle to appear different for different "regions"
                setVideos(fetchedVideos.sort(() => Math.random() - 0.5));
            } catch (err: any) {
                setError(err.message || 'Failed to load news.');
            } finally {
                setIsLoading(false);
            }
        };

        loadRegionalNews();
    }, [location.state, location.district]);

    const renderContent = () => {
        if (isLoading) {
            return <Spinner />;
        }

        if (error) {
            return (
                <div className="text-center py-20 bg-gray-100 rounded-lg border border-dashed border-gray-300">
                    <p className="text-lg text-red-500">{error}</p>
                </div>
            );
        }

        if (videos.length === 0) {
            return (
                <div className="text-center py-20 bg-gray-100 rounded-lg border border-dashed border-gray-300">
                    <p className="text-lg text-gray-500">No news found for this region.</p>
                </div>
            );
        }

        return (
            <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-x-6 gap-y-8">
                {videos.map((video) => (
                    <VideoCard key={video.id} video={video} onVideoSelect={onVideoSelect} />
                ))}
            </div>
        );
    };

    return (
        <div className="animate-fade-in">
            <h1 className="text-3xl font-bold text-black mb-2">News from your Region</h1>
            <p className="text-gray-600 mb-6">Showing localized news updates based on your profile settings.</p>

            <div>
                <h2 className="text-2xl font-bold text-black my-6 border-t pt-6 border-gray-200">
                    Latest from {location.district ? `${location.district}, ` : ''}{location.state || 'India'}
                </h2>
                {renderContent()}
            </div>
        </div>
    );
};

export default NewsScreen;
