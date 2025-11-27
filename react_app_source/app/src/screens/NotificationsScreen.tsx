import React from 'react';
import { useSession } from '../App';

const NotificationsScreen: React.FC = () => {
    const { user } = useSession();

    if (!user) {
        return <div className="p-8 text-center">Please log in to see your notifications.</div>;
    }

    return (
        <div className="animate-fade-in bg-gray-50 min-h-full">
            <div className="max-w-2xl mx-auto">
                <div className="bg-white rounded-lg shadow-md border">
                    <div className="flex justify-between items-center p-4 border-b border-gray-200/80">
                        <h3 className="text-xl font-bold text-gray-800">Notifications</h3>
                    </div>

                    <div className="max-h-[85vh] overflow-y-auto">
                        <div className="text-center py-16 text-gray-500">
                            <p className="font-semibold text-lg mb-2">Notifications Coming Soon!</p>
                            <p className="text-sm">Stay tuned for updates and announcements.</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    );
};

export default NotificationsScreen;
