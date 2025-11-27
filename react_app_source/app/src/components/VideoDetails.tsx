
import React from 'react';
import type { Video } from '../types';

interface VideoDetailsProps {
  video: Video;
}

const VideoDetails: React.FC<VideoDetailsProps> = ({ video }) => {
  return (
    <div className="bg-white rounded-lg p-6 shadow-md">
      <h2 className="text-2xl lg:text-3xl font-bold text-black mb-2">{video.title}</h2>
      <div className="flex items-center space-x-4 text-sm text-gray-600 mb-4 flex-wrap">
        <span>{video.channel}</span>
        <span className="w-1 h-1 bg-gray-400 rounded-full"></span>
        <span>{video.views}</span>
        <span className="w-1 h-1 bg-gray-400 rounded-full"></span>
        <span>{video.uploadedAt}</span>
      </div>
      <p className="text-gray-700 leading-relaxed">
        {video.description}
      </p>
    </div>
  );
};

export default VideoDetails;