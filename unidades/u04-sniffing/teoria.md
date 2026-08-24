# Unidad 4 — Sniffing (Análisis de tráfico)

> Material teórico de acompañamiento. Complementa las filminas y la clase.
> ARyS · IF046 · UNPSJB Trelew.

## 1. Encuadre: de escanear a escuchar

La Unidad 3 se ocupó de **mapear** la red (reconocimiento y escaneo). Esta unidad
se ocupa de **escuchar** lo que circula por ella: el **sniffing** o análisis de
tráfico, esto es, la captura y el estudio de los paquetes que viajan por un medio
de red.

El sniffing es una técnica **de doble uso**. Del lado defensivo es imprescindible:
diagnóstico y *troubleshooting*, análisis de rendimiento, detección de intrusiones
y análisis forense. Del lado ofensivo permite robar credenciales que viajan en
claro, secuestrar sesiones, espiar comunicaciones y mapear la red interna. La misma
herramienta (Wireshark, por ejemplo) sirve para ambos; lo que cambia es la
**autorización** y la **intención**.

## 2. Marco legal

> Interceptar comunicaciones ajenas sin autorización constituye delito.

En Argentina, la **Ley 26.388** de delitos informáticos tipifica, entre otros, el
acceso indebido a comunicaciones electrónicas (Art. 153) y el acceso ilegítimo a un
sistema informático (Art. 153 bis). En consecuencia, en esta materia solo se
captura **tráfico propio o de una red administrada con autorización**, y todo el
trabajo práctico se realiza en un **laboratorio aislado**. Nunca sobre la red de la
facultad, una red pública ni la de un tercero.

## 3. Sniffing pasivo y activo

- **Pasivo** — el atacante solo **escucha**; no altera la red. Es indetectable,
  pero depende de que el tráfico **llegue** a su interfaz.
- **Activo** — el atacante **manipula** la red para que el tráfico pase por él
  (MAC flooding, ARP spoofing). Deja rastro, pero es **necesario en redes
  conmutadas**, donde el tráfico ajeno no llega solo.

### 3.1 El modo promiscuo

Una interfaz de red normal descarta las tramas cuya dirección MAC de destino no es
la suya. En **modo promiscuo**, la interfaz acepta **todas** las tramas que le
llegan y las entrega al sistema operativo. El modo promiscuo es **condición
necesaria pero no suficiente** para sniffear tráfico ajeno: captura lo que *llega*
a la placa, y en una red conmutada lo que llega es, precisamente, poco.

### 3.2 Hub vs. switch

En una red con **hub**, el dispositivo repite cada trama por **todos** los puertos
(dominio de colisión compartido); basta el modo promiscuo para capturar todo:
sniffing puramente pasivo. En una red con **switch**, la tabla **CAM** (MAC →
puerto) dirige cada trama únicamente al puerto de destino, de modo que el modo
promiscuo ya no ve el tráfico ajeno. Por eso, en redes modernas, el atacante debe
recurrir a técnica activa o a métodos legítimos de captura (TAP, SPAN). El
comportamiento de reenvío de los switches está definido en el estándar **IEEE
802.1D** (bridging).

## 4. Técnicas de sniffing activo

### 4.1 MAC flooding (desbordamiento de la tabla CAM)

La tabla CAM del switch tiene capacidad finita. El atacante la **satura** enviando
miles de tramas con direcciones MAC de origen falsas. Al desbordarse, muchos
switches entran en modo **fail-open** y reenvían por todos los puertos, comportándose
como un hub; el sniffing pasivo vuelve a ser efectivo. La contramedida directa es
**Port Security** (limitar la cantidad de MAC por puerto).

### 4.2 ARP spoofing y Man-in-the-Middle (MITM)

El protocolo de resolución de direcciones **ARP** (**RFC 826**, 1982) traduce
direcciones IP a direcciones MAC dentro de una LAN, y **no incorpora ninguna
autenticación**: cualquier host puede afirmar "esa IP la tengo yo". El atacante
envía respuestas ARP falsificadas que **envenenan** las tablas de la víctima y del
gateway, asociando su propia MAC a las IP de ambos. Como resultado, se coloca **en
el medio** de la comunicación (*Man-in-the-Middle*): todo el tráfico entre víctima y
gateway pasa por él, que puede **leerlo y modificarlo** si no está cifrado. Es la
técnica de sniffing activo por excelencia en LAN conmutada. Su contramedida es
**Dynamic ARP Inspection** (ver §8).

## 5. Técnicas basadas en hardware

Son los métodos **legítimos** que usa el administrador para capturar tráfico
(monitoreo, IDS, forense):

- **Network TAP** — dispositivo de hardware que se intercala en el cable y entrega
  una **copia fiel** del tráfico a un analizador. Es pasivo, no pierde paquetes y es
  invisible en la red; es el patrón de referencia por fidelidad.
- **Port mirroring / SPAN** — el propio switch **copia** el tráfico de uno o varios
  puertos hacia un puerto de monitoreo. Es flexible y no requiere hardware extra,
  pero bajo saturación **puede descartar** paquetes.

## 6. Herramientas

- **tcpdump / tshark** — captura y filtrado desde la línea de comandos; ideales para
  servidores sin entorno gráfico. Producen y leen archivos **.pcap**, el formato
  estándar de captura.
- **Wireshark** — el analizador gráfico de referencia. Disecciona cada paquete capa
  por capa, ofrece filtros de visualización potentes (`http`, `ip.addr == …`,
  `tcp.port == 443`), reconstrucción de conversaciones (*Follow TCP stream*),
  estadísticas y exportación de objetos.
- **bettercap** — el marco moderno de MITM y manipulación de tráfico, sucesor de
  **ettercap** (y de la histórica suite **dsniff** de Dug Song). Integra ARP
  spoofing, sniffing y módulos de Wi-Fi/BLE, y es automatizable. Legal de estudiar y
  usar en laboratorio propio; su uso contra terceros sin autorización es delito.

## 7. El cambio de paradigma: el tráfico cifrado

La transformación más importante del sniffing en la última década es que **hoy casi
todo el tráfico viaja cifrado**. Según el *Google Transparency Report*,
aproximadamente el **95%** de las páginas cargadas en Chrome se sirven sobre HTTPS
(cifra viva, consultada en 2026). Esto cambia radicalmente **para qué sirve**
sniffear.

### 7.1 TLS 1.3

Con **TLS 1.3** (**RFC 8446**, 2018) gran parte del handshake —incluido el
certificado del servidor— y **todo el contenido** de la aplicación viajan cifrados.
Un sniffer todavía observa **metadatos** (IPs, puertos, tamaños y tiempos de los
paquetes) pero no el contenido (URLs, cookies, datos).

### 7.2 Encrypted Client Hello (ECH)

El **SNI** (*Server Name Indication*) era el último dato sensible que viajaba en
claro dentro del ClientHello: revelaba **a qué dominio** se conectaba el usuario. El
**Encrypted Client Hello (ECH)** cifra el ClientHello completo bajo una clave
pública del servidor, cerrando esa fuga de metadatos; ya lo despliegan las
principales CDN. ECH se estandarizó como **RFC 9849** (2026); previamente circuló
como el borrador `draft-ietf-tls-esni` (ESNI/ECH).

### 7.3 DNS cifrado (DoT y DoH)

El DNS tradicional viaja en texto plano (puerto 53), de modo que un sniffer ve qué
dominios resuelve el usuario aunque luego use HTTPS. **DNS over TLS (DoT)**
encapsula las consultas en TLS sobre el puerto 853 (**RFC 7858**), y **DNS over
HTTPS (DoH)** las transporta sobre HTTPS en el puerto 443, indistinguible del
tráfico web (**RFC 8484**). La combinación **TLS 1.3 + ECH + DNS cifrado** deja al
sniffer, en la práctica, solo con los metadatos de flujo.

### 7.4 Fingerprinting de tráfico cifrado

Cuando el contenido no puede leerse, el análisis se corre a **identificar al cliente
por la forma** de su tráfico. El ClientHello de TLS varía según la aplicación o
librería (versión, cifrados, extensiones), y un **hash** de esos campos permite
reconocer software y malware **sin descifrar**. **JA3** (Salesforce, 2017) fue el
pionero; **JA4/JA4+** (FoxIO) es su evolución más robusta —resiste la aleatorización
de extensiones y define una familia de fingerprints para TLS, HTTP, TCP y SSH—, hoy
de referencia para *threat hunting* sobre tráfico cifrado. (Nota de licencia: JA4 de
cliente TLS es BSD-3; el resto del suite usa la *FoxIO License 1.1*, permisiva para
uso académico e interno.)

## 8. Sniffing en Wi-Fi

En redes inalámbricas, el modo relevante es el **monitor mode** (distinto del
promiscuo): captura **todas** las tramas 802.11 del aire —incluidas las de
gestión— sin necesidad de estar asociado a la red. Bajo **WPA2**, esto permite
capturar el **4-way handshake** y atacarlo **offline** por diccionario o fuerza
bruta. **WPA3** reemplaza ese intercambio por **SAE** (*Simultaneous Authentication
of Equals*, "Dragonfly"), que aporta *forward secrecy* y **resistencia al ataque
offline**: capturar el handshake ya no permite adivinar la contraseña sin interactuar
en línea con el punto de acceso. Matiz importante: WPA3 **no es invulnerable**; los
ataques **Dragonblood** (Vanhoef & Ronen, 2020) demostraron canales laterales y de
*downgrade*. La base de SAE está en **RFC 7664** (Dragonfly) y su forma normativa
para Wi-Fi en **IEEE 802.11-2020** más la *WPA3 Specification* de la Wi-Fi Alliance;
**no existe un "RFC de WPA3"**.

## 9. Defensas

### 9.1 En la capa 2 (el switch)

- **Port Security** — limita las direcciones MAC por puerto; frena el MAC flooding.
- **DHCP Snooping** — distingue puertos confiables de no confiables, bloquea
  servidores DHCP falsos y construye una base de asociaciones IP-MAC.
- **Dynamic ARP Inspection (DAI)** — valida cada mensaje ARP contra esa base y
  descarta los falsificados; frena el ARP spoofing.
- **802.1X** — control de admisión: exige autenticación antes de habilitar el puerto
  (**IEEE 802.1X-2020**).

### 9.2 La defensa definitiva: cifrado extremo a extremo

Los controles de capa 2 ayudan, pero pueden fallar o no estar presentes. La defensa
**real** consiste en asumir que la red es hostil y **cifrar de punta a punta**:
HTTPS/TLS en todo (con HSTS), VPN o IPsec para el tráfico interno sensible, y DNS
cifrado. El funcionamiento interno de ese cifrado —criptografía simétrica y
asimétrica, PKI, firma digital— es el contenido de la **Unidad 6**, para la cual el
sniffing es la mejor motivación.

## 10. Ideas para llevarse

1. El sniffing es capturar y analizar tráfico; misma herramienta, distinta ética.
2. El modo promiscuo alcanza en hub, pero no en switch.
3. En redes conmutadas hace falta técnica activa: MAC flooding, ARP spoofing/MITM.
4. Las técnicas de hardware legítimas son el TAP y el port mirroring (SPAN).
5. Hoy casi todo viaja cifrado: el foco pasó del contenido a los metadatos.
6. Surgieron técnicas como el fingerprinting (JA3/JA4) que no necesitan descifrar.
7. Se defiende en capa 2 y, sobre todo, cifrando de extremo a extremo.

## 11. Referencias

- Ley 26.388 (Argentina) — Delitos Informáticos.
- **RFC 826** — *An Ethernet Address Resolution Protocol (ARP)*. https://www.rfc-editor.org/info/rfc826/
- **RFC 8446** — *The Transport Layer Security (TLS) Protocol Version 1.3*. https://www.rfc-editor.org/info/rfc8446/
- **RFC 9849** — *TLS Encrypted Client Hello (ECH)* (2026). https://www.rfc-editor.org/info/rfc9849/ · historia: `draft-ietf-tls-esni`.
- **RFC 7858** — *DNS over TLS (DoT)*. https://www.rfc-editor.org/info/rfc7858/
- **RFC 8484** — *DNS Queries over HTTPS (DoH)*. https://www.rfc-editor.org/info/rfc8484/
- **RFC 7664** — *Dragonfly Key Exchange* (base de SAE/WPA3). https://www.rfc-editor.org/info/rfc7664/
- **IEEE Std 802.1D** — MAC Bridges (reenvío de switches).
- **IEEE Std 802.1X-2020** — Port-Based Network Access Control. https://standards.ieee.org/ieee/802.1X/7345/
- **IEEE Std 802.11-2020** — WLAN; y Wi-Fi Alliance, *WPA3 Specification*. https://www.wi-fi.org/discover-wi-fi/security
- Vanhoef, M. & Ronen, E. (2020). *Dragonblood: Analyzing the Dragonfly Handshake of WPA3 and EAP-pwd*. IEEE S&P. https://wpa3.mathyvanhoef.com/
- JA3 (Salesforce). https://github.com/salesforce/ja3 · JA4/JA4+ (FoxIO). https://github.com/FoxIO-LLC/ja4
- Cisco — *Dynamic ARP Inspection*, *DHCP Snooping*, *Port Security* (Catalyst Security Configuration Guide).
- Wireshark Wiki — *CaptureSetup/Ethernet* y *CaptureSetup/WLAN*. https://wiki.wireshark.org/
- bettercap. https://www.bettercap.org/ · ettercap. https://www.ettercap-project.org/
- Google Transparency Report — *HTTPS encryption on the web*. https://transparencyreport.google.com/https/overview
- W. Stallings — *Fundamentos de Seguridad en Redes* (bibliografía de cátedra).
