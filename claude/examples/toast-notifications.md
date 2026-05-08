---
tipo: ejemplo
componente: Toast notifications — Sonner
recursos:
  - https://ui.shadcn.com/docs/components/sonner
lenguajes: [TypeScript, JavaScript]
---

# Toast Notifications — Sonner

shadcn/ui usa Sonner por defecto desde 2024. El patrón es el mismo en TS y JS — solo cambia si usás tipos explícitos en el callback.

Instalar: `npx shadcn@latest add sonner`

## Setup (una vez por proyecto)

```tsx
// app/layout.tsx — agregar Toaster al root layout
import { Toaster } from "@/components/ui/sonner"

export default function RootLayout({ children }) {
  return (
    <html>
      <body>
        {children}
        <Toaster position="bottom-right" richColors />
      </body>
    </html>
  )
}
```

## Tipos de toast — TypeScript / JavaScript

```tsx
import { toast } from "sonner"

// Éxito
toast.success("Guardado correctamente")

// Error
toast.error("No se pudo guardar. Intentá de nuevo.")

// Info
toast.info("Tu sesión expira en 5 minutos")

// Warning
toast.warning("Cambios sin guardar")

// Toast con descripción
toast.success("Usuario creado", {
  description: "Le enviamos un email de bienvenida",
})

// Toast con acción
toast("Elemento eliminado", {
  action: {
    label: "Deshacer",
    onClick: () => restoreItem(),
  },
})

// Toast de carga → resultado (promise)
toast.promise(saveData(), {
  loading: "Guardando...",
  success: "Guardado correctamente",
  error: "No se pudo guardar",
})
```

## Integración con mutación de API

TypeScript:
```tsx
import { useMutation, useQueryClient } from "@tanstack/react-query"
import { toast } from "sonner"

export function useCreatePost() {
  const queryClient = useQueryClient()

  return useMutation({
    mutationFn: (data: CreatePostInput) =>
      fetch("/api/posts", {
        method: "POST",
        body: JSON.stringify(data),
        headers: { "Content-Type": "application/json" },
      }).then((r) => r.json()),

    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["posts"] })
      toast.success("Post creado")
    },

    onError: (error: Error) => {
      toast.error(error.message || "Error al crear el post")
    },
  })
}
```

JavaScript:
```jsx
import { useMutation, useQueryClient } from "@tanstack/react-query"
import { toast } from "sonner"

export function useCreatePost() {
  const queryClient = useQueryClient()

  return useMutation({
    mutationFn: (data) =>
      fetch("/api/posts", {
        method: "POST",
        body: JSON.stringify(data),
        headers: { "Content-Type": "application/json" },
      }).then((r) => r.json()),

    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["posts"] })
      toast.success("Post creado")
    },

    onError: (error) => {
      toast.error(error.message || "Error al crear el post")
    },
  })
}
```

## Integración con form submit

```tsx
async function onSubmit(values) {
  const toastId = toast.loading("Guardando...")
  try {
    await saveData(values)
    toast.success("Guardado", { id: toastId })
  } catch (err) {
    toast.error("Error al guardar", { id: toastId })
  }
}
```

## Notas del patrón

- `toast.promise()` es la forma más limpia para operaciones async — maneja los 3 estados automáticamente
- `id` en el toast permite reemplazar el toast de loading con el resultado
- `richColors` en `<Toaster>` — verde para success, rojo para error, sin configuración extra
- `position="bottom-right"` — estándar; `top-center` para mensajes importantes
- Referencia: https://ui.shadcn.com/docs/components/sonner
