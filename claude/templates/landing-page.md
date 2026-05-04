# Plantilla: Landing Page

Páginas de marketing y conversión. El objetivo es uno: llevar al usuario a hacer una acción (signup, compra, contacto).

---

## Estructura de secciones

```
[ Navbar ]          sticky, máximo 5 links + CTA
[ Hero ]            60-80vh — lo más importante
[ Social proof ]    logos o números rápidos
[ Features ]        3-4 columnas, beneficio no característica
[ How it works ]    3 pasos numerados, visual
[ Testimonials ]    2-3 quotes reales con foto y nombre
[ Pricing ]         2-3 tiers, tier recomendado destacado
[ Final CTA ]       repetir el CTA principal con urgencia suave
[ Footer ]          links, legal, redes
```

---

## Navbar

```tsx
// Estructura
<nav className="sticky top-0 z-50 border-b border-border bg-background/80 backdrop-blur-md">
  <div className="mx-auto flex max-w-6xl items-center justify-between px-6 py-4">
    <Logo />
    <NavigationMenu /> {/* máximo 4-5 items */}
    <div className="flex items-center gap-3">
      <Button variant="ghost">Iniciar sesión</Button>
      <Button>Empezar gratis</Button>
    </div>
  </div>
</nav>
```

**Decisiones clave:**
- `backdrop-blur` + `bg-background/80` para efecto glassmorphism al scroll
- CTA siempre visible en desktop, colapsar en mobile
- En mobile: solo logo + burger menu

---

## Hero

El hero tiene una jerarquía estricta:

```
Badge opcional ("Nuevo: feature X →")
    ↓
Headline: máximo 6-8 palabras, beneficio real
    ↓
Subheadline: 1-2 líneas explicando el cómo
    ↓
CTAs: primario + secundario (ghost)
    ↓
Social proof: "X usuarios" / logos / estrellas
    ↓
Visual: screenshot, video, ilustración, demo interactiva
```

```tsx
// Tipografía del Hero
<h1 className="text-5xl font-bold tracking-tight text-foreground md:text-7xl">
  {/* En mobile: 5xl, en desktop: 7xl */}
</h1>
<p className="mt-6 max-w-2xl text-xl text-muted-foreground">
  {/* Una sola proposición de valor, sin jerga */}
</p>

// CTAs del Hero
<div className="mt-10 flex flex-col gap-4 sm:flex-row">
  <Button size="lg" className="text-base">
    Empezar gratis
  </Button>
  <Button variant="outline" size="lg" className="text-base">
    Ver demo
  </Button>
</div>
```

**Lo que no hacer en un Hero:**
- No poner más de 2 CTAs
- No poner texto debajo del fold en mobile
- No usar imágenes de stock con personas genéricas

---

## Feature cards

Patrón de 3 columnas que colapsa a 1:

```tsx
<section className="py-24">
  <div className="mx-auto max-w-6xl px-6">
    <div className="grid gap-8 md:grid-cols-3">
      {features.map((f) => (
        <div key={f.id} className="rounded-xl border border-border p-6">
          <div className="mb-4 inline-flex rounded-lg bg-primary/10 p-2">
            <Icon className="size-5 text-primary" />
          </div>
          <h3 className="mb-2 text-lg font-semibold">{f.title}</h3>
          <p className="text-muted-foreground">{f.description}</p>
        </div>
      ))}
    </div>
  </div>
</section>
```

**Regla de contenido:** el título es el beneficio, no la característica.
- Mal: "Autenticación OAuth 2.0"
- Bien: "Entra con un click, sin contraseñas"

---

## Pricing cards

El tier recomendado siempre tiene:
- Escala visual (`scale-105`)
- Borde de color primario
- Badge "Más popular" o "Recomendado"

```tsx
<div className={cn(
  "rounded-2xl border p-8",
  isPopular
    ? "scale-105 border-primary bg-primary/5 shadow-lg"
    : "border-border"
)}>
  {isPopular && (
    <Badge className="mb-4">Más popular</Badge>
  )}
  <div className="mb-6">
    <span className="text-4xl font-bold">${price}</span>
    <span className="text-muted-foreground">/mes</span>
  </div>
  <Button className="mb-8 w-full" variant={isPopular ? "default" : "outline"}>
    Empezar
  </Button>
  <ul className="space-y-3">
    {features.map((f) => (
      <li key={f} className="flex items-center gap-2 text-sm">
        <CheckIcon className="size-4 text-primary" />
        {f}
      </li>
    ))}
  </ul>
</div>
```

---

## Tokens sugeridos

```css
/* Secciones alternadas para crear ritmo */
.section-default { background: var(--background); }
.section-muted   { background: var(--muted); }

/* Max-width consistente */
.container-landing { max-width: 72rem; margin: 0 auto; padding: 0 1.5rem; }

/* Espaciado de secciones */
.section-padding { padding-top: 6rem; padding-bottom: 6rem; }
```

---

## Reglas que no se rompen

1. El CTA principal aparece mínimo 3 veces: navbar, hero, final
2. Cada sección tiene un único objetivo
3. El hero no puede tener más de 3 elementos de texto + 2 botones
4. Mobile siempre colapsa a 1 columna
5. Las animaciones de entrada son suaves y opcionales (reduce-motion)
