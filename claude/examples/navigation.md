---
tipo: ejemplo
componente: Navbar con mobile menu
recursos:
  - https://ui.shadcn.com/docs/components/sheet
  - https://lucide.dev/icons
lenguajes: [TypeScript, JavaScript]
---

# Navigation — Navbar con mobile menu

Navbar fijo con links de escritorio y Sheet (drawer) para mobile. Usa shadcn/ui Sheet y Lucide icons.

Instalar: `npx shadcn@latest add sheet`
Íconos: `npm install lucide-react` (ya incluido con shadcn)

## TypeScript / TSX

```tsx
"use client"
import Link from "next/link"
import { usePathname } from "next/navigation"
import { Menu, X } from "lucide-react"
import { useState } from "react"
import {
  Sheet,
  SheetContent,
  SheetTrigger,
  SheetClose,
} from "@/components/ui/sheet"
import { Button } from "@/components/ui/button"
import { cn } from "@/lib/utils"

interface NavLink {
  href: string
  label: string
}

const LINKS: NavLink[] = [
  { href: "/", label: "Inicio" },
  { href: "/productos", label: "Productos" },
  { href: "/precios", label: "Precios" },
  { href: "/contacto", label: "Contacto" },
]

function NavLinks({ mobile = false, onClose }: { mobile?: boolean; onClose?: () => void }) {
  const pathname = usePathname()

  return (
    <>
      {LINKS.map(({ href, label }) => (
        <Link
          key={href}
          href={href}
          onClick={onClose}
          className={cn(
            "text-sm font-medium transition-colors hover:text-foreground",
            pathname === href
              ? "text-foreground"
              : "text-muted-foreground",
            mobile && "text-base py-2"
          )}
        >
          {label}
        </Link>
      ))}
    </>
  )
}

export function Navbar() {
  const [open, setOpen] = useState(false)

  return (
    <header className="sticky top-0 z-50 w-full border-b bg-background/95 backdrop-blur supports-[backdrop-filter]:bg-background/60">
      <div className="container mx-auto flex h-14 items-center px-4">
        {/* Logo */}
        <Link href="/" className="mr-8 font-bold text-foreground">
          Mi App
        </Link>

        {/* Links — desktop */}
        <nav className="hidden md:flex items-center gap-6 flex-1">
          <NavLinks />
        </nav>

        {/* CTA desktop */}
        <div className="hidden md:flex items-center gap-2 ml-auto">
          <Button variant="ghost" asChild>
            <Link href="/login">Entrar</Link>
          </Button>
          <Button asChild>
            <Link href="/registro">Empezar</Link>
          </Button>
        </div>

        {/* Mobile menu */}
        <Sheet open={open} onOpenChange={setOpen}>
          <SheetTrigger asChild className="ml-auto md:hidden">
            <Button variant="ghost" size="icon" aria-label="Abrir menú">
              <Menu className="size-5" />
            </Button>
          </SheetTrigger>
          <SheetContent side="left" className="flex flex-col gap-6 pt-10">
            <Link
              href="/"
              className="font-bold text-lg"
              onClick={() => setOpen(false)}
            >
              Mi App
            </Link>
            <nav className="flex flex-col gap-1">
              <NavLinks mobile onClose={() => setOpen(false)} />
            </nav>
            <div className="mt-auto flex flex-col gap-2">
              <Button variant="outline" asChild>
                <Link href="/login" onClick={() => setOpen(false)}>Entrar</Link>
              </Button>
              <Button asChild>
                <Link href="/registro" onClick={() => setOpen(false)}>Empezar</Link>
              </Button>
            </div>
          </SheetContent>
        </Sheet>
      </div>
    </header>
  )
}
```

## JavaScript / JSX

```jsx
"use client"
import Link from "next/link"
import { usePathname } from "next/navigation"
import { Menu } from "lucide-react"
import { useState } from "react"
import { Sheet, SheetContent, SheetTrigger } from "@/components/ui/sheet"
import { Button } from "@/components/ui/button"
import { cn } from "@/lib/utils"

const LINKS = [
  { href: "/", label: "Inicio" },
  { href: "/productos", label: "Productos" },
  { href: "/precios", label: "Precios" },
  { href: "/contacto", label: "Contacto" },
]

function NavLinks({ mobile = false, onClose }) {
  const pathname = usePathname()
  return (
    <>
      {LINKS.map(({ href, label }) => (
        <Link
          key={href}
          href={href}
          onClick={onClose}
          className={cn(
            "text-sm font-medium transition-colors hover:text-foreground",
            pathname === href ? "text-foreground" : "text-muted-foreground",
            mobile && "text-base py-2"
          )}
        >
          {label}
        </Link>
      ))}
    </>
  )
}

export function Navbar() {
  const [open, setOpen] = useState(false)

  return (
    <header className="sticky top-0 z-50 w-full border-b bg-background/95 backdrop-blur supports-[backdrop-filter]:bg-background/60">
      <div className="container mx-auto flex h-14 items-center px-4">
        <Link href="/" className="mr-8 font-bold text-foreground">Mi App</Link>
        <nav className="hidden md:flex items-center gap-6 flex-1">
          <NavLinks />
        </nav>
        <div className="hidden md:flex items-center gap-2 ml-auto">
          <Button variant="ghost" asChild><Link href="/login">Entrar</Link></Button>
          <Button asChild><Link href="/registro">Empezar</Link></Button>
        </div>
        <Sheet open={open} onOpenChange={setOpen}>
          <SheetTrigger asChild className="ml-auto md:hidden">
            <Button variant="ghost" size="icon" aria-label="Abrir menú">
              <Menu className="size-5" />
            </Button>
          </SheetTrigger>
          <SheetContent side="left" className="flex flex-col gap-6 pt-10">
            <Link href="/" className="font-bold text-lg" onClick={() => setOpen(false)}>Mi App</Link>
            <nav className="flex flex-col gap-1">
              <NavLinks mobile onClose={() => setOpen(false)} />
            </nav>
            <div className="mt-auto flex flex-col gap-2">
              <Button variant="outline" asChild>
                <Link href="/login" onClick={() => setOpen(false)}>Entrar</Link>
              </Button>
              <Button asChild>
                <Link href="/registro" onClick={() => setOpen(false)}>Empezar</Link>
              </Button>
            </div>
          </SheetContent>
        </Sheet>
      </div>
    </header>
  )
}
```

## Notas del patrón

- `sticky top-0 z-50` + `backdrop-blur` — navbar flotante con efecto glass
- `usePathname()` para link activo — siempre comparar pathname completo
- `SheetTrigger asChild` — usa el Button como trigger sin wrapper extra en el DOM
- `aria-label` en el botón de menú — describe la acción para screen readers
- Para React sin Next.js: reemplazar `Link` + `usePathname` por `react-router-dom`
- Más íconos: https://lucide.dev/icons
