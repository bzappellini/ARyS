# Unidad 3 — Hacking Ético

> Material teórico de acompañamiento. Complementa las filminas y la clase.
> ARyS · IF046 · UNPSJB Trelew.

## 1. Encuadre: del perímetro físico al lógico

La Unidad 2 trató al atacante que ingresa físicamente. Esta unidad estudia al
atacante que ingresa **por la red**, con el mismo esquema mental: estudiar el
blanco, mapear sus accesos y entrar. La diferencia decisiva no es técnica sino
**ética y legal**: el hacking ético se realiza con **autorización escrita, previa
y de alcance definido**, y su objetivo final es **mejorar la defensa**.

## 2. Marco legal (Argentina)

> Sin autorización, las técnicas de esta unidad constituyen delito, aun cuando
> no se produzca daño.

La **Ley 26.388 de Delitos Informáticos** (2008) incorporó al Código Penal
argentino figuras relevantes:

- **Art. 153 bis** — acceso ilegítimo a un sistema o dato informático de acceso
  restringido. Escanear o ingresar sin permiso ya encuadra aquí.
- **Art. 155** — publicación indebida de comunicaciones electrónicas.
- **Art. 157 bis** — acceso ilegítimo a bancos de datos personales.
- **Arts. 183 y 184** — daño informático: alteración, destrucción o
  inutilización de datos o sistemas (incluye sabotaje y ransomware).

La consecuencia práctica: **el reconocimiento activo y el escaneo requieren
autorización**. La regla de oro del curso es que un profesional nunca prueba
sobre sistemas que no le pertenecen o para los que no tiene permiso documentado.

## 3. Hacker, ética y roles

El término **hacker** designa a quien comprende un sistema en profundidad y lo
lleva más allá de su uso previsto; no implica ilegalidad. La ética se expresa
con "sombreros":

- **White hat** — actúa con autorización, reporta y ayuda a remediar.
- **Black hat** — actúa sin permiso, con fin ilícito o dañino.
- **Grey hat** — sin permiso pero sin intención dañina; sigue siendo ilegal.

La materia forma **white hats**: el conocimiento ofensivo se estudia para poder
**defender**.

## 4. Reglas de compromiso y tipos de evaluación

Un test de intrusión (*pentest*) profesional se define antes de ejecutar:

- **Alcance (scope)** — sistemas incluidos y excluidos.
- **Ventana temporal** — cuándo se puede probar.
- **Autorización firmada** — respaldo legal del trabajo.
- **Contacto de emergencia** y **reglas de exclusión** (por ejemplo, sin DoS).
- **Manejo de datos** hallados durante la prueba.

Según el conocimiento previo entregado al evaluador:

- **Black box** — sin información; simula un atacante externo.
- **White box** — acceso completo (código, credenciales, arquitectura).
- **Grey box** — conocimiento parcial; simula un insider.

Metodologías reconocidas que estructuran el trabajo y lo hacen repetible y
auditable: **PTES**, **OSSTMM**, **NIST SP 800‑115**, **OWASP WSTG** (web) y
modelos de adversario como **Cyber Kill Chain** (Lockheed Martin) y **MITRE
ATT&CK**.

## 5. Las fases del hacking ético

El modelo clásico define cinco fases:

1. **Reconocimiento** — recolección de información sobre el blanco.
2. **Escaneo** — identificación de hosts, puertos y servicios vivos.
3. **Obtener acceso** — explotación de una debilidad.
4. **Mantener acceso** — persistencia (backdoors, cuentas).
5. **Borrar huellas** — eliminación de rastros.

El **programa de la materia** se concentra en las tres primeras. Las fases 4 y 5
se ven como contexto y motivan la Unidad 8 (Monitoreo): el registro centralizado
y protegido dificulta la persistencia y el borrado de huellas.

## 6. Fase 1 — Reconocimiento

### 6.1 Pasivo vs. activo

- **Pasivo** — se obtiene información **sin interactuar** con el objetivo,
  usando fuentes públicas. Es indetectable por el blanco.
- **Activo** — se **interactúa** con el objetivo (ping, consultas DNS a sus
  servidores, banner grabbing). Deja rastro y, sin autorización, ya puede
  constituir delito.

### 6.2 OSINT

La *Open Source Intelligence* recolecta información pública que la organización
expone sin advertirlo: personas (LinkedIn, organigramas), tecnología (avisos de
empleo que revelan el stack), infraestructura (DNS, rangos IP, subdominios),
metadatos de documentos, credenciales filtradas en brechas previas (Have I Been
Pwned) y secretos en repositorios públicos.

### 6.3 Footprinting

Consiste en construir el mapa externo del blanco:

- **Whois** — titular, contactos y fechas de un dominio.
- **DNS** — registros A, MX, NS, TXT; una **transferencia de zona (AXFR)** mal
  configurada entrega todos los registros de una vez.
- **Enumeración de subdominios** — pasiva por certificados TLS (crt.sh) o por
  fuerza bruta con diccionario (dnsrecon).
- **Google Dorking** — operadores de búsqueda (`site:`, `filetype:`, `inurl:`,
  `intitle:"index of"`) que exponen documentos, paneles y backups indexados; la
  **Google Hacking Database** (GHDB) los cataloga.
- **Shodan / Censys** — buscadores de **dispositivos** conectados (cámaras,
  bases de datos, sistemas industriales), muchos sin autenticación.
- **Metadatos** — `exiftool` extrae autor, software, rutas internas, versiones y
  hasta GPS de documentos y fotos publicados.

## 7. Fase 2 — Escaneo

El reconocimiento produce un mapa; el escaneo confirma qué está **vivo y
escuchando**, respondiendo tres preguntas en orden:

1. **Host discovery** — qué equipos están activos.
2. **Port scanning** — qué puertos están abiertos.
3. **Service & OS fingerprinting** — qué servicio y versión hay detrás, y qué
   sistema operativo.

Un **puerto** (0–65535, sobre TCP o UDP) identifica un servicio; correlativa con
IF019 (Redes). Un escáner reporta cada puerto como **open**, **closed** o
**filtered** (descartado por un firewall).

### 7.1 Nmap

Herramienta estándar del escaneo:

- `nmap -sn RED/24` — descubrimiento de hosts sin escanear puertos.
- `nmap -sS host` — escaneo **TCP SYN**: no completa la conexión (no envía el ACK
  final), por lo que es más rápido y discreto que un connect completo.
- `nmap -sV host` — detección de producto y versión del servicio.
- `nmap -O host` — inferencia del sistema operativo por diferencias en la pila
  TCP/IP (TTL, tamaño de ventana). Es probabilístico.
- `nmap -A host` — modo agresivo: versión, SO, scripts y traceroute.

El **estado del puerto** se deduce de la respuesta: SYN/ACK → abierto; RST →
cerrado; sin respuesta → filtrado.

### 7.2 Por qué importa la versión

Producto + versión permiten buscar en **CVE / NVD / Exploit-DB** si existe un
exploit público. La versión es, con frecuencia, la llave del acceso.

### 7.3 NSE y escáneres de vulnerabilidades

El **Nmap Scripting Engine** (NSE) automatiza tareas con scripts por categorías
(`safe`, `discovery`, `vuln`, `intrusive`, `exploit`). Las categorías intrusivas
ya no son reconocimiento: atacan, y requieren autorización explícita.

Los **escáneres de vulnerabilidades** dedicados (OpenVAS/Greenbone, Nessus,
Nuclei) comparan servicios y versiones contra una base de vulnerabilidades
conocidas. Producen **falsos positivos**: el profesional los verifica antes de
reportarlos.

## 8. Fase 3 — Obtener acceso (concepto)

La explotación convierte un hallazgo (servicio + versión + vulnerabilidad) en
acceso real. Vectores frecuentes:

- **Vulnerabilidad de software** — exploit contra un servicio sin parchear.
- **Credenciales débiles o por defecto** — probadas por fuerza bruta/diccionario
  (Hydra en línea; John the Ripper y Hashcat fuera de línea).
- **Errores de configuración** — permisos o exposición excesiva.
- **Factor humano** — phishing e ingeniería social (Unidad 2).

**Metasploit** es el framework de explotación de referencia (exploits, payloads,
post-explotación). Su estudio y uso son legales en laboratorio propio; su uso
contra terceros sin permiso es delito.

### 8.1 Laboratorio seguro

La práctica se realiza siempre en un entorno propio y aislado: blancos
deliberadamente vulnerables y legales (Metasploitable, DVWA, VulnHub, HackTheBox,
TryHackMe) sobre una plataforma ofensiva (Kali, Parrot) en red host-only o NAT
aislada, con snapshots para revertir. Nunca contra la red de la facultad ni
contra Internet.

## 9. El informe: el verdadero producto

El hacking ético no termina en el acceso, sino en un **informe** útil para la
organización: resumen ejecutivo (sin jerga), hallazgos con riesgo, evidencia y
pasos de reproducción, clasificación por criticidad (CVSS), recomendaciones
priorizadas y descripción del alcance y las limitaciones. El valor del
profesional está en **explicar cómo cerrar la puerta**, no en abrirla.

## 10. Ideas para llevarse

1. La ley va primero: sin autorización escrita, es delito (Ley 26.388).
2. Formamos white hats; lo ofensivo está al servicio de la defensa.
3. Metodología, no improvisación.
4. Reconocimiento pasivo antes que activo; OSINT rinde mucho.
5. Escaneo: hosts → puertos → servicios → versión.
6. El informe es el producto, no el acceso.

## 11. Referencias

- Ley 26.388 (Argentina) — Delitos Informáticos.
- NIST SP 800‑115 — *Technical Guide to Information Security Testing*.
- PTES — *Penetration Testing Execution Standard*.
- MITRE ATT&CK — matriz de tácticas y técnicas del adversario.
- Documentación oficial de Nmap (nmap.org/book).
- W. Stallings — *Fundamentos de Seguridad en Redes* (bibliografía de cátedra).
