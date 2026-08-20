# Unidad 2 — Seguridad Física

> Material teórico de acompañamiento. Complementa las filminas y la clase.
> ARyS · IF046 · UNPSJB Trelew.

## 1. Por qué la seguridad física es la base

En la Unidad 1 definimos la seguridad de la información sobre seis pilares:
confidencialidad, integridad, disponibilidad, autenticidad, no repudio y
privacidad. Todos ellos se implementan mediante **controles lógicos** —
contraseñas, cifrado, firewalls, permisos— que se ejecutan sobre **hardware
físico**.

De ahí el axioma que ordena toda esta unidad:

> Si un atacante obtiene acceso físico irrestricto a un equipo, ese equipo
> deja de ser confiable.

Es una de las *10 Immutable Laws of Security* de Microsoft y sigue vigente:
quien controla el hardware controla la ejecución del software que lo protege.
Puede reiniciar desde otro medio, extraer el disco, intervenir el arranque o
implantar hardware. La seguridad física es, por lo tanto, el **primer
perímetro** y la precondición de todos los demás controles.

## 2. Qué protegemos

La seguridad física no protege solo servidores. El alcance incluye:

- **Personas** — prioridad absoluta; ningún activo justifica un riesgo de vida.
- **Instalaciones** — edificio, sala técnica, centro de datos.
- **Equipamiento** — servidores, equipos de red, estaciones de trabajo, móviles.
- **Medios de almacenamiento** — discos, cintas, unidades removibles, backups.
- **Infraestructura de soporte** — energía, refrigeración, cableado.
- **Documentación** — planos, credenciales, contratos, información en papel.

## 3. Las tres familias de amenazas

El programa organiza la seguridad física en tres tipos de amenaza. Conviene
tenerlas separadas porque las contramedidas son distintas.

### 3.1 Acceso físico no autorizado (intencional)

Una persona ingresa a un espacio o accede a un equipo sin autorización. Es la
amenaza con **agente deliberado**. Se combate con **defensa en profundidad**:
capas concéntricas de control, cada una de las cuales retrasa al atacante y
genera evidencia.

Las capas típicas, de afuera hacia adentro:

1. **Perímetro** — cerco, portón, iluminación, vigilancia.
2. **Edificio** — recepción, control de visitas, torniquete.
3. **Sala técnica** — esclusa (mantrap), control de acceso por doble factor.
4. **Rack** — jaula o gabinete con cerradura.
5. **Equipo** — cifrado de disco, TPM, bloqueo de puertos.

Los controles se clasifican por su función:

| Tipo | Propósito | Ejemplo |
|---|---|---|
| Disuasivo | Desalentar el intento | Cartelería, iluminación, garita |
| Preventivo | Impedir el hecho | Cerradura, esclusa, jaula |
| Detectivo | Descubrir el hecho | CCTV, sensores, alarmas |
| Correctivo | Restaurar tras el hecho | Backup, repuestos, sitio alterno |
| Compensatorio | Sustituir otro control | Guardia 24×7 |

Un principio de diseño complementario es **CPTED** (*Crime Prevention Through
Environmental Design*): control natural de accesos, vigilancia natural,
refuerzo territorial y mantenimiento. Es el control más económico porque se
decide en la etapa de planos.

#### Mecanismos de control de acceso

Se basan en los mismos factores de autenticación que veremos en la Unidad 7,
aplicados al mundo físico:

- **Algo que se sabe** — PIN.
- **Algo que se tiene** — llave, tarjeta de proximidad, token.
- **Algo que se es** — biometría (huella, iris, rostro, geometría de mano).

La **biometría** merece una advertencia doble: no es secreta (dejamos huellas y
rostro por todos lados) y **no es revocable** (no se puede "cambiar de dedo" si
se filtra la plantilla). Sus métricas clave son FAR (tasa de falsa aceptación,
riesgo de seguridad), FRR (tasa de falso rechazo, riesgo de disponibilidad) y
CER/EER (punto de cruce, útil para comparar sistemas). Debe usarse como **un**
factor, nunca como el único.

#### Ataques al acceso físico

- **Tailgating** — seguir a una persona autorizada sin credencial propia.
- **Piggybacking** — igual, pero con consentimiento del autorizado.
- **Lockpicking / bumping** — apertura de cerraduras.
- **Clonado RFID** — copia de tarjetas de baja frecuencia (125 kHz) con
  Proxmark3 o Flipper Zero.
- **Shoulder surfing** — observación del PIN.
- **Dumpster diving** — recuperación de información de la basura.

La mayoría de las intrusiones reales explotan el **factor humano** mediante
ingeniería social: una credencial impresa y una excusa creíble superan casi
cualquier control técnico. La contramedida es procedimental y cultural:
procedimiento de visitas, acompañamiento obligatorio y una cultura donde
verificar y preguntar sea la norma.

#### Ataques al equipo con acceso físico

- **Arranque alternativo** — booteo desde USB o red para eludir el sistema.
- **Extracción de disco** — leer los datos en otra máquina.
- **Evil maid** — manipulación del gestor de arranque en una ausencia breve.
- **Cold boot** — recuperación de claves desde la RAM enfriada.
- **BadUSB / Rubber Ducky** — dispositivo que se presenta como teclado y ejecuta
  comandos; requiere segundos.
- **DMA** — acceso directo a memoria por Thunderbolt/PCIe.
- **JTAG / UART** — acceso a la consola de depuración de la placa.

Contramedidas a nivel de equipo: cifrado de disco completo (LUKS), contraseña
de firmware con orden de arranque fijo, Secure Boot, TPM 2.0 para sellar la
clave al estado del arranque, protección DMA (IOMMU), bloqueo de puertos USB
(USBGuard con política de lista blanca) y detección de apertura de gabinete.

### 3.2 Desastres naturales (no intencional)

Amenazas sin agente deliberado: incendio, inundación, sismo, viento, actividad
volcánica. La primera contramedida es la **ubicación**: evitar sótanos
(inundación), últimas plantas (temperatura, filtraciones) y proximidad a baños,
cocinas o cañerías.

En el contexto **patagónico**, el perfil de riesgo dominante no es el sismo sino
el **viento fuerte, los cortes de energía prolongados y la ceniza volcánica**.
La ceniza es abrasiva y conductiva: daña ventiladores, filtros y fuentes de
alimentación, y obliga a presurización positiva de sala y filtrado reforzado.

Controles principales:

- **Fuego** — detección temprana por aspiración (VESDA), detectores de humo y
  térmicos, extinción por agente limpio (NOVEC 1230, FM-200, INERGEN). Nunca
  agua ni polvo químico en sala de servidores. Corte automático de energía y
  HVAC al disparar la extinción.
- **Agua** — sensores de humedad bajo piso técnico, ausencia de cañerías sobre
  los racks, piso elevado con desagüe.
- **Sismo** — anclaje de racks, aisladores de base, sujeción de cargas altas.
- **Viento y ceniza** — sellado de aberturas, presurización, filtros F7/F9.

La respuesta a desastres se planifica con métricas de continuidad:

- **RTO** (*Recovery Time Objective*) — tiempo máximo tolerable de caída.
- **RPO** (*Recovery Point Objective*) — pérdida máxima tolerable de datos.
- **BIA** (*Business Impact Analysis*) — análisis que identifica procesos
  críticos y el costo de su interrupción; de él sale el presupuesto de todos los
  controles.

Los **sitios alternos** (cold, warm, hot, cloud/DRaaS) y la política de
**backups** completan la estrategia. La regla mínima es **3‑2‑1** (tres copias,
dos medios, una fuera del sitio), extendida a **3‑2‑1‑1‑0** para incluir una
copia inmutable/offline contra ransomware y cero errores en una restauración
**probada**. Un backup nunca restaurado no es un backup.

### 3.3 Alteraciones del entorno (no intencional)

Fallas de las condiciones ambientales que rompen sin dejar marca visible.

#### Energía eléctrica

Fenómenos: blackout (corte total), brownout (baja tensión sostenida), sag
(caída breve), surge/spike (sobretensión), ruido/EMI (interferencia). La defensa
combina **UPS** (estabilización y autonomía corta), **grupo electrógeno**
(autonomía larga), puesta a tierra correcta y protección contra sobretensión.

El UPS no está para cubrir toda la noche: está para sostener hasta que arranque
el grupo o para permitir un apagado ordenado. El grupo debe probarse **con
carga** y las baterías deben medirse (vida útil 3–5 años).

La **redundancia** se expresa como N, N+1, 2N o 2N+1. Advertencia frecuente: dos
fuentes conectadas a la misma regleta no son redundancia.

#### Clima

Rango recomendado por **ASHRAE**: temperatura 18–27 °C, humedad relativa
40–60 %. Humedad baja → electricidad estática; humedad alta → condensación y
corrosión. El esquema **pasillo frío / pasillo caliente** con contención evita
que el aire frío y el caliente se mezclen.

#### Cableado y emanaciones

El cableado es parte de la seguridad: canalizaciones cerradas y rotuladas, patch
panel bajo llave, separación de datos y energía, y **puertos de switch sin uso
deshabilitados**. Un *network tap* pasivo en un patch panel descuidado copia
todo el tráfico sin alterar el enlace (tema que retomaremos en la Unidad 4).

Las **emanaciones electromagnéticas** (TEMPEST) son un canal lateral: monitores,
cables y teclados irradian señal recuperable. Es una amenaza de alto costo y
objetivos de alto valor; para el curso vale como concepto: el canal lateral
existe aunque no se lo vea.

## 4. Marcos de referencia

Dos marcos ordenan los controles físicos y sirven como lista de verificación al
diseñar:

- **ISO/IEC 27001:2022**, Anexo A, cláusula 7 (Controles físicos): perímetros,
  ingreso, áreas seguras, monitoreo, protección frente a amenazas físicas,
  escritorio y pantalla limpios, equipamiento, cableado, mantenimiento y
  descarte seguro.
- **NIST SP 800‑53 Rev. 5**, familia **PE** (*Physical and Environmental
  Protection*): autorizaciones, control de acceso, monitoreo, energía, fuego,
  clima y sitio alterno.

Complementan la unidad las prácticas de **clean desk / clean screen** y el
**descarte seguro de medios**: papel a destructora de corte cruzado, discos
magnéticos por borrado o desmagnetizado, y SSD por borrado criptográfico (la
sobrescritura no es suficiente en memoria flash).

## 5. Ideas para llevarse

1. El acceso físico derrota al control lógico.
2. Se defiende en capas, y cada capa debe dejar registro.
3. Prevenir, detectar y responder: las tres funciones, no una sola.
4. El BIA define cuánto invertir; decide el riesgo, no el miedo.
5. La disponibilidad se sostiene en energía, clima y backups probados.
6. El eslabón humano abre más puertas que cualquier ganzúa.

## 6. Referencias

- Microsoft — *Ten Immutable Laws of Security*.
- ISO/IEC 27001:2022 — Anexo A, controles físicos (cláusula 7).
- NIST SP 800‑53 Rev. 5 — familia PE.
- ASHRAE TC 9.9 — *Thermal Guidelines for Data Processing Environments*.
- W. Stallings — *Fundamentos de Seguridad en Redes* (bibliografía de cátedra).
