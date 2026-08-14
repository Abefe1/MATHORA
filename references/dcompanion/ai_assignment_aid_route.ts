import { NextRequest, NextResponse } from 'next/server'
import Anthropic from '@anthropic-ai/sdk'

const anthropic = new Anthropic({ apiKey: process.env.ANTHROPIC_API_KEY })

const SYSTEM_PROMPT = `You are a patient, encouraging math tutor for Nigerian secondary school students (JSS1-SS3).
When given a math problem (text or image), respond ONLY with a JSON object in this exact format:
{
  "problem": "restate the problem clearly",
  "steps": ["step 1 explanation", "step 2 explanation", ...],
  "answer": "the final answer",
  "tips": "a short study tip related to this topic"
}
Always show working step by step. Use simple English. Reference Nigerian curriculum topics.`

export async function POST(req: NextRequest) {
  try {
    const { mode, text, image } = await req.json()

    const userContent: any[] = []

    if (mode === 'image' && image) {
      // image is base64 data URL: "data:image/jpeg;base64,..."
      const [, base64] = image.split(',')
      const mediaType  = image.split(';')[0].split(':')[1] || 'image/jpeg'

      userContent.push({
        type: 'image',
        source: { type: 'base64', media_type: mediaType, data: base64 }
      })
      userContent.push({ type: 'text', text: 'Please solve the math problem in this image.' })
    } else {
      userContent.push({ type: 'text', text: `Please solve this math problem: ${text}` })
    }

    const response = await anthropic.messages.create({
      model:      'claude-opus-4-5',
      max_tokens: 1000,
      system:     SYSTEM_PROMPT,
      messages:   [{ role: 'user', content: userContent }],
    })

    const raw     = response.content[0].type === 'text' ? response.content[0].text : ''
    const cleaned = raw.replace(/```json|```/g, '').trim()
    const parsed  = JSON.parse(cleaned)

    return NextResponse.json(parsed)
  } catch (e: any) {
    return NextResponse.json({ error: e.message }, { status: 500 })
  }
}
