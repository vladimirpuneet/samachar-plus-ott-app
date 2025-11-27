
import { openDB, DBSchema, IDBPDatabase } from 'idb';

interface UserSession {
  uid: string;
}

interface UserSessionDB extends DBSchema {
  'user-session': {
    key: string;
    value: UserSession;
  };
}

let dbPromise: Promise<IDBPDatabase<UserSessionDB>> | null = null;

export const initializeDB = (dbName: string, storeName: string): Promise<IDBPDatabase<UserSessionDB>> => {
  if (!dbPromise) {
    // Bump the version to 3 to force a new upgrade and fix the broken state.
    dbPromise = openDB<UserSessionDB>(dbName, 3, {
      upgrade(db) {
        // A robust check to see if the store exists before trying to create it.
        // This handles all previous broken states.
        if (db.objectStoreNames.contains(storeName)) {
          db.deleteObjectStore(storeName);
        }
        // This is the correct method for creating the object store.
        db.createObjectStore(storeName);
      },
    });
  }
  return dbPromise;
};
