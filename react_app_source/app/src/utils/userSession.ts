
import { initializeDB } from './indexedDB';

const DB_NAME = 'user-session-db';
const STORE_NAME = 'user-session';
const ACTIVE_USER_KEY = 'activeUser';

// 1. Set the active user ID in IndexedDB
export const setActiveUserInDB = async (uid: string): Promise<void> => {
    if (!uid) return;
    try {
        const db = await initializeDB(DB_NAME, STORE_NAME);
        const tx = db.transaction(STORE_NAME, 'readwrite');
        const store = tx.objectStore(STORE_NAME);
        // The key is now passed as a separate argument to put()
        await store.put({ uid }, ACTIVE_USER_KEY);
        await tx.done;
        console.log("User session started in IndexedDB:", uid);
    } catch (error) {
        console.error("Error setting active user in IndexedDB:", error);
    }
};

// 2. Clear the active user ID from IndexedDB
export const clearActiveUserFromDB = async (): Promise<void> => {
    try {
        const db = await initializeDB(DB_NAME, STORE_NAME);
        const tx = db.transaction(STORE_NAME, 'readwrite');
        const store = tx.objectStore(STORE_NAME);
        // The key is passed as an argument to delete()
        await store.delete(ACTIVE_USER_KEY);
        await tx.done;
        console.log("User session cleared from IndexedDB.");
    } catch (error) {
        console.error("Error clearing active user from IndexedDB:", error);
    }
};

// 3. Get the active user ID from IndexedDB
export const getActiveUserId = async (): Promise<string | null> => {
    try {
        const db = await initializeDB(DB_NAME, STORE_NAME);
        const tx = db.transaction(STORE_NAME, 'readonly');
        const store = tx.objectStore(STORE_NAME);
        // The key is passed as an argument to get()
        const user = await store.get(ACTIVE_USER_KEY);
        await tx.done;
        return user ? user.uid : null;
    } catch (error) {
        console.error("Error getting active user from IndexedDB:", error);
        return null;
    }
};
