---
tipo: ejemplo
componente: Card Grid responsivo
recursos:
  - https://ui.shadcn.com/docs/components/card
  - https://tailwindcss.504b.cc/
lenguajes: [TypeScript, JavaScript]
---

# Card Grid — Grid responsivo 1→2→3 columnas

Patrón de grid con shadcn/ui Card. Escala de 1 col en mobile a 3 en desktop.

Instalar: `npx shadcn@latest add card`

## TypeScript / TSX

```tsx
import {
  Card,
  CardContent,
  CardDescription,
  CardFooter,
  CardHeader,
  CardTitle,
} from "@/components/ui/card"
import { Button } from "@/components/ui/button"
import { Skeleton } from "@/components/ui/skeleton"

interface CardItem {
  id: string
  title: string
  description: string
  meta?: string
}

interface CardGridProps {
  items: CardItem[]
  isLoading?: boolean
  onAction?: (id: string) => void
}

function CardSkeleton() {
  return (
    <Card>
      <CardHeader>
        <Skeleton className="h-5 w-3/4" />
        <Skeleton className="h-4 w-full mt-1" />
      </CardHeader>
      <CardContent>
        <Skeleton className="h-20 w-full" />
      </CardContent>
    </Card>
  )
}

export function CardGrid({ items, isLoading = false, onAction }: CardGridProps) {
  if (isLoading) {
    return (
      <div className="grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-3">
        {Array.from({ length: 6 }).map((_, i) => (
          <CardSkeleton key={i} />
        ))}
      </div>
    )
  }

  if (!items.length) {
    return (
      <div className="py-16 text-center text-muted-foreground">
        No hay elementos para mostrar
      </div>
    )
  }

  return (
    <div className="grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-3">
      {items.map((item) => (
        <Card key={item.id} className="flex flex-col">
          <CardHeader>
            <CardTitle className="line-clamp-1">{item.title}</CardTitle>
            {item.meta && (
              <CardDescription>{item.meta}</CardDescription>
            )}
          </CardHeader>
          <CardContent className="flex-1">
            <p className="text-sm text-muted-foreground line-clamp-3">
              {item.description}
            </p>
          </CardContent>
          {onAction && (
            <CardFooter>
              <Button
                variant="outline"
                className="w-full"
                onClick={() => onAction(item.id)}
              >
                Ver más
              </Button>
            </CardFooter>
          )}
        </Card>
      ))}
    </div>
  )
}
```

## JavaScript / JSX

```jsx
import {
  Card, CardContent, CardDescription,
  CardFooter, CardHeader, CardTitle,
} from "@/components/ui/card"
import { Button } from "@/components/ui/button"
import { Skeleton } from "@/components/ui/skeleton"

function CardSkeleton() {
  return (
    <Card>
      <CardHeader>
        <Skeleton className="h-5 w-3/4" />
        <Skeleton className="h-4 w-full mt-1" />
      </CardHeader>
      <CardContent>
        <Skeleton className="h-20 w-full" />
      </CardContent>
    </Card>
  )
}

export function CardGrid({ items, isLoading = false, onAction }) {
  if (isLoading) {
    return (
      <div className="grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-3">
        {Array.from({ length: 6 }).map((_, i) => <CardSkeleton key={i} />)}
      </div>
    )
  }

  if (!items.length) {
    return (
      <div className="py-16 text-center text-muted-foreground">
        No hay elementos para mostrar
      </div>
    )
  }

  return (
    <div className="grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-3">
      {items.map((item) => (
        <Card key={item.id} className="flex flex-col">
          <CardHeader>
            <CardTitle className="line-clamp-1">{item.title}</CardTitle>
            {item.meta && <CardDescription>{item.meta}</CardDescription>}
          </CardHeader>
          <CardContent className="flex-1">
            <p className="text-sm text-muted-foreground line-clamp-3">
              {item.description}
            </p>
          </CardContent>
          {onAction && (
            <CardFooter>
              <Button variant="outline" className="w-full" onClick={() => onAction(item.id)}>
                Ver más
              </Button>
            </CardFooter>
          )}
        </Card>
      ))}
    </div>
  )
}
```

## Notas del patrón

- `flex flex-col` en la Card + `flex-1` en CardContent — hace todas las cards de igual altura
- `line-clamp-1` y `line-clamp-3` para evitar overflow con texto variable
- Skeleton con la misma estructura que el Card real — evita layout shift al cargar
- Estado vacío siempre explícito — no desaparecer silenciosamente
- Más patrones de cards: https://tailwindcss.504b.cc/
