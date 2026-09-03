---
marp: true
theme: arys
paginate: true
footer: 'ARyS · IF046 · UNPSJB Trelew'
---

<!-- _class: portada -->
<!-- _paginate: false -->
<!-- _footer: '' -->

# Administración de Redes y Seguridad
## Presentación de la materia

<div class="meta">IF046 · UNPSJB · Sede Trelew · 2026</div>

<!--
Nota del docente:
Primera clase. El objetivo es que se lleven el mapa completo: qué van a
aprender, cómo se trabaja y cómo se aprueba. Sin tecnicismos todavía.
-->

---

## ¿Qué vas a aprender acá?

A **administrar una red sin descuidar su seguridad** — porque son la misma cosa.

- Cómo se **defiende** una red: física, lógica y humana
- Cómo **piensa un atacante**, para poder anticiparlo
- **Criptografía** aplicada: qué protege y qué no
- Cómo **monitorear** y mantener una red sana

<div class="nota red"><span class="rot">La idea de fondo</span>
Administrar y asegurar no son dos trabajos: son dos caras del mismo trabajo.</div>

---

## La cátedra

<div class="cols">
<div>

### Equipo docente
- **Profesor:** Bruno Zappellini
- **Ayudante de práctica:** Lucas Krmpotic
- **Código:** IF046 · 2º cuatrimestre
- **Carga:** 90 h (45 teoría + 45 práctica)

</div>
<div>

### Cursada
- **Teoría:** jueves 15:00 – 18:00 *(Bruno)*
- **Práctica:** viernes 17:00 – 20:00 *(Lucas)*
- **Correlativa:** IF019 — Redes y
  Transmisión de Datos

</div>
</div>

<div class="nota legal"><span class="rot">Correlativa</span>
Damos por sabido lo de <strong>Redes (IF019)</strong>: modelo TCP/IP, direccionamiento,
puertos, ruteo. Sobre eso construimos.</div>

---

## ¿Por qué importa esta materia?

Todo lo que hacés hoy pasa por una red: banco, salud, estado, trabajo.

- La red es la **infraestructura crítica** de cualquier organización
- Un incidente de seguridad **no es un problema de TI**: es un problema del negocio
- El profesional que **administra** también **responde** por la seguridad

<div class="nota amenaza"><span class="rot">Realidad del campo</span>
No hay "administrador de red" por un lado y "de seguridad" por otro en la mayoría
de las organizaciones. Sos vos. Por eso las juntamos.</div>

---

## El mapa: 8 unidades

<div class="tarjetas">
<div class="t"><b>1 · Conceptos</b>Los pilares: CIA, riesgo, controles.</div>
<div class="t"><b>2 · Seguridad Física</b>El primer perímetro.</div>
<div class="t"><b>3 · Hacking Ético</b>Reconocimiento, escaneo, acceso.</div>
<div class="t"><b>4 · Sniffing</b>Análisis de tráfico.</div>
<div class="t"><b>5 · Firewall / IDS</b>Defensa perimetral y detección.</div>
<div class="t"><b>6 · Criptografía</b>Simétrica, asimétrica, PKI, VPN.</div>
<div class="t"><b>7 · Autenticación</b>AAA, Kerberos, MFA.</div>
<div class="t"><b>8 · Monitoreo</b>SNMP, Syslog, gestión.</div>
</div>

---

## El hilo que une todo

No son ocho temas sueltos. Es **una historia**:

1. Entendés **qué proteger** (U1) y el **perímetro físico** (U2)
2. Aprendés a **atacar para defender** (U3–U4)
3. Levantás las **defensas** (U5)
4. Protegés los datos aunque los capturen (U6)
5. Controlás **quién entra** (U7)
6. **Vigilás** que todo siga sano (U8)

<div class="nota control"><span class="rot">Objetivo final</span>
Que puedas mirar una red y ver, a la vez, cómo administrarla y cómo la atacarían.</div>

---

## Cronograma (16 semanas)

| Sem | Tema | Sem | Tema |
|---|---|---|---|
| 1 | Conceptos | 9 | Firma digital |
| 2 | Seguridad física | 10 | Firewall |
| 3–4 | Reconocimiento y escaneo | 11 | IDS y Honeypot |
| 5 | Fingerprinting | 12 | Autenticación |
| 6 | Escaneos | 13–14 | Monitoreo |
| 7 | Criptografía simétrica | 15–16 | Gestión de red y seguridad |
| 8 | Criptografía asimétrica | | |

<div class="nota"><span class="rot">Orientativo</span>
Es el mapa del programa. Las fechas exactas y feriados los ajustamos sobre la marcha.</div>

---

## Cómo trabajamos

<div class="cols">
<div>

### Teoría
Los conceptos y el porqué.
El profesor abre cada tema.

### Práctica
Guías de laboratorio con
**software libre**, sobre
máquinas virtuales propias.

</div>
<div>

### Trabajo final
Investigación y aplicación de un
tema de la materia, preferentemente
con software libre.

Cierra con **informe** y
**exposición oral**.

</div>
</div>

<div class="nota red"><span class="rot">Filosofía</span>
Conceptos antes que herramientas. La herramienta cambia; el concepto queda.</div>

---

## El laboratorio

Todo lo ofensivo se practica en un **entorno propio y aislado**:

- Máquinas virtuales (VirtualBox / VMware)
- Blancos vulnerables legales: Metasploitable, DVWA
- Kali / Parrot como plataforma de trabajo
- Red **host-only**, snapshots para revertir

<div class="nota amenaza"><span class="rot">Regla de oro del laboratorio</span>
Lo que aprendés acá se practica <strong>sobre lo tuyo</strong>. Nunca sobre sistemas
ajenos sin autorización escrita. En la Unidad 3 vemos por qué eso es delito.</div>

---

## Cómo se aprueba

<div class="cols">
<div>

### Durante la cursada
- Prácticos de laboratorio
- Participación y compromiso
- Parciales

</div>
<div>

### Al cierre
- **Trabajo final** (investigación + aplicación)
- **Informe** escrito
- **Exposición oral**

</div>
</div>

<div class="nota legal"><span class="rot">A confirmar en clase</span>
El detalle de fechas de parciales, recuperatorios y condiciones de regularidad
se acuerda la primera semana y queda en el campus.</div>

---

## Herramientas que vas a usar

<div class="tarjetas">
<div class="t"><b>Nmap</b>Escaneo y descubrimiento.</div>
<div class="t"><b>Wireshark</b>Análisis de tráfico.</div>
<div class="t"><b>OpenSSL / GnuPG</b>Criptografía aplicada.</div>
<div class="t"><b>iptables / nftables</b>Firewall.</div>
<div class="t"><b>Snort / Suricata</b>IDS/IPS.</div>
<div class="t"><b>Wazuh / SNMP</b>Monitoreo.</div>
</div>

Todas **libres y gratuitas**. Se instalan en tu propia máquina o VM.

---

## Bibliografía y recursos

<div class="cols">
<div>

### Base
- W. Stallings — *Fundamentos de
  Seguridad en Redes*
- W. Stallings — *Network and
  Internetwork Security*

</div>
<div>

### Complementario
- OWASP Top 10
- NIST SP 800 (guías técnicas)
- Documentación de cada herramienta
- Material de la cátedra

</div>
</div>

---

## Cómo nos comunicamos

<div class="tarjetas">
<div class="t"><b>Campus virtual</b>Material, entregas y avisos oficiales.</div>
<div class="t"><b>Repositorio ARyS</b>Filminas, teoría y prácticos, siempre al día.</div>
<div class="t"><b>Grupo de WhatsApp</b>Coordinación del día a día.</div>
</div>

<div class="nota"><span class="rot">Fuente de verdad</span>
Lo oficial (fechas, entregas, notas) está en el <strong>campus</strong>. El resto es apoyo.</div>

---

## Lo que espero de vos

- **Curiosidad**: preguntar el *por qué*, no solo el *cómo*
- **Constancia**: la seguridad no se aprende en un fin de semana
- **Ética**: el poder de atacar viene con la responsabilidad de no hacerlo
- **Manos**: esto se aprende **haciendo**, en el laboratorio

<div class="nota control"><span class="rot">Trato</span>
Yo pongo el mapa, el contexto y las herramientas. El camino lo caminás vos.</div>

---

<!-- _class: portada -->
<!-- _paginate: false -->
<!-- _footer: '' -->

# ¡Bienvenidos a ARyS!
## Arrancamos por los conceptos

<div class="meta">Unidad 1 · github.com/bzappellini/ARyS · Campus virtual UNPSJB</div>
