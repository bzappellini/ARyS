# ARyS 🛡️
### Administración de Redes y Seguridad — IF046

Repositorio de la cátedra **Administración de Redes y Seguridad** de la
**Universidad Nacional de la Patagonia San Juan Bosco** (UNPSJB), Facultad de
Ingeniería, Sede Trelew.

Reúne **filminas, material teórico y trabajos prácticos** de las ocho unidades de
la materia, pensado para **reutilizarse año a año**: todo es Markdown versionado,
las filminas se generan con **[Marp](https://marp.app/)** y se publican solas como
sitio web.

> **Profesor responsable:** Bruno Zappellini · Segundo cuatrimestre
> **Cursada:** Teoría jueves 15–18 · Práctica viernes 17–20
> **Correlativa:** IF019 — Redes y Transmisión de Datos

## 🌐 Sitio web

Publicado en GitHub Pages:

**https://bzappellini.github.io/ARyS/**

- **`index.html`** — portal con todas las unidades
- **`unidades/<u>/filminas.html`** — filminas (generadas por Marp, autocontenidas)
- **`doc.html?md=<ruta>`** — lector de teoría y prácticos (Markdown)

## 🚀 Uso local con Docker (recomendado)

Un solo comando levanta el sitio completo (genera las filminas y las sirve):

```bash
docker compose up --build
```

Abrí **http://localhost:8080/**. Para bajarlo: `docker compose down`.

## 🖥️ Uso local sin Docker

Requiere [Marp CLI](https://github.com/marp-team/marp-cli):

```bash
npm install -g @marp-team/marp-cli
./scripts/build.sh              # genera las filminas .html
python3 -m http.server 8000     # servir en http://localhost:8000
```

## 📄 Exportar filminas a PDF / PPTX (para Moodle o impresión)

Usa la imagen oficial de Marp (incluye Chromium), no requiere instalar nada más:

```bash
./scripts/export.sh pdf     # genera dist/uNN-*.pdf
./scripts/export.sh pptx    # genera dist/uNN-*.pptx (editable en PowerPoint)
```

## 📂 Estructura

```
ARyS/
├── index.html                 # Portal principal
├── doc.html                   # Lector de teoría / prácticos (marked)
├── Dockerfile                 # Marp build -> nginx
├── docker-compose.yml         # docker compose up --build
├── marp.config.mjs            # Config Marp (HTML + tema arys)
├── identidad/
│   ├── arys-marp.css          # Tema Marp institucional (UNPSJB)
│   ├── arys-tokens.css        # Tokens para el portal
│   ├── GUIA-IDENTIDAD.md      # Guía de marca
│   └── assets/                # Logos ARyS + escudos UNPSJB
├── assets/
│   ├── css/arys-site.css      # Estilos del portal
│   ├── img/                   # Diagramas SVG de las filminas
│   └── vendor/marked/         # Lector Markdown (offline)
├── unidades/
│   ├── u00-presentacion/      # filminas.md
│   ├── u01-conceptos-seguridad/
│   ├── u02-seguridad-fisica/  # filminas.md · teoria.md · practico.md
│   ├── u03-hacking-etico/     # filminas.md · teoria.md · practico.md
│   └── ...                    # u04–u08 (en construcción)
├── cursadas/2026/             # Material específico del año
└── scripts/                   # build.sh · export.sh
```

## ✍️ Editar contenido

Cada unidad tiene hasta tres archivos Markdown:

| Archivo | Se ve con | Formato |
|---|---|---|
| `filminas.md` | Marp → `filminas.html` | Diapositivas separadas por `---` |
| `teoria.md` | `doc.html` | Documento largo |
| `practico.md` | `doc.html` | Guía de laboratorio |

### Sintaxis de filminas (Marp)

- Cada archivo empieza con front-matter: `marp: true`, `theme: arys`.
- Diapositivas separadas por `---` en línea sola.
- Portada / cierre: `<!-- _class: portada -->` como primera línea del slide.
- Notas del docente: comentario HTML `<!-- ... -->` (visibles en modo presentador).
- Imágenes con alto fijo: `![h:320](../../assets/img/diagrama.svg)`.
- Callouts, columnas y tarjetas (HTML embebido, estilado por el tema):

```html
<div class="nota amenaza"><span class="rot">Riesgo</span>Texto…</div>
<div class="nota control"><span class="rot">Defensa</span>Texto…</div>
<div class="cols"><div>…</div><div>…</div></div>
<div class="tarjetas"><div class="t"><b>Título</b>…</div></div>
```

## 🎨 Identidad visual

Base institucional **UNPSJB** (azul `#004992` + amarillo-anaranjado `#FF9900` del
escudo) combinada con una identidad propia de la materia. Ver
[`identidad/GUIA-IDENTIDAD.md`](identidad/GUIA-IDENTIDAD.md).

## 📊 Estado del contenido

| Unidad | Filminas | Teoría | Práctico |
|---|:---:|:---:|:---:|
| 0 · Presentación | ✅ | — | — |
| 1 · Conceptos | ✅ | ✅ | ✅ |
| 2 · Seguridad Física | ✅ | ✅ | ✅ |
| 3 · Hacking Ético | ✅ | ✅ | ✅ |
| 4 · Sniffing | ✅ | ✅ | ✅ |
| 5 · Firewall/IDS | ⬜ | ⬜ | ⬜ |
| 6 · Criptografía | ⬜ | ⬜ | ⬜ |
| 7 · Autenticación | ⬜ | ⬜ | ⬜ |
| 8 · Monitoreo | ⬜ | ⬜ | ⬜ |

## 👥 Trabajar en equipo

El material lo mantiene el equipo docente. Todo cambio entra por **Pull Request**;
al mergear a `main`, el sitio se **republica solo**. Un workflow valida en cada PR
que las filminas compilan antes de poder mergear.

Guía completa del flujo (ramas, commits, dónde va cada cosa):
**[`CONTRIBUTING.md`](CONTRIBUTING.md)**.

Resumen rápido:

```bash
git checkout main && git pull
git checkout -b u04/filminas-sniffing
# ...editar los .md...
docker compose up --build          # previsualizar en localhost:8080
git commit -am "feat(u04): filminas de Sniffing"
git push -u origin u04/filminas-sniffing
# abrir el PR en GitHub
```

## 📄 Licencia y créditos

- Material educativo de la cátedra. Los escudos e isologos de la UNPSJB son
  propiedad de la Universidad y se usan según su Manual de Identidad Institucional.
- Filminas generadas con [Marp](https://marp.app/) (MIT). Lector de documentos con
  [marked](https://marked.js.org/) (MIT, incluido en `assets/vendor/`).
