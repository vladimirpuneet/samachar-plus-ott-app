
import React from 'react';
import { useLocation, useNavigate } from 'react-router-dom';

const ArticleScreen: React.FC = () => {
    const location = useLocation();
    const navigate = useNavigate();
    const articleId = location.pathname.split('/').pop();
    const article = null; // No longer using mockNews

    if (!article) {
        return (
            <div className="p-4">
                <button
                    onClick={() => navigate(-1)}
                    className="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded mb-4"
                >
                    Go Back
                </button>
                <div>Article not found</div>
            </div>
        );
    }

    return (
        <div className="p-4">
            <button
                onClick={() => navigate(-1)}
                className="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded mb-4"
            >
                Go Back
            </button>
            <h1 className="text-3xl font-bold mb-4">{article.title}</h1>
            <img src={article.imageUrl} alt={article.title} className="w-full h-auto mb-4 rounded"/>
            <p className="text-lg text-gray-800">{article.content}</p>
        </div>
    );
};

export default ArticleScreen;
