---
marp: true
theme: arys
paginate: true
footer: 'ARyS · IF046 · UNPSJB Trelew'
---

<!-- _class: portada -->
<!-- _paginate: false -->
<!-- _footer: '' -->

# Hacking Ético
## Unidad 3 — Reconocimiento, escaneo y acceso

<div class="meta">ARyS · IF046 · UNPSJB Trelew · 2026</div>

<!--
Nota del docente:
Clase teórica. El eje legal va PRIMERO y se repite. Sin autorización escrita,
todo lo que sigue es delito. Arrancar por ahí, no por las herramientas.
-->

---

## Del perímetro físico al perímetro lógico

En la **Unidad 2** el atacante entraba caminando.
Hoy entra **por la red**.

Mismo objetivo, mismas fases mentales:

- Estudiar el blanco (reconocimiento)
- Mapear puertas y ventanas (escaneo)
- Entrar (acceso)

<div class="nota red"><span class="rot">Diferencia clave</span>
Nosotros hacemos esto <strong>con permiso y con método</strong>. Esa es toda la
diferencia entre un profesional y un delincuente.</div>

---

## Primero lo primero: la ley

> Sin **autorización escrita, previa y con alcance definido**,
> todo lo que veremos hoy es un **delito**.

En Argentina, la **Ley 26.388** (delitos informáticos) modificó el Código Penal:

- Art. 153 bis — **acceso ilegítimo** a un sistema informático
- Art. 155 — publicación indebida de comunicaciones
- Art. 157 bis — acceso a bancos de datos personales
- Art. 183/184 — **daño informático** (sabotaje, ransomware)

<div class="nota legal"><span class="rot">Regla de oro</span>
Escanear un sistema que no es tuyo y para el que no tenés permiso <strong>ya es
ilegal</strong>, aunque no rompas nada.</div>


<!--
Nota del docente:
ARRANCAR POR ACÁ Y NO AFLOJAR. Es la slide más importante de la unidad.
Repetir 3 veces si hace falta: sin autorización escrita, TODO esto es delito.
Contar un caso real (multa/causa por escaneo no autorizado). Preguntar al aula:
"¿escanear el puerto de un servidor ajeno, sin tocar nada, es delito?" (Sí, Art. 153 bis).
Tiempo: 5-7 min. Que quede grabado antes de ver una sola herramienta.
-->

---

## Hacker ≠ delincuente

El término técnico es **hacker**: alguien que entiende un sistema a fondo y lo
lleva más allá de su uso previsto. El color indica la **ética**, no la
habilidad.

<div class="tarjetas">
<div class="t"><b>White hat</b>Trabaja con autorización. Reporta y ayuda a corregir.</div>
<div class="t"><b>Black hat</b>Actúa sin permiso, con fin ilícito o dañino.</div>
<div class="t"><b>Grey hat</b>Sin permiso, pero sin intención dañina. Igual es ilegal.</div>
</div>

<div class="nota"><span class="rot">En esta materia</span>
Formamos <strong>white hats</strong>. El conocimiento ofensivo existe para
poder <strong>defender</strong>.</div>


<!--
Nota del docente:
Desarmar el prejuicio de los medios. El sombrero indica la ÉTICA, no la habilidad.
Preguntar: "¿un grey hat que reporta un bug sin permiso, comete delito?" (Sí, aunque su
intención sea buena). En esta materia formamos white hats. Tiempo: 3 min.
-->

---

## Marco del trabajo: reglas de compromiso

Antes de tocar una sola tecla, un pentest serio define:

- **Scope** — qué IPs, dominios y sistemas entran (y cuáles NO)
- **Ventana de tiempo** — cuándo se puede probar
- **Autorización firmada** — el "get out of jail card"
- **Contacto de emergencia** — a quién llamar si algo se cae
- **Manejo de datos** — qué se hace con lo que se encuentre
- **Reglas de exclusión** — sin DoS, sin ingeniería social, etc.

<div class="nota legal"><span class="rot">Sin esto</span>
No hay pentest. Hay una intrusión.</div>


<!--
Nota del docente:
Analogía: es como una orden de allanamiento. Sin el papel firmado, el mejor pentester del
mundo es un intruso. Recalcar el 'scope': lo que NO está en el alcance, no se toca. Tiempo: 4 min.
-->

---

## Tipos de evaluación según conocimiento

<div class="cols">
<div>

### Black box
El evaluador **no sabe nada**.
Simula un atacante externo real.
Más realista, más lento.

### White box
Acceso **total**: código, credenciales, arquitectura.
Más profundo, más rápido.

</div>
<div>

### Grey box
Conocimiento **parcial**.
Simula un insider o un atacante que ya obtuvo algo.
El equilibrio más común.

</div>
</div>


<!--
Nota del docente:
Pedir ejemplos al aula. Black box = simular atacante externo real (lento). White box =
auditoría profunda. Grey box = punto medio, lo más común. Tiempo: 3 min.
-->

---

## Metodologías reconocidas

No improvisamos: seguimos marcos probados.

- **PTES** — Penetration Testing Execution Standard
- **OSSTMM** — Open Source Security Testing Methodology Manual
- **NIST SP 800‑115** — guía técnica de evaluación de seguridad
- **OWASP WSTG** — para aplicaciones web (lo veremos más adelante)
- **Cyber Kill Chain** (Lockheed Martin) y **MITRE ATT&CK** — modelan al adversario

<div class="nota"><span class="rot">Para qué</span>
Una metodología asegura que <strong>no te olvides pasos</strong> y que el
trabajo sea <strong>repetible y auditable</strong>.</div>

---

## Las fases del hacking ético

![h:300](../../assets/img/fases-hacking.svg)

El programa de la materia se enfoca en las **tres primeras**:
**Reconocimiento, Escaneo y Acceso.**

<div class="nota red"><span class="rot">Hoy</span>
Fase 1 y 2 en profundidad. La fase 3 la vemos en concepto; la explotación real
la trabajan las unidades de criptografía, firewall y las prácticas.</div>


<!--
Nota del docente:
Anclar TODA la clase a estas fases. Nosotros vemos 1, 2 y 3 (foco naranja); 4 y 5 en
concepto, motivan la Unidad 8 (Monitoreo). Volver a este diagrama al cambiar de fase. 3 min.
-->

---

## Fase 1 · Reconocimiento
### Conocé al blanco antes de tocarlo

---

## Recon pasivo vs. activo

<div class="cols">
<div>

### Pasivo
**No tocás** el objetivo.
Usás fuentes públicas.

- Google, redes sociales
- Whois, DNS público
- Shodan, Censys
- Certificados (crt.sh)

**Indetectable** por el blanco.

</div>
<div>

### Activo
**Interactuás** con el objetivo.

- Ping, traceroute
- Consultas DNS al servidor del blanco
- Banner grabbing

Deja rastro. **Ya toca** al objetivo.

</div>
</div>


<!--
Nota del docente:
Clave: el pasivo es INDETECTABLE, no tocás el objetivo. Preguntar: "¿buscar la empresa en
LinkedIn es pasivo o activo?" (pasivo). "¿un ping?" (activo).
>>> DEMO 1 (whois + dig): hacer el recon pasivo de un dominio en vivo (ver guia-demos.md). 4 min + demo.
-->

---

## OSINT — inteligencia de fuentes abiertas

La información pública que una organización regala sin darse cuenta:

<div class="tarjetas">
<div class="t"><b>Personas</b>LinkedIn, organigramas, mails, roles.</div>
<div class="t"><b>Tecnología</b>Ofertas de empleo que revelan el stack.</div>
<div class="t"><b>Infraestructura</b>Registros DNS, rangos IP, subdominios.</div>
<div class="t"><b>Metadatos</b>Autores y software en PDFs y documentos.</div>
<div class="t"><b>Filtraciones</b>Credenciales en brechas previas (HIBP).</div>
<div class="t"><b>Código</b>Repos públicos con secretos olvidados.</div>
</div>


<!--
Nota del docente:
Mensaje: las organizaciones REGALAN información. Que el aula piense qué exponen ELLOS
(Instagram, CV con mail laboral, fotos con GPS). Que busquen su mail en Have I Been Pwned. 4 min.
-->

---

## Footprinting: huella de la organización

**Footprinting** = construir el mapa completo del blanco desde afuera.

```bash
# Whois: titular, contactos, fechas del dominio
whois unp.edu.ar

# Registros DNS
dig unp.edu.ar ANY +noall +answer
dig MX unp.edu.ar +short          # servidores de correo
dig NS unp.edu.ar +short          # servidores de nombres

# Transferencia de zona (mal configurada = regalo)
dig AXFR unp.edu.ar @ns1.ejemplo.com
```

<div class="nota amenaza"><span class="rot">Hallazgo típico</span>
Una <strong>transferencia de zona</strong> abierta entrega TODOS los registros
DNS internos de una vez.</div>


<!--
Nota del docente:
>>> DEMO 2 (footprinting): whois + dig MX/NS de un dominio real. Mostrar proveedor de mail
y servidores de nombres. Explicar la transferencia de zona (AXFR) como el regalo clásico
de una mala config. Tiempo: 5 min con demo.
-->

---

## Enumeración de subdominios y DNS

```bash
# Enumeración pasiva por certificados TLS emitidos
# (crt.sh indexa todos los certificados públicos)
curl -s "https://crt.sh/?q=%25.unp.edu.ar&output=json" | jq -r '.[].name_value' | sort -u

# Fuerza bruta de subdominios con diccionario
dnsrecon -d unp.edu.ar -D subdominios.txt -t brt

# Búsqueda inversa de un rango
dnsrecon -r 200.16.16.0/24
```

Cada subdominio nuevo es **una puerta más** que quizá nadie está vigilando.


<!--
Nota del docente:
>>> DEMO 3 (crt.sh): en el navegador, buscar %.unp.edu.ar en crt.sh. Aparecen los subdominios
de los certificados públicos. Preguntar: "¿pasivo o activo?" (pasivo). Impacta mucho.
-->

---

## Google Dorking

Operadores de búsqueda que exponen lo que no debería estar indexado:

```
site:unp.edu.ar filetype:pdf           # documentos públicos
site:unp.edu.ar intitle:"index of"     # listados de directorios
site:unp.edu.ar inurl:admin            # paneles de administración
site:unp.edu.ar ext:sql | ext:log      # backups y logs expuestos
"password" filetype:xls site:ejemplo   # credenciales en planillas
```

<div class="nota"><span class="rot">Google Hacking Database</span>
Exploit-DB mantiene la <strong>GHDB</strong>: un catálogo de dorks por categoría.
Los defensores la usan para buscarse a sí mismos.</div>


<!--
Nota del docente:
>>> DEMO 4 (dorks): probar site:unp.edu.ar filetype:pdf y luego intitle:"index of". Mostrar la
GHDB. ADVERTENCIA: mirar resultados públicos es legal; ACCEDER a lo que no debería estar ahí, no.
-->

---

## Shodan: el buscador de dispositivos

Google indexa páginas. **Shodan indexa dispositivos** conectados: cámaras, PLCs,
bases de datos, routers, servidores.

```
# Consultas típicas en shodan.io
org:"Universidad Nacional Patagonia"
port:3389 country:AR              # escritorio remoto expuesto
product:MongoDB                   # bases sin autenticación
"default password"
```

<div class="nota amenaza"><span class="rot">Realidad</span>
Miles de dispositivos industriales y cámaras están en Internet
<strong>sin contraseña</strong>. Shodan solo los lista; ya estaban ahí.</div>


<!--
Nota del docente:
>>> DEMO 5 (Shodan, la estrella): ver guia-demos.md, sección Shodan. Mostrar GRATIS vs PAGA en
vivo. Gratis: una búsqueda simple (product:MongoDB o una webcam), resultados y filtros limitados.
Paga: más resultados, filtros avanzados, exportación y API. Recalcar: Shodan solo LISTA lo ya
expuesto; conectarse a esos equipos sin permiso es delito. 7-8 min. Es la que más engancha.
-->

---

## Metadatos: lo que filtran los documentos

Un PDF o una foto publicada llevan **metadatos** ocultos:

```bash
# Autor, software, sistema operativo de un documento
exiftool informe.pdf

# GPS y modelo de cámara en una foto
exiftool foto.jpg | grep -i gps
```

- Nombres de usuario internos
- Rutas de red y nombres de equipos
- Versiones de software (= vulnerabilidades conocidas)
- Ubicación física (GPS de fotos)

<div class="nota control"><span class="rot">Defensa</span>
Limpiar metadatos antes de publicar. Muchos CMS lo hacen; muchos no.</div>


<!--
Nota del docente:
>>> DEMO 6 (exiftool): bajar un PDF público y correr exiftool: autor, software, a veces rutas.
Con una foto, los datos GPS. Moraleja: limpiar metadatos antes de publicar. 4 min.
-->

---

## Fase 2 · Escaneo
### Ahora sí, tocamos la red

---

## Del mapa al terreno

El reconocimiento nos dio el **mapa**. El escaneo confirma qué hay **realmente
vivo y escuchando**. Tres preguntas, en orden:

1. **¿Qué hosts están activos?** — *host discovery*
2. **¿Qué puertos están abiertos?** — *port scanning*
3. **¿Qué corre detrás y en qué versión?** — *service & OS fingerprinting*

<div class="nota amenaza"><span class="rot">Recordá</span>
A partir de acá <strong>ya interactuás</strong> con sistemas ajenos. Sin
autorización, es delito bajo el Art. 153 bis.</div>

---

## Repaso: puertos y estados

Un **puerto** es un número (0–65535) que identifica un servicio sobre TCP o UDP.
Correlativa con **IF019 Redes**.

| Puerto | Servicio | | Puerto | Servicio |
|---|---|---|---|---|
| 22 | SSH | | 443 | HTTPS |
| 25 | SMTP | | 3306 | MySQL |
| 53 | DNS | | 3389 | RDP |
| 80 | HTTP | | 8080 | HTTP alt |

Un escáner reporta cada puerto como: **open**, **closed** o **filtered**
(un firewall descarta la respuesta).

---

## Nmap: el estándar del escaneo

```bash
# Descubrimiento de hosts en una red (ping scan, sin escanear puertos)
nmap -sn 192.168.1.0/24

# Escaneo TCP SYN de los puertos más comunes (requiere privilegios)
sudo nmap -sS 192.168.1.10

# Todos los puertos TCP
sudo nmap -sS -p- 192.168.1.10

# Detección de versión de servicios y sistema operativo
sudo nmap -sV -O 192.168.1.10
```

<div class="nota"><span class="rot">Por qué SYN</span>
El escaneo <strong>-sS</strong> no completa la conexión TCP (no manda el ACK
final): es más rápido y más discreto que un connect completo.</div>


<!--
Nota del docente:
AVISO antes de tocar Nmap: a partir de acá YA interactuamos con sistemas. Solo contra
scanme.nmap.org (Nmap lo autoriza) o nuestras VMs. Nunca la red de la facultad.
>>> DEMO 7 (nmap): -sn de la red del lab, luego -sS -sV contra scanme.nmap.org. Leer la salida
juntos. Tiempo: 6 min con demo.
-->

---

## Anatomía del escaneo TCP SYN

![h:330](../../assets/img/escaneo-tcp.svg)

El estado del puerto se deduce de **cómo responde** (o si no responde).

---

## Detección de servicios y versiones

Saber que el 80 está abierto es poco. Importa **qué** y **qué versión**:

```bash
# -sV interroga el servicio para identificar producto y versión
sudo nmap -sV -p 80,443,22 192.168.1.10

# Ejemplo de salida
# 22/tcp  open  ssh      OpenSSH 7.6p1 Ubuntu
# 80/tcp  open  http     Apache httpd 2.4.29
# 443/tcp open  ssl/http Apache httpd 2.4.29
```

<div class="nota amenaza"><span class="rot">Por qué importa la versión</span>
Con producto + versión buscás en <strong>CVE / Exploit-DB / NVD</strong> si hay
un exploit público. La versión es la llave del acceso.</div>


<!--
Nota del docente:
Fijar EL concepto: la VERSIÓN es la llave. Mostrar el salto de 'Apache 2.4.29' a buscar en
CVE/Exploit-DB. Preguntar: "¿por qué el atacante quiere la versión exacta, no solo el puerto?" 4 min.
-->

---

## Fingerprinting del sistema operativo

Cada pila TCP/IP responde de forma ligeramente distinta. Nmap analiza esas
diferencias (TTL, tamaño de ventana, flags) para **adivinar el SO**.

```bash
sudo nmap -O 192.168.1.10

# Aggressive: versión + SO + scripts + traceroute, todo junto
sudo nmap -A 192.168.1.10
```

- TTL inicial ≈ 64 → Linux/Unix
- TTL inicial ≈ 128 → Windows
- TTL inicial ≈ 255 → dispositivos de red

<div class="nota"><span class="rot">Cuidado</span>
El fingerprinting es probabilístico, no exacto. Un firewall o NAT puede
alterar los valores.</div>

---

## NSE: el motor de scripts de Nmap

Nmap no solo escanea: **automatiza tareas** con scripts (Lua).

```bash
# Scripts de descubrimiento y "seguros" por defecto
nmap -sC 192.168.1.10

# Categoría específica: buscar vulnerabilidades conocidas
sudo nmap --script vuln 192.168.1.10

# Un script puntual: enumerar recursos compartidos SMB
nmap --script smb-enum-shares -p445 192.168.1.10
```

<div class="nota amenaza"><span class="rot">Cruce de fases</span>
Categorías como <code>intrusive</code> o <code>exploit</code> ya no son
reconocimiento: <strong>atacan</strong>. Solo con autorización explícita.</div>


<!--
Nota del docente:
Línea roja: -sC y scripts 'safe' son reconocimiento; 'intrusive' y 'exploit' YA atacan y
necesitan autorización. Buen momento para recordar la ley. 3 min.
-->

---

## Escaneo de vulnerabilidades

Distinto de Nmap: herramientas dedicadas que **comparan** servicios y versiones
contra una base de vulnerabilidades conocidas.

- **OpenVAS / Greenbone** — libre, completo
- **Nessus** — comercial, estándar de la industria
- **Nuclei** — plantillas rápidas, muy usado hoy

<div class="nota control"><span class="rot">Ojo con los falsos positivos</span>
Un escáner <em>sugiere</em> vulnerabilidades. El profesional las
<strong>verifica</strong> antes de reportarlas. Reportar un falso positivo
destruye tu credibilidad.</div>

---

## Fase 3 · Obtener acceso
### La puerta que encontramos, abierta

---

## Del hallazgo a la explotación

El escaneo nos dio: servicio + versión + posible vulnerabilidad.
La **explotación** convierte eso en acceso real.

Vectores más comunes:

- **Vulnerabilidad de software** — exploit contra un servicio sin parchear
- **Credenciales débiles o por defecto** — admin/admin todavía funciona
- **Errores de configuración** — permisos, servicios expuestos de más
- **Factor humano** — phishing, ingeniería social (Unidad 2)

<div class="nota"><span class="rot">Alcance del curso</span>
Vemos el <strong>concepto</strong>. La explotación práctica y su defensa se
trabajan en criptografía, firewall/IDS y los TP de laboratorio.</div>

---

## Contraseñas: el vector eterno

```bash
# Fuerza bruta / diccionario contra un servicio (SOLO con autorización)
hydra -l admin -P rockyou.txt ssh://192.168.1.10

# Crackeo offline de hashes capturados
john --wordlist=rockyou.txt hashes.txt
hashcat -m 0 -a 0 hashes.txt rockyou.txt
```

<div class="nota control"><span class="rot">Defensa</span>
Contraseñas largas y únicas, <strong>MFA</strong> (Unidad 7), bloqueo por
intentos, y nunca dejar credenciales por defecto. Un buen firewall (Unidad 5)
corta la fuerza bruta antes de que empiece.</div>

---

## Frameworks de explotación

**Metasploit** es el más conocido: base de exploits + payloads + post-explotación.

```bash
msfconsole
> search type:exploit apache 2.4
> use exploit/...
> set RHOSTS 192.168.1.10
> set LHOST 192.168.1.5
> exploit
```

<div class="nota legal"><span class="rot">Insistimos</span>
Estas herramientas son legales de <strong>estudiar</strong> y de usar en
<strong>tu laboratorio</strong>. Usarlas contra terceros sin permiso es delito
federal.</div>

---

## Laboratorio seguro para practicar

**Nunca** practiques sobre sistemas reales ajenos. Armá un entorno propio:

<div class="cols">
<div>

### Blancos vulnerables (legales)
- **Metasploitable 2/3**
- **DVWA** (web)
- **VulnHub** (VMs)
- **HackTheBox**, **TryHackMe**

</div>
<div>

### Plataforma
- **Kali Linux** o **Parrot OS**
- Red **solo host** / NAT aislada
- Snapshots para revertir

</div>
</div>

<div class="nota control"><span class="rot">Regla del laboratorio</span>
Aislado de Internet y de la red de la facultad. Lo que pasa en el lab, queda en
el lab.</div>


<!--
Nota del docente:
Cerrar lo práctico: TODO lo ofensivo va en laboratorio propio y aislado (Metasploitable, DVWA,
host-only, snapshots). Conecta con el TP3. 'Lo que pasa en el lab, queda en el lab.' 3 min.
-->

---

## El otro lado: fases 4 y 5

Un atacante real no se va después de entrar:

- **Fase 4 — Mantener acceso**: backdoors, cuentas ocultas, persistencia.
- **Fase 5 — Borrar huellas**: limpieza de logs, timestamps, anti-forense.

<div class="nota red"><span class="rot">Por eso importa la Unidad 8</span>
El <strong>monitoreo</strong> (SNMP, Syslog, SIEM) existe para que borrar huellas
sea difícil. Un log centralizado y protegido es la pesadilla del atacante.</div>

---

## El entregable de un pentest: el informe

El hacking ético **no termina en el acceso**. Termina en un **informe** que le
sirva a la organización para mejorar.

- **Resumen ejecutivo** — para la dirección, sin jerga
- **Hallazgos** — cada uno con riesgo, evidencia y reproducción
- **Clasificación** — CVSS / criticidad
- **Recomendaciones** — cómo remediar, priorizado
- **Alcance y limitaciones** — qué se probó y qué no

<div class="nota"><span class="rot">La verdad</span>
El valor de un pentester no está en <em>entrar</em>. Está en
<strong>explicar cómo cerrar la puerta</strong>.</div>


<!--
Nota del docente:
Mensaje para llevarse: el valor del profesional NO está en entrar, está en EXPLICAR CÓMO
CERRAR LA PUERTA. Un buen informe vale más que un buen exploit. 3 min.
-->

---

## Cerrando la unidad

1. **La ley va primero**: sin autorización escrita, es delito (Ley 26.388)
2. Formamos **white hats**: lo ofensivo al servicio de la defensa
3. **Metodología**, no improvisación: PTES, OSSTMM, NIST
4. **Recon** pasivo antes que activo; OSINT rinde más de lo que parece
5. **Escaneo**: hosts → puertos → servicios → versión (la llave)
6. El **informe** es el producto, no el acceso

<div class="nota red"><span class="rot">Próximas unidades</span>
La Unidad 4 (Sniffing) profundiza el análisis de tráfico; la 5 (Firewall/IDS)
es la defensa contra todo esto; la 6 (Criptografía) protege lo que igual se
capture.</div>


<!--
Nota del docente:
Recap y enganche con lo que viene. Preguntar qué fase les pareció más peligrosa y por qué.
Recordar el TP3 y su encuadre ético. 3 min.
-->

---

<!-- _class: portada -->
<!-- _paginate: false -->
<!-- _footer: '' -->

# ¿Preguntas?

<div class="meta">Material: github.com/bzappellini/ARyS · Campus virtual UNPSJB</div>
