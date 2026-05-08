---
tipo: ejemplo
componente: Tokens de tema — CSS variables
recursos:
  - https://tweakcn.com/editor/theme
  - https://ui.shadcn.com/docs/theming
  - https://tailwindcss.com/showcase
lenguajes: [CSS — aplica igual en TS y JS]
---

# Theme Tokens — Variables CSS para shadcn/ui

Sistema de tokens compatible con shadcn/ui + Tailwind 4. Usar tweakcn.com para generar la paleta visualmente y pegar el resultado aquí.

Generador visual: https://tweakcn.com/editor/theme
Referencia de variables: https://ui.shadcn.com/docs/theming

---

## Estructura base (globals.css)

```css
@import "tailwindcss";

/* ── 1. PRIMITIVOS — valores base sin semántica ── */
@theme {
  /* Tipografía */
  --font-sans: "Inter", ui-sans-serif, system-ui, sans-serif;
  --font-mono: "JetBrains Mono", ui-monospace, monospace;

  /* Paleta de marca — generar con tweakcn.com */
  --color-brand-50:  oklch(97% 0.02 250);
  --color-brand-100: oklch(93% 0.05 250);
  --color-brand-200: oklch(87% 0.09 250);
  --color-brand-300: oklch(78% 0.13 250);
  --color-brand-400: oklch(67% 0.17 250);
  --color-brand-500: oklch(55% 0.20 250);
  --color-brand-600: oklch(48% 0.20 250);
  --color-brand-700: oklch(40% 0.18 250);
  --color-brand-800: oklch(32% 0.14 250);
  --color-brand-900: oklch(25% 0.10 250);
  --color-brand-950: oklch(16% 0.06 250);

  /* Neutros */
  --color-neutral-50:  oklch(98% 0 0);
  --color-neutral-100: oklch(95% 0 0);
  --color-neutral-200: oklch(90% 0 0);
  --color-neutral-300: oklch(83% 0 0);
  --color-neutral-400: oklch(70% 0 0);
  --color-neutral-500: oklch(55% 0 0);
  --color-neutral-600: oklch(44% 0 0);
  --color-neutral-700: oklch(35% 0 0);
  --color-neutral-800: oklch(25% 0 0);
  --color-neutral-900: oklch(17% 0 0);
  --color-neutral-950: oklch(10% 0 0);

  /* Spacing y radios */
  --spacing-section: 5rem;
  --spacing-container: 1.5rem;
  --radius-sm:   0.375rem;
  --radius-md:   0.5rem;
  --radius-lg:   0.75rem;
  --radius-xl:   1rem;
  --radius-full: 9999px;
}

/* ── 2. SEMÁNTICOS light — lo que usa shadcn/ui ── */
:root {
  --background:            var(--color-neutral-50);
  --foreground:            var(--color-neutral-900);

  --card:                  white;
  --card-foreground:       var(--color-neutral-900);

  --popover:               white;
  --popover-foreground:    var(--color-neutral-900);

  --primary:               var(--color-brand-600);
  --primary-foreground:    white;

  --secondary:             var(--color-neutral-100);
  --secondary-foreground:  var(--color-neutral-900);

  --muted:                 var(--color-neutral-100);
  --muted-foreground:      var(--color-neutral-500);

  --accent:                var(--color-neutral-100);
  --accent-foreground:     var(--color-neutral-900);

  --destructive:           oklch(55% 0.22 25);
  --destructive-foreground: white;

  --border:                var(--color-neutral-200);
  --input:                 var(--color-neutral-200);
  --ring:                  var(--color-brand-500);

  --radius:                var(--radius-md);
}

/* ── 3. SEMÁNTICOS dark ── */
.dark {
  --background:            var(--color-neutral-950);
  --foreground:            var(--color-neutral-50);

  --card:                  var(--color-neutral-900);
  --card-foreground:       var(--color-neutral-50);

  --popover:               var(--color-neutral-900);
  --popover-foreground:    var(--color-neutral-50);

  --primary:               var(--color-brand-400);
  --primary-foreground:    var(--color-brand-950);

  --secondary:             var(--color-neutral-800);
  --secondary-foreground:  var(--color-neutral-50);

  --muted:                 var(--color-neutral-800);
  --muted-foreground:      var(--color-neutral-400);

  --accent:                var(--color-neutral-800);
  --accent-foreground:     var(--color-neutral-50);

  --destructive:           oklch(62% 0.22 25);
  --destructive-foreground: white;

  --border:                var(--color-neutral-700);
  --input:                 var(--color-neutral-700);
  --ring:                  var(--color-brand-400);
}
```

---

## Workflow para personalizar el tema

1. Ir a https://tweakcn.com/editor/theme
2. Ajustar colores, radios y fuentes visualmente
3. Exportar el CSS generado
4. Reemplazar los valores primitivos en `@theme` con los exportados
5. Mantener los nombres semánticos (`--primary`, `--background`, etc.) — shadcn/ui los espera exactamente así

## Variables obligatorias para shadcn/ui

Si el proyecto usa shadcn/ui, estas variables DEBEN existir:

```
--background / --foreground
--card / --card-foreground
--popover / --popover-foreground
--primary / --primary-foreground
--secondary / --secondary-foreground
--muted / --muted-foreground
--accent / --accent-foreground
--destructive / --destructive-foreground
--border
--input
--ring
--radius
```

## Notas del patrón

- Usar oklch para colores — mejor interpolación y soporte para P3 displays
- Nunca hardcodear `#hex` o `rgb()` directamente en componentes — siempre `var(--token)`
- Para proyectos sin dark mode: mantener igual el bloque `.dark` vacío, escala sin costo
- tweakcn.com genera Tailwind 3 por defecto — adaptar a sintaxis `@theme` de Tailwind 4
