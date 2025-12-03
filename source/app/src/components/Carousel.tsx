
import React, { useState } from 'react';

interface CarouselProps {
    items: any[];
}

const Carousel: React.FC<CarouselProps> = ({ items }) => {
    const [currentIndex, setCurrentIndex] = useState(0);

    const handleNext = () => {
        setCurrentIndex((prevIndex) => (prevIndex + 1) % items.length);
    };

    const handlePrev = () => {
        setCurrentIndex((prevIndex) => (prevIndex - 1 + items.length) % items.length);
    };

    return (
        <div className="relative">
            <div className="overflow-hidden rounded-lg">
                <div
                    className="flex transition-transform duration-500 ease-in-out"
                    style={{ transform: `translateX(-${currentIndex * 100}%)` }}
                >
                    {items.map((item, index) => (
                        <div key={index} className="w-full flex-shrink-0">
                            <img src={item.imageUrl} alt={item.title} className="w-full h-auto" />
                            <div className="absolute bottom-0 left-0 bg-black bg-opacity-50 text-white p-4">
                                <h3 className="text-lg font-bold">{item.title}</h3>
                                <p className="text-sm">{item.description}</p>
                            </div>
                        </div>
                    ))}
                </div>
            </div>

            <button
                onClick={handlePrev}
                className="absolute top-1/2 left-4 -translate-y-1/2 bg-white/50 hover:bg-white/80 rounded-full p-2"
            >
                <span className="material-icons">chevron_left</span>
            </button>
            <button
                onClick={handleNext}
                className="absolute top-1/2 right-4 -translate-y-1/2 bg-white/50 hover:bg-white/80 rounded-full p-2"
            >
                <span className="material-icons">chevron_right</span>
            </button>
        </div>
    );
};

export default Carousel;
