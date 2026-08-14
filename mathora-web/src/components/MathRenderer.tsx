'use client';

import React from 'react';
import katex from 'katex';
import 'katex/dist/katex.min.css';

interface MathRendererProps {
  content: string;
  className?: string;
}

export default function MathRenderer({ content, className = '' }: MathRendererProps) {
  if (!content) return null;

  // Function to split text and render inline ($...$) and block ($$...$$) math
  const renderFormattedText = (text: string) => {
    // Regex for block math ($$...$$) and inline math ($...$)
    const parts: React.ReactNode[] = [];
    const regex = /(\$\$[\s\S]+?\$\$|\$[^$\n]+?\$)/g;

    let lastIndex = 0;
    let match;

    while ((match = regex.exec(text)) !== null) {
      // Push text before match
      if (match.index > lastIndex) {
        const plainText = text.substring(lastIndex, match.index);
        parts.push(<span key={`text-${lastIndex}`}>{plainText}</span>);
      }

      const matchStr = match[0];
      const isBlock = matchStr.startsWith('$$') && matchStr.endsWith('$$');
      const mathExpr = isBlock
        ? matchStr.substring(2, matchStr.length - 2)
        : matchStr.substring(1, matchStr.length - 1);

      try {
        const html = katex.renderToString(mathExpr, {
          displayMode: isBlock,
          throwOnError: false
        });

        parts.push(
          <span
            key={`math-${match.index}`}
            className={isBlock ? 'block my-3 text-center text-indigo-900 font-semibold' : 'inline-block px-1 font-semibold text-indigo-950'}
            dangerouslySetInnerHTML={{ __html: html }}
          />
        );
      } catch (err) {
        parts.push(<code key={`err-${match.index}`} className="text-red-500">{matchStr}</code>);
      }

      lastIndex = regex.lastIndex;
    }

    if (lastIndex < text.length) {
      parts.push(<span key={`text-${lastIndex}`}>{text.substring(lastIndex)}</span>);
    }

    return parts;
  };

  return (
    <div className={`prose prose-indigo max-w-none dark:prose-invert ${className}`}>
      {content.split('\n').map((line, idx) => (
        <p key={idx} className="mb-2 leading-relaxed">
          {renderFormattedText(line)}
        </p>
      ))}
    </div>
  );
}
