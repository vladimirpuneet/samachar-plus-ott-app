
import React from 'react';
import { Link } from 'react-router-dom';
import { NewsArticle } from '../types';

interface NewsCardProps {
    article: NewsArticle;
}

const NewsCard: React.FC<NewsCardProps> = ({ article }) => {
    // Safely access and process the article content
    const content = article.content ? article.content.replace(/\\"/g, '"') : 'Content not available';

    return (
        <Link to={`/article/${article.id}`} className="block">
            <div className="bg-white rounded-lg shadow-md overflow-hidden mb-4 transition-transform duration-300 ease-in-out hover:scale-105">
                <img src={article.imageUrl} alt={article.title} className="w-full h-48 object-cover" />
                <div className="p-4">
                    <h3 className="text-lg font-bold mb-2 text-gray-800">{article.title}</h3>
                    <p className="text-gray-600 text-sm mb-4">{content}</p>
                </div>
            </div>
        </Link>
    );
};

export default NewsCard;
