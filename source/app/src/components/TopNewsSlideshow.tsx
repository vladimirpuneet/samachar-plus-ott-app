
import React, { useState, useEffect } from 'react';
import { supabase } from '../lib/supabaseClient';

const TopNewsSlideshow: React.FC = () => {
  const [slides, setSlides] = useState<any[]>([]);
  const [currentSlide, setCurrentSlide] = useState(0);

  useEffect(() => {
    const fetchSlides = async () => {
      try {
        // Empty array for featured news
        setSlides([]);
      } catch (error) {
        console.error('Error fetching top news:', error);
        setSlides([]);
      }
    };

    fetchSlides();
  }, []);

  const nextSlide = () => {
    setCurrentSlide((prev) => (prev >= slides.length - 1 ? 0 : prev + 1));
  };

  const prevSlide = () => {
    setCurrentSlide((prev) => (prev <= 0 ? slides.length - 1 : prev - 1));
  };

  if (slides.length === 0) {
    return (
        <div className="w-full max-w-4xl rounded-lg overflow-hidden shadow-lg bg-white flex items-center justify-center" style={{ height: '256px' }}>
            <p className="text-gray-500">No featured news right now. Check back later!</p>
        </div>
    );
  }

  const slide = slides[currentSlide];

  return (
    <div className="relative w-full max-w-4xl rounded-lg overflow-hidden shadow-lg">
        {slide.imageUrl ? (
            <img src={slide.imageUrl} alt={slide.title} className="w-full h-64 object-cover" />
        ) : (
             <div className="w-full h-64 bg-gray-200 flex items-center justify-center">
                <p className="text-gray-500">Image not available</p>
             </div>
        )}
        <div className="absolute bottom-0 left-0 right-0 bg-black bg-opacity-50 p-4">
            <h3 className="text-white text-xl font-bold">{slide.title}</h3>
            {slide.summary && <p className="text-white text-sm mt-1">{slide.summary}</p>}
        </div>

      <button
        onClick={prevSlide}
        className="absolute top-1/2 left-4 transform -translate-y-1/2 bg-white rounded-full p-2 shadow-md hover:bg-gray-200 opacity-75 hover:opacity-100"
        aria-label="Previous slide"
      >
        &#10094;
      </button>
      <button
        onClick={nextSlide}
        className="absolute top-1/2 right-4 transform -translate-y-1/2 bg-white rounded-full p-2 shadow-md hover:bg-gray-200 opacity-75 hover:opacity-100"
        aria-label="Next slide"
      >
        &#10095;
      </button>
    </div>
  );
};

export default TopNewsSlideshow;
