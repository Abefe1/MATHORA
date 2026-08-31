'use client';

import React, { useState } from 'react';
import Navbar from '@/components/Navbar';
import { Card, Badge, Button } from '@/components/ui/Primitives';
import { 
  MessageSquare, 
  Send, 
  Users, 
  Hash, 
  ShieldCheck
} from 'lucide-react';

interface ChatMessage {
  id: string;
  senderName: string;
  senderRole: 'student' | 'teacher' | 'parent';
  avatarColor: string;
  content: string;
  timestamp: string;
  isVerifiedTeacher?: boolean;
}

interface ChatChannel {
  id: string;
  name: string;
  category: string;
  unreadCount: number;
  description: string;
  messages: ChatMessage[];
}

const mockChannels: ChatChannel[] = [
  {
    id: 'ch-squad-ss2',
    name: 'SS2 Math Champions Squad',
    category: 'Study Squad',
    unreadCount: 2,
    description: 'Collaborative group solving WAEC & BECE past questions together.',
    messages: [
      {
        id: 'm1',
        senderName: 'Chidiebere Okafor',
        senderRole: 'student',
        avatarColor: 'bg-amber-500',
        content: 'Has anyone solved Question 4b on Quadratic Factorization from the 2024 WAEC mock?',
        timestamp: '10:14 AM',
      },
      {
        id: 'm2',
        senderName: 'Mr. Olanrewaju Bello',
        senderRole: 'teacher',
        avatarColor: 'bg-emerald-500',
        content: 'Remember to complete the square first or check if $b^2 - 4ac > 0$ before factoring!',
        timestamp: '10:16 AM',
        isVerifiedTeacher: true,
      },
      {
        id: 'm3',
        senderName: 'Aminat Yusuf',
        senderRole: 'student',
        avatarColor: 'bg-indigo-500',
        content: 'Ah thanks Mr. Bello! I got $x = 2$ and $x = 3$.',
        timestamp: '10:18 AM',
      },
    ],
  },
  {
    id: 'ch-trig-help',
    name: 'Trigonometry & Geometry Help',
    category: 'Subject Channel',
    unreadCount: 0,
    description: 'Sine, Cosine rules, Bearings, and Elevation Q&A.',
    messages: [
      {
        id: 'm4',
        senderName: 'Nneka Okafor',
        senderRole: 'student',
        avatarColor: 'bg-purple-500',
        content: 'How do I memorize $\\sin 30^\\circ$ without a calculator for BECE?',
        timestamp: '9:30 AM',
      },
      {
        id: 'm5',
        senderName: 'Mrs. Cynthia Agbo',
        senderRole: 'teacher',
        avatarColor: 'bg-cyan-500',
        content: 'Use the $30^\\circ-60^\\circ-90^\\circ$ special triangle! $\\sin 30^\\circ = 1/2 = 0.5$.',
        timestamp: '9:35 AM',
        isVerifiedTeacher: true,
      },
    ],
  },
];

export default function ChatPage() {
  const [channels, setChannels] = useState<ChatChannel[]>(mockChannels);
  const [activeChannelId, setActiveChannelId] = useState<string>('ch-squad-ss2');
  const [messageInput, setMessageInput] = useState('');

  const activeChannel = channels.find((c) => c.id === activeChannelId) || channels[0];

  const handleSendMessage = (e: React.FormEvent) => {
    e.preventDefault();
    if (!messageInput.trim()) return;

    const newMessage: ChatMessage = {
      id: `msg-${Date.now()}`,
      senderName: 'Chidiebere Okafor (You)',
      senderRole: 'student',
      avatarColor: 'bg-amber-500',
      content: messageInput,
      timestamp: new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' }),
    };

    setChannels((prev) =>
      prev.map((c) => (c.id === activeChannelId ? { ...c, messages: [...c.messages, newMessage] } : c))
    );

    setMessageInput('');
  };

  return (
    <div className="min-h-screen bg-slate-50 dark:bg-slate-950 text-slate-900 dark:text-slate-100 flex flex-col font-sans selection:bg-amber-500 selection:text-slate-950">
      <Navbar currentRole="student" userName="Chidiebere Okafor" />

      <main className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8 w-full flex-grow flex flex-col">
        {/* Top Header */}
        <div className="flex items-center justify-between gap-4 mb-6 bg-slate-900/80 p-5 rounded-2xl border border-slate-200 dark:border-slate-800 backdrop-blur-md">
          <div className="flex items-center gap-3">
            <div className="w-12 h-12 rounded-xl bg-indigo-500/10 border border-indigo-500/30 flex items-center justify-center text-indigo-600 dark:text-indigo-400">
              <MessageSquare className="w-6 h-6 text-indigo-600 dark:text-indigo-400" />
            </div>
            <div>
              <div className="flex items-center gap-2">
                <Badge variant="bece">Real-Time Messaging</Badge>
                <span className="text-[11px] font-mono text-emerald-600 dark:text-emerald-400 flex items-center gap-1">
                  <ShieldCheck className="w-3.5 h-3.5" /> DCOMPANION Squad Channels
                </span>
              </div>
              <h1 className="text-xl sm:text-2xl font-display font-extrabold text-slate-900 dark:text-white mt-0.5">
                Math Squad &amp; Teacher Live Chat
              </h1>
            </div>
          </div>

          <span className="text-xs font-mono text-slate-500 dark:text-slate-400 hidden sm:inline-block">
            Connected as <strong className="text-amber-600 dark:text-amber-400">Chidiebere Okafor (SS2)</strong>
          </span>
        </div>

        {/* Chat Interface Grid */}
        <div className="grid grid-cols-1 lg:grid-cols-4 gap-6 flex-grow items-stretch">
          {/* Sidebar Channels List */}
          <Card variant="paper" className="p-4 flex flex-col space-y-4 lg:col-span-1">
            <div className="flex items-center justify-between pb-3 border-b border-slate-200 dark:border-slate-800">
              <span className="text-xs font-mono font-bold text-slate-500 dark:text-slate-400 uppercase tracking-wider flex items-center gap-1.5">
                <Users className="w-4 h-4 text-amber-600 dark:text-amber-400" /> Study Squads
              </span>
              <span className="text-[10px] font-mono bg-slate-100 dark:bg-slate-800 text-slate-600 dark:text-slate-300 px-2 py-0.5 rounded">
                {channels.length} Channels
              </span>
            </div>

            <div className="space-y-2 font-mono flex-grow overflow-y-auto">
              {channels.map((ch) => (
                <button
                  key={ch.id}
                  onClick={() => setActiveChannelId(ch.id)}
                  className={`w-full text-left p-3 rounded-xl transition-all border ${
                    activeChannelId === ch.id
                      ? 'bg-amber-500/10 border-amber-500/40 text-slate-900 dark:text-white shadow-md'
                      : 'bg-slate-900/60 border-slate-800/80 text-slate-500 dark:text-slate-400 hover:bg-slate-100 dark:hover:bg-slate-900 hover:text-slate-900 dark:hover:text-slate-200'
                  }`}
                >
                  <div className="flex items-center justify-between">
                    <span className="text-xs font-bold font-sans text-slate-900 dark:text-slate-100 flex items-center gap-1.5 truncate">
                      <Hash className="w-3.5 h-3.5 text-amber-600 dark:text-amber-400 shrink-0" />
                      {ch.name}
                    </span>
                    {ch.unreadCount > 0 && (
                      <span className="text-[10px] font-bold bg-amber-500 text-slate-950 px-1.5 py-0.5 rounded-full">
                        {ch.unreadCount}
                      </span>
                    )}
                  </div>
                  <span className="text-[10px] text-slate-500 block mt-1 truncate">{ch.description}</span>
                </button>
              ))}
            </div>
          </Card>

          {/* Main Chat Feed */}
          <Card variant="paper" className="p-6 flex flex-col lg:col-span-3 space-y-4 min-h-[500px]">
            {/* Active Channel Top Bar */}
            <div className="flex items-center justify-between pb-4 border-b border-slate-200 dark:border-slate-800 font-mono">
              <div className="flex items-center gap-3">
                <Hash className="w-5 h-5 text-amber-600 dark:text-amber-400" />
                <div>
                  <h2 className="text-base font-display font-bold text-slate-900 dark:text-white font-sans">{activeChannel.name}</h2>
                  <p className="text-xs text-slate-500 dark:text-slate-400">{activeChannel.description}</p>
                </div>
              </div>

              <span className="text-xs text-emerald-600 dark:text-emerald-400 bg-emerald-50 dark:bg-emerald-950 px-2.5 py-1 rounded-md border border-emerald-200 dark:border-emerald-800 flex items-center gap-1">
                <span className="w-2 h-2 rounded-full bg-emerald-400 animate-pulse" /> Live Realtime
              </span>
            </div>

            {/* Messages Scroll Feed */}
            <div className="flex-grow space-y-4 overflow-y-auto pr-2 font-mono">
              {activeChannel.messages.map((msg) => (
                <div key={msg.id} className="flex items-start gap-3">
                  <div className={`w-9 h-9 rounded-full ${msg.avatarColor} flex items-center justify-center font-bold text-slate-950 text-xs shrink-0 shadow-md`}>
                    {msg.senderName.charAt(0)}
                  </div>
                  <div className="flex-grow bg-slate-900/90 border border-slate-200 dark:border-slate-800 rounded-2xl p-3.5">
                    <div className="flex items-center justify-between mb-1">
                      <div className="flex items-center gap-2">
                        <span className="text-xs font-bold text-slate-800 dark:text-slate-200 font-sans">{msg.senderName}</span>
                        {msg.isVerifiedTeacher && (
                          <Badge variant="verified">Verified Teacher</Badge>
                        )}
                      </div>
                      <span className="text-[10px] text-slate-500">{msg.timestamp}</span>
                    </div>
                    <p className="text-xs text-slate-600 dark:text-slate-300 leading-relaxed font-sans mt-1">{msg.content}</p>
                  </div>
                </div>
              ))}
            </div>

            {/* Message Input Box */}
            <form onSubmit={handleSendMessage} className="pt-4 border-t border-slate-200 dark:border-slate-800 font-mono flex items-center gap-3">
              <input
                type="text"
                value={messageInput}
                onChange={(e) => setMessageInput(e.target.value)}
                placeholder={`Message #${activeChannel.name}...`}
                className="flex-grow bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-xl px-4 py-3 text-xs text-slate-900 dark:text-white placeholder-slate-500 focus:outline-none focus:border-amber-500 transition-colors"
              />

              <Button variant="primary" size="md" type="submit" className="shrink-0">
                Send <Send className="w-3.5 h-3.5" />
              </Button>
            </form>
          </Card>
        </div>
      </main>
    </div>
  );
}
