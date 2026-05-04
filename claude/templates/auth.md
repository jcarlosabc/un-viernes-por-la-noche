# Plantilla: Auth Flows

Login, registro, recuperación de contraseña. El objetivo es que el usuario entre rápido y con confianza.

---

## Layout base

Tres variantes según el tono del producto:

**Variante A — Card centrada (más común)**
```
┌──────────────────────────────────┐
│                                  │
│   [Logo]                         │
│                                  │
│   ┌────────────────────────┐     │
│   │  Título del formulario │     │
│   │  Campos               │     │
│   │  CTA                  │     │
│   │  Links secundarios    │     │
│   └────────────────────────┘     │
│                                  │
└──────────────────────────────────┘
```

**Variante B — Split screen (SaaS con branding fuerte)**
```
┌─────────────────┬────────────────┐
│                 │                │
│  Branding /     │  Formulario    │
│  testimonial    │                │
│  / visual       │                │
│                 │                │
└─────────────────┴────────────────┘
```

**Variante C — Full page minimalista**
Fondo de un solo color, formulario en el centro sin card wrapper.

---

## Formulario de login

```tsx
<div className="flex min-h-screen items-center justify-center p-4">
  <div className="w-full max-w-md">
    {/* Logo */}
    <div className="mb-8 text-center">
      <Logo className="mx-auto mb-2 size-10" />
      <h1 className="text-2xl font-bold">Bienvenido de nuevo</h1>
      <p className="mt-1 text-muted-foreground">
        Ingresá tu cuenta para continuar
      </p>
    </div>

    {/* Social login (si aplica, va primero) */}
    <div className="mb-6 space-y-3">
      <Button variant="outline" className="w-full gap-2">
        <GoogleIcon className="size-4" />
        Continuar con Google
      </Button>
    </div>

    {/* Separador */}
    <div className="relative mb-6">
      <div className="absolute inset-0 flex items-center">
        <Separator />
      </div>
      <div className="relative flex justify-center text-xs uppercase">
        <span className="bg-background px-2 text-muted-foreground">o con email</span>
      </div>
    </div>

    {/* Form */}
    <form className="space-y-4">
      <div className="space-y-2">
        <Label htmlFor="email">Correo electrónico</Label>
        <Input
          id="email"
          type="email"
          placeholder="tu@empresa.com"
          autoComplete="email"
          required
        />
      </div>

      <div className="space-y-2">
        <div className="flex items-center justify-between">
          <Label htmlFor="password">Contraseña</Label>
          <Link href="/forgot" className="text-sm text-primary hover:underline">
            ¿Olvidaste la contraseña?
          </Link>
        </div>
        <Input
          id="password"
          type="password"
          autoComplete="current-password"
          required
        />
      </div>

      {/* Error message */}
      {error && (
        <div role="alert" className="rounded-md bg-destructive/10 p-3 text-sm text-destructive">
          {error}
        </div>
      )}

      <Button type="submit" className="w-full" disabled={isLoading}>
        {isLoading ? <Spinner className="mr-2 size-4" /> : null}
        Ingresar
      </Button>
    </form>

    {/* Link a registro */}
    <p className="mt-6 text-center text-sm text-muted-foreground">
      ¿No tenés cuenta?{" "}
      <Link href="/register" className="text-primary hover:underline">
        Registrate gratis
      </Link>
    </p>
  </div>
</div>
```

---

## Formulario de registro

Diferencias clave vs login:
- Título positivo: "Creá tu cuenta" no "Registrarse"
- Pedir solo lo necesario (email + password mínimo)
- Password strength indicator si el UX lo permite
- Mencionar los beneficios cerca del CTA ("Gratis por 14 días, sin tarjeta")

```tsx
// Password con toggle de visibilidad
<div className="space-y-2">
  <Label htmlFor="password">Contraseña</Label>
  <div className="relative">
    <Input
      id="password"
      type={showPassword ? "text" : "password"}
      autoComplete="new-password"
      required
    />
    <button
      type="button"
      onClick={() => setShowPassword(!showPassword)}
      className="absolute right-3 top-1/2 -translate-y-1/2 text-muted-foreground"
      aria-label={showPassword ? "Ocultar contraseña" : "Mostrar contraseña"}
    >
      {showPassword ? <EyeOffIcon className="size-4" /> : <EyeIcon className="size-4" />}
    </button>
  </div>
</div>

// Password strength (simple)
<div className="flex gap-1">
  {[1,2,3,4].map((level) => (
    <div
      key={level}
      className={cn(
        "h-1 flex-1 rounded-full transition-colors",
        strength >= level
          ? strength <= 2 ? "bg-orange-400" : "bg-green-500"
          : "bg-muted"
      )}
    />
  ))}
</div>
```

---

## Recuperación de contraseña

Flujo en 3 pasos en la misma URL (sin cambiar ruta):

```
Paso 1: Ingresar email → enviar link
Paso 2: "Revisá tu correo" (pantalla de confirmación)
Paso 3: Nueva contraseña (desde el link del email)
```

```tsx
// Pantalla de "revisá tu correo" — siempre incluir opción de reenviar
<div className="text-center">
  <div className="mx-auto mb-4 flex size-16 items-center justify-center rounded-full bg-primary/10">
    <MailIcon className="size-8 text-primary" />
  </div>
  <h2 className="text-xl font-bold">Revisá tu correo</h2>
  <p className="mt-2 text-muted-foreground">
    Te enviamos un link a <strong>{email}</strong>
  </p>
  <Button
    variant="ghost"
    className="mt-6"
    onClick={resend}
    disabled={resendCooldown > 0}
  >
    {resendCooldown > 0
      ? `Reenviar en ${resendCooldown}s`
      : "No llegó — reenviar"
    }
  </Button>
</div>
```

---

## Tokens y decisiones de diseño

```css
/* Auth pages suelen tener fondo ligeramente distinto al resto */
.auth-background {
  background: var(--background);
  /* Opcional: patrón sutil de fondo */
  background-image: radial-gradient(var(--muted) 1px, transparent 1px);
  background-size: 20px 20px;
}
```

---

## Reglas que no se rompen

1. `autoComplete` siempre correcto (email, current-password, new-password)
2. Los errores van en `role="alert"` arriba del CTA, nunca inline sin anuncio
3. El botón de submit muestra loading state mientras procesa
4. El link "olvidé la contraseña" va junto al label, no lejos del campo
5. En mobile: el teclado no debe tapar el CTA (usar `min-h-screen` + scroll)
6. Texto de términos y privacidad cerca del CTA de registro, no en el footer
