# Trabajo Práctico 3 — Reconocimiento y Escaneo

> ARyS · IF046 · UNPSJB Trelew. Modalidad: laboratorio guiado + informe.
> Duración estimada: una clase práctica (3 h) + entrega.

## Objetivos

1. Aplicar reconocimiento pasivo (OSINT/footprinting) sobre un blanco autorizado.
2. Ejecutar un escaneo metódico con Nmap: hosts, puertos, servicios y versiones.
3. Correlacionar versiones con vulnerabilidades públicas y redactar hallazgos.

> **Encuadre ético y legal — LEER ANTES DE EMPEZAR.**
> Bajo la **Ley 26.388**, escanear un sistema ajeno sin autorización es delito
> (Art. 153 bis), aunque no se cause daño. Este práctico se realiza **únicamente**
> contra:
> - el **laboratorio propio** que se arma en la Parte A (Metasploitable/DVWA en
>   una VM aislada), **o**
> - blancos **explícitamente autorizados para práctica** por sus dueños
>   (`scanme.nmap.org` para Nmap; plataformas tipo TryHackMe/HackTheBox dentro de
>   su propio entorno).
>
> No se escanea la red de la facultad, ni redes domésticas de terceros, ni
> ningún sistema fuera de esa lista. Ante la duda: no se hace.

---

## Parte A — Armado del laboratorio (obligatoria)

1. Instalá **VirtualBox** o **VMware**.
2. Descargá **Kali Linux** (atacante) y **Metasploitable 2** (blanco).
3. Configurá ambas VMs en una red **host-only** o **NAT interna** aislada de
   Internet y de la red física.
4. Verificá conectividad entre ambas y tomá un **snapshot** limpio del blanco.

**Entregable A:** captura del `ip a` de ambas máquinas y del `ping` exitoso
entre ellas, mostrando que están en la misma red aislada.

---

## Parte B — Reconocimiento pasivo (OSINT)

Blanco autorizado: el dominio público de la universidad (`unp.edu.ar`) **solo
para consultas pasivas de información pública**, sin escaneo.

```bash
# Datos del dominio
whois unp.edu.ar

# Registros DNS
dig unp.edu.ar ANY +noall +answer
dig MX unp.edu.ar +short
dig NS unp.edu.ar +short

# Subdominios por certificados públicos (crt.sh)
curl -s "https://crt.sh/?q=%25.unp.edu.ar&output=json" | jq -r '.[].name_value' | sort -u | head -40
```

**Consignas B:**

1. ¿Quién administra el dominio y qué servidores de correo y de nombres usa?
2. Listá cinco subdominios encontrados por crt.sh. ¿Alguno sugiere un servicio
   interesante (correo, campus, VPN, admin)?
3. Explicá la diferencia entre lo que hiciste acá (pasivo) y un escaneo (activo),
   y por qué solo uno de los dos necesita autorización.

---

## Parte C — Escaneo del laboratorio (contra Metasploitable)

Todo lo siguiente se ejecuta **contra la VM Metasploitable**, nunca contra
`unp.edu.ar`.

```bash
# 1. ¿Está vivo el host?
nmap -sn 192.168.56.0/24

# 2. Puertos abiertos (SYN scan)
sudo nmap -sS 192.168.56.101

# 3. Todos los puertos + servicios + versiones
sudo nmap -sS -sV -p- 192.168.56.101 -oN escaneo_completo.txt

# 4. Sistema operativo
sudo nmap -O 192.168.56.101

# 5. Scripts seguros de descubrimiento
nmap -sC 192.168.56.101
```

**Consignas C:**

1. Completá una tabla con **puerto / estado / servicio / versión** de al menos
   ocho servicios abiertos.
2. Elegí **tres** servicios y buscá en **Exploit-DB o NVD** si su versión tiene
   una vulnerabilidad conocida (CVE). Anotá el identificador y una línea de
   descripción.
3. ¿Qué diferencia observaste entre el escaneo `-sS` solo y el `-sV`? ¿Por qué la
   versión es tan importante para un atacante?
4. Interpretá un puerto **filtered** si aparece: ¿qué lo produce?

---

## Parte D — Análisis y defensa (individual)

Para **cada** uno de los tres servicios vulnerables de la Parte C:

| Servicio / versión | CVE | Riesgo (CVSS aprox.) | Cómo lo detectaría un defensor | Contramedida |
|---|---|---|---|---|

- La contramedida debe ser concreta (parche, cierre de puerto, segmentación,
  firewall, deshabilitar servicio) y, cuando aplique, referenciar la unidad
  correspondiente (Firewall/IDS → Unidad 5; Monitoreo → Unidad 8).

**Entregable D:** tabla completa + un párrafo respondiendo: si fueras el
administrador de ese servidor, ¿cuáles serían tus **tres primeras** acciones,
en orden, y por qué?

---

## Entrega y evaluación

- **Formato:** un único PDF con las partes A–D. Nombre: `TP3_ApellidoNombre.pdf`.
- **Vía:** campus virtual UNPSJB.
- **Criterios de corrección:**
  - Laboratorio correctamente aislado y documentado (15 %).
  - Reconocimiento pasivo e interpretación de resultados (25 %).
  - Escaneo metódico y lectura correcta de la salida de Nmap (35 %).
  - Correlación con CVE y calidad de las contramedidas (25 %).

> **Recordatorio final.** La entrega debe evidenciar que **todo el escaneo** se
> hizo contra el laboratorio propio o blancos autorizados. Cualquier evidencia
> de escaneo no autorizado invalida el trabajo.

## Para investigar (opcional, suma)

- Diferencia entre `-sS` (SYN), `-sT` (connect) y `-sU` (UDP). ¿Cuándo conviene
  cada uno?
- Qué es el **banner grabbing** y cómo se relaciona con `-sV`.
- Cómo un **IDS** (Unidad 5) detecta un escaneo de Nmap y qué técnicas de evasión
  existen (`-T0`, fragmentación, señuelos `-D`).
