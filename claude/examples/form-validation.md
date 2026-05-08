---
tipo: ejemplo
componente: Form con validación
recursos:
  - https://ui.shadcn.com/docs/components/form
  - https://ui.shadcn.com/docs/components/input
lenguajes: [TypeScript, JavaScript]
---

# Form con validación

Patrón con react-hook-form + shadcn/ui Form.
- **TypeScript**: usa Zod para schema y tipos inferidos
- **JavaScript**: usa `rules` nativas de react-hook-form, sin Zod

Instalar: `npx shadcn@latest add form input`
Referencia: https://ui.shadcn.com/docs/components/form

## TypeScript / TSX

```tsx
"use client"
import { useForm } from "react-hook-form"
import { zodResolver } from "@hookform/resolvers/zod"
import { z } from "zod"
import {
  Form, FormControl, FormField,
  FormItem, FormLabel, FormMessage
} from "@/components/ui/form"
import { Input } from "@/components/ui/input"
import { Button } from "@/components/ui/button"

const schema = z.object({
  email: z.string().email("Email inválido"),
  password: z.string().min(8, "Mínimo 8 caracteres"),
})

type FormValues = z.infer<typeof schema>

export function LoginForm() {
  const form = useForm<FormValues>({
    resolver: zodResolver(schema),
    defaultValues: { email: "", password: "" },
  })

  async function onSubmit(values: FormValues) {
    // llamar API aquí
  }

  return (
    <Form {...form}>
      <form onSubmit={form.handleSubmit(onSubmit)} className="space-y-4">
        <FormField
          control={form.control}
          name="email"
          render={({ field }) => (
            <FormItem>
              <FormLabel>Email</FormLabel>
              <FormControl>
                <Input type="email" placeholder="tu@email.com" {...field} />
              </FormControl>
              <FormMessage />
            </FormItem>
          )}
        />
        <FormField
          control={form.control}
          name="password"
          render={({ field }) => (
            <FormItem>
              <FormLabel>Contraseña</FormLabel>
              <FormControl>
                <Input type="password" {...field} />
              </FormControl>
              <FormMessage />
            </FormItem>
          )}
        />
        <Button
          type="submit"
          className="w-full"
          disabled={form.formState.isSubmitting}
        >
          {form.formState.isSubmitting ? "Iniciando..." : "Iniciar sesión"}
        </Button>
      </form>
    </Form>
  )
}
```

## JavaScript / JSX

```jsx
"use client"
import { useForm } from "react-hook-form"
import {
  Form, FormControl, FormField,
  FormItem, FormLabel, FormMessage
} from "@/components/ui/form"
import { Input } from "@/components/ui/input"
import { Button } from "@/components/ui/button"

export function LoginForm() {
  const form = useForm({
    defaultValues: { email: "", password: "" },
  })

  async function onSubmit(values) {
    // llamar API aquí
  }

  return (
    <Form {...form}>
      <form onSubmit={form.handleSubmit(onSubmit)} className="space-y-4">
        <FormField
          control={form.control}
          name="email"
          rules={{
            required: "El email es obligatorio",
            pattern: { value: /\S+@\S+\.\S+/, message: "Email inválido" },
          }}
          render={({ field }) => (
            <FormItem>
              <FormLabel>Email</FormLabel>
              <FormControl>
                <Input type="email" placeholder="tu@email.com" {...field} />
              </FormControl>
              <FormMessage />
            </FormItem>
          )}
        />
        <FormField
          control={form.control}
          name="password"
          rules={{
            required: "La contraseña es obligatoria",
            minLength: { value: 8, message: "Mínimo 8 caracteres" },
          }}
          render={({ field }) => (
            <FormItem>
              <FormLabel>Contraseña</FormLabel>
              <FormControl>
                <Input type="password" {...field} />
              </FormControl>
              <FormMessage />
            </FormItem>
          )}
        />
        <Button
          type="submit"
          className="w-full"
          disabled={form.formState.isSubmitting}
        >
          {form.formState.isSubmitting ? "Iniciando..." : "Iniciar sesión"}
        </Button>
      </form>
    </Form>
  )
}
```

## Notas del patrón

- `FormMessage` muestra errores de validación automáticamente — no agregar lógica extra
- JS sin Zod: `rules` de react-hook-form son suficientes para validación básica
- TS con Zod: tipos inferidos del schema — nunca definir tipos manualmente para el form
- El botón `disabled` durante `isSubmitting` evita doble submit
- Para forms complejos (multi-step, arrays de fields), escalar a `useFieldArray`
