---
tipo: ejemplo
componente: Data fetching — loading / error / empty states
recursos:
  - https://ui.shadcn.com/docs/components/skeleton
  - https://tanstack.com/query/latest
lenguajes: [TypeScript, JavaScript]
---

# API Fetch — Patrones de data fetching

Los tres estados siempre presentes: loading, error, vacío. Usar el bloque del lenguaje del proyecto.

Instalar TanStack Query: `npm install @tanstack/react-query`
Instalar SWR: `npm install swr`

## TanStack Query — TypeScript

```tsx
"use client"
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query"
import { Skeleton } from "@/components/ui/skeleton"

interface Post {
  id: string
  title: string
  body: string
}

// Custom hook — lógica de fetching separada del componente
function usePosts() {
  return useQuery<Post[]>({
    queryKey: ["posts"],
    queryFn: async () => {
      const res = await fetch("/api/posts")
      if (!res.ok) throw new Error("Error al cargar posts")
      return res.json()
    },
    staleTime: 1000 * 60 * 5,
  })
}

export function PostList() {
  const { data, isLoading, error } = usePosts()

  if (isLoading)
    return (
      <div className="space-y-3">
        {Array.from({ length: 3 }).map((_, i) => (
          <Skeleton key={i} className="h-20 w-full rounded-lg" />
        ))}
      </div>
    )

  if (error)
    return (
      <div className="text-center py-8">
        <p className="text-destructive">{error.message}</p>
        <button onClick={() => window.location.reload()} className="mt-2 text-sm underline">
          Reintentar
        </button>
      </div>
    )

  if (!data?.length)
    return (
      <div className="text-center py-8 text-muted-foreground">
        No hay posts todavía
      </div>
    )

  return (
    <ul className="space-y-3">
      {data.map((post) => (
        <li key={post.id} className="p-4 border rounded-lg">
          <h3 className="font-medium">{post.title}</h3>
          <p className="text-sm text-muted-foreground">{post.body}</p>
        </li>
      ))}
    </ul>
  )
}
```

## TanStack Query — JavaScript

```jsx
"use client"
import { useQuery } from "@tanstack/react-query"
import { Skeleton } from "@/components/ui/skeleton"

function usePosts() {
  return useQuery({
    queryKey: ["posts"],
    queryFn: async () => {
      const res = await fetch("/api/posts")
      if (!res.ok) throw new Error("Error al cargar posts")
      return res.json()
    },
    staleTime: 1000 * 60 * 5,
  })
}

export function PostList() {
  const { data, isLoading, error } = usePosts()

  if (isLoading)
    return (
      <div className="space-y-3">
        {Array.from({ length: 3 }).map((_, i) => (
          <Skeleton key={i} className="h-20 w-full rounded-lg" />
        ))}
      </div>
    )

  if (error)
    return <p className="text-destructive py-8 text-center">{error.message}</p>

  if (!data?.length)
    return <p className="text-muted-foreground py-8 text-center">No hay posts todavía</p>

  return (
    <ul className="space-y-3">
      {data.map((post) => (
        <li key={post.id} className="p-4 border rounded-lg">
          <h3 className="font-medium">{post.title}</h3>
        </li>
      ))}
    </ul>
  )
}
```

## Next.js Server Component (sin TanStack Query)

```tsx
// app/posts/page.tsx — Server Component, fetch en el servidor
export default async function PostsPage() {
  const res = await fetch(`${process.env.API_URL}/posts`, {
    next: { revalidate: 300 }, // ISR cada 5 min
  })

  if (!res.ok) throw new Error("Error al cargar posts")
  const posts: Post[] = await res.json()

  if (!posts.length) return <p className="text-muted-foreground">Sin posts</p>

  return (
    <ul className="space-y-3">
      {posts.map((p) => (
        <li key={p.id}>{p.title}</li>
      ))}
    </ul>
  )
}
```

## Setup de QueryClient (Next.js)

```tsx
// app/providers.tsx
"use client"
import { QueryClient, QueryClientProvider } from "@tanstack/react-query"
import { useState } from "react"

export function Providers({ children }: { children: React.ReactNode }) {
  const [queryClient] = useState(() => new QueryClient())
  return (
    <QueryClientProvider client={queryClient}>
      {children}
    </QueryClientProvider>
  )
}

// app/layout.tsx
import { Providers } from "./providers"

export default function RootLayout({ children }) {
  return (
    <html>
      <body>
        <Providers>{children}</Providers>
      </body>
    </html>
  )
}
```

## Notas del patrón

- `queryKey` siempre como array — `["posts"]`, `["posts", id]` — nunca string suelto
- Custom hook por recurso — nunca el fetch directo en el componente
- Skeleton con la misma forma del contenido — no spinner genérico
- Error con opción de retry — no solo el mensaje
