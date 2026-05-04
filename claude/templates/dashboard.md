# Plantilla: Dashboard

Interfaces de administración y datos. El objetivo es dar información procesable al usuario en el menor número de pasos.

---

## Layout base (el más usado)

```
┌─────────────────────────────────────────┐
│  Topbar (64px)                          │
├──────────┬──────────────────────────────┤
│          │  Stats row (4 KPI cards)     │
│ Sidebar  │──────────────────────────────│
│  (240px) │  Chart principal             │
│          │──────────────────────────────│
│          │  Tabla de datos              │
└──────────┴──────────────────────────────┘
```

En mobile: sidebar se convierte en bottom nav o drawer lateral.

---

## Sidebar

```tsx
// Estructura del sidebar
<aside className="flex h-screen w-60 flex-col border-r border-border bg-background">
  {/* Logo */}
  <div className="flex h-16 items-center border-b border-border px-6">
    <Logo />
  </div>

  {/* Navegación principal */}
  <nav className="flex-1 overflow-y-auto p-4">
    <ul className="space-y-1">
      {navItems.map((item) => (
        <li key={item.href}>
          <Link
            href={item.href}
            className={cn(
              "flex items-center gap-3 rounded-lg px-3 py-2 text-sm transition-colors",
              isActive
                ? "bg-primary/10 font-medium text-primary"
                : "text-muted-foreground hover:bg-muted hover:text-foreground"
            )}
          >
            <item.icon className="size-4" />
            {item.label}
          </Link>
        </li>
      ))}
    </ul>
  </nav>

  {/* Usuario en el fondo */}
  <div className="border-t border-border p-4">
    <UserMenu />
  </div>
</aside>
```

**Reglas del sidebar:**
- Máximo 7 items en navegación principal (memoria de trabajo humana)
- El item activo: fondo con color primario muy suave, texto primario
- Hover: fondo muted, texto foreground
- Colapsar a iconos en `lg:` si el espacio es ajustado

---

## KPI Cards (stats row)

4 métricas clave en la parte superior. Siempre incluir:
- El número (grande y prominente)
- El label descriptivo
- La variación vs período anterior (verde/rojo)

```tsx
<div className="grid grid-cols-2 gap-4 lg:grid-cols-4">
  {stats.map((stat) => (
    <Card key={stat.id}>
      <CardContent className="p-6">
        <p className="text-sm text-muted-foreground">{stat.label}</p>
        <p className="mt-2 text-3xl font-bold">{stat.value}</p>
        <div className={cn(
          "mt-2 flex items-center gap-1 text-sm",
          stat.delta > 0 ? "text-green-600" : "text-red-600"
        )}>
          {stat.delta > 0 ? <TrendingUpIcon /> : <TrendingDownIcon />}
          <span>{Math.abs(stat.delta)}% vs mes anterior</span>
        </div>
      </CardContent>
    </Card>
  ))}
</div>
```

---

## Tabla de datos

Patrón completo: header con búsqueda + filtros, tabla, paginación.

```tsx
// Header de la tabla
<div className="flex items-center justify-between">
  <div className="flex items-center gap-2">
    <Input
      placeholder="Buscar..."
      className="w-64"
      value={search}
      onChange={(e) => setSearch(e.target.value)}
    />
    <Select>
      <SelectTrigger className="w-32">
        <SelectValue placeholder="Estado" />
      </SelectTrigger>
      <SelectContent>
        <SelectItem value="all">Todos</SelectItem>
        <SelectItem value="active">Activos</SelectItem>
        <SelectItem value="inactive">Inactivos</SelectItem>
      </SelectContent>
    </Select>
  </div>
  <Button>
    <PlusIcon className="mr-2 size-4" />
    Nuevo
  </Button>
</div>

// Tabla
<Table>
  <TableHeader>
    <TableRow>
      {columns.map((col) => (
        <TableHead key={col.key} className="cursor-pointer" onClick={() => sort(col.key)}>
          <div className="flex items-center gap-1">
            {col.label}
            <SortIcon direction={sortState[col.key]} />
          </div>
        </TableHead>
      ))}
    </TableRow>
  </TableHeader>
  <TableBody>
    {/* row vacio */}
    {rows.length === 0 && (
      <TableRow>
        <TableCell colSpan={columns.length} className="h-32 text-center text-muted-foreground">
          Sin resultados
        </TableCell>
      </TableRow>
    )}
    {rows.map((row) => (
      <TableRow key={row.id} className="hover:bg-muted/50">
        {/* celdas */}
      </TableRow>
    ))}
  </TableBody>
</Table>

// Paginación
<div className="flex items-center justify-between py-4">
  <p className="text-sm text-muted-foreground">
    {start}-{end} de {total} resultados
  </p>
  <Pagination />
</div>
```

---

## Estados del dashboard

**Sin datos (first time user):**
```tsx
<div className="flex flex-col items-center justify-center py-24 text-center">
  <div className="mb-4 rounded-full bg-muted p-6">
    <DatabaseIcon className="size-8 text-muted-foreground" />
  </div>
  <h3 className="mb-2 text-lg font-semibold">Todavía no hay datos</h3>
  <p className="mb-6 max-w-sm text-muted-foreground">
    Comenzá agregando tu primer registro para ver el panel completo.
  </p>
  <Button>Agregar primero</Button>
</div>
```

**Cargando (skeleton):**
- Stats cards: 4 skeletons de altura fija
- Tabla: 8 filas de skeleton, width variable por columna

---

## Reglas de dashboards

1. La acción más frecuente del usuario debe estar a 1 click
2. Los números tienen unidad (%, $, kg) — nunca un número suelto
3. Color rojo = problema; verde = bueno; gris = neutro. No invertir.
4. Las tablas siempre tienen estado vacío y paginación (aunque sean 5 filas)
5. Sticky header en tablas largas
6. El sidebar muestra contadores de notificación si los hay
