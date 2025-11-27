import React from 'react';
import { NavLink, useLocation } from 'react-router-dom';
import { UserIcon } from '../icons';
import UniButton from './UniButton';

interface BottomNavProps {
    onProfileClick: () => void;
    unreadCount?: number;
}

const BottomNavigationBar: React.FC<BottomNavProps> = ({ onProfileClick, unreadCount = 0 }) => {
  const location = useLocation();

  const footerClasses = `
    fixed bottom-0 left-0 right-0 bg-white border-t border-gray-200 shadow-lg z-40
  `;

  const navContainerClasses = `
    flex items-center h-full max-w-4xl mx-auto
  `;
  
  const baseItemClass = "flex items-center justify-center transition-colors p-2 w-1/5";
  
  const navLinkClass = ({ isActive }: { isActive: boolean }) =>
    `${baseItemClass} ${isActive ? 'text-red-600' : 'text-gray-500 hover:text-red-600'}`;

  const isProfileActive = location.pathname === '/profile';
  const profileButtonClass = `${baseItemClass} ${isProfileActive ? 'text-red-600' : 'text-gray-500 hover:text-red-600'}`;

  // Placeholder bell icon component
  const BellIcon = ({ className }: { className?: string }) => (
    <svg className={className} fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6.002 6.002 0 00-4-5.659V5a2 2 0 10-4 0v.341C7.67 6.165 6 8.388 6 11v3.159c0 .538-.214 1.055-.595 1.436L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9" />
    </svg>
  );

  return (
    <footer className={footerClasses}>
      <nav className={navContainerClasses}>
        
        <button onClick={onProfileClick} className={profileButtonClass}>
          <UserIcon />
        </button>
        
        <UniButton />

        <NavLink to="/notifications" className={navLinkClass}>
            <div className="relative">
                <BellIcon className="w-8 h-8" />
                {unreadCount > 0 && (
                    <span className="absolute top-0 right-0 transform translate-x-1/2 -translate-y-1/2 bg-red-600 text-white text-[10px] font-bold rounded-full h-4 w-4 flex items-center justify-center">
                        {unreadCount}
                    </span>
                )}
            </div>
        </NavLink>

      </nav>
    </footer>
  );
};

export default BottomNavigationBar;
