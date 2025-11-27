import React from 'react';

const LiveIcon: React.FC<{ className?: string }> = ({ className = "w-6 h-6" }) => (
    <svg 
        className={className}
        viewBox="0 0 80 40" 
        xmlns="http://www.w3.org/2000/svg"
        aria-hidden="true"
        role="img"
    >
        <rect 
            x="2" y="2" 
            width="76" height="36" 
            rx="8"
            stroke="currentColor" 
            strokeWidth="3"
            fill="none" 
        />
        <text 
            x="50%" 
            y="50%" 
            dy=".3em"
            textAnchor="middle" 
            fill="currentColor" 
            fontSize="18" 
            fontWeight="bold"
        >
            LIVE
        </text>
    </svg>
);

export default LiveIcon;
