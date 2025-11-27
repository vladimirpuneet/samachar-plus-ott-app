import React, { useState, useEffect, createContext, useContext, useCallback } from 'react';
import { BrowserRouter as Router, Routes, Route, useNavigate, useLocation } from 'react-router-dom';
import { User } from '@supabase/supabase-js';
import { supabase } from './lib/supabaseClient';
import { onUserProfileChange } from './utils/api';
import { setActiveUserInDB, clearActiveUserFromDB } from './utils/userSession';
import type { UserProfile } from './types';
import './transitions.css';

import Header from './components/Header';
import BottomNavigationBar from './components/BottomNavigationBar';
import Spinner from './components/Spinner';
import AuthScreen from './screens/AuthScreen';
import LiveNewsScreen from './screens/LiveNewsScreen';
import RegionalNewsScreen from './screens/RegionalNewsScreen';
import NationalNewsScreen from './screens/NationalNewsScreen';
import RegionalLiveScreen from './screens/RegionalLiveScreen';
import ProfileScreen from './screens/ProfileScreen';
import NotificationsScreen from './screens/NotificationsScreen';
import ArticleScreen from './screens/ArticleScreen';
import ProtectedRoute from './components/ProtectedRoute';
import SwipeableWrapper from './components/SwipeableWrapper';

interface AppContextType {
    user: User | null;
    profile: UserProfile | null;
    loading: boolean;
    reloadProfile: () => void;
    showAuthModal: boolean;
    setShowAuthModal: (show: boolean) => void;
}

export const AppContext = createContext<AppContextType | undefined>(undefined);
export const useSession = () => {
    const context = useContext(AppContext);
    if (!context) throw new Error('useSession must be used within an AppProvider');
    return context;
};

const AppContent: React.FC = () => {
    const [user, setUser] = useState<User | null>(null);
    const [profile, setProfile] = useState<UserProfile | null>(null);
    const [loading, setLoading] = useState(true);

    const [showAuthModal, setShowAuthModal] = useState(false);
    const navigate = useNavigate();
    const location = useLocation();

    const reloadProfile = useCallback(() => {
        // This can be used to trigger a profile reload if needed
    }, []);

    useEffect(() => {
        const getSession = async () => {
            const { data: { session } } = await supabase.auth.getSession();
            setLoading(true);
            if (session?.user) {
                await setActiveUserInDB(session.user.id);
                setUser(session.user);
                const unsubscribeProfile = onUserProfileChange(session.user.id, (userProfile) => {
                    setProfile(userProfile);
                    setLoading(false);
                });
            } else {
                await clearActiveUserFromDB();
                setUser(null);
                setProfile(null);
                setLoading(false);
            }
        };

        // Listen for auth changes
        const { data: { subscription } } = supabase.auth.onAuthStateChange(
            async (event, session) => {
                setLoading(true);
                if (session?.user) {
                    await setActiveUserInDB(session.user.id);
                    setUser(session.user);
                    const unsubscribeProfile = onUserProfileChange(session.user.id, (userProfile) => {
                        setProfile(userProfile);
                        setLoading(false);
                    });
                } else {
                    await clearActiveUserFromDB();
                    setUser(null);
                    setProfile(null);
                    setLoading(false);
                }
            }
        );

        getSession();

        return () => {
            subscription.unsubscribe();
        };
    }, []);



    const handleLogout = useCallback(async () => {
        await supabase.auth.signOut();
        navigate('/');
    }, [navigate]);

    const handleProfileClick = () => {
        if (user) {
            navigate('/profile');
        } else {
            setShowAuthModal(true); // Show auth modal for unauthenticated users
        }
    };
    
    const handleLogoClick = () => navigate('/news');

    if (loading) {
        return <div className="w-screen h-screen flex justify-center items-center"><Spinner /></div>;
    }

    const value = { user, profile, loading, reloadProfile, showAuthModal, setShowAuthModal };
    const mainContainerClasses = "bg-gray-100 min-h-screen font-sans pb-20 landscape:pb-0 landscape:pr-20";

    return (
        <AppContext.Provider value={value}>
            <div className={mainContainerClasses}>
                <Header onLogoClick={handleLogoClick} />
                <main className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
                    <SwipeableWrapper>
                        <Routes location={location}>
                            <Route path="/news" element={<RegionalNewsScreen />} />
                            <Route path="/national" element={<NationalNewsScreen />} />
                            <Route path="/live" element={<LiveNewsScreen />} />
                            <Route path="/regional-live" element={<RegionalLiveScreen />} />
                            <Route path="/profile" element={<ProfileScreen onLogout={handleLogout} />} />
                            <Route path="/notifications" element={<NotificationsScreen />} />
                            <Route path="/article/:id" element={<ArticleScreen />} />
                            <Route path="*" element={<RegionalNewsScreen />} />
                        </Routes>
                    </SwipeableWrapper>
                </main>
                <BottomNavigationBar onProfileClick={handleProfileClick} />
                
                {/* Auth Modal */}
                {showAuthModal && (
                    <AuthScreen onClose={() => setShowAuthModal(false)} />
                )}
            </div>
        </AppContext.Provider>
    );
};

const App: React.FC = () => (
    <Router basename="/app">
        <AppContent />
    </Router>
);

export default App;
