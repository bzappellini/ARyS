---
marp: true
theme: arys
paginate: true
footer: 'ARyS · IF046 · UNPSJB Trelew'
---

<!-- _class: portada -->
<!-- _paginate: false -->
<!-- _footer: '' -->

# Conceptos de Seguridad
## Unidad 1 — Los pilares

<div class="meta">ARyS · IF046 · UNPSJB Trelew · 2026</div>

<!--
Nota del docente:
Unidad fundacional. Todo el resto del curso se apoya en este vocabulario.
Insistir: la seguridad es un proceso, no un producto.
-->

---

## ¿De qué hablamos cuando decimos "seguridad"?

Seguridad de la información = **proteger la información** y los sistemas que la
procesan, almacenan y transmiten.

- No es "poner un antivirus"
- No es un producto que se compra
- Es una **propiedad** que se diseña y se sostiene

<div class="nota red"><span class="rot">Punto de partida</span>
La seguridad perfecta no existe. El objetivo es <strong>gestionar el riesgo</strong>
a un nivel aceptable, con lo que tenés.</div>

---

## Dato ≠ información

<div class="cols">
<div>

### Dato
Un hecho crudo, sin contexto.

`AR-2026-4471`
`27.5`
`-43.30, -65.10`

</div>
<div>

### Información
Datos con **contexto y significado**.

"El sensor de la sala de servidores
de Trelew marca 27,5 °C, por encima
del umbral."

</div>
</div>

<div class="nota"><span class="rot">Por qué importa</span>
Protegemos <strong>información</strong> y los sistemas que la sostienen. El valor está
en el significado, no en los bits.</div>

---

## Los tres pilares: la tríada CIA

![h:440](../../assets/img/triada-cia.svg)

---

## Confidencialidad

> Que la información sea accesible **solo para quien está autorizado**.

- Se rompe con: fuga de datos, espionaje, acceso indebido, sniffing
- Se protege con: **cifrado**, control de acceso, clasificación de la información

<div class="nota amenaza"><span class="rot">Se viola cuando…</span>
Alguien <em>lee</em> lo que no debía: una base filtrada, un mail interceptado,
una pantalla espiada.</div>

---

## Integridad

> Que la información **no se altere** de forma no autorizada, y que puedas
> **detectarlo** si ocurre.

- Se rompe con: manipulación, corrupción, errores, ransomware
- Se protege con: **hashes**, firmas digitales, control de versiones, permisos

<div class="nota amenaza"><span class="rot">Se viola cuando…</span>
Alguien <em>modifica</em> lo que no debía: un monto en una transferencia,
un log borrado, un archivo cifrado por ransomware.</div>

---

## Disponibilidad

> Que la información y los servicios estén **accesibles cuando se los necesita**.

- Se rompe con: DoS/DDoS, fallas de hardware, desastres, errores
- Se protege con: **redundancia**, backups, balanceo, mantenimiento

<div class="nota amenaza"><span class="rot">Se viola cuando…</span>
Algo <em>no está</em> cuando lo necesitás: un servidor caído, un ataque de
denegación, un backup que nunca se probó.</div>

---

## La tríada en tensión

Los tres pilares muchas veces **compiten** entre sí.

- Cifrado fuerte (confidencialidad) → más lento (¿disponibilidad?)
- Backups en todos lados (disponibilidad) → más superficie (¿confidencialidad?)
- Controles estrictos (integridad) → más fricción para el usuario

<div class="nota control"><span class="rot">El oficio</span>
Seguridad es <strong>equilibrar</strong> los tres según el contexto, no maximizar uno.
Un cajero automático y un blog no necesitan el mismo balance.</div>

---

## Más allá de CIA: autenticidad

> Garantizar que algo (un mensaje, un usuario, un sistema) **es quien dice ser**.

- ¿El que se conecta es realmente quien afirma?
- ¿Este mensaje vino de quien dice venir?

Se protege con: **autenticación** (Unidad 7), certificados, firma digital (Unidad 6).

<div class="nota"><span class="rot">Diferencia clave</span>
Confidencialidad protege el <em>contenido</em>. Autenticidad protege el <em>origen</em>.</div>

---

## No repudio

> Que quien realizó una acción **no pueda negar** haberla hecho.

- Firmaste digitalmente un documento → no podés decir "yo no fui"
- Un log firmado registra quién hizo qué y cuándo

Se apoya en: **firma digital**, registros íntegros (Unidad 6 y Unidad 8).

<div class="nota control"><span class="rot">Dónde se usa</span>
Comercio electrónico, expedientes digitales, auditoría. Sin no repudio no hay
responsabilidad demostrable.</div>

---

## Privacidad

> El **control de la persona** sobre sus propios datos personales.

- No es lo mismo que confidencialidad: es **quién decide** sobre el dato
- Marco legal en Argentina: **Ley 25.326** de Protección de Datos Personales

<div class="nota legal"><span class="rot">Responsabilidad</span>
Si administrás sistemas con datos de personas, tenés obligaciones legales sobre
ellos. La técnica no te exime de la ley.</div>

---

## El vocabulario del riesgo

![h:340](../../assets/img/riesgo.svg)

---

## Las cuatro piezas

<div class="tarjetas">
<div class="t"><b>Activo</b>Lo que tiene valor: datos, servidores, servicios, reputación.</div>
<div class="t"><b>Amenaza</b>Quién o qué puede causar daño: atacante, falla, desastre.</div>
<div class="t"><b>Vulnerabilidad</b>La debilidad que la amenaza aprovecha.</div>
<div class="t"><b>Riesgo</b>La probabilidad de que pase, por el impacto si pasa.</div>
</div>

<div class="nota red"><span class="rot">Clave</span>
Sin vulnerabilidad no hay riesgo, aunque exista la amenaza. Y sin activo de valor,
tampoco. El riesgo vive en la <strong>intersección</strong>.</div>

---

## ¿Cómo tratamos el riesgo?

Una vez que lo identificás y lo medís, tenés **cuatro** caminos:

1. **Mitigar** — poner controles que lo bajen (lo más común)
2. **Transferir** — pasarlo a un tercero (seguro, proveedor)
3. **Aceptar** — convivir con él si es bajo y controlarlo cuesta más
4. **Evitar** — no hacer la actividad que lo genera

<div class="nota control"><span class="rot">Decisión de negocio</span>
No todo se mitiga. Aceptar un riesgo bajo <em>a conciencia</em> es una decisión
válida; ignorarlo no.</div>

---

## Tipos de controles

Ya los vamos a usar en toda la materia. Se clasifican por **cuándo** actúan:

| Tipo | Cuándo | Ejemplo |
|---|---|---|
| **Preventivo** | Antes | Firewall, cifrado, control de acceso |
| **Detectivo** | Durante | IDS, monitoreo, logs |
| **Correctivo** | Después | Backup, respuesta a incidentes |
| **Disuasivo** | Antes (psicológico) | Cartelería, políticas |

<div class="nota"><span class="rot">Y también</span>
Por su naturaleza: <strong>físicos</strong> (U2), <strong>técnicos/lógicos</strong>
(casi todo el curso) y <strong>administrativos</strong> (políticas, procedimientos).</div>

---

## Defensa en profundidad

Ningún control es perfecto. Por eso **nunca uno solo**: capas que se respaldan.

- Si una capa falla, la siguiente contiene
- Cada capa **retrasa** al atacante y **genera evidencia**
- Aplica a lo físico, lo lógico y lo humano

<div class="nota control"><span class="rot">Lo vemos en detalle</span>
Es el corazón de la <strong>Unidad 2</strong> (perímetro físico) y reaparece en
firewall, IDS y arquitectura de red.</div>

---

## Principios de diseño seguro

<div class="cols">
<div>

- **Menor privilegio** — solo los permisos necesarios
- **Mínima exposición** — menos superficie, menos riesgo
- **Fail-safe** — si algo falla, que falle cerrado

</div>
<div>

- **Separación de deberes** — nadie controla todo el proceso
- **Defensa en capas** — nunca un único control
- **KISS** — lo simple es más fácil de asegurar

</div>
</div>

<div class="nota red"><span class="rot">Regla que vale oro</span>
<strong>Menor privilegio.</strong> La mayoría de los incidentes graves empiezan con
una cuenta que tenía más permisos de los que necesitaba.</div>

---

## La seguridad es un proceso

No se "termina". Se **sostiene** con un ciclo de mejora continua (PDCA):

<div class="cols">
<div>

- **Planificar** — evaluar riesgos, definir controles
- **Hacer** — implementarlos

</div>
<div>

- **Verificar** — monitorear, auditar, medir
- **Actuar** — corregir y mejorar

</div>
</div>

<div class="nota amenaza"><span class="rot">Por qué nunca termina</span>
Aparecen nuevas amenazas, cambia la tecnología, rota la gente. Un sistema
"seguro" el año pasado no lo es hoy por default.</div>

---

## Marcos de referencia (para ubicarte)

<div class="tarjetas">
<div class="t"><b>ISO/IEC 27001</b>Sistema de gestión de seguridad de la información (SGSI).</div>
<div class="t"><b>NIST CSF</b>Identificar · Proteger · Detectar · Responder · Recuperar.</div>
<div class="t"><b>OWASP</b>Seguridad de aplicaciones web (Top 10).</div>
<div class="t"><b>CIS Controls</b>Controles priorizados y accionables.</div>
</div>

<div class="nota"><span class="rot">Para qué sirven</span>
No para memorizarlos hoy: para saber que existe un <strong>consenso</strong> sobre qué
hacer, y no reinventar la rueda cuando diseñes.</div>

---

## Cerrando la unidad

1. Protegemos **información** y los sistemas que la sostienen
2. **CIA**: confidencialidad, integridad, disponibilidad — en equilibrio
3. Sumá **autenticidad**, **no repudio** y **privacidad**
4. **Riesgo** = amenaza + vulnerabilidad sobre un activo de valor
5. Se trata con **controles**, en **capas** (defensa en profundidad)
6. La seguridad es un **proceso**, no un producto

<div class="nota red"><span class="rot">Próxima unidad</span>
<strong>Unidad 2 — Seguridad Física.</strong> El primer perímetro: porque todos
estos controles se ejecutan sobre hardware que alguien puede tocar.</div>

---

<!-- _class: portada -->
<!-- _paginate: false -->
<!-- _footer: '' -->

# ¿Preguntas?

<div class="meta">Material: github.com/bzappellini/ARyS · Campus virtual UNPSJB</div>
