import React, { useState, useEffect } from 'react';
import { useSession } from '../App';
import { NEWS_CATEGORIES } from '../constants';
import { fetchEnabledLocations } from '../data/locations';
import type { UserProfile, UserPreferences } from '../types';
import { updateUserProfile } from '../utils/api';
import Spinner from '../components/Spinner';
import { capitalize } from '../utils/helpers';

// --- ICONS ---
const LogoutIcon = ({ className }: { className?: string }) => (<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" className={className || "w-5 h-5"}><path fillRule="evenodd" d="M7.5 3.75A1.5 1.5 0 006 5.25v13.5a1.5 1.5 0 001.5 1.5h6a1.5 1.5 0 001.5-1.5V15a.75.75 0 011.5 0v3.75a3 3 0 01-3 3h-6a3 3 0 01-3-3V5.25a3 3 0 013-3h6a3 3 0 013 3V9A.75.75 0 0115 9V5.25a1.5 1.5 0 00-1.5-1.5h-6zm10.72 4.72a.75.75 0 011.06 0l3 3a.75.75 0 010 1.06l-3 3a.75.75 0 11-1.06-1.06l1.72-1.72H9a.75.75 0 010-1.5h10.94l-1.72-1.72a.75.75 0 010-1.06z" clipRule="evenodd" /></svg>);
const UserIcon = ({ className }: { className?: string }) => (<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" className={className}><path fillRule="evenodd" d="M7.5 6a4.5 4.5 0 119 0 4.5 4.5 0 01-9 0zM3.751 20.105a8.25 8.25 0 0116.498 0 .75.75 0 01-.437.695A18.683 18.683 0 0112 22.5c-2.786 0-5.433-.608-7.812-1.7a.75.75 0 01-.437-.695z" clipRule="evenodd" /></svg>);
const MaleIcon = ({ className }: { className?: string }) => (<svg className={className} viewBox="0 0 24 24" fill="currentColor"><path d="M12,2A3,3,0,0,1,15,5A3,3,0,0,1,12,8A3,3,0,0,1,9,5A3,3,0,0,1,12,2M10,9H14A2,2,0,0,1,16,11V17H13.5V22H10.5V17H8V11A2,2,0,0,1,10,9Z" /></svg>);
const FemaleIcon = ({ className }: { className?: string }) => (<svg className={className} viewBox="0 0 24 24" fill="currentColor"><path d="M12,2A3,3,0,0,1,15,5A3,3,0,0,1,12,8A3,3,0,0,1,9,5A3,3,0,0,1,12,2M10,9H14A2,2,0,0,1,16,11V16L13,22H11L8,16V11A2,2,0,0,1,10,9Z" /></svg>);
const EditIcon = ({ className }: { className?: string }) => (<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" className={className}><path d="M5.433 13.917l1.262-3.155A4 4 0 017.58 9.42l6.92-6.918a2.121 2.121 0 013 3l-6.92 6.918c-.383.383-.84.685-1.343.886l-3.154 1.262a.5.5 0 01-.65-.65z" /><path d="M3.5 5.75c0-.69.56-1.25 1.25-1.25H10A.75.75 0 0010 3H4.75A2.75 2.75 0 002 5.75v9.5A2.75 2.75 0 004.75 18h9.5A2.75 2.75 0 0017 15.25V10a.75.75 0 00-1.5 0v5.25c0 .69-.56 1.25-1.25-1.25h-9.5c-.69 0-1.25-.56-1.25-1.25v-9.5z" /></svg>);

const defaultPreferences: UserPreferences = { categories: [], state: '', district: '' };

const ProfileScreen: React.FC<{ onLogout: () => void }> = ({ onLogout }) => {
    const { user, profile: sessionProfile, loading, reloadProfile } = useSession();
    
    const [displayProfile, setDisplayProfile] = useState(sessionProfile);
    const [isInitialLoad, setIsInitialLoad] = useState(true);
    const [isEditing, setIsEditing] = useState(false);
    const [name, setName] = useState(displayProfile?.name || '');
    const [gender, setGender] = useState(displayProfile?.gender || 'other');
    const [preferences, setPreferences] = useState<UserPreferences>(displayProfile?.preferences || defaultPreferences);
    const [locations, setLocations] = useState<{ INDIAN_STATES: string[], INDIAN_STATES_AND_DISTRICTS: { [key: string]: string[] } }>({ INDIAN_STATES: [], INDIAN_STATES_AND_DISTRICTS: {} });
    const [districts, setDistricts] = useState<string[]>([]);
    const [saveLoading, setSaveLoading] = useState(false);
    const [statusMessage, setStatusMessage] = useState('');
    const [errorMessage, setErrorMessage] = useState('');

    useEffect(() => {
        if (!loading && isInitialLoad) {
            setIsInitialLoad(false);
        }
    }, [loading, isInitialLoad]);
    
    useEffect(() => {
        if (sessionProfile) {
            setDisplayProfile(sessionProfile);
        }
    }, [sessionProfile]);
    
    useEffect(() => {
        fetchEnabledLocations().then(setLocations);
    }, []);

    useEffect(() => {
        setDistricts(preferences.state ? locations.INDIAN_STATES_AND_DISTRICTS[preferences.state] || [] : []);
    }, [preferences.state, locations]);

    const clearMessages = () => { setStatusMessage(''); setErrorMessage(''); };

    const handleEditClick = () => {
        clearMessages();
        if(displayProfile) {
            setName(displayProfile.name);
            setGender(displayProfile.gender);
            setPreferences(displayProfile.preferences || defaultPreferences);
        }
        setIsEditing(true);
    };
    
    const handleCancelEdit = () => { setIsEditing(false); clearMessages(); };
    
    const handleSaveAll = async () => {
        clearMessages();
        if (!name.trim()) { setErrorMessage("Name cannot be empty."); return; }
        if (!user) { setErrorMessage("You must be logged in to save."); return; }
        setSaveLoading(true);
        
        const updatedProfile: Partial<UserProfile> = { name, gender, preferences };
        setDisplayProfile(prev => ({ ...prev!, ...updatedProfile }));
        setIsEditing(false);

        try {
            await updateUserProfile(user.uid, { name, gender, preferences });
            setStatusMessage('Profile and preferences updated!');
            reloadProfile();
        } catch (err: any) { 
            setErrorMessage(err.message || 'Failed to update profile.');
            setDisplayProfile(sessionProfile);
        } finally { 
            setSaveLoading(false);
            setTimeout(() => clearMessages(), 4000); 
        }
    };

    const toggleCategory = (cat: string) => setPreferences(p => ({ ...p, categories: p.categories.includes(cat) ? p.categories.filter(c => c !== cat) : [...p.categories, cat] }));
    const handleStateChange = (e: React.ChangeEvent<HTMLSelectElement>) => setPreferences(p => ({ ...p, state: e.target.value, district: '' }));
    const handleDistrictChange = (e: React.ChangeEvent<HTMLSelectElement>) => setPreferences(p => ({ ...p, district: e.target.value }));
    
    const renderGenderIcon = (genderStr: string, className: string) => {
        const lowerGender = genderStr?.toLowerCase();
        if (lowerGender === 'male') return <MaleIcon className={className} />;
        if (lowerGender === 'female') return <FemaleIcon className={className} />;
        return <UserIcon className={className} />;
    };

    if (loading && isInitialLoad) {
        return <div className="w-full flex justify-center items-center py-20"><Spinner /></div>;
    }
    
    if (!user || !displayProfile) {
        return <div className="p-8 text-center">Please log in to see your profile.</div>;
    }

    return (
        <div className="animate-fade-in bg-gray-50 min-h-full">
            <div className="max-w-2xl mx-auto p-4 sm:p-6 lg:p-8">
                
                {statusMessage && <div className="bg-green-100 border-l-4 border-green-500 text-green-700 p-4 mb-6 rounded-r-lg shadow-md" role="alert"><p>{statusMessage}</p></div>}
                {errorMessage && <div className="bg-red-100 border-l-4 border-red-500 text-red-700 p-4 mb-6 rounded-r-lg shadow-md" role="alert"><p>{errorMessage}</p></div>}

                <div className="space-y-8">

                    {/* --- PROFILE & PREFERENCES --- */}
                    <div>
                        {isEditing ? (
                            <div className="bg-white rounded-lg p-6 shadow-md border">
                                 <h3 className="text-xl font-semibold text-gray-800 mb-4">Edit Profile</h3>
                                 <div className="space-y-4 mb-6">
                                     <div><label className="block text-gray-600 text-sm font-bold mb-2">Full Name</label><input type="text" value={name} onChange={(e) => setName(e.target.value)} className="w-full px-4 py-2 rounded-lg bg-gray-100 border-gray-300 focus:outline-none focus:ring-2 focus:ring-[#b30002] text-black" /></div>
                                     <div>
                                         <label className="block text-gray-600 text-sm font-bold mb-2">Gender</label>
                                         <div className="flex justify-start space-x-4 bg-gray-100 p-2 rounded-lg">
                                             {(['male', 'female', 'other'] as const).map(g => (
                                                 <label key={g} className="flex items-center space-x-2 cursor-pointer p-1 rounded-md">
                                                     <input type="radio" name="gender" value={g} checked={gender === g} onChange={(e) => setGender(e.target.value)} className="form-radio h-4 w-4 text-[#b30002]" />
                                                     <span className="text-gray-700">{capitalize(g)}</span>
                                                 </label>
                                             ))}
                                         </div>
                                     </div>
                                 </div>
                                 <h3 className="text-xl font-semibold text-gray-800 mb-4 border-t pt-6">Manage Preferences</h3>
                                 <div className="space-y-4">
                                     <div className="mb-4"><h4 className="font-semibold text-gray-700 mb-2">Favorite Categories</h4><div className="flex flex-wrap gap-2">{NEWS_CATEGORIES.map(cat => (<button key={cat} onClick={() => toggleCategory(cat)} className={`px-3 py-1 text-sm rounded-full transition-colors ${preferences.categories.includes(cat) ? 'bg-[#8a1315] text-white' : 'bg-gray-200 text-gray-700'}`}>{cat}</button>))}</div></div>
                                     <div><h4 className="font-semibold text-gray-700 mb-2">Location</h4><div className="grid grid-cols-1 gap-4"><div><label className="block text-sm text-gray-600">State</label><select value={preferences.state} onChange={handleStateChange} className="w-full p-2 rounded bg-gray-100 border-gray-300"><option value="">Select State</option>{locations.INDIAN_STATES.map(s => <option key={s} value={s}>{s}</option>)}</select></div><div><label className="block text-sm text-gray-600">District</label><select value={preferences.district} onChange={handleDistrictChange} className="w-full p-2 rounded bg-gray-100 border-gray-300" disabled={!districts.length}><option value="">Select District</option>{districts.map(d => <option key={d} value={d}>{d}</option>)}</select></div></div></div>
                                 </div>
                                 <div className="flex gap-4 pt-8 border-t mt-8"><button onClick={handleSaveAll} disabled={saveLoading} className="flex-1 bg-green-600 hover:bg-green-700 text-white font-bold py-3 px-4 rounded-lg disabled:bg-gray-400">{saveLoading ? 'Saving...' : 'Save Changes'}</button><button onClick={handleCancelEdit} className="flex-1 bg-gray-500 hover:bg-gray-600 text-white font-bold py-3 px-4 rounded-lg">Cancel</button></div>
                            </div>
                        ) : (
                            <div className="bg-white rounded-lg p-6 shadow-md border">
                                <div className="flex items-start">
                                    <div className="w-20 h-20 bg-gray-100 rounded-full flex items-center justify-center mr-5 border-2 border-gray-200">{renderGenderIcon(displayProfile.gender || '', "w-10 h-10 text-gray-500")}</div>
                                    <div className="flex-grow">
                                        <h2 className="text-2xl font-bold text-gray-800">{displayProfile.name}</h2>
                                        <p className="text-sm text-gray-500 mt-1">{displayProfile.phone}</p>
                                        {displayProfile.preferences?.state && <p className="text-sm text-gray-500">{displayProfile.preferences.district}, {displayProfile.preferences.state}</p>}
                                    </div>
                                    <div className="flex flex-col space-y-2">
                                        <button onClick={handleEditClick} className="p-2 rounded-full text-gray-500 hover:text-blue-600 hover:bg-gray-100 transition-colors"><EditIcon className="w-5 h-5" /></button>
                                        <button onClick={onLogout} className="p-2 rounded-full text-gray-500 hover:text-red-600 hover:bg-gray-100 transition-colors"><LogoutIcon className="w-5 h-5" /></button>
                                    </div>
                                </div>
                                <div className="mt-6 pt-6 border-t border-gray-200/80">
                                    <h4 className="font-semibold text-gray-700 mb-3">Favorite Categories</h4>
                                    <div className="flex flex-wrap gap-2">{displayProfile.preferences?.categories?.length ? displayProfile.preferences.categories.map(cat => (<span key={cat} className={'px-3 py-1 text-xs font-medium rounded-full bg-red-700 text-white shadow-sm'}>{cat}</span>)) : <p className="text-sm text-gray-500">No categories selected.</p>}</div>
                                </div>
                            </div>
                        )}
                    </div>
                </div>
            </div>
        </div>
    );
}

export default ProfileScreen;
