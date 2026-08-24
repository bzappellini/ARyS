# Unidad 8 — Herramientas de Monitoreo

> Material teórico de acompañamiento. Complementa las filminas y la clase.
> Es la última unidad y cierra el curso. ARyS · IF046 · UNPSJB Trelew.

## 1. Encuadre: ver para poder defender

La Unidad 7 resolvió **quién entra**. Pero una red no se administra a ciegas: hay
que **verla** para saber si está sana, si rinde y si la están atacando. La premisa
es simple: **sin visibilidad no hay defensa**; no se puede proteger lo que no se ve.

Esta unidad cierra el ciclo planteado en la Unidad 1: la seguridad es un **proceso**,
y el monitoreo es la fase que permite **detectar, responder y mejorar**.

## 2. Gestión de red: FCAPS y NMS

El marco clásico de gestión de red, de ISO/ITU-T, organiza la disciplina en cinco
áreas funcionales, conocidas por el acrónimo **FCAPS**:

- **Fault** — gestión de fallas (detectar y resolver caídas).
- **Configuration** — configuración de los equipos.
- **Accounting** — contabilidad y uso de recursos.
- **Performance** — rendimiento (latencia, tráfico, capacidad).
- **Security** — seguridad de la propia gestión.

El acrónimo proviene del modelo de gestión OSI (**ITU-T X.700 / ISO 7498-4**),
mientras que **ITU-T M.3400** enumera las funciones de gestión TMN dentro de esas
categorías. Un **NMS (Network Management System)** es la plataforma que descubre,
monitorea y controla los elementos de red cubriendo estas áreas.

## 3. SNMP

**SNMP (Simple Network Management Protocol)** es el protocolo de gestión más
difundido en equipamiento de red.

### 3.1 Arquitectura

- Un **Manager** (el NMS) dialoga con un **Agente** presente en cada dispositivo.
- El agente expone objetos en la **MIB (Management Information Base)**, un árbol de
  datos donde cada elemento se identifica con un **OID (Object Identifier)**.
- **Operaciones**: **GET / GETNEXT / GETBULK** (leer), **SET** (escribir) y
  **TRAP / INFORM** (el agente avisa de un evento).
- **Puertos**: **UDP 161** (agente) y **UDP 162** (traps/informs al manager).

Fuentes: SNMPv1 en **RFC 1157**; estructura de la MIB (SMIv2) en **RFC 2578**
(STD 58); operaciones en **RFC 3416**.

### 3.2 Las versiones y la seguridad

Es el punto crítico para esta materia:

- **v1** y **v2c** envían la *community string* (la "contraseña" de la gestión) en
  **texto plano**. Un sniffer (Unidad 4) la captura y puede tomar el control de la
  gestión de los equipos.
- **v3** es la **única versión segura**: aporta **autenticación** (HMAC) y **cifrado**
  mediante el **User-based Security Model (USM)**, además de protección anti-replay.

Encontrar SNMP **v2c con community "public"** es uno de los primeros hallazgos en
cualquier pentest. Fuentes: arquitectura de SNMPv3 en **RFC 3411** (STD 62), USM en
**RFC 3414**.

## 4. Syslog

**Syslog** transporta mensajes de **eventos/log** desde los dispositivos a un
colector central.

- **Severidades**: de **0 (Emergency)** a **7 (Debug)**, además de *facilities* que
  clasifican el origen.
- **Transporte**: históricamente **UDP 514**; hoy también TCP y, para logging seguro,
  **TLS sobre TCP 6514**.

El cifrado importa porque los logs contienen información sensible **y** son
evidencia: sin protección, un atacante puede leerlos o alterarlos. Fuentes: **RFC
5424** (el protocolo moderno, que obsoleta al viejo RFC 3164) y **RFC 5425** (mapeo
sobre TLS).

### 4.1 Centralización

Un log que reside **solo en el equipo** sirve de poco: si el atacante entra, borra
sus huellas (Unidad 3, fases 4-5). Con logs **centralizados y protegidos**, el
borrado es mucho más difícil —la evidencia ya salió del equipo comprometido— y,
además, permite **correlacionar** eventos de toda la red. El monitoreo centralizado
es la contramedida directa al borrado de huellas.

## 5. Monitoreo de flujos: NetFlow / IPFIX

Además de métricas SNMP y logs, el monitoreo moderno analiza **flujos**: metadatos de
*quién habló con quién, por qué puerto y cuánto tráfico*, **sin inspeccionar el
contenido**. Es la base para la detección de anomalías, la planificación de capacidad
y el análisis forense. **NetFlow** es la tecnología original de Cisco (formato v9,
RFC 3954) e **IPFIX** su estandarización IETF (**RFC 7011**, STD 77). En el mundo
cifrado (Unidad 4), los metadatos de flujo son gran parte de lo analizable.

## 6. La observabilidad moderna

El monitoreo cloud-native evolucionó del *polling* SNMP hacia **métricas de series
temporales por modelo pull, dashboards e instrumentación estándar**, consolidando el
marco de los **tres pilares de la observabilidad**:

- **Métricas** — números en el tiempo (CPU, tráfico, latencia): "¿está pasando algo?".
  Herramientas: **Prometheus** (series temporales, modelo *pull*) + **Grafana**
  (visualización). Prometheus es el "SNMP" de la infraestructura cloud-native.
- **Logs** — eventos con detalle: "¿qué pasó exactamente?". Herramientas: Syslog,
  **ELK/Elastic Stack**, **Grafana Loki**.
- **Trazas** — el recorrido de una petición entre servicios: "¿dónde se trabó?".

**OpenTelemetry (OTel)**, proyecto de la CNCF, es el estándar emergente que
**unifica** la instrumentación de las tres señales. El objetivo de fondo es el mismo
que el de SNMP/Syslog —recolectar, almacenar, graficar y alertar—; cambian las
herramientas y la escala.

## 7. SIEM y monitoreo de seguridad

Un **SIEM (Security Information and Event Management)** **centraliza** logs y eventos
de toda la infraestructura para **correlacionarlos** y **detectar** incidentes; es el
punto donde el monitoreo alimenta directamente a la seguridad, integrando fuentes como
SNMP, Syslog, flujos, IDS (Unidad 5) y endpoints. Su valor está en la correlación:
un login inusual **más** un escaneo **más** una transferencia grande pueden, juntos,
disparar una alerta que por separado pasarían inadvertidos. Se opera desde un **SOC
(Security Operations Center)**. Herramientas: **Wazuh** (open source), Elastic
Security y Splunk.

## 8. El cierre del ciclo

El monitoreo es la fase que **sostiene** al resto del ciclo de seguridad: sin
detección no hay respuesta a incidentes, y sin evidencia no hay investigación ni
mejora continua. Cierra el círculo con la idea de "seguridad como proceso" de la
Unidad 1, siguiendo el esquema **detectar → responder → mejorar**. La referencia del
ciclo de respuesta a incidentes es **NIST SP 800-61 Rev. 3**. La tendencia actual es
**AIOps** —detección de anomalías basada en aprendizaje automático sobre el volumen
de métricas, logs y flujos—.

## 9. Ideas para llevarse

1. Sin visibilidad no hay defensa: el monitoreo cierra el ciclo de la seguridad.
2. FCAPS organiza la gestión; el NMS la implementa.
3. SNMP: manager/agente, MIB/OID; **solo v3 es seguro** (v1/v2c van en claro).
4. Syslog centraliza eventos; con TLS (6514) protege la evidencia.
5. La observabilidad moderna: métricas, logs y trazas (Prometheus, OTel).
6. El SIEM correlaciona todo y alimenta al SOC; es donde converge el curso.

## 10. Cierre del curso

A lo largo de las ocho unidades vimos una sola historia: entender **qué proteger**
(U1) y el **perímetro físico** (U2); aprender a **atacar para defender** (U3-U4);
levantar las **defensas** (U5); **proteger la información** aunque el canal sea hostil
(U6); controlar **quién entra** (U7); y **vigilar** que todo siga sano (U8). La idea
que las atraviesa: la seguridad es un **proceso** que se diseña, se sostiene y se
mejora, y administrar una red y asegurarla son la misma tarea. Los fundamentos
perduran aunque las herramientas cambien.

## 11. Referencias

- **ITU-T M.3400** — *TMN management functions*. https://www.itu.int/rec/T-REC-M.3400/en
- **ITU-T X.700** — *Management framework for OSI*. https://www.itu.int/rec/T-REC-X.700/en · ISO/IEC 7498-4.
- **RFC 1157** — *A Simple Network Management Protocol (SNMPv1)*. https://www.rfc-editor.org/info/rfc1157
- **RFC 2578** — *Structure of Management Information v2 (SMIv2)* (STD 58). https://www.rfc-editor.org/info/rfc2578
- **RFC 3411** — *Architecture for SNMP Management Frameworks* (SNMPv3, STD 62). https://www.rfc-editor.org/info/rfc3411
- **RFC 3414** — *User-based Security Model (USM) for SNMPv3*. https://www.rfc-editor.org/info/rfc3414
- **RFC 3416** — *Version 2 of the Protocol Operations for SNMP*. https://www.rfc-editor.org/info/rfc3416
- **RFC 5424** — *The Syslog Protocol*. https://www.rfc-editor.org/info/rfc5424 · **RFC 5425** — *TLS Transport Mapping for Syslog*. https://www.rfc-editor.org/info/rfc5425
- **RFC 7011** — *IPFIX Protocol Specification* (STD 77). https://www.rfc-editor.org/info/rfc7011 · **RFC 3954** — *Cisco NetFlow v9*. https://www.rfc-editor.org/info/rfc3954
- **Prometheus**. https://prometheus.io/docs/ · **Grafana**. https://grafana.com/docs/ · **OpenTelemetry** (CNCF). https://opentelemetry.io/docs/
- **Elastic Stack**. https://www.elastic.co/elastic-stack · **Grafana Loki**. https://grafana.com/docs/loki/latest/
- **Wazuh** (SIEM/XDR open source). https://documentation.wazuh.com/ · Elastic Security · Splunk.
- **NIST SP 800-61 Rev. 3** — *Incident Response Recommendations*. https://csrc.nist.gov/pubs/sp/800/61/r3/final
- C. Sridharan — *Distributed Systems Observability* (O'Reilly, 2018).
- W. Stallings — *Fundamentos de Seguridad en Redes* (bibliografía de cátedra).
