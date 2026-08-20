# Guía de Identidad — ARyS

Identidad visual de la cátedra **Administración de Redes y Seguridad** (IF046,
UNPSJB Trelew). Combina la **base institucional** de la Universidad con una
**identidad propia** derivada del contenido de la materia.

## 1. Origen institucional (UNPSJB)

Según el *Manual de Identidad Institucional* de la UNPSJB (Res. 505/81):

| Color oficial | RGB | Uso |
|---|---|---|
| **Azul (azur del escudo)** | `0, 73, 146` → `#004992` | Color principal |
| **Amarillo-anaranjado** | `255, 153, 0` → `#FF9900` | Acento (pico/patas del albatros) |

- **Sigla oficial:** `UNPSJB`, siempre en español, sin puntos.
- **Escudo:** óvalo azur con albatros regional. Se usa el provisto por la
  Universidad; **no** se recolorea ni se deforma.
- Tipografía institucional para texto corrido: Times New Roman (documentos
  formales). En pantalla usamos stacks del sistema por compatibilidad.

Los assets institucionales están en `identidad/assets/unpsjb-*.png`.

## 2. Identidad propia de la materia (ARyS)

La materia articula **redes** + **seguridad**. De ahí el isotipo:

- **Escudo** → seguridad, protección, el "primer perímetro".
- **Nodos y enlaces** dentro del escudo → la red administrada.
- **Nodo naranja central** → el activo protegido; usa el acento institucional.

Archivos:

- `identidad/assets/arys-isotipo.svg` — marca compacta (favicon, avatar).
- `identidad/assets/arys-logo.svg` — logo horizontal con nombre completo.

El isotipo hereda el **azul y el naranja institucionales**, de modo que la
identidad de la materia se lee como parte de la Universidad, no como algo ajeno.

## 3. Paleta extendida

La base institucional se amplía con **colores semánticos** mapeados a conceptos
de la materia (definidos en `arys-tokens.css`):

| Token | Color | Concepto |
|---|---|---|
| `--arys-red` | `#35C4DC` | Red / tráfico |
| `--arys-amenaza` | `#E5484D` | Amenaza / ataque / riesgo |
| `--arys-control` | `#3DA35D` | Control / contramedida |
| `--arys-evidencia` | `#A78BFA` | Registro / auditoría / evidencia |

Estos colores estructuran los *callouts* de las filminas (`.nota amenaza`,
`.nota control`, `.nota legal`, `.nota red`) para que el mismo concepto tenga
siempre el mismo color en todo el curso.

## 4. Tipografía en pantalla

- **Títulos:** Trebuchet MS / Verdana / DejaVu Sans (stack del sistema).
- **Texto:** stack de sistema (`system-ui`).
- **Código / mono:** JetBrains Mono / Fira Code / DejaVu Sans Mono.

No se usan fuentes de CDN: las filminas deben funcionar **sin conexión** en el
aula.

## 5. Usos correctos e incorrectos

**Correcto**
- Respetar los colores institucionales en logos y encabezados.
- Usar el escudo provisto por la Universidad, sin alterarlo.
- Mantener el pie institucional en filminas y sitio.

**Incorrecto**
- Recolorear o distorsionar el escudo de la UNPSJB.
- Cambiar el azul institucional por otro azul.
- Mezclar la identidad de la materia con logos de terceros sin criterio.

## 6. Archivos de identidad

```
identidad/
├── arys-tokens.css          # Fuente única de colores y tipografía
├── GUIA-IDENTIDAD.md        # Este documento
└── assets/
    ├── arys-isotipo.svg     # Isotipo de la materia
    ├── arys-logo.svg        # Logo horizontal
    ├── unpsjb-escudo.png            # Escudo sin letras
    ├── unpsjb-escudo-letras.png     # Escudo con letras
    ├── unpsjb-escudo-blanco.png     # Escudo para fondos oscuros
    ├── unpsjb-albatros.png          # Albatros aislado
    └── unpsjb-logo50.png            # Logo horizontal 50 años
```
