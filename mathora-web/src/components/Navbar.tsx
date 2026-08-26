'use client';

import React, { useState } from 'react';
import Link from 'next/link';
import { usePathname } from 'next/navigation';
import { UserRole } from '@/lib/types';
import { useTheme } from '@/lib/themeContext';
import { useAuth } from '@/lib/authContext';
import { useOfflineFlush } from '@/lib/useOfflineFlush';
import { DCompanionMark } from '@/components/ui/Primitives';
import { Settings, Sun, Moon, Monitor, ChevronDown, Check, LogOut, CloudOff, RefreshCw } from 'lucide-react';

interface NavItem {
  label: string;
  href: string;
  highlight?: boolean;
  purple?: boolean;
  parentCorner?: boolean;
}

interface NavbarProps {
  currentRole?: UserRole;
  userName?: string;
  onRoleChange?: (role: UserRole) => void;
  onLogout?: () => void;
}

export default function Navbar({ currentRole = 'student', userName = 'Chidiebere Okafor' }: NavbarProps) {
  const pathname = usePathname();
  const { theme, setTheme } = useTheme();
  const { user, signOut } = useAuth();
  const { pendingCount, syncing } = useOfflineFlush();
  const [showRoleDropdown, setShowRoleDropdown] = useState(false);

  const toggleTheme = () => {
    if (theme === 'light') setTheme('dark');
    else if (theme === 'dark') setTheme('system');
    else setTheme('light');
  };

  // Role-specific Navigation Links
  const getNavLinks = (): NavItem[] => {
    switch (currentRole) {
      case 'student':
        return [
          { label: 'Dashboard', href: '/student' },
          { label: 'Lessons', href: '/student/learn' },
          { label: 'Practice', href: '/student/practice', highlight: true },
          { label: 'Mock Exam', href: '/student/mock-exam' },
          { label: 'Why Struggling?', href: '/student/struggling-analysis', purple: true },
          { label: 'Squad Chat', href: '/chat' },
          { label: 'Parent Corner', href: '/parent', parentCorner: true },
          { label: 'Squads', href: '/student/groups' },
        ];
      case 'teacher':
        return [
          { label: 'Teacher Portal', href: '/teacher' },
          { label: 'Classes & Roster', href: '/teacher' },
          { label: 'Question Bank', href: '/admin' },
        ];
      case 'parent':
        return [
          { label: 'Parent Overview', href: '/parent' },
          { label: 'Child Progress', href: '/parent' },
        ];
      default:
        return [
          { label: 'Admin CMS', href: '/admin' },
          { label: 'Curriculum Engine', href: '/admin' },
        ];
    }
  };

  const navLinks = getNavLinks();

  const getRoleLabel = (role: UserRole) => {
    switch (role) {
      case 'student': return 'Student (SS2)';
      case 'teacher': return 'Verified Teacher';
      case 'parent': return 'Parent';
      default: return 'Administrator';
    }
  };

  const getRoleBadgeStyle = (role: UserRole) => {
    switch (role) {
      case 'student': return 'bg-amber-950/80 text-amber-300 border-amber-800/80';
      case 'teacher': return 'bg-emerald-950/80 text-emerald-300 border-emerald-800/80';
      case 'parent': return 'bg-amber-900/60 text-amber-200 border-amber-700/60';
      default: return 'bg-slate-800 text-slate-300 border-slate-700';
    }
  };

  return (
    <header className="sticky top-0 z-50 bg-slate-950/90 backdrop-blur-md border-b border-slate-800/80 font-sans">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 h-16 flex items-center justify-between">
        {/* DCOMPANION Brand Mark */}
        <Link href="/" className="flex items-center gap-3 group">
          <DCompanionMark className="w-8 h-8 text-amber-500 group-hover:scale-105 transition-transform" />
          <div>
            <span className="font-display font-extrabold text-xl tracking-tight text-white block">
              DCOMPANION
            </span>
            <p className="text-[10px] font-mono text-amber-400 tracking-wide font-semibold">
              D-Math Companion
            </p>
          </div>
        </Link>

        {/* Role Navigation */}
        <nav className="hidden md:flex items-center gap-6">
          {navLinks.map((link, idx) => {
            const isActive = pathname === link.href;
            let linkStyle = 'text-xs font-semibold text-slate-300 hover:text-amber-400 transition-colors';

            if (link.highlight) {
              linkStyle = 'text-xs font-bold text-amber-400 flex items-center gap-1';
            } else if (link.purple) {
              linkStyle = 'text-xs font-bold text-cyan-400 transition-colors';
            } else if (link.parentCorner) {
              linkStyle = 'text-xs font-bold px-2.5 py-1 rounded-lg bg-amber-500/10 border border-amber-500/30 text-amber-300 hover:bg-amber-500/20 transition-all';
            }

            if (isActive) {
              linkStyle += ' font-bold text-white underline underline-offset-4 decoration-amber-500';
            }

            return (
              <Link key={idx} href={link.href} className={linkStyle}>
                {link.label}
              </Link>
            );
          })}
        </nav>

        {/* Profile & Theme Switcher */}
        <div className="flex items-center gap-3">
          <button
            onClick={toggleTheme}
            className="p-2 text-slate-400 hover:text-white hover:bg-slate-900 rounded-xl transition-colors"
            title={`Current Theme: ${theme.toUpperCase()}`}
          >
            {theme === 'light' && <Sun className="w-4 h-4 text-amber-400" />}
            {theme === 'dark' && <Moon className="w-4 h-4 text-indigo-400" />}
            {theme === 'system' && <Monitor className="w-4 h-4 text-cyan-400" />}
          </button>

          {/* User Role Badge & Dropdown */}
          <div className="relative">
            <button
              onClick={() => setShowRoleDropdown((prev) => !prev)}
              className="flex items-center gap-2 p-1.5 rounded-xl hover:bg-slate-900 transition-colors"
            >
              <div className="hidden sm:flex flex-col items-end">
                <span className="text-xs font-bold text-white">{userName}</span>
                <span className={`px-2 py-0.5 rounded text-[10px] font-mono font-bold border flex items-center gap-1 ${getRoleBadgeStyle(currentRole)}`}>
                  {getRoleLabel(currentRole)} <ChevronDown className="w-3 h-3" />
                </span>
              </div>
            </button>

            {showRoleDropdown && (
              <div className="absolute right-0 mt-2 w-52 bg-slate-900 rounded-xl shadow-2xl border border-slate-800 py-2 z-50">
                <span className="px-3 py-1 text-[10px] font-mono font-bold uppercase text-slate-400 block">Switch Portal View</span>

                <Link
                  href="/student"
                  onClick={() => setShowRoleDropdown(false)}
                  className="w-full text-left px-3 py-2 text-xs font-semibold hover:bg-slate-800 flex items-center justify-between text-slate-200"
                >
                  Student Notebook {currentRole === 'student' && <Check className="w-3.5 h-3.5 text-amber-400" />}
                </Link>

                <Link
                  href="/teacher"
                  onClick={() => setShowRoleDropdown(false)}
                  className="w-full text-left px-3 py-2 text-xs font-semibold hover:bg-slate-800 flex items-center justify-between text-slate-200"
                >
                  Teacher Ledger {currentRole === 'teacher' && <Check className="w-3.5 h-3.5 text-emerald-400" />}
                </Link>

                <Link
                  href="/parent"
                  onClick={() => setShowRoleDropdown(false)}
                  className="w-full text-left px-3 py-2 text-xs font-semibold hover:bg-slate-800 flex items-center justify-between text-slate-200"
                >
                  Parent Report {currentRole === 'parent' && <Check className="w-3.5 h-3.5 text-amber-400" />}
                </Link>

                <Link
                  href="/admin"
                  onClick={() => setShowRoleDropdown(false)}
                  className="w-full text-left px-3 py-2 text-xs font-semibold hover:bg-slate-800 flex items-center justify-between text-slate-200"
                >
                  Admin CMS {currentRole === 'super_admin' && <Check className="w-3.5 h-3.5 text-slate-400" />}
                </Link>

                {user && (
                  <>
                    <div className="border-t border-slate-800 my-1" />
                    <button
                      onClick={() => {
                        setShowRoleDropdown(false);
                        signOut();
                      }}
                      className="w-full text-left px-3 py-2 text-xs font-semibold hover:bg-slate-800 flex items-center gap-2 text-rose-400"
                    >
                      <LogOut className="w-3.5 h-3.5" /> Sign Out
                    </button>
                  </>
                )}
              </div>
            )}
          </div>

          {pendingCount > 0 && (
            <div
              className="flex items-center gap-1.5 px-2.5 py-1.5 rounded-lg bg-amber-950/60 border border-amber-800/80 text-amber-300 text-[11px] font-mono font-bold"
              title={`${pendingCount} practice attempt${pendingCount === 1 ? '' : 's'} saved offline — will sync when back online`}
            >
              {syncing ? (
                <RefreshCw className="w-3.5 h-3.5 animate-spin" />
              ) : (
                <CloudOff className="w-3.5 h-3.5" />
              )}
              <span>{pendingCount} queued</span>
            </div>
          )}

          <Link href="/student/settings" className="p-2 text-slate-400 hover:text-white rounded-lg">
            <Settings className="w-4 h-4" />
          </Link>
        </div>
      </div>
    </header>
  );
}
