
import React, { useState, useEffect } from 'react';
import { supabase } from '../lib/supabaseClient';
import NewsCard from './NewsCard';
import { useSession } from '../App';
import { fetchEnabledCategories } from '../data/locations';

const CategoryNewsCarousel: React.FC = () => {
    const { user, profile } = useSession();
    const [categories, setCategories] = useState<string[]>([]);
    const [selectedCategory, setSelectedCategory] = useState<string>('');
    const [filteredNews, setFilteredNews] = useState<any[]>([]);

    useEffect(() => {
        const fetchCategories = async () => {
            // Fetch categories from Supabase database
            try {
                const categoriesList = await fetchEnabledCategories();
                setCategories(categoriesList);
            } catch (error) {
                console.error('Error fetching categories:', error);
                // Fallback to default categories
                setCategories(['Politics', 'Sports', 'Entertainment', 'Technology', 'Business']);
            }
        };
        fetchCategories();
    }, []);

    useEffect(() => {
        const getInitialCategory = () => {
            if (!user) return '';
            const preferred = profile?.preferences?.categories;
            if (preferred && preferred.length > 0) return preferred[0];
            const nonLocalCategories = categories.filter(c => c !== 'Local');
            return nonLocalCategories.length > 0 ? nonLocalCategories[0] : '';
        };

        const initialCategory = getInitialCategory();
        if (initialCategory) {
            setSelectedCategory(initialCategory);
        }
    }, [user, profile, categories]);

    useEffect(() => {
        const fetchNews = async () => {
            if (selectedCategory) {
                setFilteredNews([]); // Clear old news
                try {
                    // For now, use empty array since we don't have Supabase content setup
                    setFilteredNews([]);
                } catch (error) {
                    console.error('Error fetching news:', error);
                    setFilteredNews([]);
                }
            }
        };
        fetchNews();
    }, [selectedCategory]);

    const getCategoriesForButtons = () => {
        if (!user) return [];
        const preferred = profile?.preferences?.categories;
        if (preferred && preferred.length > 0) return preferred;
        return categories.filter(c => c !== 'Local');
    };

    const categoriesForButtons = getCategoriesForButtons();

    return (
        <div>
            {user && categoriesForButtons.length > 0 && (
                <div className="flex justify-center mb-4 flex-wrap">
                    {categoriesForButtons.map(category => (
                        <button
                            key={category}
                            onClick={() => setSelectedCategory(category)}
                            className={`px-4 py-2 mx-2 my-1 rounded-full font-semibold ${
                                selectedCategory === category
                                    ? 'bg-blue-500 text-white'
                                    : 'bg-gray-200 text-gray-700'
                            }`}>
                            {category}
                        </button>
                    ))}
                </div>
            )}
            <div className="relative">
                <div className="flex overflow-x-auto space-x-4 p-4" style={{ scrollSnapType: 'x mandatory' }}>
                    {filteredNews.length > 0 ? (
                        filteredNews.map(article => (
                            <div key={article.id} className="flex-shrink-0 w-80" style={{ scrollSnapAlign: 'start' }}>
                                <NewsCard article={article} />
                            </div>
                        ))
                    ) : (
                        <div className="text-center w-full py-16 text-gray-500">
                            <p className="font-semibold">{user ? `No news for ${selectedCategory}.` : "No news available."}</p>
                        </div>
                    )}
                </div>
            </div>
        </div>
    );
};

export default CategoryNewsCarousel;
