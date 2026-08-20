# ARyS 🛡️
### Administración de Redes y Seguridad — IF046

Repositorio de la cátedra **Administración de Redes y Seguridad** de la
**Universidad Nacional de la Patagonia San Juan Bosco** (UNPSJB), Facultad de
Ingeniería, Sede Trelew.

Reúne **filminas, material teórico y trabajos prácticos** de las ocho unidades de
la materia, en un formato pensado para **reutilizarse año a año**: todo es
Markdown versionado y se publica solo como sitio web.

> **Profesor responsable:** Bruno Zappellini · Segundo cuatrimestre
> **Cursada:** Teoría jueves 15–18 · Práctica viernes 17–20
> **Correlativa:** IF019 — Redes y Transmisión de Datos

## 🌐 Sitio web

Una vez publicado en GitHub Pages:

**https://bzappellini.github.io/ARyS/**

- **`index.html`** — portal con todas las unidades
- **`slides.html?md=<ruta>`** — visor de filminas (Reveal.js)
- **`doc.html?md=<ruta>`** — lector de material teórico y prácticos (Markdown)

## 📂 Estructura

```
ARyS/
├── index.html                 # Portal principal
├── slides.html                # Visor de filminas (Reveal.js)
├── doc.html                   # Lector de teoría / prácticos
├── identidad/                 # Identidad visual
│   ├── arys-tokens.css        # Tokens de color y tipografía
│   ├── GUIA-IDENTIDAD.md      # Guía de marca
│   └── assets/                # Logos ARyS + escudos UNPSJB
├── assets/
│   ├── css/                   # Estilos de filminas y sitio
│   └── vendor/                # Reveal.js y marked (offline, sin CDN)
├── unidades/
│   ├── u00-presentacion/
│   ├── u01-conceptos-seguridad/
│   ├── u02-seguridad-fisica/  # filminas.md · teoria.md · practico.md
│   ├── u03-hacking-etico/     # filminas.md · teoria.md · practico.md
│   └── ...                    # u04–u08 (en construcción)
├── cursadas/
│   └── 2026/                  # Material específico del año (notas, actas)
└── .github/workflows/pages.yml
```

## ✍️ Cómo agregar o editar contenido

Cada unidad tiene hasta tres archivos Markdown:

| Archivo | Se ve con | Formato |
|---|---|---|
| `filminas.md` | `slides.html` | Diapositivas Reveal.js, separadas por `---` |
| `teoria.md` | `doc.html` | Documento largo |
| `practico.md` | `doc.html` | Guía de laboratorio |

### Sintaxis de filminas

- Separá diapositivas con `---` en una línea sola.
- Portada / cierre: primera línea del slide `<!-- .slide: class="portada" -->`.
- Notas del presentador: bloque `Note:` (se ven con la tecla **S**).
- Callouts semánticos:

```html
<div class="nota amenaza"><span class="rot">Riesgo</span>Texto…</div>
<div class="nota control"><span class="rot">Defensa</span>Texto…</div>
<div class="nota legal"><span class="rot">Legal</span>Texto…</div>
<div class="nota red"><span class="rot">Red</span>Texto…</div>
```

- Columnas: `<div class="cols">…</div>` (o `cols c3` para tres).
- Tarjetas: `<div class="tarjetas"><div class="t"><b>Título</b>…</div></div>`.

### Vista previa local

```bash
# Desde la raíz del repo
python3 -m http.server 8000
# Abrir http://localhost:8000/
```

### Exportar filminas a PDF

Abrir la presentación con `?print-pdf` y guardar como PDF desde el navegador:

```
http://localhost:8000/slides.html?md=unidades/u02-seguridad-fisica/filminas.md&print-pdf
```

## 🎨 Identidad visual

Base institucional **UNPSJB** (azul oficial + amarillo-anaranjado del escudo)
combinada con una identidad propia de la materia. Ver
[`identidad/GUIA-IDENTIDAD.md`](identidad/GUIA-IDENTIDAD.md).

## 🚀 Publicar en GitHub Pages

1. Crear el repositorio `ARyS` en GitHub y subir este contenido.
2. **Settings → Pages → Source: GitHub Actions**.
3. El workflow `pages.yml` publica en cada push a `main`.

## 📊 Estado del contenido

| Unidad | Filminas | Teoría | Práctico |
|---|:---:|:---:|:---:|
| 0 · Presentación | 🟡 base | — | — |
| 1 · Conceptos | 🟡 base | 🟡 base | — |
| 2 · Seguridad Física | ✅ | ✅ | ✅ |
| 3 · Hacking Ético | ✅ | ✅ | ✅ |
| 4 · Sniffing | ⬜ | ⬜ | ⬜ |
| 5 · Firewall/IDS | ⬜ | ⬜ | ⬜ |
| 6 · Criptografía | ⬜ | ⬜ | ⬜ |
| 7 · Autenticación | ⬜ | ⬜ | ⬜ |
| 8 · Monitoreo | ⬜ | ⬜ | ⬜ |

## 📄 Licencia y créditos

- Material educativo de la cátedra. Los escudos e isologos de la UNPSJB son
  propiedad de la Universidad y se usan según su Manual de Identidad Institucional.
- [Reveal.js](https://revealjs.com/) y [marked](https://marked.js.org/) se
  incluyen bajo licencia MIT (ver `assets/vendor/*/LICENSE`).
