import './globals.css'
import type { Metadata } from 'next'

export const metadata: Metadata = {
  title: 'ContribPortal',
  description: 'A platform for discovering open source contribution opportunities',
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="en">
      <body className="font-sans">
        <main className="min-h-screen bg-gradient-to-br from-blue-50 to-indigo-100">
          {children}
        </main>
      </body>
    </html>
  )
}