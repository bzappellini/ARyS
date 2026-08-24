---
marp: true
theme: arys
paginate: true
footer: 'ARyS · IF046 · UNPSJB Trelew'
---

<!-- _class: portada -->
<!-- _paginate: false -->
<!-- _footer: '' -->

# Firewall, IDS y Honeypot
## Unidad 5 — Defender, detectar y engañar

<div class="meta">ARyS · IF046 · UNPSJB Trelew · 2026</div>

<!--
Nota del docente:
Retomamos el cierre de U4: pasamos de ESCUCHAR la red a CONTROLARLA y
VIGILARLA. Tres roles: firewall (controla), IDS/IPS (detecta), honeypot (engaña).
Aviso: las guías NIST de firewall/IDPS son normativas pero antiguas; usarlas
como marco y complementar con la doc de cada herramienta.
-->

---

## De escuchar a controlar

En la **Unidad 4** aprendimos a **escuchar** la red. Vimos también que la defensa
real es **cifrar** y **controlar** el tráfico.

Esta unidad son las **tres defensas** del perímetro:

<div class="tarjetas">
<div class="t"><b>Firewall</b>Controla: quién pasa y quién no.</div>
<div class="t"><b>IDS / IPS</b>Detecta: quién está atacando.</div>
<div class="t"><b>Honeypot</b>Engaña: atrae y estudia al atacante.</div>
</div>

---

## ¿Qué es un firewall?

> Un dispositivo o software que aplica una **política de control de acceso** entre
> dos zonas de **distinta confianza**.

- Decide qué tráfico **permite** y cuál **bloquea**, según reglas
- Es el **portero** entre tu red e Internet (y entre segmentos internos)

<div class="nota"><span class="rot">Marco de referencia</span>
NIST SP 800-41 Rev.1 (<em>Guidelines on Firewalls</em>). Es la guía normativa, aunque
<strong>antigua (2009)</strong>: sirve de marco; el estado del arte lo pone cada
herramienta.</div>

---

## Firewall de red vs. de host

<div class="cols">
<div>

### De red (perimetral)
Protege **un segmento entero**.
Se ubica en el borde o entre zonas.

- Un punto de control central
- Ejemplo: el firewall del borde

</div>
<div>

### De host
Protege **una sola máquina**.
Corre en el propio equipo.

- Última línea si el atacante ya entró
- Ejemplo: nftables/firewalld, Windows Firewall

</div>
</div>

<div class="nota control"><span class="rot">No es "o"</span>
Se usan <strong>los dos</strong>: defensa en profundidad (Unidad 1). El de red filtra
el grueso; el de host protege aunque el perímetro caiga.</div>

---

## Tipos de firewall por capa

![h:300](../../assets/img/tipos-firewall.svg)

---

## Políticas: la regla que ordena todo

Dos filosofías opuestas para la regla por defecto:

<div class="cols">
<div>

### Default **deny** ✓
Se **bloquea todo** y se permite solo lo necesario.

Lista blanca. **La correcta.**

</div>
<div>

### Default allow ✗
Se **permite todo** y se bloquea lo malo conocido.

Lista negra. Siempre te olvidás algo.

</div>
</div>

<div class="nota red"><span class="rot">Principio</span>
<strong>Menor privilegio</strong> (Unidad 1): abrí solo lo que hace falta. Todo lo
demás, cerrado por defecto.</div>

---

## NAT: traducción de direcciones

**NAT** reescribe las direcciones IP de los paquetes. **PAT/NAPT** además multiplexa
por **puerto**: muchos equipos privados salen tras **una** IP pública.

<div class="nota"><span class="rot">Fuentes</span>
Terminología NAT: <strong>RFC 2663</strong>. NAT tradicional (Basic NAT y NAPT):
<strong>RFC 3022</strong>. No es una función de seguridad en sí, pero es
inseparable del firewall perimetral.</div>

---

## SNAT vs. DNAT

<div class="cols">
<div>

### SNAT — Source NAT
Traduce el **origen**.
La red interna sale **enmascarada** con la IP pública.

*Salida* de la LAN a Internet.

</div>
<div>

### DNAT — Destination NAT
Traduce el **destino**.
**Publica** un servicio interno hacia afuera (*port forwarding*).

*Entrada* de Internet a un server.

</div>
</div>

<div class="nota amenaza"><span class="rot">Ojo con DNAT</span>
Cada regla DNAT <strong>abre una puerta</strong> desde Internet hacia adentro.
Publicá lo mínimo, y preferentemente hacia la <strong>DMZ</strong>, no a la LAN.</div>

---

## La DMZ: zona desmilitarizada

![h:300](../../assets/img/arquitectura-dmz.svg)

---

## Por qué existe la DMZ

Los servicios **públicos** (web, mail, DNS) tienen que ser accesibles desde
Internet… pero **no querés** que un atacante que comprometa el servidor web salte
directo a tu LAN.

<div class="nota control"><span class="rot">La idea</span>
La DMZ es una <strong>zona intermedia</strong>: si cae un servicio público, el
atacante queda <em>atrapado</em> ahí, con otro firewall entre él y la red interna.
Es defensa en profundidad aplicada a la topología.</div>

---

## Proxy directo vs. proxy reverso

<div class="cols">
<div>

### Proxy directo
Intermedia la **salida** de los clientes.

- Filtrado de contenido, caché
- El servidor externo ve al proxy

</div>
<div>

### Proxy reverso
Intermedia la **entrada** hacia tus servidores.

- Terminación TLS, balanceo, caché
- Punto ideal para un **WAF**

</div>
</div>

<div class="nota"><span class="rot">En la DMZ</span>
El proxy reverso suele vivir en la DMZ: recibe de Internet y reparte a los
servidores internos, sin exponerlos directamente.</div>

---

## Firewall en Linux: de iptables a nftables

**nftables** es el framework moderno de netfilter que **reemplaza** a iptables.
Hoy es el **backend por defecto** en las distros modernas; `firewalld` lo gestiona
por zonas.

```bash
# Política por defecto DENY + permitir SSH y HTTP (stateful) con nftables
nft add table inet filtro
nft add chain inet filtro entrada '{ type filter hook input priority 0; policy drop; }'
nft add rule inet filtro entrada ct state established,related accept
nft add rule inet filtro entrada tcp dport { 22, 80 } accept
```

<div class="nota"><span class="rot">Fuente</span>
Proyecto nftables (netfilter.org). <code>ct state</code> es la <strong>inspección de
estado</strong>: acepta lo que pertenece a una conexión ya válida.</div>

---

## NGFW: el firewall moderno

**Next-Generation Firewall**: combina el filtrado stateful con inspección **de
capa 7**, identidad de usuario, *deep packet inspection* e **IPS integrado**.

<div class="nota amenaza"><span class="rot">Honestidad de cátedra</span>
<strong>NGFW no está definido en ningún NIST ni RFC</strong>: es un término de
industria (Gartner). Útil como concepto, pero no le pongas un número normativo.</div>

---

## WAF: firewall de aplicación web

Un **WAF** inspecciona HTTP/HTTPS para frenar ataques web: inyección, XSS, y el
resto del **OWASP Top 10**.

- Se ubica delante de la app (proxy reverso)
- Reglas de referencia: **OWASP Core Rule Set (CRS)**, hoy en la línea 4.x

<div class="nota control"><span class="rot">Enganche</span>
El detalle de los ataques web (OWASP Top 10) es un mundo propio; acá nos alcanza
con saber que el WAF es el firewall <strong>que entiende de aplicaciones</strong>.</div>

---

<!-- _class: portada -->
<!-- _paginate: false -->
<!-- _footer: '' -->

# Detectar
## IDS · IPS

<div class="meta">El firewall controla; el IDS/IPS vigila</div>

---

## IDS vs. IPS

![h:300](../../assets/img/ids-vs-ips.svg)

---

## Cómo detectan

<div class="cols">
<div>

### Por firmas
Compara con patrones de ataques **conocidos**.

- Bajo falso positivo
- **Ciego** ante lo nuevo (0-day)

</div>
<div>

### Por anomalías
Modela el comportamiento **normal** y detecta **desvíos**.

- Puede ver lo desconocido
- **Más** falsos positivos

</div>
</div>

<div class="nota"><span class="rot">En la práctica</span>
Los sistemas modernos combinan ambos. Y recordá lo de la Unidad 4: hoy gran parte
del tráfico está cifrado, así que el IDS se apoya cada vez más en <strong>metadatos
y fingerprinting</strong> (JA3/JA4).</div>

---

## NIDS vs. HIDS · herramientas

<div class="cols">
<div>

### NIDS (de red)
Un sensor observa el **tráfico** de un segmento.

### HIDS (de host)
Un agente vigila **un equipo**: logs, integridad de archivos, procesos.

</div>
<div>

### Herramientas actuales
- **Snort 3** — el clásico, por firmas
- **Suricata** — multihilo, IDS/IPS/NSM
- **Zeek** (antes *Bro*) — análisis y
  *logging* profundo, no solo firmas

</div>
</div>

---

<!-- _class: portada -->
<!-- _paginate: false -->
<!-- _footer: '' -->

# Engañar
## Honeypots

<div class="meta">Convertir al atacante en tu fuente de inteligencia</div>

---

## ¿Qué es un honeypot?

> Un recurso **señuelo** cuyo único propósito es **ser atacado**.

- Nadie legítimo debería tocarlo → **casi cero falsos positivos**
- Cada interacción es, por definición, **sospechosa**
- Genera inteligencia: qué buscan, cómo entran, qué herramientas usan

<div class="nota control"><span class="rot">Alta señal</span>
Un IDS te ahoga en alertas. Un honeypot te da <strong>pocas alertas, pero todas
importan</strong>.</div>

---

## Interacción y honeytokens

<div class="cols">
<div>

### Baja interacción
**Emula** servicios. Bajo riesgo, menos datos.

### Alta interacción
Sistemas **reales**. Más realismo y más datos… y más riesgo.

</div>
<div>

### Honeytokens
Un **señuelo-dato**: una credencial, un archivo, una fila de BD falsos que
**disparan alerta** al ser usados.

</div>
</div>

<div class="nota"><span class="rot">Herramientas</span>
<strong>Cowrie</strong> (honeypot SSH/Telnet) · <strong>T-Pot</strong> (plataforma
multi-honeypot dockerizada, de Deutsche Telekom). La <em>deception technology</em>
lleva esto a escala de red.</div>

---

<!-- _class: portada -->
<!-- _paginate: false -->
<!-- _footer: '' -->

# El perímetro está cambiando
## De "castillo y foso" a Zero Trust

<div class="meta">La actualización que redefine todo lo anterior</div>

---

## El modelo "castillo y foso" en crisis

El esquema clásico: un **perímetro duro** (firewall) y un **interior confiable**.
Adentro, todos se creen entre sí.

**¿Por qué se rompió?**

- **Trabajo remoto** y movilidad: ya no hay un "adentro" claro
- **Cloud / SaaS**: los datos viven fuera de tu red
- **Movimiento lateral**: si el atacante entra, circula sin fricción

<div class="nota amenaza"><span class="rot">El problema de fondo</span>
Confiar por <strong>ubicación de red</strong> ("está adentro, es de confianza") es
la falla que explotan casi todos los ataques modernos.</div>

---

## Zero Trust

> **Nunca confíes, siempre verificá.** No hay confianza implícita por estar "dentro"
> de la red.

- Cada acceso a un recurso se **autentica y autoriza** por sesión
- **Microsegmentación**: la red se divide en segmentos mínimos con política estricta
- En cloud-native: firewalling por **identidad de workload** con **eBPF** (ej. Cilium)

<div class="nota control"><span class="rot">Fuente</span>
<strong>NIST SP 800-207</strong> (<em>Zero Trust Architecture</em>, 2020) y su
complemento cloud-native <strong>SP 800-207A</strong> (2023).</div>

---

## Una nota sobre las fuentes

En esta unidad conviven **dos edades**:

- Las guías **normativas** de NIST son sólidas pero **antiguas**: firewalls
  (800-41 Rev.1, **2009**) e IDPS (800-94, **2007**). NIST no publicó revisiones
  finales posteriores.
- El **estado del arte** vive en la documentación de cada herramienta (nftables,
  Suricata, Zeek, Cilium) y en marcos recientes como Zero Trust (2020).

<div class="nota red"><span class="rot">Criterio profesional</span>
Usá la norma como <strong>marco conceptual</strong> y la doc de la herramienta como
<strong>práctica actual</strong>. Citá cada cosa por lo que es.</div>

---

## Cerrando la unidad

1. **Firewall** = política de acceso entre zonas; de red y de host
2. Por capa: **stateless → stateful → aplicación (NGFW/WAF)**
3. Política **default deny** (menor privilegio); NAT: **SNAT** sale, **DNAT** publica
4. La **DMZ** aísla los servicios públicos de la LAN
5. **IDS** detecta y alerta; **IPS** bloquea inline; por firmas y por anomalías
6. El **honeypot** es señuelo de alta señal; **honeytokens** y deception
7. El perímetro clásico cede ante **Zero Trust**: nunca confíes, siempre verificá

<div class="nota red"><span class="rot">Próxima unidad</span>
<strong>Unidad 6 — Criptografía.</strong> La defensa que atraviesa todo el curso:
cómo se protege la información aunque el firewall falle y el tráfico se capture.</div>

---

<!-- _class: portada -->
<!-- _paginate: false -->
<!-- _footer: '' -->

# ¿Preguntas?

<div class="meta">Material: github.com/bzappellini/ARyS · Campus virtual UNPSJB</div>
