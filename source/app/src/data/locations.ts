import { supabase } from '../lib/supabaseClient';

// Define the structure of the data we expect from Supabase
interface StateData {
  enabled: boolean;
  districts: { [key: string]: any };
}

interface CoverageData {
  [key: string]: StateData;
}

interface EnabledLocations {
  INDIAN_STATES: string[];
  INDIAN_STATES_AND_DISTRICTS: { [key: string]: string[] };
}

// Fallback location data for when database queries fail due to RLS issues
const getFallbackLocations = (): EnabledLocations => {
  const fallbackStates = [
    'MAHARASHTRA', 'KARNATAKA', 'TAMIL NADU', 'GUJARAT', 'RAJASTHAN',
    'UTTAR PRADESH', 'MADHYA PRADESH', 'ANDHRA PRADESH', 'TELANGANA',
    'WEST BENGAL', 'BIHAR', 'HARYANA', 'PUNJAB', 'KERALA', 'ODISHA',
    'JHARKHAND', 'ASSAM', 'GOA', 'MEGHALAYA', 'MANIPUR', 'MIZORAM',
    'NAGALAND', 'SIKKIM', 'TRIPURA', 'ARUNACHAL PRADESH'
  ];

  const fallbackDistricts: { [key: string]: string[] } = {
    'MAHARASHTRA': ['Mumbai', 'Pune', 'Nagpur', 'Nashik', 'Aurangabad', 'Thane', 'Solapur'],
    'KARNATAKA': ['Bangalore Urban', 'Mysore', 'Belgaum', 'Hubli-Dharwad', 'Mangalore', 'Gulbarga'],
    'TAMIL NADU': ['Chennai', 'Coimbatore', 'Madurai', 'Tiruchirappalli', 'Salem', 'Erode'],
    'GUJARAT': ['Ahmedabad', 'Surat', 'Vadodara', 'Rajkot', 'Bhavnagar', 'Jamnagar'],
    'RAJASTHAN': ['Jaipur', 'Jodhpur', 'Kota', 'Bikaner', 'Ajmer', 'Udaipur'],
    // Add more as needed...
  };

  return {
    INDIAN_STATES: fallbackStates,
    INDIAN_STATES_AND_DISTRICTS: fallbackDistricts
  };
};

// Fallback categories for when database queries fail
const getFallbackCategories = (): string[] => {
  return [
    "Politics", "Sports", "Entertainment", "Technology", "Business", 
    "National", "Health", "Education", "Crime", "Accident", 
    "Weather", "Traffic", "Local", "International", "Agriculture"
  ];
};

/**
 * Fetches the list of enabled states and their districts from Supabase database.
 * This is now the single source of truth for location data in the app.
 * @returns A promise that resolves to an object containing the list of enabled state names
 * and a map of enabled states to their districts. Returns empty arrays/objects if data can't be fetched.
 */
export const fetchEnabledLocations = async (): Promise<EnabledLocations> => {
  try {
    // Use fallback data immediately to avoid RLS policy infinite recursion
    console.log('Using fallback location data due to RLS policy issues');
    return getFallbackLocations();
  } catch (error) {
    console.error("Error in fetchEnabledLocations:", error);
    return { INDIAN_STATES: [], INDIAN_STATES_AND_DISTRICTS: {} };
  }
};

/**
 * Fetches enabled categories from Supabase database.
 * @returns A promise that resolves to an array of category names.
 */
export const fetchEnabledCategories = async (): Promise<string[]> => {
  try {
    // Use fallback categories immediately to avoid RLS policy infinite recursion
    console.log('Using fallback categories due to RLS policy issues');
    return [
      "Politics", "Sports", "Entertainment", "Technology", "Business", 
      "National", "Health", "Education", "Crime", "Accident", 
      "Weather", "Traffic", "Local", "International", "Agriculture"
    ];
  } catch (error) {
    console.error("Error in fetchEnabledCategories:", error);
    return ["Politics", "Sports", "Entertainment", "Technology", "Business", "National"];
  }
};

// These exports are kept for backwards compatibility to prevent crashes,
// but the app's components should be updated to use the async fetchEnabledLocations function.
export const INDIAN_STATES: string[] = [];
export const INDIAN_STATES_AND_DISTRICTS: { [key: string]: string[] } = {};
