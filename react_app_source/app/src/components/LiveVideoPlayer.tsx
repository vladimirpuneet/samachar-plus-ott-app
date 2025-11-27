

import React, { useEffect, useRef, useState } from 'react';
import Hls from 'hls.js';
import type { LiveChannel } from '../types';
import { reportBrokenLink } from '../utils/api';
import Spinner from './Spinner';

// Interfaces for vendor-prefixed Fullscreen APIs
interface DocumentWithFullscreen extends Document {
    mozFullScreenElement?: Element;
    msFullscreenElement?: Element;
    webkitFullscreenElement?: Element;
    msExitFullscreen?: () => Promise<void>;
    mozCancelFullScreen?: () => Promise<void>;
    webkitExitFullscreen?: () => Promise<void>;
}

interface HTMLElementWithFullscreen extends HTMLElement {
    msRequestFullscreen?: () => Promise<void>;
    mozRequestFullScreen?: () => Promise<void>;
    webkitRequestFullscreen?: () => Promise<void>;
}

interface HTMLVideoElementWithIOSFullscreen extends HTMLVideoElement {
    webkitEnterFullscreen?: () => void;
}

interface LiveVideoPlayerProps {
  channel: LiveChannel;
  onClose: () => void;
}

const CloseIcon = () => (
    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" className="w-6 h-6">
        <path fillRule="evenodd" d="M5.47 5.47a.75.75 0 011.06 0L12 10.94l5.47-5.47a.75.75 0 111.06 1.06L13.06 12l5.47 5.47a.75.75 0 11-1.06 1.06L12 13.06l-5.47 5.47a.75.75 0 01-1.06-1.06L10.94 12 5.47 6.53a.75.75 0 010-1.06z" clipRule="evenodd" />
    </svg>
);

const FullscreenEnterIcon = () => (
    <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" strokeWidth={1.5} stroke="currentColor" className="w-6 h-6">
        <path strokeLinecap="round" strokeLinejoin="round" d="M3.75 3.75v4.5m0-4.5h4.5m-4.5 0L9 9M3.75 20.25v-4.5m0 4.5h4.5m-4.5 0L9 15M20.25 3.75h-4.5m4.5 0v4.5m0-4.5L15 9m5.25 11.25h-4.5m4.5 0v-4.5m0 4.5L15 15" />
    </svg>
);

const FullscreenExitIcon = () => (
    <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" strokeWidth={1.5} stroke="currentColor" className="w-6 h-6">
        <path strokeLinecap="round" strokeLinejoin="round" d="M9 9V4.5M9 9H4.5M9 9L3.75 3.75M9 15v4.5M9 15H4.5M9 15l-5.25 5.25M15 9h4.5M15 9V4.5M15 9l5.25-5.25M15 15h4.5M15 15v4.5M15 15l5.25 5.25" />
    </svg>
);
  
const MuteIcon = () => (
    <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" strokeWidth={1.5} stroke="currentColor" className="w-6 h-6">
        <path strokeLinecap="round" strokeLinejoin="round" d="M17.25 9.75L19.5 12m0 0l2.25 2.25M19.5 12l2.25-2.25M19.5 12l-2.25 2.25m-10.5-6l4.72-4.72a.75.75 0 011.28 .53v15.88a.75.75 0 01-1.28 .53l-4.72-4.72H4.51c-.88 0-1.704-.507-1.938-1.354A9.01 9.01 0 012.25 12c0-.83.112-1.633.322-2.396C2.806 8.756 3.63 8.25 4.51 8.25H6.75z" />
    </svg>
);

const VolumeIcon = () => (
    <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" strokeWidth={1.5} stroke="currentColor" className="w-6 h-6">
        <path strokeLinecap="round" strokeLinejoin="round" d="M19.114 5.636a9 9 0 010 12.728M16.463 8.288a5.25 5.25 0 010 7.424M6.75 8.25l4.72-4.72a.75.75 0 011.28 .53v15.88a.75.75 0 01-1.28 .53l-4.72-4.72H4.51c-.88 0-1.704-.507-1.938-1.354A9.01 9.01 0 012.25 12c0-.83.112-1.633.322-2.396C2.806 8.756 3.63 8.25 4.51 8.25H6.75z" />
    </svg>
);

const AttentionIcon = () => (
    <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" strokeWidth={1.5} stroke="currentColor" className="w-6 h-6">
        <path strokeLinecap="round" strokeLinejoin="round" d="M12 9v3.75m-9.303 3.376c-.866 1.5.217 3.374 1.948 3.374h14.71c1.73 0 2.813-1.874 1.948-3.374L13.949 3.378c-.866-1.5-3.032-1.5-3.898 0L2.697 16.126zM12 15.75h.007v.008H12v-.008z" />
    </svg>
);

const CheckIcon = () => (
    <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" strokeWidth={1.5} stroke="currentColor" className="w-6 h-6 text-green-400">
        <path strokeLinecap="round" strokeLinejoin="round" d="M9 12.75L11.25 15 15 9.75M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
    </svg>
);

const ReportingSpinner = () => (
    <svg className="animate-spin h-6 w-6 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
        <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4"></circle>
        <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
    </svg>
);


const LiveVideoPlayer: React.FC<LiveVideoPlayerProps> = ({ channel, onClose }) => {
    const videoRef = useRef<HTMLVideoElementWithIOSFullscreen>(null);
    const playerContainerRef = useRef<HTMLDivElement>(null);
    const [isMuted, setIsMuted] = useState(false);
    const [isFullScreen, setIsFullScreen] = useState(false);
    const [isReporting, setIsReporting] = useState(false);
    const [reportSuccess, setReportSuccess] = useState(false);
    const [isBuffering, setIsBuffering] = useState(true);
    const [isMobile, setIsMobile] = useState(false);

    if (!channel) {
        return null;
    }

    useEffect(() => {
        const handleResize = () => {
            setIsMobile(window.innerWidth < 640); // sm breakpoint
        };
        handleResize();
        window.addEventListener('resize', handleResize);
        return () => window.removeEventListener('resize', handleResize);
    }, []);

    useEffect(() => {
        const handleEsc = (event: KeyboardEvent) => {
           if (event.key === 'Escape' && !isFullScreen) {
              onClose();
           }
        };
        document.body.style.overflow = 'hidden';
        window.addEventListener('keydown', handleEsc);
        
        const handleFullScreenChange = () => {
            const doc = document as DocumentWithFullscreen;
            setIsFullScreen(!!(doc.fullscreenElement || doc.mozFullScreenElement || doc.webkitFullscreenElement || doc.msFullscreenElement));
        };

        document.addEventListener('fullscreenchange', handleFullScreenChange);
        document.addEventListener('webkitfullscreenchange', handleFullScreenChange);
        document.addEventListener('mozfullscreenchange', handleFullScreenChange);
        document.addEventListener('MSFullscreenChange', handleFullScreenChange);
        
        return () => {
            document.body.style.overflow = 'auto';
            window.removeEventListener('keydown', handleEsc);
            document.removeEventListener('fullscreenchange', handleFullScreenChange);
            document.removeEventListener('webkitfullscreenchange', handleFullScreenChange);
            document.removeEventListener('mozfullscreenchange', handleFullScreenChange);
            document.removeEventListener('MSFullscreenChange', handleFullScreenChange);
        };
    }, [onClose, isFullScreen]);

    useEffect(() => {
        if (!videoRef.current) return;
        const video = videoRef.current;
        const videoSrc = channel.streamUrl;
        let hls: Hls;

        setIsBuffering(true);

        const handleWaiting = () => setIsBuffering(true);
        const handlePlaying = () => setIsBuffering(false);

        video.addEventListener('waiting', handleWaiting);
        video.addEventListener('playing', handlePlaying);
    
        if (Hls.isSupported()) {
          const hlsConfig = {
            lowLatencyMode: true,
            liveSyncDurationCount: 2,
            maxBufferLength: 10, 
            startLevel: 0,
            abrEwmaDefaultEstimate: 500000,
          };

          hls = new Hls(hlsConfig);
          hls.loadSource(videoSrc);
          hls.attachMedia(video);
          hls.on(Hls.Events.MANIFEST_PARSED, () => {
            video.play().catch(() => {
                console.log("Autoplay was prevented by the browser.");
                setIsBuffering(false);
            });
          });
        } else if (video.canPlayType('application/vnd.apple.mpegurl')) {
          video.src = videoSrc;
          video.addEventListener('loadedmetadata', () => {
            video.play().catch(() => {
                console.log("Autoplay was prevented by the browser.");
                setIsBuffering(false);
            });
          });
        }
    
        return () => { 
            if (hls) hls.destroy(); 
            video.removeEventListener('waiting', handleWaiting);
            video.removeEventListener('playing', handlePlaying);
        };
    }, [channel.streamUrl]);

    const handleMuteToggle = () => {
        if (videoRef.current) {
            videoRef.current.muted = !videoRef.current.muted;
            setIsMuted(videoRef.current.muted);
        }
    };
    
    const handleFullScreenToggle = () => {
        const doc = document as DocumentWithFullscreen;
        const player = playerContainerRef.current as HTMLElementWithFullscreen;
        const video = videoRef.current;

        const isCurrentlyFullScreen = !!(doc.fullscreenElement || doc.webkitFullscreenElement || doc.mozFullScreenElement || doc.msFullscreenElement);

        if (!isCurrentlyFullScreen) {
            if (video && video.webkitEnterFullscreen) {
                video.webkitEnterFullscreen();
            } else if (player.requestFullscreen) {
                player.requestFullscreen().catch(err => console.error(`Error attempting to enable full-screen mode: ${err.message} (${err.name})`));
            } else if (player.webkitRequestFullscreen) {
                player.webkitRequestFullscreen().catch(err => console.error(`Error attempting to enable full-screen mode: ${err.message} (${err.name})`));
            } else if (player.mozRequestFullScreen) {
                player.mozRequestFullScreen().catch(err => console.error(`Error attempting to enable full-screen mode: ${err.message} (${err.name})`));
            } else if (player.msRequestFullscreen) {
                player.msRequestFullscreen().catch(err => console.error(`Error attempting to enable full-screen mode: ${err.message} (${err.name})`));
            }
        } else {
            if (doc.exitFullscreen) {
                doc.exitFullscreen();
            } else if (doc.webkitExitFullscreen) {
                doc.webkitExitFullscreen();
            } else if (doc.mozCancelFullScreen) {
                doc.mozCancelFullScreen();
            } else if (doc.msExitFullscreen) {
                doc.msExitFullscreen();
            }
        }
    };

    const handleReport = async () => {
        if (isReporting || reportSuccess) return;
        setIsReporting(true);
        try {
            await reportBrokenLink(channel);
            setReportSuccess(true);
            setTimeout(() => setReportSuccess(false), 3000);
        } catch (error) {
            console.error(error);
            alert('Failed to submit report. Please try again later.');
        } finally {
            setIsReporting(false);
        }
    };

    const getReportButtonText = () => {
        if (isReporting) return isMobile ? 'REPORTING' : 'REPORTING...';
        if (reportSuccess) return 'REPORTED';
        return isMobile ? 'REPORT' : 'REPORT NOT WORKING';
    };

    const subcategoryDisplay = Array.isArray(channel.subCategory)
        ? channel.subCategory.join(', ')
        : channel.subCategory;

    return (
        <div 
            className="fixed inset-0 bg-black/80 backdrop-blur-sm z-50 flex items-center justify-center animate-fade-in"
            aria-modal="true" role="dialog"
        >
            <div className="relative w-full max-w-4xl mx-4">
                <div 
                    ref={playerContainerRef} 
                    className="bg-black rounded-lg shadow-2xl overflow-hidden flex flex-col"
                >
                    <div className="w-full aspect-video relative bg-black">
                        {isBuffering && (
                            <div className="absolute inset-0 flex items-center justify-center z-10">
                                <Spinner />
                            </div>
                        )}
                        <video ref={videoRef} autoPlay playsInline className="w-full h-full" muted={isMuted}>
                            Your browser does not support the video tag.
                        </video>
                    </div>
                    
                    <div className="relative bg-gray-900/70 backdrop-blur-sm p-2 flex justify-between items-center">
                        <button 
                            onClick={handleReport} 
                            disabled={isReporting || reportSuccess} 
                            className="bg-transparent hover:bg-white/20 text-white rounded-md px-3 py-2.5 transition-all duration-200 disabled:opacity-50 disabled:cursor-not-allowed flex items-center space-x-2 z-10" 
                            aria-label="Report broken link"
                        >
                            {isReporting ? <ReportingSpinner /> : reportSuccess ? <CheckIcon /> : <AttentionIcon />}
                            <span className="text-sm font-medium whitespace-nowrap">
                                {getReportButtonText()}
                            </span>
                        </button>

                        <div className="absolute left-1/2 top-1/2 -translate-x-1/2 -translate-y-1/2 text-center text-white pointer-events-none">
                            <p className="font-bold text-sm truncate">{channel.name}</p>
                            <p className="text-xs text-gray-400 truncate">{subcategoryDisplay}</p>
                        </div>

                        <div className="flex items-center space-x-2 z-10">
                            <button onClick={handleMuteToggle} className="bg-transparent hover:bg-white/20 text-white rounded-full p-2.5 transition-all duration-200" aria-label={isMuted ? 'Unmute' : 'Mute'}>
                                {isMuted ? <MuteIcon /> : <VolumeIcon />}
                            </button>
                            <button onClick={handleFullScreenToggle} className="bg-transparent hover:bg-white/20 text-white rounded-full p-2.5 transition-all duration-200" aria-label={isFullScreen ? 'Exit Fullscreen' : 'Enter Fullscreen'}>
                                {isFullScreen ? <FullscreenExitIcon /> : <FullscreenEnterIcon />}
                            </button>
                        </div>
                    </div>
                </div>

                <button
                    onClick={onClose}
                    className="absolute -top-4 -right-4 bg-gradient-to-br from-gray-700 to-gray-900 text-white rounded-full p-3 hover:from-red-500 hover:to-red-600 transition-all duration-200 z-10 shadow-lg border-2 border-black/20"
                    aria-label="Close video player"
                >
                    <CloseIcon />
                </button>
            </div>
        </div>
    );
};

export default LiveVideoPlayer;
