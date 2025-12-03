import React, { useState, useEffect } from 'react';
import { LIVE_CHANNELS } from '../constants';
import type { LiveChannel } from '../types';
import LiveVideoPlayer from '../components/LiveVideoPlayer';
import Spinner from '../components/Spinner';

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

const RegionalLiveScreen: React.FC = () => {
  const [selectedChannel, setSelectedChannel] = useState<LiveChannel | null>(null);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [channelsByState, setChannelsByState] = useState<Record<string, LiveChannel[]>>({});

  const loadRegionalChannels = () => {
    setIsLoading(true);
    setError(null);
    try {
      const regionalChannels = LIVE_CHANNELS.filter(c => c.category === 'REGIONAL');
      
      const groupedByState: Record<string, LiveChannel[]> = {};
      regionalChannels.forEach(channel => {
        if (channel.category === 'REGIONAL') {
          channel.subCategory.forEach(state => {
            if (!groupedByState[state]) {
              groupedByState[state] = [];
            }
            groupedByState[state].push(channel);
          });
        }
      });

      setChannelsByState(groupedByState);

    } catch (err: any) {
      setError("Failed to load regional live channels.");
    } finally {
      setIsLoading(false);
    }
  };

  useEffect(() => {
    loadRegionalChannels();
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
                <button onClick={loadRegionalChannels} className="bg-[#8a1315] hover:bg-red-700 text-white font-bold py-2 px-4 rounded">
                    Retry
                </button>
            </div>
        );
    }

    return (
      <div>
        {Object.entries(channelsByState).map(([state, channelsInState]) => (
          <section key={state} className="mb-8">
            <h2 className="text-xl font-bold text-gray-800 border-b-2 border-red-600 pb-2 mb-4">{state}</h2>
            <div className="grid grid-cols-3 sm:grid-cols-4 md:grid-cols-5 lg:grid-cols-6 gap-4 lg:gap-6">
              {channelsInState.map((channel) => (
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
        <h1 className="text-3xl font-bold text-black mb-2">Regional Live</h1>
        <p className="text-gray-600 mb-6">Live news from your state.</p>
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

export default RegionalLiveScreen;
