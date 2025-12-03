import React from 'react';
import { useSwipeable } from 'react-swipeable';
import { useLocation, useNavigate } from 'react-router-dom';

const SwipeableWrapper: React.FC<{ children: React.ReactNode }> = ({ children }) => {
    const navigate = useNavigate();
    const location = useLocation();

    const handlers = useSwipeable({
        onSwipedLeft: () => {
            // Swipe left to go to News
            if (location.pathname.includes('live')) {
                const newPath = location.pathname.replace('live', 'news');
                navigate(newPath);
            }
        },
        onSwipedRight: () => {
            // Swipe right to go to Live
            if (location.pathname.includes('news')) {
                const newPath = location.pathname.replace('news', 'live');
                navigate(newPath);
            }
        },
        preventScrollOnSwipe: true,
        trackMouse: true
    });

    return (
        <div {...handlers} style={{ touchAction: 'pan-y' }}>
            {children}
        </div>
    );
};

export default SwipeableWrapper;
