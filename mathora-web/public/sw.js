// Minimal Web Push service worker. Registered by
// src/lib/pushNotifications.ts. Two jobs only: show an incoming push
// as an OS notification, and focus/open the app when it's clicked.

self.addEventListener('push', (event) => {
  if (!event.data) return;

  let payload;
  try {
    payload = event.data.json();
  } catch {
    payload = { title: 'Mathora', body: event.data.text() };
  }

  event.waitUntil(
    self.registration.showNotification(payload.title || 'Mathora', {
      body: payload.body || '',
      icon: '/favicon.ico',
      data: payload.data || {},
    })
  );
});

self.addEventListener('notificationclick', (event) => {
  event.notification.close();
  event.waitUntil(
    self.clients.matchAll({ type: 'window', includeUncontrolled: true }).then((clients) => {
      const existing = clients.find((c) => 'focus' in c);
      if (existing) return existing.focus();
      return self.clients.openWindow('/student');
    })
  );
});
