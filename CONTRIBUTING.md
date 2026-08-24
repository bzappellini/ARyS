# Cómo colaborar en ARyS

Guía para el equipo docente de la cátedra. El objetivo es trabajar de a varios
sobre el material sin pisarnos, con historial claro y sin romper el sitio.

## Modelo de trabajo

- Trabajamos sobre **este mismo repositorio** (no hace falta fork).
- **Nadie edita `main` directo**: todo cambio entra por **Pull Request (PR)**.
- Al aprobar y mergear un PR a `main`, GitHub Actions **republica el sitio** solo.

## Requisitos

- **git** y una cuenta de GitHub con acceso al repo.
- Para previsualizar: **Docker** (recomendado) o **Node + Marp CLI**.

## Flujo paso a paso

```bash
# 1. Clonar (solo la primera vez)
git clone https://github.com/bzappellini/ARyS.git
cd ARyS

# 2. Traer lo último de main antes de empezar
git checkout main
git pull

# 3. Crear una rama para tu cambio (ver convención abajo)
git checkout -b u04/filminas-sniffing

# 4. Editar el o los archivos Markdown correspondientes
#    (ver "Dónde va cada cosa")

# 5. Previsualizar localmente (elegí una opción)
docker compose up --build        # -> http://localhost:8080
#   o, sin Docker:
#   ./scripts/build.sh && python3 -m http.server 8000

# 6. Commit con mensaje convencional (ver abajo)
git add -A
git commit -m "feat(u04): filminas de Sniffing"

# 7. Subir la rama y abrir el PR
git push -u origin u04/filminas-sniffing
```

Después, en GitHub: **Compare & pull request** → completá la plantilla → asigná
revisor. Cuando esté aprobado, **merge** (y borrá la rama).

## Convención de ramas

`<unidad-o-area>/<descripcion-corta>` en minúsculas y con guiones:

- `u04/filminas-sniffing`
- `u02/corregir-typo-biometria`
- `identidad/ajuste-tema-tablas`
- `infra/actualizar-workflow`

## Convención de commits

Usamos [Conventional Commits](https://www.conventionalcommits.org/):

- `feat(u05): filminas y teoría de Firewall/IDS`
- `fix(u03): corregir comando nmap en el práctico`
- `docs: aclarar entrega en el práctico de U1`
- `chore(infra): actualizar Marp CLI`

Prefijos útiles: `feat`, `fix`, `docs`, `chore`, `refactor`.

## Dónde va cada cosa

| Quiero… | Edito… |
|---|---|
| Filminas de una unidad | `unidades/uNN-*/filminas.md` |
| Teoría de acompañamiento | `unidades/uNN-*/teoria.md` |
| Guía de trabajo práctico | `unidades/uNN-*/practico.md` |
| Un diagrama nuevo | agregar SVG en `assets/img/` y referenciarlo |
| Colores / tipografía de filminas | `identidad/arys-marp.css` |
| Estilos del portal | `assets/css/arys-site.css` |
| Listado de unidades en el portal | `index.html` |

### Sintaxis de filminas (Marp)

- Cada `filminas.md` empieza con front-matter: `marp: true`, `theme: arys`.
- Diapositivas separadas por `---` en línea sola.
- Portada/cierre: `<!-- _class: portada -->` como primera línea del slide.
- Notas del docente: comentario HTML `<!-- ... -->`.
- Imágenes con alto fijo: `![h:320](../../assets/img/diagrama.svg)`.
- Callouts, columnas y tarjetas (HTML embebido, estilado por el tema):
  `.nota` (`amenaza` / `control` / `legal` / `red`), `.cols`, `.tarjetas`.

Guía completa de estilo y marca: [`identidad/GUIA-IDENTIDAD.md`](identidad/GUIA-IDENTIDAD.md).

## Qué NO commitear

- **Filminas HTML generadas** (`unidades/**/filminas.html`) — las produce el build.
- **Exportaciones** (`*.pdf`, `*.pptx`, carpeta `dist/`).
- `node_modules/`.

Ya están en `.gitignore`. Si aparecen en tu `git status`, no las agregues.

## Qué revisamos en un PR

- El sitio **compila** (lo valida GitHub Actions automáticamente en el PR).
- El contenido es **correcto** y usa el vocabulario de la materia.
- Respeta la **identidad visual** (usa el tema y los callouts, no estilos sueltos).
- Los **prácticos** aclaran el encuadre ético/legal cuando corresponde.

## Dudas

Coordinamos por el grupo de WhatsApp de la cátedra o en los comentarios del PR.
