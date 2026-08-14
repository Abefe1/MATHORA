/**
 * useDaily — wrapper around Daily.co REST API + client SDK
 *
 * Usage:
 *   const { createRoom, joinRoom, leaveRoom, callFrame, isJoined } = useDaily()
 */
'use client'
import { useState, useRef, useCallback } from 'react'

interface DailyRoom {
  id: string
  name: string
  url: string
  token?: string
}

export function useDaily() {
  const [isJoined, setIsJoined]     = useState(false)
  const [isLoading, setIsLoading]   = useState(false)
  const [error, setError]           = useState<string | null>(null)
  const callFrameRef                = useRef<any>(null)
  const containerRef                = useRef<HTMLDivElement | null>(null)

  // ─── Create a new Daily room via our API route ─────────────────────────────
  const createRoom = useCallback(async (sessionTitle: string): Promise<DailyRoom | null> => {
    setIsLoading(true)
    setError(null)
    try {
      const res = await fetch('/api/daily/create-room', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ name: sessionTitle.toLowerCase().replace(/\s+/g, '-') }),
      })
      if (!res.ok) throw new Error('Failed to create room')
      return await res.json()
    } catch (e: any) {
      setError(e.message)
      return null
    } finally {
      setIsLoading(false)
    }
  }, [])

  // ─── Join a Daily room in an embedded iframe ────────────────────────────────
  const joinRoom = useCallback(async (roomUrl: string, token?: string, container?: HTMLDivElement) => {
    setIsLoading(true)
    setError(null)

    try {
      // Dynamically import Daily to avoid SSR issues
      const DailyIframe = (await import('@daily-co/daily-js')).default

      const frame = DailyIframe.createFrame(container || document.body, {
        showLeaveButton: true,
        showFullscreenButton: true,
        iframeStyle: {
          position: 'relative',
          width: '100%',
          height: '100%',
          border: 'none',
          borderRadius: '16px',
        },
      })

      callFrameRef.current = frame

      frame.on('joined-meeting',  () => setIsJoined(true))
      frame.on('left-meeting',    () => { setIsJoined(false); frame.destroy() })
      frame.on('error',           (e: any) => setError(e.errorMsg))

      await frame.join({ url: roomUrl, token })
    } catch (e: any) {
      setError(e.message)
    } finally {
      setIsLoading(false)
    }
  }, [])

  const leaveRoom = useCallback(() => {
    callFrameRef.current?.leave()
  }, [])

  return { createRoom, joinRoom, leaveRoom, isJoined, isLoading, error, containerRef }
}
