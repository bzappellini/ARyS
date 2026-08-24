# Trabajo Práctico 4 — Sniffing y Análisis de tráfico

> ARyS · IF046 · UNPSJB Trelew. Modalidad: laboratorio guiado + informe.
> Duración estimada: una clase práctica (3 h) + entrega.

## Objetivos

1. Capturar y **analizar** tráfico propio con tcpdump y Wireshark.
2. Comprobar **empíricamente** qué expone y qué oculta el cifrado (HTTP vs HTTPS,
   DNS en claro vs DoH).
3. Ejecutar un **ARP spoofing / MITM controlado** en laboratorio aislado y observar
   sus efectos y sus límites frente al tráfico cifrado.
4. Proponer **defensas** de capa 2 justificadas.

> ## ⚠️ Encuadre ético y legal — LEER ANTES DE EMPEZAR
> Bajo la **Ley 26.388**, interceptar comunicaciones ajenas sin autorización es
> **delito** (Art. 153 y 153 bis), aunque no causes daño. **Todo** este práctico se
> hace **exclusivamente**:
> - sobre **tu propio tráfico**, y
> - en una **red de laboratorio aislada** (host-only) entre **VMs tuyas**.
>
> No se sniffea la red de la facultad, una red Wi-Fi pública, la de tu casa
> compartida ni la de ningún tercero. La Parte B (MITM) se ejecuta **solo** entre
> dos máquinas virtuales propias en red aislada. Ante la duda: no se hace.

---

## Parte A — Armado y captura pasiva

### A.1 Laboratorio

1. Dos VMs en una red **host-only / interna** aislada:
   - **VM-Víctima** (Linux con navegador)
   - **VM-Atacante** (Kali/Parrot, con `tcpdump`, `wireshark`, `bettercap`)
2. Verificá conectividad (`ping`) entre ambas y anotá IP y MAC de cada una
   (`ip a`, `ip neigh`).

### A.2 Anatomía de una conexión

Desde la VM-Atacante, capturá **tu propio** tráfico mientras navegás desde esa
misma máquina:

```bash
# Capturar en la interfaz de laboratorio y guardar a archivo
sudo tcpdump -i eth1 -w /tmp/captura.pcap

# En otra terminal, generar tráfico: una conexión HTTP en claro
curl http://neverssl.com
```

Abrí `/tmp/captura.pcap` en **Wireshark**.

**Consignas A.2:**
1. Localizá el **handshake TCP** (SYN, SYN/ACK, ACK) de la conexión. Pegá la captura.
2. Usá **Follow TCP Stream** sobre el tráfico HTTP: ¿se lee la petición y la
   respuesta? ¿Qué datos quedarían expuestos si esto fuera un login?

### A.3 HTTP vs HTTPS

Repetí la captura generando ahora tráfico **cifrado**:

```bash
curl https://example.com
```

**Consigna A.3.** Compará ambas capturas. En la de HTTPS, ¿qué podés ver
(direcciones, puerto, tamaños) y qué **no** podés ver (contenido)? Relacionalo con
**TLS 1.3 (RFC 8446)**.

### A.4 DNS en claro vs cifrado

```bash
# Filtro en Wireshark: dns   -> observá las consultas en texto plano
```

**Consigna A.4.** ¿Qué revela el DNS tradicional a un sniffer aunque después uses
HTTPS? Explicá cómo lo cierran **DoT (RFC 7858)** y **DoH (RFC 8484)**.

**Entregable A:** capturas y respuestas de A.2 a A.4.

---

## Parte B — ARP spoofing / MITM controlado

> Solo entre tus dos VMs, en la red aislada. Nunca fuera de ahí.

Desde la **VM-Atacante**, colocate en el medio entre la **VM-Víctima** y el gateway
de laboratorio con **bettercap**:

```bash
# Reemplazá 10.0.0.5 por la IP real de tu VM-Víctima
sudo bettercap -iface eth1 -eval "set arp.spoof.targets 10.0.0.5; arp.spoof on; net.sniff on"
```

En la **VM-Víctima**, antes y durante el ataque, mirá la tabla ARP:

```bash
ip neigh          # observá la MAC asociada al gateway antes y después
```

**Consignas B:**
1. Mostrá cómo **cambia la MAC** del gateway en la tabla ARP de la víctima cuando el
   spoofing está activo. Explicá por qué ARP lo permite (**RFC 826**, sin
   autenticación).
2. Con el MITM activo, generá tráfico **HTTP** desde la víctima: ¿lo ve el atacante?
3. Generá tráfico **HTTPS** desde la víctima: ¿qué ve el atacante ahora? ¿Por qué el
   MITM **no alcanza** para leer el contenido?
4. Detené el ataque (`arp.spoof off`) y verificá que la tabla ARP se normaliza.

**Entregable B:** capturas del cambio de tabla ARP y de lo que el atacante logra ver
(y no ver) con HTTP y con HTTPS, y las respuestas.

---

## Parte C — Defensas

**Consignas C:**
1. Para el ataque de la Parte B, indicá qué control de capa 2 lo **hubiera frenado**
   y cómo funciona: **Dynamic ARP Inspection** (apoyado en DHCP Snooping).
2. Para MAC flooding, ¿qué control aplica? (**Port Security**).
3. Explicá por qué, aun con todas las defensas de capa 2, la protección **definitiva**
   contra el sniffing es el **cifrado extremo a extremo** (enlazá con lo observado en
   A.3 y B.3).

**Entregable C:** tabla ataque → control → cómo funciona, y el párrafo de cierre.

---

## Entrega y evaluación

- **Formato:** un único PDF con las partes A, B y C. Nombre: `TP4_ApellidoNombre.pdf`.
- **Vía:** campus virtual UNPSJB.
- **Criterios de corrección:**
  - Laboratorio correctamente aislado y documentado (10 %).
  - Captura y lectura correcta del tráfico en Wireshark (30 %).
  - MITM ejecutado y **correctamente interpretado**, sobre todo el límite frente a
    HTTPS (30 %).
  - Defensas justificadas y trazadas a los conceptos (20 %).
  - Claridad, prolijidad y respeto del encuadre ético (10 %).

> La entrega debe evidenciar que **todo** se hizo en laboratorio propio y aislado.
> Cualquier evidencia de captura sobre redes de terceros invalida el trabajo.

## Para investigar (opcional, suma)

- Qué es el **SNI** y cómo lo cifra **ECH (RFC 9849)**: ¿qué metadato deja de ver el
  sniffer?
- **JA3 / JA4**: cómo se identifica un cliente o malware **sin descifrar** el tráfico.
- **Monitor mode** en Wi-Fi: por qué **WPA3 (SAE)** dificulta el ataque offline al
  handshake que sí funcionaba contra WPA2, y qué mostró **Dragonblood**.
