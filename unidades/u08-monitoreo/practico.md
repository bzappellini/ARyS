# Trabajo Práctico 8 — Monitoreo

> ARyS · IF046 · UNPSJB Trelew. Modalidad: laboratorio guiado + informe.
> Es el último práctico del curso. Duración estimada: una clase práctica (3 h) + entrega.

## Objetivos

1. Consultar un agente **SNMP** y recorrer su **MIB**.
2. **Demostrar** por qué SNMP v2c es inseguro capturando la community con Wireshark
   (integrando la Unidad 4).
3. Centralizar **logs** con Syslog y leer sus severidades.
4. Levantar una pila de **observabilidad** (Prometheus + Grafana) y ver una métrica.

> Todo en **laboratorio propio y aislado**. La captura de la Parte A.2 se hace sobre
> **tu propio** tráfico SNMP entre tus VMs.

---

## Parte A — SNMP

### A.1 Consultar un agente

En una VM, instalá el agente y las herramientas:

```bash
sudo apt install snmpd snmp
# Agente con community v2c "catedra" de solo lectura (solo para el lab)
echo 'rocommunity catedra' | sudo tee -a /etc/snmp/snmpd.conf
sudo systemctl restart snmpd

# Desde la misma u otra VM: recorrer la MIB y consultar un OID puntual
snmpwalk  -v2c -c catedra localhost | head -20
snmpget   -v2c -c catedra localhost sysDescr.0
snmpget   -v2c -c catedra localhost sysUpTime.0
```

**Consignas A.1:**
1. ¿Qué información expone `snmpwalk`? Mostrá 5 OIDs y qué representan.
2. Identificá el **manager**, el **agente** y la **MIB** en lo que hiciste.

### A.2 Por qué v2c es inseguro (integra Unidad 4)

```bash
# Capturá el tráfico SNMP mientras hacés una consulta v2c
sudo tcpdump -i lo -w snmp.pcap udp port 161 &
snmpget -v2c -c catedra localhost sysDescr.0
# Abrí snmp.pcap en Wireshark y buscá la community string
```

**Consignas A.2:**
1. ¿Pudiste **ver la community string "catedra"** en texto plano en la captura?
   Mostralo.
2. Explicá por qué esto es un problema grave y cómo lo resuelve **SNMP v3** (USM:
   autenticación + cifrado).

---

## Parte B — Syslog

```bash
# Generar mensajes de log con distintas severidades
logger -p user.info  "Prueba INFO desde el TP8"
logger -p user.err   "Prueba ERROR desde el TP8"

# Verlos
sudo tail -n 20 /var/log/syslog
```

**Consignas B:**
1. Ubicá tus dos mensajes y su **severidad**. Enumerá la escala 0–7.
2. Un log solo vive en el equipo. Explicá por qué **centralizarlo** (y protegerlo con
   TLS/6514) es clave contra el **borrado de huellas** (Unidad 3).

---

## Parte C — Observabilidad (Prometheus + Grafana)

Con Docker (Unidad de infraestructura del repo):

```bash
# Prometheus scrapeando su propia métrica
docker run -d --name prometheus -p 9090:9090 prom/prometheus
# Grafana para visualizar
docker run -d --name grafana -p 3000:3000 grafana/grafana
```

- Prometheus: http://localhost:9090 → consultá la métrica `up`.
- Grafana: http://localhost:3000 (admin/admin) → agregá Prometheus como *data source*
  y graficá una métrica.

**Consignas C:**
1. Mostrá la métrica `up` en Prometheus. ¿Qué representa?
2. Relacioná este stack con SNMP: ¿qué rol cumple Prometheus (recolección) y cuál
   Grafana (visualización)?
3. Nombrá los **tres pilares** de la observabilidad y qué herramienta viste de cada uno.

---

## Parte D — Cierre: del dato a la defensa

**Consignas D:**
1. De todo lo que monitoreaste (SNMP, logs, métricas), ¿qué alimentarías a un
   **SIEM** y para qué? Relacionalo con el **IDS** de la Unidad 5.
2. Explicá con tus palabras cómo el monitoreo cierra el ciclo **detectar → responder
   → mejorar** (seguridad como proceso, Unidad 1).

---

## Entrega y evaluación

- **Formato:** un único PDF con las partes A–D. Nombre: `TP8_ApellidoNombre.pdf`.
- **Vía:** campus virtual UNPSJB.
- **Criterios de corrección:**
  - SNMP: consulta, MIB/OID y demostración de la fuga de v2c (35 %).
  - Syslog: severidades y valor de la centralización (20 %).
  - Observabilidad: Prometheus/Grafana y los tres pilares (30 %).
  - Cierre: integración con SIEM y el ciclo de seguridad (10 %).
  - Claridad y prolijidad del informe (5 %).

## Para investigar (opcional, suma)

- Configurar **SNMP v3** con autenticación y cifrado: ¿qué cambia respecto de v2c?
- **NetFlow / IPFIX**: cómo se ve un flujo y para qué sirve en detección de anomalías.
- **Wazuh**: qué es un SIEM open source y cómo correlaciona eventos de varias fuentes.

---

> **Cierre del curso.** Con esta unidad completaste el recorrido de ARyS: de los
> conceptos y el perímetro físico, pasando por el ataque ético, las defensas, la
> criptografía y la autenticación, hasta el monitoreo que sostiene todo el ciclo.
> La seguridad es un proceso: seguí aprendiendo.
