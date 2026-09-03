# U3 · Guía de demos en vivo (docente)

> Material de apoyo para el profesor. Demostraciones para hacer **en clase** y
> afianzar los conceptos de la Unidad 3. ARyS · IF046 · UNPSJB Trelew.
>
> **Encuadre para el aula (repetir antes de cada demo activa):** el reconocimiento
> **pasivo** (leer fuentes públicas) es legal; el reconocimiento **activo** y el
> escaneo solo se hacen contra **blancos autorizados** (`scanme.nmap.org`, nuestras
> VMs) o sobre **información pública** que ya está expuesta. Interactuar con sistemas
> ajenos sin permiso es delito (Ley 26.388), aunque no se rompa nada.

Blancos seguros para las demos:
- **OSINT pasivo**: cualquier dominio público (ej. `unp.edu.ar`) — solo leemos datos públicos.
- **Escaneo activo**: `scanme.nmap.org` (Nmap lo autoriza expresamente) o VMs propias.

---

## DEMO 1 — Reconocimiento pasivo: whois + DNS  *(≈4 min)*

**Objetivo:** mostrar cuánta información se obtiene sin tocar el objetivo.

```bash
whois unp.edu.ar
dig unp.edu.ar ANY +noall +answer
```

**Qué señalar:** titular del dominio, fechas, y en el DNS los registros. Preguntar al
aula: *"¿esto es pasivo o activo?"* → pasivo, consultamos registros públicos.

---

## DEMO 2 — Footprinting: correo, nombres y transferencia de zona  *(≈5 min)*

```bash
dig MX unp.edu.ar +short      # servidores de correo → revela el proveedor
dig NS unp.edu.ar +short      # servidores de nombres
# Transferencia de zona (casi siempre bloqueada; si respondiera, es un GRAN hallazgo)
dig AXFR unp.edu.ar @ns1.ejemplo.com
```

**Qué señalar:** el MX suele delatar si usan Google/Microsoft/propio. Explicar que una
**transferencia de zona (AXFR)** abierta entregaría *todos* los registros DNS de una
vez — el "regalo" clásico de una mala configuración. Normalmente responde `Transfer
failed`: ese es el comportamiento correcto.

---

## DEMO 3 — Subdominios por certificados: crt.sh  *(≈4 min)*

**En el navegador**, abrir: `https://crt.sh/?q=%25.unp.edu.ar`

O por terminal:

```bash
curl -s "https://crt.sh/?q=%25.unp.edu.ar&output=json" | jq -r '.[].name_value' | sort -u | head -40
```

**Qué señalar:** aparece una lista enorme de subdominios extraídos de los
**certificados TLS públicos**. Preguntar: *"¿pasivo o activo?"* → pasivo, leemos un
registro público (Certificate Transparency, que vimos en la U6). Suele impactar mucho
ver cuántos subdominios expone una organización sin saberlo.

---

## DEMO 4 — Google Dorking  *(≈4 min)*

**En el navegador**, probar estos "dorks":

```
site:unp.edu.ar filetype:pdf
site:unp.edu.ar intitle:"index of"
site:unp.edu.ar inurl:login
```

Mostrar la **Google Hacking Database**: `https://www.exploit-db.com/google-hacking-database`

**Advertencia para el aula (importante):** *mirar* resultados públicos e indexados es
legal; **acceder** a algo que claramente no debería estar expuesto (un panel, un
backup) ya cruza la línea. El dorking muestra la puerta; abrirla sin permiso es otra
cosa.

---

## DEMO 5 — Shodan: el buscador de dispositivos  ⭐ *(≈8 min — la que más engancha)*

**Idea a transmitir:** Google indexa *páginas*; **Shodan indexa *dispositivos*
conectados** (cámaras, bases de datos, routers, sistemas industriales). Shodan **solo
lista** lo que ya está expuesto: no ataca nada. Conectarse a esos equipos sin permiso,
sí es delito.

### 5.1 Búsquedas para mostrar en vivo (funcionan con cuenta gratis)

En `https://www.shodan.io` (con la cuenta gratis logueada):

```
product:MongoDB              # bases de datos MongoDB expuestas a Internet
port:3389 country:AR         # escritorio remoto (RDP) en Argentina
"default password"           # dispositivos que anuncian credenciales por defecto
apache country:AR city:"Trelew"
```

Mostrar cómo cada resultado trae **IP, puerto, banner del servicio, ubicación,
organización** — todo lo que un atacante querría saber, ya recolectado.

### 5.2 Cuenta GRATIS vs. PAGA — el ejemplo pedido

Este es el punto didáctico: **por qué a veces alcanza con la gratis y cuándo se
necesita la paga.**

| Función | Cuenta **gratis** (registro) | Cuenta **paga** (membership) |
|---|---|---|
| Búsqueda web básica | ✅ | ✅ |
| Filtros básicos (`port:`, `country:`, `org:`) | ✅ | ✅ |
| Cantidad de resultados por búsqueda | ⚠️ **limitada** (primeras páginas) | ✅ **completa** |
| Filtro por vulnerabilidad (`vuln:` con CVE) | ❌ | ✅ |
| **Exportar** resultados (CSV/JSON) | ❌ | ✅ |
| **API** con créditos para automatizar | ⚠️ mínimos | ✅ (para scripts, integraciones) |
| **Shodan Monitor** (vigilar tus propias IPs) | ❌ | ✅ |
| Escaneo **on-demand** de una IP | ❌ | ✅ |

**Cómo contarlo en clase:**
- *Con la gratis* alcanza para **entender el concepto** y para búsquedas puntuales:
  "¿hay algo mío expuesto?", ver un par de ejemplos, mostrar un banner.
- *La paga* se necesita cuando el trabajo es **profesional y a escala**: exportar
  cientos de resultados para un informe, buscar por **CVE** (`vuln:CVE-2021-...`) todos
  los equipos vulnerables de un rango, **automatizar** con la API, o **monitorear** el
  perímetro propio de una organización de forma continua.

> **Nota:** los planes y precios de Shodan cambian; verificá el detalle vigente en
> `https://account.shodan.io/billing`. La idea a transmitir no es el precio, sino la
> lógica *free = explorar / paga = trabajo profesional a escala*.

### 5.3 Cierre ético de la demo
Recordar: Shodan es legal de usar para **buscar** y para **auditar lo propio**. Un
buen ejercicio defensivo es **buscarse a uno mismo** (la organización) en Shodan para
ver qué expone. Lo que no se hace es **conectarse** a equipos de terceros que aparezcan.

---

## DEMO 6 — Metadatos: lo que filtran los documentos  *(≈4 min)*

```bash
# Bajar un PDF público del sitio de la demo y leer sus metadatos
exiftool algun_documento_publico.pdf
# En una foto, buscar coordenadas GPS
exiftool foto.jpg | grep -i gps
```

**Qué señalar:** autor, software y versión del sistema, a veces rutas internas o
nombres de usuario; en fotos, la **ubicación GPS**. Moraleja para el aula: limpiar los
metadatos **antes** de publicar. Muchos CMS lo hacen; muchos no.

---

## DEMO 7 — Escaneo con Nmap  *(≈6 min)*

**AVISO antes de ejecutar:** de acá en adelante **ya interactuamos** con sistemas. Solo
contra `scanme.nmap.org` (autorizado por Nmap) o VMs propias. Nunca la red de la facultad.

```bash
# 1. ¿Qué hay vivo en la red del laboratorio? (sin escanear puertos)
nmap -sn 192.168.56.0/24

# 2. Escaneo SYN + versiones contra el blanco autorizado
sudo nmap -sS -sV scanme.nmap.org

# 3. Detección de SO
sudo nmap -O scanme.nmap.org
```

**Qué señalar leyendo la salida juntos:**
- El **estado** de cada puerto (open/closed/filtered) y de dónde sale.
- La **versión** del servicio → *"esta es la llave: con producto + versión buscamos en
  CVE / Exploit-DB si hay un exploit público"*.
- Recordar que `-sS` no completa la conexión (más rápido y discreto).

---

## Cierre de las demos

Volver a la slide de **fases** y ubicar cada demo:
- Demos 1–6 = **Fase 1, Reconocimiento** (casi todo pasivo).
- Demo 7 = **Fase 2, Escaneo** (ya activo, requiere autorización).
- La **Fase 3 (acceso)** no se demuestra en vivo sobre terceros: va en el **laboratorio
  aislado** del TP3.

**Mensaje final para el aula:** la diferencia entre un profesional y un delincuente no
es la herramienta —son las mismas— sino la **autorización** y la **intención**.
