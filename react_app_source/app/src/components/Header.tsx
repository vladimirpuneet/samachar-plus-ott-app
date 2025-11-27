
import React from 'react';

interface HeaderProps {
  onLogoClick: () => void;
}

const Header: React.FC<HeaderProps> = ({ onLogoClick }) => {
  return (
    <header className="bg-red-600 shadow-lg sticky top-0 z-20">
      <div className="container mx-auto px-4 lg:px-6 py-3 flex justify-between items-center h-[68px]">
        <button onClick={onLogoClick} aria-label="Go to Home" className="flex-shrink-0 z-10">
            <img src="https://s12.gifyu.com/images/b38qq.gif" alt="Samachar Plus OTT Logo" className="h-14" />
        </button>
      </div>
    </header>
  );
};

export default Header;
