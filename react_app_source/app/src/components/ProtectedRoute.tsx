import React, { useEffect } from 'react';
import { useSession } from '../App';
import Spinner from './Spinner';

interface ProtectedRouteProps {
    children: React.ReactElement;
}

const ProtectedRoute: React.FC<ProtectedRouteProps> = ({ children }) => {
    const { profile, loading, setShowAuthModal } = useSession();

    useEffect(() => {
        // If the session has loaded and the profile is still missing or incomplete (no name),
        // then we need to show the authentication modal.
        if (!loading && (!profile || !profile.name)) {
            setShowAuthModal(true);
        }
    }, [loading, profile, setShowAuthModal]);

    // While the session is loading, display a spinner.
    if (loading) {
        return <div className="w-screen h-screen flex justify-center items-center"><Spinner /></div>;
    }

    // If a complete profile exists, the user is fully authenticated and can see the content.
    if (profile?.name) {
        return children;
    }

    // If there is no complete profile and loading is finished, render nothing.
    // The useEffect above will have triggered the auth modal to open.
    // This prevents a redirect and allows the user to complete their profile.
    return null;
};

export default ProtectedRoute;
