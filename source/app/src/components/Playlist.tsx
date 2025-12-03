
import React from 'react';
import type { Video } from '../types';

interface PlaylistProps {
  videos: Video[];
  selectedVideo: Video;
  onSelectVideo: (video: Video) => void;
}

const PlaylistItem: React.FC<{ video: Video; isSelected: boolean; onSelect: () => void; }> = ({ video, isSelected, onSelect }) => {
    const selectedClasses = isSelected ? 'bg-red-100 border-[#be95be]' : 'bg-white border-transparent hover:bg-gray-100 hover:border-[#be95be]';

    return (
        <div 
            onClick={onSelect}
            className={`flex items-center p-2 rounded-lg cursor-pointer transition-all duration-200 border-l-4 ${selectedClasses} mb-2`}
        >
            <img 
                src={video.thumbnailUrl}
                alt={video.title}
                className="w-28 h-16 object-cover rounded-md flex-shrink-0"
            />
            <div className="ml-3 overflow-hidden">
                <h3 className="text-sm font-semibold text-gray-900 truncate">{video.title}</h3>
                <p className="text-xs text-gray-600 truncate">{video.channel}</p>
                <p className="text-xs text-gray-500">{video.duration}</p>
            </div>
        </div>
    );
};

const Playlist: React.FC<PlaylistProps> = ({ videos, selectedVideo, onSelectVideo }) => {
  return (
    <div className="bg-white rounded-lg p-4 shadow-lg h-full max-h-[400px] lg:max-h-[440px] overflow-y-auto">
      <h2 className="text-lg font-bold text-black mb-4 border-b border-gray-200 pb-2">Up Next</h2>
      <div>
        {videos.map((video) => (
          <PlaylistItem
            key={video.id}
            video={video}
            isSelected={video.id === selectedVideo.id}
            onSelect={() => onSelectVideo(video)}
          />
        ))}
      </div>
    </div>
  );
};

export default Playlist;