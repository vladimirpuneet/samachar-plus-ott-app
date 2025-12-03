
import React, { useState, useEffect } from 'react';
import { supabase } from '../lib/supabaseClient';
import { updateUserProfile, getUserProfile } from '../utils/api';
import { fetchEnabledLocations } from '../data/locations';
import { NEWS_CATEGORIES } from '../constants';
import type { UserPreferences } from '../types';

interface AuthScreenProps {
    onClose: () => void;
    initialStep?: number;
}

const AuthScreen: React.FC<AuthScreenProps> = ({ onClose, initialStep = 1 }) => {
    const [step, setStep] = useState(initialStep); // 1: SMS auth, 2: Details
    
    // SMS state
    const [phoneNumber, setPhoneNumber] = useState('');
    const [otp, setOtp] = useState('');
    const [verificationId, setVerificationId] = useState('');
    const [otpStep, setOtpStep] = useState(false);
    
    const [error, setError] = useState('');
    const [loading, setLoading] = useState(false);

    const [name, setName] = useState('');
    const [gender, setGender] = useState('other');
    const [preferences, setPreferences] = useState<UserPreferences>({ categories: [], state: '', district: '' });
    const [locations, setLocations] = useState<{ INDIAN_STATES: string[]; INDIAN_STATES_AND_DISTRICTS: { [key: string]: string[] } }>({ INDIAN_STATES: [], INDIAN_STATES_AND_DISTRICTS: {} });
    const [districts, setDistricts] = useState<string[]>([]);

    useEffect(() => {
        fetchEnabledLocations().then(setLocations);
    }, []);

    useEffect(() => {
        if (preferences.state && locations.INDIAN_STATES_AND_DISTRICTS) {
            setDistricts(locations.INDIAN_STATES_AND_DISTRICTS[preferences.state] || []);
        }
    }, [preferences.state, locations]);

    const handleSendOTP = async () => {
        setError('');
        if (!phoneNumber) {
            setError('Please enter your phone number.');
            return;
        }
        
        if (phoneNumber.length !== 10) {
            setError('Please enter a valid 10-digit phone number.');
            return;
        }
        
        setLoading(true);
        try {
            // Use the actual SMS Edge Function
            const response = await fetch(`${import.meta.env.VITE_SUPABASE_URL}/functions/v1/sms-auth`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'Authorization': `Bearer ${import.meta.env.VITE_SUPABASE_ANON_KEY}`,
                    'apikey': import.meta.env.VITE_SUPABASE_ANON_KEY
                },
                body: JSON.stringify({
                    action: 'sendOTP',
                    phoneNumber: phoneNumber,
                    purpose: 'signup'
                })
            });

            const result = await response.json();
            
            if (!result.success) {
                throw new Error(result.error || 'Failed to send OTP');
            }

            setVerificationId(result.verificationId);
            setOtpStep(true);
            setError('');
        } catch (err: any) {
            console.error('Send OTP error:', err);
            if (err.name === 'TypeError' && err.message.includes('fetch')) {
                setError('Unable to connect to authentication service. Please check your internet connection and try again.');
            } else if (err.message.includes('CORS') || err.message.includes('blocked')) {
                setError('Authentication service is temporarily unavailable. Please try again later.');
            } else {
                setError(err.message || 'Failed to send OTP. Please check your phone number and try again.');
            }
        } finally {
            setLoading(false);
        }
    };

    const handleVerifyOTP = async () => {
        setError('');
        if (!otp || otp.length !== 6) {
            setError('Please enter the complete 6-digit OTP.');
            return;
        }
        
        setLoading(true);
        try {
            // Use the actual SMS Edge Function for verification
            const response = await fetch(`${import.meta.env.VITE_SUPABASE_URL}/functions/v1/sms-auth`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'Authorization': `Bearer ${import.meta.env.VITE_SUPABASE_ANON_KEY}`,
                    'apikey': import.meta.env.VITE_SUPABASE_ANON_KEY
                },
                body: JSON.stringify({
                    action: 'verifyOTP',
                    verificationId,
                    otp
                })
            });

            const result = await response.json();
            
            if (!result.verified) {
                throw new Error('Invalid or expired OTP');
            }

            // If this is for registration (no existing user), create account
            if (result.needsRegistration) {
                setStep(2); // Go to profile completion
            } else {
                // User exists, check profile and redirect accordingly
                const { data: { user } } = await supabase.auth.getUser();
                if (user) {
                    const profile = await getUserProfile(user.id);
                    if (profile?.name) {
                        onClose();
                    } else {
                        setStep(2); // Go to profile completion
                    }
                }
            }
        } catch (err: any) {
            setError(err.message || 'OTP verification failed');
            console.error(err);
        } finally {
            setLoading(false);
        }
    };

    const handleResendOTP = async () => {
        if (!verificationId) return;
        
        setLoading(true);
        setError('');

        try {
            // Use the actual SMS Edge Function for resending OTP
            const response = await fetch(`${import.meta.env.VITE_SUPABASE_URL}/functions/v1/sms-auth`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'Authorization': `Bearer ${import.meta.env.VITE_SUPABASE_ANON_KEY}`,
                    'apikey': import.meta.env.VITE_SUPABASE_ANON_KEY
                },
                body: JSON.stringify({
                    action: 'resendOTP',
                    verificationId
                })
            });

            const result = await response.json();
            
            if (!result.success) {
                throw new Error(result.error || 'Failed to resend OTP');
            }

            setError('');
        } catch (err: any) {
            setError(err.message || 'Failed to resend OTP');
            console.error(err);
        } finally {
            setLoading(false);
        }
    };

    const resetToPhoneInput = () => {
        setOtpStep(false);
        setOtp('');
        setVerificationId('');
        setError('');
    };

    const handleProfileSubmit = async () => {
        setError('');
        if (!name.trim()) { setError("Name is required."); return; }
        if (!preferences.state || !preferences.district) { setError("Location is required."); return; }
        setLoading(true);
        try {
            // For SMS auth, we need to create the auth user first
            if (!verificationId) {
                throw new Error("No verification found. Please complete OTP verification first.");
            }

            let user = null;
            
            // For SMS auth, create a temporary password and sign up
            // This is a workaround since Supabase requires password for phone signup
            const tempPassword = `temp_${phoneNumber}_${Date.now()}`;
            const { data, error } = await supabase.auth.signUp({
                phone: `+91${phoneNumber}`,
                password: tempPassword,
                options: {
                    data: {
                        name,
                        phone: `+91${phoneNumber}`
                    }
                }
            });
            if (error) throw error;
            user = data.user;

            if (!user) throw new Error("No authenticated user found.");

            await updateUserProfile(user.id, {
                uid: user.id,
                name,
                gender: gender as 'male' | 'female' | 'other',
                phone: `+91${phoneNumber}`,
                email: user.email || '',
                preferences
            });
            
            // Success! Close the modal
            onClose();
        } catch (err: any) {
            console.error('Profile submission error:', err);
            setError(err.message || 'Failed to save profile.');
        } finally {
            setLoading(false);
        }
    };
    
    const toggleCategory = (cat: string) => setPreferences(p => ({ ...p, categories: p.categories.includes(cat) ? p.categories.filter(c => c !== cat) : [...p.categories, cat] }));
    const handleStateChange = (e: React.ChangeEvent<HTMLSelectElement>) => setPreferences(p => ({ ...p, state: e.target.value, district: '' }));
    const capitalize = (s: string) => s.charAt(0).toUpperCase() + s.slice(1);

    return (
        <div className="fixed inset-0 bg-black bg-opacity-60 backdrop-blur-sm flex justify-center items-center z-50 p-4">
            <div className="bg-white p-8 rounded-2xl shadow-2xl max-w-md w-full m-4 relative">
                <button onClick={onClose} className="absolute top-3 right-3 text-gray-400 hover:text-gray-600">&times;</button>
                {error && <p className="text-red-500 text-sm text-center mb-4 bg-red-100 p-2 rounded">{error}</p>}
                
                {step === 1 && (
                    <div className="space-y-4">
                        <h2 className="text-2xl font-bold text-center">Phone Authentication</h2>
                        
                        {!otpStep ? (
                            // Phone number input
                            <div className="space-y-4">
                                <div>
                                    <label className="block text-sm font-medium">Phone Number</label>
                                    <input
                                        type="tel"
                                        value={phoneNumber}
                                        onChange={(e) => setPhoneNumber(e.target.value.replace(/\D/g, '').slice(0, 10))}
                                        className="w-full mt-1 p-2 border rounded"
                                        placeholder="Enter 10-digit phone number"
                                        maxLength={10}
                                        pattern="[0-9]{10}"
                                    />
                                    <p className="text-xs text-gray-500 mt-1">
                                        We'll send you a 6-digit OTP
                                    </p>
                                </div>
                                <button
                                    onClick={handleSendOTP}
                                    disabled={loading || !phoneNumber || phoneNumber.length !== 10}
                                    className="w-full bg-red-600 text-white p-2 rounded hover:bg-red-700 disabled:bg-gray-400"
                                >
                                    {loading ? 'Sending OTP...' : 'Send OTP'}
                                </button>
                            </div>
                        ) : (
                            // OTP verification
                            <div>
                                <div className="mb-4 text-center">
                                    <p className="text-sm text-gray-600">
                                        OTP sent to {phoneNumber.replace(/(\d{3})(\d{3})(\d{4})/, '$1-$2-$3')}
                                    </p>
                                    <button
                                        type="button"
                                        onClick={resetToPhoneInput}
                                        className="text-red-600 hover:text-red-800 text-sm underline"
                                    >
                                        Change number
                                    </button>
                                </div>
                                
                                <div className="space-y-4">
                                    <div>
                                        <label className="block text-sm font-medium">Enter OTP</label>
                                        <input
                                            type="text"
                                            value={otp}
                                            onChange={(e) => setOtp(e.target.value.replace(/\D/g, '').slice(0, 6))}
                                            className="w-full mt-1 p-2 border rounded text-center text-lg tracking-widest"
                                            placeholder="Enter 6-digit OTP"
                                            maxLength={6}
                                            pattern="[0-9]{6}"
                                        />
                                    </div>
                                    
                                    <button
                                        onClick={handleVerifyOTP}
                                        disabled={loading || otp.length !== 6}
                                        className="w-full bg-green-600 text-white p-2 rounded hover:bg-green-700 disabled:bg-gray-400"
                                    >
                                        {loading ? 'Verifying...' : 'Verify OTP'}
                                    </button>
                                    
                                    <div className="text-center">
                                        <button
                                            type="button"
                                            onClick={handleResendOTP}
                                            disabled={loading}
                                            className="text-red-600 hover:text-red-800 text-sm underline disabled:opacity-50"
                                        >
                                            Resend OTP
                                        </button>
                                    </div>
                                </div>
                            </div>
                        )}
                    </div>
                )}

                {step === 2 && (
                    <div className="space-y-4">
                        <h2 className="text-2xl font-bold text-center">Complete Your Profile</h2>
                        <div><label className="block text-sm font-medium">Full Name</label><input type="text" value={name} onChange={e => setName(e.target.value)} className="w-full mt-1 p-2 border rounded" /></div>
                        <div>
                            <label className="block text-sm font-medium">Gender</label>
                            <div className="flex justify-start space-x-4 p-2 rounded-lg">
                                {(['male', 'female', 'other'] as const).map(g => (
                                    <label key={g} className="flex items-center space-x-2 cursor-pointer"><input type="radio" name="gender" value={g} checked={gender === g} onChange={e => setGender(e.target.value)} className="form-radio h-4 w-4" /><span>{capitalize(g)}</span></label>
                                ))}
                            </div>
                        </div>
                        <div><label className="block text-sm font-medium">State</label><select value={preferences.state} onChange={handleStateChange} className="w-full p-2 border rounded"><option value="">Select</option>{locations.INDIAN_STATES.map(s => <option key={s} value={s}>{s}</option>)}</select></div>
                        <div><label className="block text-sm font-medium">District</label><select value={preferences.district} onChange={e => setPreferences(p => ({ ...p, district: e.target.value }))} className="w-full p-2 border rounded" disabled={!districts.length}><option value="">Select</option>{districts.map(d => <option key={d} value={d}>{d}</option>)}</select></div>
                        <div><h4 className="font-medium">Favorite Categories</h4><div className="flex flex-wrap gap-2 mt-2">{(NEWS_CATEGORIES).map(cat => (<button key={cat} onClick={() => toggleCategory(cat)} className={`px-3 py-1 text-sm rounded-full ${preferences.categories.includes(cat) ? 'bg-red-600 text-white' : 'bg-gray-200'}`}>{cat}</button>))}</div></div>
                        <button onClick={handleProfileSubmit} disabled={loading} className="w-full bg-green-600 text-white p-2 rounded hover:bg-green-700 disabled:bg-gray-400">{loading ? 'Saving...' : 'Save Profile'}</button>
                    </div>
                )}
            </div>
        </div>
    );
};

export default AuthScreen;
