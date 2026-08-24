# Unidad 5 — Firewall, IDS y Honeypot

> Material teórico de acompañamiento. Complementa las filminas y la clase.
> ARyS · IF046 · UNPSJB Trelew.

## 1. Encuadre: defender, detectar y engañar

La Unidad 4 mostró cómo se **escucha** una red y concluyó que la defensa real pasa
por **cifrar** y **controlar** el tráfico. Esta unidad desarrolla las tres piezas de
la defensa perimetral, con roles complementarios:

- **Firewall** — controla qué tráfico pasa entre zonas de distinta confianza.
- **IDS / IPS** — detecta (y, en el caso del IPS, bloquea) actividad maliciosa.
- **Honeypot** — atrae y estudia al atacante, generando inteligencia de alta señal.

Una advertencia metodológica que atraviesa la unidad: las guías **normativas** de
NIST sobre firewalls (SP 800-41 Rev. 1, 2009) e IDPS (SP 800-94, 2007) son sólidas
pero **antiguas** —NIST no publicó revisiones finales posteriores—, de modo que
conviene usarlas como **marco conceptual** y complementar el estado del arte con la
documentación oficial de cada herramienta.

## 2. Firewalls

### 2.1 Qué es y para qué sirve

Un **firewall** es un dispositivo o software que aplica una **política de control de
acceso** entre dos zonas de **confianza distinta** (por ejemplo, Internet y la red
interna). Decide, según reglas, qué tráfico se permite y cuál se bloquea. Es el
marco de referencia normativo **NIST SP 800-41 Rev. 1** el que ordena estas ideas.

### 2.2 De red vs. de host

- **Firewall de red (perimetral)** — protege un segmento completo; se ubica en el
  borde o entre zonas, como punto de control central.
- **Firewall de host** — corre en la propia máquina y la protege individualmente; es
  la última línea si el atacante ya superó el perímetro.

No es una elección excluyente: la **defensa en profundidad** (Unidad 1) usa ambos.

### 2.3 Clasificación por capa

- **Filtrado de paquetes (stateless)** — decide paquete por paquete según cabeceras
  de capas 3–4 (IP, puerto, protocolo), sin memoria de la conexión. Rápido y simple,
  pero sin contexto.
- **Inspección de estado (stateful)** — mantiene una **tabla de conexiones** y evalúa
  cada paquete en el contexto de su sesión. Es el **estándar de facto** actual.
- **Aplicación / proxy (capa 7)** — termina y reinspecciona la sesión entendiendo el
  protocolo (HTTP, DNS, TLS). Más costoso, pero ve el contenido y la aplicación; es
  la base del **NGFW** y del **WAF**.

### 2.4 Políticas

La regla por defecto define la filosofía del firewall:

- **Default deny** (lista blanca) — se bloquea todo y se habilita solo lo necesario.
  Es la política **correcta**, alineada con el principio de **menor privilegio**.
- **Default allow** (lista negra) — se permite todo y se bloquea lo malo conocido;
  frágil, porque siempre queda algo abierto por olvido.

## 3. NAT, DMZ y proxies

### 3.1 NAT / PAT y SNAT / DNAT

**NAT** reescribe direcciones IP; **PAT / NAPT** además multiplexa por puerto, de
modo que muchos equipos privados salen tras una única IP pública. La terminología
está definida en **RFC 2663** y el mecanismo tradicional (Basic NAT y NAPT) en
**RFC 3022**. En jerga de firewall:

- **SNAT (Source NAT)** — traduce el **origen**; la LAN sale enmascarada. Es el flujo
  de **salida**.
- **DNAT (Destination NAT)** — traduce el **destino**; **publica** un servicio interno
  hacia afuera (*port forwarding*). Es el flujo de **entrada**, y cada regla DNAT abre
  una puerta desde Internet, por lo que debe minimizarse y apuntar preferentemente a
  la DMZ.

### 3.2 La DMZ

La **zona desmilitarizada (DMZ)** es una subred perimetral que aloja los servicios
expuestos a Internet (web, correo, DNS, proxy reverso) aislándolos de la LAN. Si un
servicio público es comprometido, el atacante queda confinado en la DMZ, con otro
firewall entre él y la red interna. Es defensa en profundidad aplicada a la
**topología**.

### 3.3 Proxy directo y reverso

- **Proxy directo** — intermedia la **salida** de los clientes (filtrado de
  contenido, caché); el servidor externo ve al proxy, no al cliente.
- **Proxy reverso** — intermedia la **entrada** hacia los servidores (terminación
  TLS, balanceo, caché) y es el punto ideal para ubicar un **WAF**. Suele vivir en la
  DMZ.

### 3.4 Firewall en Linux: nftables

**nftables** es el framework moderno del proyecto **netfilter** que reemplaza a
iptables/ip6tables/arptables/ebtables con una única herramienta (`nft`) y una máquina
de clasificación en el kernel. Es el **backend por defecto** en las distribuciones
modernas (incluso cuando se usa la sintaxis `iptables`, por debajo corre
`iptables-nft`). **firewalld** actúa como front-end de gestión dinámica por zonas.
La inspección de estado se expresa, por ejemplo, con `ct state established,related
accept`.

### 3.5 NGFW y WAF

El **Next-Generation Firewall (NGFW)** combina el filtrado stateful con inspección de
capa 7, identidad de usuario, *deep packet inspection* e IPS integrado. **Importante
para citar con honestidad: NGFW no está definido en ningún NIST SP ni RFC**; es un
término de industria (acuñado por Gartner), útil como concepto pero sin fuente
normativa. El **WAF (Web Application Firewall)** inspecciona HTTP/HTTPS para mitigar
el **OWASP Top 10**; su conjunto de reglas de referencia es el **OWASP Core Rule Set
(CRS)**, hoy en la línea 4.x.

## 4. IDS / IPS

### 4.1 Detección vs. prevención

Un **IDS (Intrusion Detection System)** observa el tráfico o el host y **alerta**
ante actividad sospechosa, típicamente **fuera de línea** (analizando una copia del
tráfico por SPAN/TAP), sin frenar el flujo. Un **IPS (Intrusion Prevention System)**
se ubica **en línea (inline)** y puede **bloquear** el tráfico malicioso, al costo de
ser un punto en el camino de los datos. El marco normativo es **NIST SP 800-94**
(*Guide to Intrusion Detection and Prevention Systems*, 2007; su Rev. 1 quedó en
borrador y fue retirada, así que la versión citable es la original).

### 4.2 Métodos de detección

- **Por firmas** — compara con patrones de ataques **conocidos**; bajo falso
  positivo, pero ciego ante lo nuevo (0-day).
- **Por anomalías** — modela el comportamiento **normal** y detecta desvíos; puede
  descubrir lo desconocido, a costa de más falsos positivos.

Los sistemas modernos combinan ambos. Además, como gran parte del tráfico va cifrado
(Unidad 4), la detección se apoya cada vez más en **metadatos y fingerprinting**
(JA3/JA4).

### 4.3 Ubicación y herramientas

- **NIDS (de red)** — un sensor observa el tráfico de un segmento.
- **HIDS (de host)** — un agente vigila un equipo (logs, integridad de archivos,
  procesos).

Herramientas vigentes: **Snort 3** (el clásico basado en firmas), **Suricata**
(multihilo, IDS/IPS/NSM) y **Zeek** (antes *Bro*; orientado al análisis y al
*logging* profundo del tráfico más que a las firmas).

## 5. Honeypots y deception

Un **honeypot** es un recurso **señuelo** cuyo único propósito es ser sondeado y
atacado. Como ningún usuario legítimo debería interactuar con él, **cada interacción
es sospechosa por definición**, lo que produce alertas de **muy alta señal y casi
ningún falso positivo** —el complemento perfecto de un IDS, que tiende a saturar de
alertas—. Se distingue entre honeypots de **baja interacción** (emulan servicios,
bajo riesgo, menos datos) y de **alta interacción** (sistemas reales, más realismo y
más riesgo). Un **honeytoken** es un artefacto-señuelo (una credencial, un archivo o
una fila de base de datos falsos) que dispara una alerta al ser usado, y la
**deception technology** industrializa estas técnicas a escala de red.

Herramientas de referencia: **Cowrie** (honeypot SSH/Telnet de media-alta
interacción) y **T-Pot** (plataforma multi-honeypot dockerizada de Deutsche Telekom
Security).

## 6. La evolución del perímetro: Zero Trust

El modelo clásico de **"castillo y foso"** —un perímetro duro con un interior
confiable— entró en crisis por el trabajo remoto, la adopción de cloud/SaaS, la
movilidad y el **movimiento lateral** (una vez dentro, el atacante circula con poca
fricción). Confiar por **ubicación de red** resultó ser la falla que explotan casi
todos los ataques modernos.

El paradigma dominante es **Zero Trust**: **no hay confianza implícita** por estar
"dentro" de la red; cada acceso a un recurso se autentica, autoriza y evalúa **por
sesión**. Se apoya en la **microsegmentación** (dividir la red en segmentos mínimos
con política estricta entre ellos) y, en entornos cloud-native, en el firewalling por
**identidad de workload** mediante **eBPF** (por ejemplo, Cilium en Kubernetes) en
lugar de reglas basadas en IP o VLAN. La referencia es **NIST SP 800-207 (Zero Trust
Architecture, 2020)** y su complemento cloud-native **SP 800-207A (2023)**.

## 7. Ideas para llevarse

1. El firewall aplica una política de acceso entre zonas; hay de red y de host.
2. Por capa: filtrado de paquetes → inspección de estado → aplicación (NGFW/WAF).
3. Política **default deny** (menor privilegio); SNAT sale, DNAT publica.
4. La DMZ aísla los servicios públicos de la red interna.
5. El IDS detecta y alerta; el IPS bloquea inline; por firmas y por anomalías.
6. El honeypot es un señuelo de alta señal; existen honeytokens y deception.
7. El perímetro clásico cede ante Zero Trust: nunca confíes, siempre verificá.

## 8. Referencias

- **NIST SP 800-41 Rev. 1** — *Guidelines on Firewalls and Firewall Policy* (2009). https://csrc.nist.gov/pubs/sp/800/41/r1/final
- **NIST SP 800-94** — *Guide to Intrusion Detection and Prevention Systems (IDPS)* (2007). https://csrc.nist.gov/pubs/sp/800/94/final
- **NIST SP 800-207** — *Zero Trust Architecture* (2020). https://csrc.nist.gov/pubs/sp/800/207/final · **SP 800-207A** (2023). https://csrc.nist.gov/pubs/sp/800/207/a/final
- **RFC 2663** — *IP NAT Terminology and Considerations* (1999). https://www.rfc-editor.org/rfc/rfc2663
- **RFC 3022** — *Traditional IP Network Address Translator* (2001). https://www.rfc-editor.org/rfc/rfc3022
- nftables (proyecto netfilter). https://www.netfilter.org/projects/nftables/index.html · wiki: https://wiki.nftables.org
- firewalld. https://firewalld.org/documentation/
- OWASP Core Rule Set (CRS). https://coreruleset.org/
- Snort. https://www.snort.org/ · Suricata. https://suricata.io/ · Zeek. https://zeek.org/
- Cowrie. https://github.com/cowrie/cowrie · T-Pot. https://github.com/telekom-security/tpotce
- Cilium (eBPF, microsegmentación cloud-native). https://cilium.io/
- Gartner Glossary — *Next-Generation Firewalls (NGFW)* (término de industria, sin norma). https://www.gartner.com/en/information-technology/glossary/next-generation-firewalls-ngfws
- W. Stallings — *Fundamentos de Seguridad en Redes* (bibliografía de cátedra).
