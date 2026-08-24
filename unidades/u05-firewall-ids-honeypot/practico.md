# Trabajo Práctico 5 — Firewall, IDS y Honeypot

> ARyS · IF046 · UNPSJB Trelew. Modalidad: laboratorio guiado + informe.
> Duración estimada: una clase práctica (3 h) + entrega.

## Objetivos

1. Construir un **firewall stateful** con **nftables** aplicando *default deny*.
2. Publicar un servicio con **DNAT** y entender el riesgo que introduce.
3. **Detectar** un ataque con un **IDS** (Suricata) reusando el escaneo de la U3.
4. Desplegar un **honeypot** (Cowrie) y leer la inteligencia que produce.

> ## Encuadre
> Todo se hace en **laboratorio propio y aislado** (VMs en red host-only). El
> escaneo de la Parte C se ejecuta **solo** contra tus propias VMs, como en la
> Unidad 3.

---

## Parte A — Firewall con nftables

En una VM Linux (la que oficia de "servidor"):

```bash
# Ver el estado actual
sudo nft list ruleset

# Tabla y cadena de entrada con política DENY por defecto
sudo nft add table inet filtro
sudo nft add chain inet filtro entrada '{ type filter hook input priority 0; policy drop; }'

# Permitir tráfico de conexiones ya establecidas (inspección de estado)
sudo nft add rule inet filtro entrada ct state established,related accept
# Permitir loopback y SSH
sudo nft add rule inet filtro entrada iif lo accept
sudo nft add rule inet filtro entrada tcp dport 22 accept

sudo nft list ruleset
```

**Consignas A:**
1. Con la política en `drop`, ¿qué pasa si intentás conectarte a un puerto **no**
   habilitado (por ejemplo, 8080) desde la otra VM? Probalo y explicá **por qué**.
2. ¿Qué hace exactamente la regla `ct state established,related accept` y por qué es
   lo que convierte a este firewall en **stateful**? Relacionalo con la diapositiva
   de tipos de firewall.
3. Explicá cómo esta configuración aplica el principio de **default deny / menor
   privilegio**.

---

## Parte B — Publicar un servicio con DNAT

Levantá un servicio web simple en el "servidor" y publicalo:

```bash
python3 -m http.server 8000 &     # servicio interno en el puerto 8000

# DNAT: redirigir el puerto público 80 al servicio interno 8000
sudo nft add chain inet filtro prerouting '{ type nat hook prerouting priority -100; }'
sudo nft add rule inet filtro prerouting tcp dport 80 dnat ip to :8000
```

**Consignas B:**
1. Verificá desde la otra VM que accedés al servicio por el puerto 80.
2. **Análisis de riesgo**: cada regla DNAT "abre una puerta" desde afuera. ¿Por qué
   conviene que el destino de un DNAT esté en una **DMZ** y no en la LAN? (Usá el
   diagrama de DMZ de las filminas).

---

## Parte C — Detección con un IDS (Suricata)

En la VM "servidor", instalá y ejecutá **Suricata** en modo IDS sobre la interfaz de
laboratorio:

```bash
sudo apt install suricata
sudo suricata -i eth1 &        # análisis en vivo

# Desde la VM "atacante", repetí un escaneo de la Unidad 3
sudo nmap -sS -sV 10.0.0.10

# Ver las alertas que generó Suricata
sudo tail -f /var/log/suricata/fast.log
```

**Consignas C:**
1. Mostrá las alertas que **Suricata** generó ante el escaneo. ¿Detectó el `nmap`?
2. Diferencia **IDS vs IPS**: lo que hiciste, ¿frenó el escaneo o solo lo **alertó**?
   ¿Qué habría cambiado con Suricata en modo **IPS (inline)**?
3. ¿La detección fue por **firmas** o por **anomalías**? Justificá.

---

## Parte D — Honeypot (Cowrie)

Desplegá **Cowrie** (honeypot SSH) en una VM señuelo y atacalo desde la VM
"atacante":

```bash
# (según la doc oficial de Cowrie: https://docs.cowrie.org/)
# Con Cowrie escuchando, intentá un login SSH contra el honeypot
ssh root@10.0.0.20        # probá varias contraseñas

# En la VM del honeypot, revisá el registro de la sesión
tail -f var/log/cowrie/cowrie.log
```

**Consignas D:**
1. Mostrá qué **registró** Cowrie de tu intento: IP, usuario, contraseñas probadas,
   comandos.
2. ¿Por qué se dice que un honeypot tiene **casi cero falsos positivos**? ¿Quién,
   legítimamente, debería estar conectándose a esa máquina?
3. Proponé un **honeytoken** que podrías sembrar en tu red y qué alerta dispararía.

---

## Entrega y evaluación

- **Formato:** un único PDF con las partes A–D. Nombre: `TP5_ApellidoNombre.pdf`.
- **Vía:** campus virtual UNPSJB.
- **Criterios de corrección:**
  - Firewall nftables correcto y comprendido (30 %).
  - DNAT funcionando + análisis de riesgo de la exposición (15 %).
  - IDS detectando el ataque e interpretación IDS/IPS y firmas/anomalías (30 %).
  - Honeypot desplegado y lectura de su inteligencia (15 %).
  - Claridad y prolijidad del informe (10 %).

## Para investigar (opcional, suma)

- Migrar una regla de **iptables** a **nftables**: ¿qué cambia en la sintaxis?
- Qué agrega un **NGFW** sobre un firewall stateful, y por qué **no** tiene una
  definición normativa (NIST/RFC).
- Cómo cambia el diseño de red bajo **Zero Trust (NIST SP 800-207)**: ¿qué reemplaza
  al "adentro confiable"? Investigá **microsegmentación**.
