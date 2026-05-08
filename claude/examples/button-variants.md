---
tipo: ejemplo
componente: Button
recursos:
  - https://ui.shadcn.com/docs/components/button
  - https://tailwindcss.504b.cc/
lenguajes: [TypeScript, JavaScript]
---

# Button — Variantes y estado de carga

Extender el Button de shadcn/ui con loading state. Usar el bloque del lenguaje del proyecto (guardado en `~/.claude/memory/design-systems/[proyecto].md`).

Instalar: `npx shadcn@latest add button`
Referencia visual extra: https://tailwindcss.504b.cc/

## TypeScript / TSX

```tsx
import { Button } from "@/components/ui/button"
import { Loader2 } from "lucide-react"
import { cn } from "@/lib/utils"

interface CustomButtonProps extends React.ComponentProps<typeof Button> {
  loading?: boolean
}

export function CustomButton({
  loading = false,
  disabled,
  className,
  children,
  ...props
}: CustomButtonProps) {
  return (
    <Button
      disabled={disabled || loading}
      className={cn("gap-2", className)}
      {...props}
    >
      {loading && <Loader2 className="size-4 animate-spin" />}
      {children}
    </Button>
  )
}

// Showcase de variantes
export function ButtonShowcase() {
  return (
    <div className="flex flex-wrap gap-3">
      <CustomButton>Primary</CustomButton>
      <CustomButton variant="secondary">Secondary</CustomButton>
      <CustomButton variant="outline">Outline</CustomButton>
      <CustomButton variant="ghost">Ghost</CustomButton>
      <CustomButton variant="destructive">Destructive</CustomButton>
      <CustomButton variant="link">Link</CustomButton>
      <CustomButton loading>Guardando...</CustomButton>
    </div>
  )
}
```

## JavaScript / JSX

```jsx
import { Button } from "@/components/ui/button"
import { Loader2 } from "lucide-react"
import { cn } from "@/lib/utils"

export function CustomButton({
  loading = false,
  disabled,
  className,
  children,
  ...props
}) {
  return (
    <Button
      disabled={disabled || loading}
      className={cn("gap-2", className)}
      {...props}
    >
      {loading && <Loader2 className="size-4 animate-spin" />}
      {children}
    </Button>
  )
}

export function ButtonShowcase() {
  return (
    <div className="flex flex-wrap gap-3">
      <CustomButton>Primary</CustomButton>
      <CustomButton variant="secondary">Secondary</CustomButton>
      <CustomButton variant="outline">Outline</CustomButton>
      <CustomButton variant="ghost">Ghost</CustomButton>
      <CustomButton variant="destructive">Destructive</CustomButton>
      <CustomButton variant="link">Link</CustomButton>
      <CustomButton loading>Guardando...</CustomButton>
    </div>
  )
}
```

## Notas del patrón

- El `loading` desactiva el botón — nunca dejar clickeable mientras procesa
- `cn()` para merge de clases sin conflictos con Tailwind
- No hardcodear colores: `variant` y `className` con tokens del design system
- Consultar https://ui.shadcn.com/docs/components/button para variantes adicionales
