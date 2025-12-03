// WARNING: DO NOT MODIFY THIS FILE
// This file contains the core live stream UI and is considered final.
// Any changes to this file may break the live stream functionality.

import React, { useState, useEffect } from 'react';
import { LIVE_CHANNELS } from '../constants';
import type { LiveChannel, Video } from '../types';
import LiveVideoPlayer from '../components/LiveVideoPlayer';
import Spinner from '../components/Spinner';

interface LiveNewsScreenProps {
  onVideoSelect?: (video: Video) => void;
}

const LiveChannelCard: React.FC<{ channel: LiveChannel; onSelect: () => void; }> = ({ channel, onSelect }) => {
  return (
    <div
      onClick={onSelect}
      className="group cursor-pointer aspect-square rounded-lg bg-white shadow-md hover:shadow-lg transition-shadow duration-300 overflow-hidden"
    >
      <img 
        src={channel.logoUrl} 
        alt={`${channel.name} Logo`} 
        className="w-full h-full object-cover transition-transform duration-300 group-hover:scale-110"
      />
    </div>
  );
};


const LiveNewsScreen: React.FC<LiveNewsScreenProps> = ({ onVideoSelect }) => {
  const [selectedChannel, setSelectedChannel] = useState<LiveChannel | null>(null);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [categorizedChannels, setCategorizedChannels] = useState<Record<string, LiveChannel[]>>({});

  const loadChannels = () => {
    setIsLoading(true);
    setError(null);
    try {
      const nationalChannels = LIVE_CHANNELS.filter(c => c.category === 'NATIONAL');
      
      const grouped: Record<string, LiveChannel[]> = nationalChannels.reduce((acc, channel) => {
        const { subCategory } = channel;
        if (!acc[subCategory]) {
          acc[subCategory] = [];
        }
        acc[subCategory].push(channel);
        return acc;
      }, {} as Record<string, LiveChannel[]>);
      
      const subCategoryOrder = ['HINDI', 'ENGLISH', 'BUSINESS'];
      const orderedGrouped: Record<string, LiveChannel[]> = {};
      for (const subCategory of subCategoryOrder) {
          if(grouped[subCategory]){
            orderedGrouped[subCategory] = grouped[subCategory];
          }
      }
      setCategorizedChannels(orderedGrouped);

    } catch (err: any) {
      setError("Failed to load live channels.");
    } finally {
      setIsLoading(false);
    }
  };

  useEffect(() => {
    loadChannels();
  }, []);

  const handleSelectChannel = (channel: LiveChannel) => {
    setSelectedChannel(channel);
  };

  const handleClosePlayer = () => {
    setSelectedChannel(null);
  };
  
  const renderContent = () => {
    if (isLoading) {
        return <Spinner />;
    }

    if (error) {
        return (
            <div className="text-center py-20">
                <p className="text-red-600 mb-4">{error}</p>
                <button onClick={loadChannels} className="bg-[#8a1315] hover:bg-red-700 text-white font-bold py-2 px-4 rounded">
                    Retry
                </button>
            </div>
        );
    }

    return (
      <div>
        {Object.entries(categorizedChannels).map(([subCategory, channelsInCategory]) => (
          <section key={subCategory} className="mb-8">
            <h2 className="text-xl font-bold text-gray-800 border-b-2 border-red-600 pb-2 mb-4">{subCategory}</h2>
            <div className="grid grid-cols-3 sm:grid-cols-4 md:grid-cols-5 lg:grid-cols-6 gap-4 lg:gap-6">
              {channelsInCategory.map((channel) => (
                <LiveChannelCard
                  key={channel.id}
                  channel={channel}
                  onSelect={() => handleSelectChannel(channel)}
                />
              ))}
            </div>
          </section>
        ))}
      </div>
    );
  };

  return (
    <>
      <div>
        <h1 className="text-3xl font-bold text-black mb-2">Live News</h1>
        <p className="text-gray-600 mb-6">Watch national news channels live.</p>
        {renderContent()}
      </div>
      {selectedChannel && (
        <LiveVideoPlayer
          channel={selectedChannel}
          onClose={handleClosePlayer}
        />
      )}
    </>
  );
};

export default LiveNewsScreen;
