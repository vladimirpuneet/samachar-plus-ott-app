
import React from 'react';
import type { Video } from '../types';

interface VideoPlayerModalProps {
  video: Video;
  onClose: () => void;
}

const VideoPlayerModal: React.FC<VideoPlayerModalProps> = ({ video, onClose }) => {
    return (
        <div className="fixed inset-0 bg-black bg-opacity-75 z-50 flex justify-center items-center" onClick={onClose}>
            <div className="relative bg-black w-full max-w-4xl h-auto rounded-lg overflow-hidden mx-4" onClick={e => e.stopPropagation()}>
                <button onClick={onClose} className="absolute top-2 right-2 text-white text-2xl z-10">&times;</button>
                <div className="aspect-video">
                    <iframe 
                        src={video.videoUrl} 
                        title={video.title} 
                        frameBorder="0" 
                        allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" 
                        allowFullScreen
                        className="w-full h-full"
                    ></iframe>
                </div>
                <div className="p-4">
                    <h2 className="text-xl font-bold text-white">{video.title}</h2>
                    <p className="text-sm text-gray-400">{video.channelName}</p>
                    <p className="text-xs text-gray-500">{video.views} &bull; {video.uploadedAt}</p>
                    <p className="text-sm text-gray-300 mt-2">{video.description}</p>
                </div>
            </div>
        </div>
    );
};

export default VideoPlayerModal;
