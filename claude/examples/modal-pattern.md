---
tipo: ejemplo
componente: Modal / Dialog
recursos:
  - https://ui.shadcn.com/docs/components/dialog
  - https://ui.shadcn.com/docs/components/alert-dialog
lenguajes: [TypeScript, JavaScript]
---

# Modal / Dialog — Con gestión de foco

Dos patrones: Dialog estándar (contenido genérico) y AlertDialog (confirmaciones destructivas).

Instalar: `npx shadcn@latest add dialog alert-dialog`
Referencia: https://ui.shadcn.com/docs/components/dialog

## TypeScript / TSX

```tsx
// Dialog estándar — para contenido informativo o formularios
import {
  Dialog, DialogContent, DialogDescription,
  DialogHeader, DialogTitle, DialogTrigger
} from "@/components/ui/dialog"
import { Button } from "@/components/ui/button"

interface ConfirmDialogProps {
  trigger: React.ReactNode
  title: string
  description?: string
  children: React.ReactNode
}

export function AppDialog({ trigger, title, description, children }: ConfirmDialogProps) {
  return (
    <Dialog>
      <DialogTrigger asChild>{trigger}</DialogTrigger>
      <DialogContent>
        <DialogHeader>
          <DialogTitle>{title}</DialogTitle>
          {description && <DialogDescription>{description}</DialogDescription>}
        </DialogHeader>
        {children}
      </DialogContent>
    </Dialog>
  )
}

// AlertDialog — para acciones destructivas (borrar, cerrar sesión)
import {
  AlertDialog, AlertDialogAction, AlertDialogCancel,
  AlertDialogContent, AlertDialogDescription,
  AlertDialogFooter, AlertDialogHeader,
  AlertDialogTitle, AlertDialogTrigger
} from "@/components/ui/alert-dialog"

interface DeleteConfirmProps {
  onConfirm: () => void
  itemName: string
}

export function DeleteConfirm({ onConfirm, itemName }: DeleteConfirmProps) {
  return (
    <AlertDialog>
      <AlertDialogTrigger asChild>
        <Button variant="destructive">Eliminar</Button>
      </AlertDialogTrigger>
      <AlertDialogContent>
        <AlertDialogHeader>
          <AlertDialogTitle>¿Eliminar {itemName}?</AlertDialogTitle>
          <AlertDialogDescription>
            Esta acción no se puede deshacer.
          </AlertDialogDescription>
        </AlertDialogHeader>
        <AlertDialogFooter>
          <AlertDialogCancel>Cancelar</AlertDialogCancel>
          <AlertDialogAction onClick={onConfirm}>Eliminar</AlertDialogAction>
        </AlertDialogFooter>
      </AlertDialogContent>
    </AlertDialog>
  )
}
```

## JavaScript / JSX

```jsx
import {
  Dialog, DialogContent, DialogDescription,
  DialogHeader, DialogTitle, DialogTrigger
} from "@/components/ui/dialog"
import { Button } from "@/components/ui/button"

export function AppDialog({ trigger, title, description, children }) {
  return (
    <Dialog>
      <DialogTrigger asChild>{trigger}</DialogTrigger>
      <DialogContent>
        <DialogHeader>
          <DialogTitle>{title}</DialogTitle>
          {description && <DialogDescription>{description}</DialogDescription>}
        </DialogHeader>
        {children}
      </DialogContent>
    </Dialog>
  )
}

import {
  AlertDialog, AlertDialogAction, AlertDialogCancel,
  AlertDialogContent, AlertDialogDescription,
  AlertDialogFooter, AlertDialogHeader,
  AlertDialogTitle, AlertDialogTrigger
} from "@/components/ui/alert-dialog"

export function DeleteConfirm({ onConfirm, itemName }) {
  return (
    <AlertDialog>
      <AlertDialogTrigger asChild>
        <Button variant="destructive">Eliminar</Button>
      </AlertDialogTrigger>
      <AlertDialogContent>
        <AlertDialogHeader>
          <AlertDialogTitle>¿Eliminar {itemName}?</AlertDialogTitle>
          <AlertDialogDescription>
            Esta acción no se puede deshacer.
          </AlertDialogDescription>
        </AlertDialogHeader>
        <AlertDialogFooter>
          <AlertDialogCancel>Cancelar</AlertDialogCancel>
          <AlertDialogAction onClick={onConfirm}>Eliminar</AlertDialogAction>
        </AlertDialogFooter>
      </AlertDialogContent>
    </AlertDialog>
  )
}
```

## Notas del patrón

- `DialogTrigger asChild` — delega el evento al hijo directo sin wrapper extra en el DOM
- `DialogDescription` es obligatorio para accesibilidad — describe el propósito del modal al screen reader
- Para modals controlados externamente: usar `open` y `onOpenChange` props en `<Dialog>`
- Radix gestiona el foco automáticamente (trap + restore al cerrar) — no agregar lógica manual
- Acciones destructivas siempre en `AlertDialog`, no en `Dialog` — tiene el rol `alertdialog` correcto
- Para modals con form: colocar el `<form>` dentro de `DialogContent`, el submit cierra con `DialogClose`
