# Plantilla: E-commerce

Catálogo, detalle de producto, carrito y checkout. El objetivo es reducir la fricción entre ver el producto y completar la compra.

---

## Product Grid (catálogo)

```tsx
// Grid responsivo: 2 columnas mobile, 3 tablet, 4 desktop
<div className="grid grid-cols-2 gap-4 md:grid-cols-3 lg:grid-cols-4">
  {products.map((product) => (
    <ProductCard key={product.id} product={product} />
  ))}
</div>

// ProductCard — la imagen domina
function ProductCard({ product }) {
  return (
    <Link href={`/products/${product.slug}`} className="group">
      <div className="overflow-hidden rounded-xl bg-muted">
        {/* Imagen: aspect-ratio fijo para evitar CLS */}
        <div className="relative aspect-square">
          <Image
            src={product.image}
            alt={product.name}
            fill
            className="object-cover transition-transform duration-300 group-hover:scale-105"
            sizes="(max-width: 768px) 50vw, (max-width: 1024px) 33vw, 25vw"
          />
          {/* Badge de descuento */}
          {product.discount && (
            <Badge className="absolute left-2 top-2 bg-destructive">
              -{product.discount}%
            </Badge>
          )}
          {/* Quick add — aparece en hover desktop */}
          <div className="absolute inset-x-0 bottom-0 translate-y-full p-3 transition-transform group-hover:translate-y-0">
            <Button size="sm" className="w-full" onClick={(e) => quickAdd(e, product)}>
              Agregar al carrito
            </Button>
          </div>
        </div>
      </div>
      {/* Info del producto */}
      <div className="mt-3 space-y-1">
        <p className="text-sm text-muted-foreground">{product.brand}</p>
        <p className="font-medium leading-tight">{product.name}</p>
        <div className="flex items-center gap-2">
          {product.originalPrice && (
            <span className="text-sm text-muted-foreground line-through">
              ${product.originalPrice}
            </span>
          )}
          <span className={cn(
            "font-semibold",
            product.discount && "text-destructive"
          )}>
            ${product.price}
          </span>
        </div>
      </div>
    </Link>
  )
}
```

---

## Filters + Sort (sidebar o topbar)

```tsx
// Sidebar de filtros (desktop) / Sheet (mobile)
<aside className="w-64 shrink-0">
  <div className="space-y-6">
    {/* Precio */}
    <div>
      <h3 className="mb-3 font-semibold">Precio</h3>
      <Slider
        min={0}
        max={1000}
        step={10}
        value={priceRange}
        onValueChange={setPriceRange}
      />
      <div className="mt-2 flex justify-between text-sm text-muted-foreground">
        <span>${priceRange[0]}</span>
        <span>${priceRange[1]}</span>
      </div>
    </div>

    {/* Categorías */}
    <div>
      <h3 className="mb-3 font-semibold">Categoría</h3>
      <div className="space-y-2">
        {categories.map((cat) => (
          <div key={cat.id} className="flex items-center gap-2">
            <Checkbox
              id={cat.id}
              checked={filters.categories.includes(cat.id)}
              onCheckedChange={(checked) => toggleCategory(cat.id, checked)}
            />
            <label htmlFor={cat.id} className="text-sm cursor-pointer">
              {cat.name}
              <span className="ml-1 text-muted-foreground">({cat.count})</span>
            </label>
          </div>
        ))}
      </div>
    </div>
  </div>
</aside>
```

---

## Product Detail Page

Layout split: imagen izquierda (55-60%), info derecha (40-45%).

```tsx
<div className="grid gap-12 lg:grid-cols-[3fr_2fr]">
  {/* Galería de imágenes */}
  <div className="space-y-4">
    {/* Imagen principal */}
    <div className="relative overflow-hidden rounded-2xl bg-muted aspect-square">
      <Image
        src={selectedImage}
        alt={product.name}
        fill
        className="object-cover"
        priority // Above the fold — importante para LCP
        sizes="(max-width: 1024px) 100vw, 60vw"
      />
    </div>
    {/* Thumbnails */}
    <div className="flex gap-2">
      {product.images.map((img, i) => (
        <button
          key={i}
          onClick={() => setSelectedImage(img)}
          className={cn(
            "relative size-16 overflow-hidden rounded-lg border-2 transition-colors",
            selectedImage === img ? "border-primary" : "border-transparent"
          )}
          aria-label={`Ver imagen ${i + 1}`}
          aria-pressed={selectedImage === img}
        >
          <Image src={img} alt="" fill className="object-cover" />
        </button>
      ))}
    </div>
  </div>

  {/* Info del producto — sticky en desktop */}
  <div className="lg:sticky lg:top-24 lg:self-start">
    <p className="mb-1 text-sm text-muted-foreground">{product.brand}</p>
    <h1 className="text-2xl font-bold lg:text-3xl">{product.name}</h1>

    {/* Rating */}
    <div className="mt-2 flex items-center gap-2">
      <Stars rating={product.rating} />
      <span className="text-sm text-muted-foreground">
        {product.rating} ({product.reviewCount} reseñas)
      </span>
    </div>

    {/* Precio */}
    <div className="mt-4 flex items-center gap-3">
      <span className="text-3xl font-bold">${product.price}</span>
      {product.originalPrice && (
        <span className="text-lg text-muted-foreground line-through">
          ${product.originalPrice}
        </span>
      )}
    </div>

    {/* Variantes (talla, color) */}
    <div className="mt-6 space-y-4">
      {product.variants.map((variant) => (
        <VariantSelector key={variant.name} variant={variant} />
      ))}
    </div>

    {/* Stock */}
    {product.stock < 5 && product.stock > 0 && (
      <p className="mt-4 text-sm font-medium text-orange-600">
        Solo quedan {product.stock} unidades
      </p>
    )}

    {/* CTA principal */}
    <div className="mt-6 space-y-3">
      <Button size="lg" className="w-full text-base" disabled={product.stock === 0}>
        {product.stock === 0 ? "Sin stock" : "Agregar al carrito"}
      </Button>
      <Button size="lg" variant="outline" className="w-full text-base">
        Comprar ahora
      </Button>
    </div>

    {/* Trust signals */}
    <div className="mt-6 space-y-2 border-t border-border pt-6">
      <TrustItem icon={ShieldIcon}>Compra 100% segura</TrustItem>
      <TrustItem icon={TruckIcon}>Envío gratis en compras +$50</TrustItem>
      <TrustItem icon={RotateCcwIcon}>Devolución gratis 30 días</TrustItem>
    </div>
  </div>
</div>
```

---

## Cart Drawer

Sheet desde la derecha, siempre accesible.

```tsx
<Sheet>
  <SheetContent className="flex w-full flex-col sm:max-w-md">
    <SheetHeader>
      <SheetTitle>Carrito ({itemCount})</SheetTitle>
    </SheetHeader>

    {/* Lista de items — scrollable */}
    <div className="flex-1 overflow-y-auto py-4">
      {cart.items.length === 0 ? (
        <div className="flex h-full flex-col items-center justify-center gap-3 text-center">
          <ShoppingBagIcon className="size-12 text-muted-foreground" />
          <p className="text-muted-foreground">Tu carrito está vacío</p>
          <SheetClose asChild>
            <Button variant="outline">Ver productos</Button>
          </SheetClose>
        </div>
      ) : (
        <ul className="space-y-4">
          {cart.items.map((item) => (
            <CartItem key={item.id} item={item} />
          ))}
        </ul>
      )}
    </div>

    {/* Resumen y CTA — siempre visible en el fondo */}
    {cart.items.length > 0 && (
      <div className="border-t border-border pt-4 space-y-4">
        <div className="flex justify-between font-semibold">
          <span>Total</span>
          <span>${cart.total}</span>
        </div>
        <Button size="lg" className="w-full">
          Ir al checkout
        </Button>
      </div>
    )}
  </SheetContent>
</Sheet>
```

---

## Reglas del e-commerce

1. **Imagen siempre con `aspect-ratio` fijo** — evita CLS (el peor enemigo del e-commerce)
2. **CTA principal siempre visible** — sticky en mobile, fixed en sidebar de producto
3. **Trust signals cerca del CTA** — no en el footer
4. **Stock bajo = urgencia suave** — solo cuando es real (< 5 unidades)
5. **Thumbnails con `aria-pressed`** — accesibilidad en la galería
6. **Quick add en hover desktop** — no mostrar en mobile (area táctil)
7. **Carrito sin cierre de página** — Sheet/Drawer, nunca navegar a /cart directamente
