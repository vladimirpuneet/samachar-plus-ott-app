
import React, { useState, useEffect } from 'react';
import { NavLink, useLocation } from 'react-router-dom';
import LiveIcon from '../icons/LiveIcon';
import TextNewsIcon from '../icons/TextNewsIcon';

const CONTENT_PREFERENCE_KEY = 'contentPreference';

const UniButton: React.FC = () => {
    const location = useLocation();
    const [preference, setPreference] = useState(
        localStorage.getItem(CONTENT_PREFERENCE_KEY) || 'national'
    );

    const isLive = location.pathname.includes('live');
    
    const isRegionalActive = location.pathname === '/' || location.pathname === '/regional-live';
    const isNationalActive = location.pathname === '/national' || location.pathname === '/live';

    useEffect(() => {
        if (isRegionalActive) {
            setPreference('regional');
            localStorage.setItem(CONTENT_PREFERENCE_KEY, 'regional');
        } else if (isNationalActive) {
            setPreference('national');
            localStorage.setItem(CONTENT_PREFERENCE_KEY, 'national');
        }
    }, [location.pathname, isRegionalActive, isNationalActive]);

    const livePath = preference === 'regional' ? '/regional-live' : '/live';
    const newsPath = preference === 'regional' ? '/' : '/national';

    const isSliderOnRegional = preference === 'regional';

    const linkClass = (isActive: boolean) => 
        `flex flex-col items-center justify-center text-xs transition-colors p-2 ${isActive ? 'text-red-600' : 'text-gray-500 hover:text-red-600'}`;

    return (
        <div className="flex items-center justify-center w-3/5 bg-white">
            <NavLink to={livePath} className={({ isActive }) => linkClass(isActive)}>
                <LiveIcon className="w-16 h-16" />
            </NavLink>

            <div className="relative flex flex-col bg-gray-200 rounded-md text-xs shadow-inner w-16">
                <div
                    className="absolute top-0 left-0 w-full h-1/2 bg-red-600 rounded-md transition-transform duration-300 ease-in-out"
                    style={{
                        transform: isSliderOnRegional ? 'translateY(100%)' : 'translateY(0)',
                    }}
                />
                <NavLink
                    to={isLive ? '/live' : '/national'}
                    className={`relative z-10 py-1 text-center font-semibold transition-colors duration-300 ${!isSliderOnRegional ? 'text-white' : 'text-gray-600'}`}
                >
                    National
                </NavLink>
                <NavLink
                    to={isLive ? '/regional-live' : '/'}
                    end
                    className={`relative z-10 py-1 text-center font-semibold transition-colors duration-300 ${isSliderOnRegional ? 'text-white' : 'text-gray-600'}`}
                >
                    Regional
                </NavLink>
            </div>

            <NavLink to={newsPath} className={({ isActive }) => linkClass(isActive)}>
                <TextNewsIcon className="w-16 h-16" />
            </NavLink>
        </div>
    );
};

export default UniButton;
