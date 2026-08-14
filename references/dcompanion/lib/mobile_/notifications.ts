import * as Notifications from 'expo-notifications'
import * as Device from 'expo-device'
import { Platform } from 'react-native'
import { supabase } from '@/lib/supabase'

// How notifications appear when app is foregrounded
Notifications.setNotificationHandler({
  handleNotification: async () => ({
    shouldShowAlert: true,
    shouldPlaySound: true,
    shouldSetBadge:  true,
  }),
})

export async function registerForPushNotifications(userId: string): Promise<string | null> {
  if (!Device.isDevice) {
    console.log('Push notifications require a physical device')
    return null
  }

  const { status: existingStatus } = await Notifications.getPermissionsAsync()
  let finalStatus = existingStatus

  if (existingStatus !== 'granted') {
    const { status } = await Notifications.requestPermissionsAsync()
    finalStatus = status
  }

  if (finalStatus !== 'granted') return null

  // Android channel
  if (Platform.OS === 'android') {
    await Notifications.setNotificationChannelAsync('live-class', {
      name:        'Live Class Alerts',
      importance:  Notifications.AndroidImportance.MAX,
      vibrationPattern: [0, 250, 250, 250],
      lightColor:  '#42A5F5',
    })
  }

  const token = (await Notifications.getExpoPushTokenAsync()).data

  // Save token to Supabase so server can send targeted pushes
  await supabase.from('push_tokens').upsert({
    user_id: userId,
    token,
    platform: Platform.OS,
    updated_at: new Date().toISOString(),
  })

  return token
}

// Send local notification (e.g. "Class starting in 5 minutes")
export async function scheduleLocalNotification(title: string, body: string, seconds = 1) {
  await Notifications.scheduleNotificationAsync({
    content: { title, body, sound: true },
    trigger: { seconds },
  })
}
