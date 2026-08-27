import AsyncStorage from '@react-native-async-storage/async-storage';

interface CacheEnvelope<T> {
  data: T;
  timestamp: number;
  ttlMs: number;
}

/**
 * Set an item in AsyncStorage with a Time-To-Live (TTL) in milliseconds.
 * Default TTL: 24 hours (86,400,000 ms).
 */
export async function setCacheItem<T>(key: string, value: T, ttlMs = 86400000): Promise<void> {
  try {
    const envelope: CacheEnvelope<T> = {
      data: value,
      timestamp: Date.now(),
      ttlMs,
    };
    await AsyncStorage.setItem(key, JSON.stringify(envelope));
  } catch (error) {
    console.warn(`[Cache] Failed to save key: ${key}`, error);
  }
}

/**
 * Get an item from AsyncStorage. Returns null if key doesn't exist or TTL expired.
 */
export async function getCacheItem<T>(key: string): Promise<T | null> {
  try {
    const raw = await AsyncStorage.getItem(key);
    if (!raw) return null;

    const envelope: CacheEnvelope<T> = JSON.parse(raw);
    const now = Date.now();

    if (now - envelope.timestamp > envelope.ttlMs) {
      // TTL expired -> clear and return null
      await AsyncStorage.removeItem(key);
      return null;
    }

    return envelope.data;
  } catch (error) {
    console.warn(`[Cache] Failed to read key: ${key}`, error);
    return null;
  }
}

/**
 * Clear a cached key explicitly.
 */
export async function removeCacheItem(key: string): Promise<void> {
  try {
    await AsyncStorage.removeItem(key);
  } catch (error) {
    console.warn(`[Cache] Failed to remove key: ${key}`, error);
  }
}
