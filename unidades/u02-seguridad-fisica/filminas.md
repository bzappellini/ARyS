---
marp: true
theme: arys
paginate: true
footer: 'ARyS · IF046 · UNPSJB Trelew'
---

<!-- _class: portada -->
<!-- _paginate: false -->
<!-- _footer: '' -->

# Seguridad Física
## Unidad 2 — El primer perímetro

<div class="meta">ARyS · IF046 · UNPSJB Trelew · 2026</div>

<!--
Nota del docente:
Clase teórica de 3 horas. Arrancar con la pregunta del axioma: si alguien
tiene acceso físico a la máquina, ¿sigue siendo tuya?
-->

---

## De dónde venimos

En la **Unidad 1** definimos los pilares:

- Confidencialidad · Integridad · Disponibilidad
- Autenticidad · No repudio · Privacidad

Y una idea clave: la seguridad es un **proceso**, no un producto.

<div class="nota red"><span class="rot">Hoy</span>
Todos esos pilares se caen en un segundo si alguien puede tocar el equipo.</div>

---

## El axioma de la seguridad física

> Si un atacante tiene acceso físico irrestricto a tu equipo,
> **ya no es tu equipo**.

Es una de las [10 Leyes Inmutables de la Seguridad](https://learn.microsoft.com/en-us/security/zero-trust/ten-laws-of-security)
y sigue siendo cierta 25 años después.

<div class="nota amenaza"><span class="rot">Por qué</span>
Todo control lógico —contraseña, firewall, antivirus— se ejecuta sobre hardware.
Quien controla el hardware controla la ejecución de esos controles.</div>

---

## ¿Qué protegemos?

<div class="tarjetas">
<div class="t"><b>Personas</b>Lo primero. Ningún dato vale una vida.</div>
<div class="t"><b>Instalaciones</b>Edificio, sala técnica, sala de servidores.</div>
<div class="t"><b>Equipamiento</b>Servidores, switches, routers, APs, notebooks.</div>
<div class="t"><b>Medios</b>Discos, cintas, pendrives, backups.</div>
<div class="t"><b>Infraestructura</b>Energía, refrigeración, cableado.</div>
<div class="t"><b>Documentación</b>Planos, credenciales en papel, contratos.</div>
</div>

---

## Las tres familias de amenazas

Según el programa de la materia:

1. **Acceso físico no autorizado** — intencional, alguien entra
2. **Desastres naturales** — no intencional, la naturaleza
3. **Alteraciones del entorno** — energía, clima, ambiente

<div class="nota"><span class="rot">Observación</span>
Las tres afectan sobre todo a la <strong>Disponibilidad</strong>, pero el acceso
físico compromete además Confidencialidad e Integridad.</div>

---

## 1 · Acceso físico
### El atacante entra caminando

---

## Defensa en profundidad física

Nunca un único control. **Capas concéntricas**:

![h:400](../../assets/img/defensa-en-profundidad.svg)

---

## Tipos de control

| Tipo | Qué hace | Ejemplo físico |
|---|---|---|
| **Disuasivo** | Desalienta el intento | Cartelería, iluminación, garita visible |
| **Preventivo** | Impide el hecho | Cerradura, esclusa, jaula |
| **Detectivo** | Descubre el hecho | CCTV, sensor de apertura, alarma |
| **Correctivo** | Restaura tras el hecho | Backup, sitio alterno, repuesto |
| **Compensatorio** | Sustituye a otro control | Guardia 24×7 si no hay control de acceso |

<div class="nota control"><span class="rot">Regla</span>
Prevenir es mejor que detectar, pero <strong>detectar siempre</strong>: sin evidencia
no hay respuesta a incidentes ni investigación posterior.</div>

---

## CPTED
### Prevención del delito mediante el diseño del entorno

Cuatro principios que se aplican antes de comprar un solo dispositivo:

- **Control natural de accesos** — un único ingreso claro y visible
- **Vigilancia natural** — ventanas, líneas de visión, sin puntos ciegos
- **Refuerzo territorial** — que se note qué es público y qué es privado
- **Mantenimiento** — el deterioro señala abandono y atrae el delito

<div class="nota"><span class="rot">Costo</span>
Es el control más barato de todos: se decide en el plano, no en la factura.</div>

---

## Control de acceso físico: mecanismos

<div class="cols">
<div>

### Lo que sabés
- PIN, clave de teclado

### Lo que tenés
- Llave mecánica
- Tarjeta de proximidad (RFID)
- Token, credencial

</div>
<div>

### Lo que sos
- Huella dactilar
- Iris / retina
- Geometría de mano
- Reconocimiento facial

### Lo que hacés
- Firma, patrón de marcha

</div>
</div>

Mismos factores que en la Unidad 7 (autenticación). **El concepto es el mismo,
cambia el mundo donde se aplica.**

---

## Biometría: métricas que importan

- **FAR** (False Acceptance Rate) — acepta a quien no debe → **riesgo de seguridad**
- **FRR** (False Rejection Rate) — rechaza a quien debe → **riesgo de disponibilidad**
- **CER / EER** — punto donde FAR = FRR; sirve para comparar sistemas

<div class="nota amenaza"><span class="rot">Cuidado</span>
La biometría <strong>no es secreta</strong> y <strong>no se puede revocar</strong>.
Dejás tus huellas en cada vaso; tu cara está en Internet. Si se filtra la plantilla,
no podés cambiar de dedo.</div>

Usarla como **un** factor, nunca como el único.

---

## Ataques al control de acceso

<div class="tarjetas">
<div class="t"><b>Tailgating</b>Entro atrás tuyo sin credencial. El atacante cuenta con tu buena educación.</div>
<div class="t"><b>Piggybacking</b>Igual, pero con tu consentimiento ("me tenés la puerta?").</div>
<div class="t"><b>Lockpicking</b>Ganzúa, bumping, llave maestra. Barato y silencioso.</div>
<div class="t"><b>Clonado RFID</b>Proxmark3 o Flipper Zero copian una tarjeta 125 kHz a 10 cm.</div>
<div class="t"><b>Shoulder surfing</b>Mirar el PIN por encima del hombro. O una cámara.</div>
<div class="t"><b>Dumpster diving</b>La basura tiene planos, listados y post-its.</div>
</div>

---

## El eslabón humano

La mayoría de las intrusiones físicas **no rompen nada**: piden permiso.

- Chaleco, credencial impresa y una escalera abren más puertas que una ganzúa
- "Vengo del proveedor de aire acondicionado"
- Urgencia + autoridad = el guardia no pregunta

<div class="nota control"><span class="rot">Contramedida</span>
Procedimiento escrito de visitas, acompañamiento obligatorio, verificación
telefónica contra el proveedor, y una cultura donde <strong>preguntar está bien visto</strong>.</div>

---

## Tarjetas: no todas son iguales

| Tecnología | Seguridad | Comentario |
|---|---|---|
| 125 kHz (EM4100, HID Prox) | ✗ Nula | Solo transmite un ID. Se clona en segundos |
| MIFARE Classic | ✗ Rota | Crypto‑1 quebrada desde 2008 |
| MIFARE DESFire EV2/EV3 | ✓ Buena | AES, autenticación mutua |
| Tarjeta + PIN | ✓ Buena | Dos factores reales |

<div class="nota amenaza"><span class="rot">Realidad</span>
Muchísimas instituciones —universidades incluidas— siguen usando 125 kHz
porque "siempre funcionó".</div>

---

## Ataques al equipo con acceso físico

<div class="cols">
<div>

### Arranque y disco
- Booteo desde USB/red
- Extracción del disco
- **Evil maid** — manipulación del gestor de arranque
- **Cold boot** — recuperar claves de la RAM enfriada

</div>
<div>

### Puertos e interfaces
- **BadUSB / Rubber Ducky** — teclado que escribe solo
- **O.MG cable** — implante dentro del cable
- **DMA** — Thunderbolt/PCIe leen la RAM directo
- **JTAG / UART** — consola en la placa

</div>
</div>

<div class="nota amenaza"><span class="rot">Tiempo requerido</span>
Un BadUSB necesita <strong>menos de 10 segundos</strong> conectado.</div>

---

## Contramedidas a nivel equipo

```bash
# Cifrado de disco completo: sin la clave, el disco robado es chatarra
cryptsetup luksFormat /dev/sda2
cryptsetup luksOpen  /dev/sda2 cryptroot

# Estado del cifrado y de los slots de clave
cryptsetup luksDump /dev/sda2
```

- **UEFI/BIOS con contraseña** y orden de booteo fijo
- **Secure Boot** activo, para detectar bootloaders manipulados
- **TPM 2.0** para sellar la clave al estado del arranque
- **IOMMU / Kernel DMA Protection** contra ataques por Thunderbolt
- **Detección de apertura de gabinete** (chassis intrusion)

---

## Bloqueo de puertos USB en Linux

```bash
# USBGuard: lista blanca de dispositivos USB permitidos
sudo apt install usbguard
sudo usbguard generate-policy > /etc/usbguard/rules.conf
sudo systemctl enable --now usbguard

# Ver dispositivos y su estado de autorización
usbguard list-devices

# Autorizar uno puntual
usbguard allow-device 6
```

<div class="nota control"><span class="rot">Criterio</span>
Regla por defecto: <strong>denegar</strong>. Se autoriza lo conocido, no se
bloquea lo sospechoso.</div>

---

## 2 · Desastres naturales
### Cuando el atacante es el planeta

---

## Empieza por la ubicación

Antes de blindar, **elegí bien dónde ponés la sala**:

- ✗ Sótano → inundación
- ✗ Última planta → filtraciones, temperatura, viento
- ✗ Pared medianera con la calle → vehículos, ruido, acceso
- ✗ Debajo o al lado de baños y cocinas → agua
- ✓ Planta intermedia, interior del edificio, sin ventanas exteriores

<div class="nota"><span class="rot">Contexto regional</span>
En Patagonia el riesgo dominante no es el sismo: es <strong>viento fuerte,
corte de energía prolongado y ceniza volcánica</strong>. La ceniza es abrasiva
y conductiva: mata ventiladores, filtros y fuentes.</div>

---

## Fuego: detectar antes de que haya llama

- **Detección temprana por aspiración (VESDA)** — analiza el aire, detecta partículas
  antes del humo visible
- **Detectores de humo y térmicos** por sobre y por debajo del piso técnico
- **Extinción por agente limpio**: NOVEC 1230, FM-200, INERGEN
- ✗ **Nunca agua** en sala de servidores; ✗ el polvo químico destruye electrónica

<div class="nota control"><span class="rot">Obligatorio</span>
Corte automático de energía y de HVAC al disparar la extinción, y
señalización de evacuación. <strong>Primero las personas.</strong></div>

---

## Agua, sismo, viento

<div class="cols">
<div>

### Agua
- Sensores de humedad bajo piso técnico
- Sin cañerías sobre el rack
- Piso elevado con desagüe

### Sismo
- Racks anclados
- Aisladores de base
- Sujeción de cargas altas

</div>
<div>

### Viento y ceniza (Patagonia)
- Presurización positiva de sala
- Filtros F7/F9 y recambio frecuente
- Sellado de aberturas
- Protección de tomas de aire exterior

</div>
</div>

---

## Continuidad: los números que importan

<div class="cols">
<div>

### RTO
**Recovery Time Objective**

¿Cuánto tiempo puedo estar caído?

### RPO
**Recovery Point Objective**

¿Cuántos datos puedo perder?

</div>
<div>

### BIA
**Business Impact Analysis**

Qué procesos son críticos y cuánto cuesta cada hora de caída.

Sale de acá el presupuesto real de todo lo demás.

</div>
</div>

<div class="nota"><span class="rot">Sin BIA</span>
Comprás controles por intuición o por miedo, no por riesgo.</div>

---

## Sitios alternos

| Tipo | Contenido | Puesta en marcha | Costo |
|---|---|---|---|
| **Cold site** | Espacio, energía, red | Semanas | Bajo |
| **Warm site** | Hardware, sin datos frescos | Horas / días | Medio |
| **Hot site** | Réplica sincronizada | Minutos | Alto |
| **Cloud / DRaaS** | Replicación bajo demanda | Minutos | Variable |

---

## Regla 3‑2‑1 de backups

- **3** copias de los datos
- **2** medios distintos
- **1** copia **fuera del sitio**

Extensión moderna: **3‑2‑1‑1‑0**

- **1** copia *offline* o inmutable (defensa contra ransomware)
- **0** errores en la **restauración probada**

<div class="nota amenaza"><span class="rot">La verdad incómoda</span>
Un backup que nunca se restauró <strong>no es un backup</strong>: es una hipótesis.</div>

---

## 3 · Alteraciones del entorno
### Lo que rompe sin romper nada

---

## Energía eléctrica: vocabulario

| Fenómeno | Qué es | Efecto |
|---|---|---|
| **Blackout** | Corte total | Caída inmediata |
| **Brownout** | Baja tensión sostenida | Fuentes recalentadas, fallas raras |
| **Sag / Dip** | Caída breve | Reinicios |
| **Surge / Spike** | Sobretensión | Daño de hardware |
| **Ruido / EMI** | Interferencia | Errores intermitentes |

<div class="nota control"><span class="rot">Defensa</span>
UPS (autonomía + estabilización) → grupo electrógeno (autonomía larga) →
puesta a tierra correcta → protección contra sobretensión.</div>

---

## UPS y grupo electrógeno

- El **UPS** no está para aguantar toda la noche: está para **sostener hasta que
  arranque el grupo** o para **apagar ordenadamente**
- Probar el arranque del grupo **con carga**, periódicamente
- Combustible: autonomía real y contrato de reposición
- Baterías: vida útil 3–5 años, **medir**, no suponer
- Apagado automático coordinado por NUT / apcupsd

```bash
# Estado del UPS en Linux (Network UPS Tools)
upsc ups@localhost

# Ejemplo de salida
# battery.charge: 100
# battery.runtime: 1840
# ups.status: OL          # OL = on line, OB = on battery
```

---

## Redundancia: N, N+1, 2N

- **N** — justo lo necesario. Falla uno, caés.
- **N+1** — un componente de sobra. Tolera una falla.
- **2N** — todo duplicado, cadenas independientes.
- **2N+1** — duplicado y con reserva.

Se aplica a UPS, chillers, fuentes de servidor, enlaces de red y proveedores
de energía.

<div class="nota"><span class="rot">Ojo</span>
Dos fuentes de alimentación conectadas a la <strong>misma</strong> regleta
no son redundancia: son dos cables al mismo punto único de falla.</div>

---

## Clima: temperatura y humedad

Rango recomendado por **ASHRAE** para sala de equipos:

- Temperatura: **18 °C a 27 °C**
- Humedad relativa: **40 % a 60 %**

<div class="cols">
<div>

### Humedad baja
Electricidad estática → descargas que dañan componentes

</div>
<div>

### Humedad alta
Condensación y corrosión

</div>
</div>

**Pasillo frío / pasillo caliente**: racks enfrentados, aire frío por el frente,
caliente por atrás, con contención. Sin contención, el aire se mezcla y el
equipo de frío trabaja de más.

---

## El cableado también es seguridad

- Canalizaciones cerradas y rotuladas
- Patch panel bajo llave; documentación actualizada
- Separar cableado de datos del de energía (interferencia)
- Puertos de switch **sin usar, deshabilitados** — no basta con no enchufar
- Fibra: más difícil de intervenir que el cobre, pero **no imposible**

<div class="nota amenaza"><span class="rot">Ataque</span>
Un <em>network tap</em> pasivo en un patch panel descuidado copia todo el
tráfico sin alterar el enlace. Nos vamos a encontrar con esto en la
<strong>Unidad 4 — Sniffing</strong>.</div>

---

## Emanaciones: TEMPEST

Todo dispositivo electrónico **irradia**. Con la antena adecuada, esa radiación
se puede reconstruir.

- Monitores, cables HDMI/VGA y teclados emiten señal recuperable
- **TEMPEST** es el conjunto de normas para limitar esas emanaciones
- Contramedidas: apantallamiento, jaula de Faraday, zonas de exclusión

<div class="nota"><span class="rot">En perspectiva</span>
Es una amenaza de alto costo y objetivos de alto valor. Para nosotros vale como
concepto: <strong>el canal lateral existe aunque no lo veas</strong>.</div>

---

## Marcos normativos

<div class="cols">
<div>

### ISO/IEC 27001:2022
**Anexo A, cláusula 7 — Controles físicos**

7.1 Perímetros · 7.2 Ingreso ·
7.3 Oficinas y salas · 7.4 Monitoreo ·
7.5 Amenazas físicas · 7.6 Áreas seguras ·
7.7 Escritorio y pantalla limpios ·
7.8–7.14 Equipamiento, cableado,
mantenimiento, retiro y descarte

</div>
<div>

### NIST SP 800‑53 Rev. 5
**Familia PE — Physical and Environmental Protection**

PE‑2 Autorizaciones · PE‑3 Control de acceso ·
PE‑6 Monitoreo · PE‑9 Energía ·
PE‑13 Fuego · PE‑14 Clima ·
PE‑17 Sitio alterno

</div>
</div>

<div class="nota control"><span class="rot">Para qué sirven</span>
No para memorizarlos: para <strong>no olvidarte de nada</strong> cuando diseñás.</div>

---

## Escritorio limpio y descarte seguro

<div class="cols">
<div>

### Clean desk / clean screen
- Nada sensible a la vista
- Bloqueo de pantalla automático
- Papeles bajo llave

</div>
<div>

### Descarte de medios
- Papel → destructora de corte cruzado
- Disco magnético → borrado o desmagnetizado
- SSD → borrado criptográfico (la sobrescritura **no** alcanza)
- Certificado de destrucción

</div>
</div>

```bash
# Borrado criptográfico de un SSD con soporte ATA Secure Erase
sudo hdparm --user-master u --security-set-pass ARyS /dev/sdb
sudo hdparm --user-master u --security-erase   ARyS /dev/sdb
```

---

## Cerrando la unidad

1. El acceso físico **derrota** al control lógico
2. Defendé **en capas**, y que cada capa **deje registro**
3. Prevenir, **detectar**, responder — las tres, no una
4. El BIA define cuánto invertir; el riesgo, no el miedo
5. La disponibilidad se gana en energía, clima y backups **probados**
6. El eslabón humano abre más puertas que cualquier ganzúa

<div class="nota red"><span class="rot">Próxima unidad</span>
<strong>Unidad 3 — Hacking Ético.</strong> Pasamos del perímetro físico al
perímetro lógico: cómo un atacante estudia, mapea y entra. Y con qué límites
legales podemos hacerlo nosotros.</div>

---

<!-- _class: portada -->
<!-- _paginate: false -->
<!-- _footer: '' -->

# ¿Preguntas?

<div class="meta">Material: github.com/bzappellini/ARyS · Campus virtual UNPSJB</div>
