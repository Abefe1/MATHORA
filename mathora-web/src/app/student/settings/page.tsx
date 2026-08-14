'use client';

import React, { useState } from 'react';
import Navbar from '@/components/Navbar';
import { useTheme, ThemeType } from '@/lib/themeContext';
import { Settings, Bell, MessageSquare, ShieldCheck, Wifi, Eye, Sun, Moon, Monitor } from 'lucide-react';

export default function SettingsPage() {
  const { theme, setTheme } = useTheme();
  const [whatsappEnabled, setWhatsappEnabled] = useState(true);
  const [notificationWindow, setNotificationWindow] = useState('afternoon');
  const [lowDataMode, setLowDataMode] = useState(true);
  const [fontSize, setFontSize] = useState('medium');

  return (
    <div className="min-h-screen bg-slate-50 dark:bg-slate-950 text-slate-900 dark:text-slate-100 flex flex-col">
      <Navbar currentRole="student" userName="Chidiebere Okafor" />

      <main className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-8 w-full">
        <div className="mb-8">
          <div className="inline-flex items-center gap-1.5 px-3 py-1 rounded-full bg-slate-200 dark:bg-slate-800 text-slate-700 dark:text-slate-300 text-xs font-semibold mb-2">
            <Settings className="w-3.5 h-3.5" /> Account, Theme & Accessibility Settings
          </div>
          <h1 className="text-2xl sm:text-3xl font-extrabold text-slate-900 dark:text-white">
            Preferences & Theme Configuration
          </h1>
        </div>

        <div className="space-y-6">
          {/* Theme Type Selection */}
          <div className="glass-card rounded-3xl p-6 border border-slate-200 dark:border-slate-800">
            <div className="flex items-center gap-3 mb-4">
              <Sun className="w-5 h-5 text-amber-500" />
              <h2 className="text-lg font-bold text-slate-900 dark:text-white">Appearance & Theme Type</h2>
            </div>

            <p className="text-xs text-slate-500 mb-4">
              Choose your preferred visual theme for studying math equations and worked solutions.
            </p>

            <div className="grid grid-cols-3 gap-4">
              <button
                onClick={() => setTheme('light')}
                className={`p-4 rounded-2xl border-2 transition-all flex flex-col items-center gap-2 ${
                  theme === 'light'
                    ? 'border-indigo-600 bg-indigo-50/50 text-indigo-900 font-bold shadow-sm'
                    : 'border-slate-200 dark:border-slate-800 bg-white dark:bg-slate-900 text-slate-700 dark:text-slate-300'
                }`}
              >
                <Sun className="w-6 h-6 text-amber-500" />
                <span className="text-xs">Light Mode</span>
              </button>

              <button
                onClick={() => setTheme('dark')}
                className={`p-4 rounded-2xl border-2 transition-all flex flex-col items-center gap-2 ${
                  theme === 'dark'
                    ? 'border-indigo-600 bg-indigo-950/60 text-indigo-100 font-bold shadow-sm'
                    : 'border-slate-200 dark:border-slate-800 bg-white dark:bg-slate-900 text-slate-700 dark:text-slate-300'
                }`}
              >
                <Moon className="w-6 h-6 text-indigo-400" />
                <span className="text-xs">Dark Mode</span>
              </button>

              <button
                onClick={() => setTheme('system')}
                className={`p-4 rounded-2xl border-2 transition-all flex flex-col items-center gap-2 ${
                  theme === 'system'
                    ? 'border-indigo-600 bg-indigo-50/50 dark:bg-indigo-950/60 text-indigo-900 dark:text-indigo-100 font-bold shadow-sm'
                    : 'border-slate-200 dark:border-slate-800 bg-white dark:bg-slate-900 text-slate-700 dark:text-slate-300'
                }`}
              >
                <Monitor className="w-6 h-6 text-cyan-500" />
                <span className="text-xs">System Default</span>
              </button>
            </div>
          </div>

          {/* WhatsApp & Notification Settings */}
          <div className="glass-card rounded-3xl p-6 border border-slate-200 dark:border-slate-800">
            <div className="flex items-center gap-3 mb-4">
              <MessageSquare className="w-5 h-5 text-emerald-500" />
              <h2 className="text-lg font-bold text-slate-900 dark:text-white">WhatsApp & Alert Channels</h2>
            </div>

            <div className="space-y-4">
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-sm font-bold text-slate-800 dark:text-slate-200">WhatsApp Notification Channel</p>
                  <p className="text-xs text-slate-500">Receive streak-at-risk alerts and assignment reminders via WhatsApp</p>
                </div>
                <input
                  type="checkbox"
                  checked={whatsappEnabled}
                  onChange={(e) => setWhatsappEnabled(e.target.checked)}
                  className="w-5 h-5 accent-indigo-600 rounded cursor-pointer"
                />
              </div>

              <div>
                <label className="block text-xs font-bold uppercase text-slate-500 mb-1">Notification Delivery Window</label>
                <select
                  value={notificationWindow}
                  onChange={(e) => setNotificationWindow(e.target.value)}
                  className="w-full max-w-xs px-4 py-2.5 rounded-xl border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-900 text-sm"
                >
                  <option value="morning">Morning (7:00 AM - 9:00 AM)</option>
                  <option value="afternoon">Afternoon (4:00 PM - 6:00 PM)</option>
                  <option value="evening">Evening (7:00 PM - 9:00 PM)</option>
                  <option value="off">Turn Off Notifications</option>
                </select>
              </div>
            </div>
          </div>

          {/* Low-Data & Accessibility */}
          <div className="glass-card rounded-3xl p-6 border border-slate-200 dark:border-slate-800">
            <div className="flex items-center gap-3 mb-4">
              <Wifi className="w-5 h-5 text-cyan-500" />
              <h2 className="text-lg font-bold text-slate-900 dark:text-white">Nigerian Connectivity & Accessibility</h2>
            </div>

            <div className="space-y-4">
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-sm font-bold text-slate-800 dark:text-slate-200">Low-Data Mode</p>
                  <p className="text-xs text-slate-500">Compress diagram resolution and defer audio downloads until Wi-Fi</p>
                </div>
                <input
                  type="checkbox"
                  checked={lowDataMode}
                  onChange={(e) => setLowDataMode(e.target.checked)}
                  className="w-5 h-5 accent-indigo-600 rounded cursor-pointer"
                />
              </div>

              <div>
                <label className="block text-xs font-bold uppercase text-slate-500 mb-1">Math Text Scale (Accessibility)</label>
                <select
                  value={fontSize}
                  onChange={(e) => setFontSize(e.target.value)}
                  className="w-full max-w-xs px-4 py-2.5 rounded-xl border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-900 text-sm"
                >
                  <option value="normal">Standard Font Size</option>
                  <option value="medium">Medium Scaled (+15%)</option>
                  <option value="large">Large Scaled (+30%)</option>
                </select>
              </div>
            </div>
          </div>
        </div>
      </main>
    </div>
  );
}
