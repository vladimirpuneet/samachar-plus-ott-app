
import React, { useState, useEffect } from 'react';
import { supabase } from '../lib/supabaseClient';
import TopNewsSlideshow from '../components/TopNewsSlideshow';

const RegionalNewsScreen: React.FC = () => {
  const [news, setNews] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchNews = async () => {
      try {
        // Empty array for news content
        setNews([]);
      } catch (error) {
        console.error('Error fetching regional news:', error);
        setNews([]);
      } finally {
        setLoading(false);
      }
    };

    fetchNews();
  }, []);

  if (loading) {
    return (
      <div className="flex justify-center items-center py-8">
        <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-red-600"></div>
      </div>
    );
  }

  return (
    <div className="space-y-8">
      <TopNewsSlideshow />
      
      <div>
        <h2 className="text-2xl font-bold text-gray-800 mb-4">Regional News</h2>
        {news.length > 0 ? (
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
            {news.map((article) => (
              <div key={article.id} className="bg-white rounded-lg shadow-md p-4">
                {article.title && <h3 className="font-semibold mb-2">{article.title}</h3>}
                {article.summary && <p className="text-gray-600 text-sm">{article.summary}</p>}
              </div>
            ))}
          </div>
        ) : (
          <div className="text-center py-8">
            <p className="text-gray-500">No regional news available right now.</p>
          </div>
        )}
      </div>
    </div>
  );
};

export default RegionalNewsScreen;
