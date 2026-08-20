# Unidad 1 — Conceptos de Seguridad

> Material teórico de acompañamiento. Complementa las filminas y la clase.
> ARyS · IF046 · UNPSJB Trelew.

## 1. Qué es la seguridad de la información

La **seguridad de la información** es el conjunto de medidas y procesos
destinados a proteger la información —y los sistemas que la procesan, almacenan
y transmiten— frente a accesos, alteraciones, divulgaciones o destrucciones no
autorizadas.

Dos precisiones importantes desde el arranque:

- La seguridad **no es un producto** que se compra e instala, sino una
  **propiedad** que se diseña, se implementa y, sobre todo, se **sostiene** en el
  tiempo.
- La **seguridad perfecta no existe**. El objetivo realista no es eliminar todo
  riesgo, sino **gestionarlo** hasta un nivel aceptable con los recursos
  disponibles.

Conviene distinguir **dato** de **información**: el dato es un hecho crudo sin
contexto (`27.5`), mientras que la información es el dato dotado de significado
("la temperatura de la sala de servidores es 27,5 °C, por encima del umbral"). Lo
que protegemos, y lo que tiene valor, es la información.

## 2. La tríada CIA

El modelo clásico organiza la seguridad de la información en tres pilares,
conocidos por su sigla en inglés **CIA**:

### 2.1 Confidencialidad (Confidentiality)

La información debe ser accesible **únicamente para quien está autorizado**. Se
vulnera cuando alguien *lee* lo que no debía (una base de datos filtrada, un
correo interceptado, una pantalla espiada). Se protege principalmente con
**cifrado**, control de acceso y clasificación de la información.

### 2.2 Integridad (Integrity)

La información no debe **alterarse de forma no autorizada**, y una modificación
debe poder **detectarse**. Se vulnera cuando alguien *modifica* lo que no debía
(el monto de una transferencia, un registro de log, un archivo cifrado por
ransomware). Se protege con **funciones de hash**, **firmas digitales**, control
de versiones y permisos.

### 2.3 Disponibilidad (Availability)

La información y los servicios deben estar **accesibles cuando se los necesita**.
Se vulnera cuando algo *no está* (un servidor caído, un ataque de denegación de
servicio, un backup que nunca se probó). Se protege con **redundancia**, backups,
balanceo de carga y mantenimiento.

### 2.4 La tríada en tensión

Los tres pilares a menudo **compiten**: el cifrado fuerte agrega latencia; más
copias de respaldo aumentan la superficie a proteger; controles estrictos generan
fricción para el usuario. El oficio de la seguridad consiste en **equilibrar** los
tres según el contexto —un cajero automático y un blog personal no requieren el
mismo balance—, no en maximizar uno solo.

## 3. Más allá de CIA

La tríada es la base, pero se complementa con tres propiedades adicionales:

- **Autenticidad** — garantizar que algo o alguien **es quien dice ser**. Mientras
  la confidencialidad protege el *contenido*, la autenticidad protege el *origen*.
  Se apoya en la **autenticación** (Unidad 7), los certificados y la firma digital.
- **No repudio** — impedir que quien realizó una acción pueda **negar** haberla
  hecho. Es la base de la responsabilidad demostrable en comercio electrónico,
  expedientes y auditoría. Se apoya en la **firma digital** (Unidad 6) y en
  registros íntegros (Unidad 8).
- **Privacidad** — el **control de la persona sobre sus propios datos personales**.
  No es sinónimo de confidencialidad: se refiere a **quién decide** sobre el dato.
  En Argentina la rige la **Ley 25.326 de Protección de Datos Personales**. Quien
  administra sistemas con datos de personas asume obligaciones legales sobre ellos.

## 4. El vocabulario del riesgo

La gestión de la seguridad gira en torno al **riesgo**, y este se compone de
cuatro piezas que conviene no confundir:

- **Activo** — todo lo que tiene valor para la organización: datos, servidores,
  servicios, reputación.
- **Amenaza** — cualquier circunstancia o agente que pueda causar daño: un
  atacante, una falla de hardware, un desastre natural.
- **Vulnerabilidad** — la **debilidad** que la amenaza puede aprovechar: un
  software sin parchear, una contraseña débil, una puerta sin llave.
- **Riesgo** — la **probabilidad** de que una amenaza explote una vulnerabilidad,
  multiplicada por el **impacto** que tendría.

De aquí sale una idea central: **sin vulnerabilidad no hay riesgo**, aunque exista
la amenaza; y sin un activo de valor, tampoco. El riesgo vive en la
**intersección** de los tres.

### 4.1 Tratamiento del riesgo

Una vez identificado y estimado, un riesgo puede tratarse de cuatro maneras:

1. **Mitigar** — aplicar controles que lo reduzcan (la opción más frecuente).
2. **Transferir** — trasladarlo a un tercero (un seguro, un proveedor).
3. **Aceptar** — convivir con él cuando es bajo y controlarlo costaría más que el
   daño esperado. Aceptar *a conciencia* es válido; ignorar no lo es.
4. **Evitar** — no realizar la actividad que lo genera.

La elección es, en última instancia, una **decisión de negocio**, no puramente
técnica.

## 5. Controles

Un **control** (o salvaguarda) es toda medida que reduce el riesgo. Se clasifican
de dos formas complementarias.

Por el **momento** en que actúan:

| Tipo | Cuándo actúa | Ejemplo |
|---|---|---|
| Preventivo | Antes del incidente | Firewall, cifrado, control de acceso |
| Detectivo | Durante el incidente | IDS, monitoreo, logs |
| Correctivo | Después del incidente | Backup, respuesta a incidentes |
| Disuasivo | Antes (efecto psicológico) | Cartelería, políticas visibles |

Por su **naturaleza**: **físicos** (Unidad 2), **técnicos o lógicos** (la mayor
parte del curso) y **administrativos** (políticas, procedimientos, capacitación).

### 5.1 Defensa en profundidad

Como ningún control es perfecto, el principio rector es **no depender de uno
solo**: se disponen **capas** que se respaldan mutuamente. Si una capa falla, la
siguiente contiene; y cada capa **retrasa** al atacante y **genera evidencia**.
Este principio, central en la Unidad 2, reaparece en firewall, IDS y en toda la
arquitectura de red segura.

## 6. Principios de diseño seguro

Un puñado de principios guía el diseño de sistemas resistentes:

- **Menor privilegio** — cada usuario o proceso recibe solo los permisos que
  necesita. Es, probablemente, el principio más rentable: muchos incidentes graves
  empiezan con una cuenta que tenía más permisos de los necesarios.
- **Mínima exposición** — a menor superficie de ataque, menor riesgo. Cerrar
  puertos, deshabilitar servicios, reducir componentes.
- **Fail-safe** — ante una falla, el sistema debe quedar en estado **seguro**
  (denegando por defecto), no abierto.
- **Separación de deberes** — ninguna persona controla un proceso crítico de
  extremo a extremo.
- **Defensa en capas** — nunca un único control.
- **KISS** (*Keep It Simple*) — lo simple es más fácil de entender, auditar y
  asegurar.

## 7. La seguridad como proceso

La seguridad no se "termina": se sostiene mediante un ciclo de **mejora continua**,
habitualmente descrito como **PDCA**:

- **Planificar** (Plan) — evaluar riesgos y definir controles.
- **Hacer** (Do) — implementarlos.
- **Verificar** (Check) — monitorear, auditar y medir su eficacia.
- **Actuar** (Act) — corregir y mejorar.

El ciclo nunca cierra porque el entorno cambia: aparecen nuevas amenazas,
evoluciona la tecnología y rota el personal. Un sistema considerado "seguro" el
año pasado no lo es hoy por defecto.

## 8. Marcos de referencia

Existe un amplio consenso, plasmado en marcos que evitan "reinventar la rueda":

- **ISO/IEC 27001** — norma para un Sistema de Gestión de Seguridad de la
  Información (SGSI).
- **NIST Cybersecurity Framework (CSF)** — cinco funciones: Identificar, Proteger,
  Detectar, Responder, Recuperar.
- **OWASP** — seguridad de aplicaciones web (célebre por su Top 10).
- **CIS Controls** — un conjunto priorizado y accionable de controles.

No se trata de memorizarlos en esta unidad, sino de saber que existen y usarlos
como lista de verificación al diseñar.

## 9. Ideas para llevarse

1. Protegemos **información** y los sistemas que la sostienen.
2. **CIA** —confidencialidad, integridad, disponibilidad— en equilibrio.
3. Se suman **autenticidad**, **no repudio** y **privacidad**.
4. **Riesgo** = amenaza + vulnerabilidad sobre un activo de valor.
5. Se trata con **controles**, dispuestos en **capas**.
6. La seguridad es un **proceso**, no un producto.

## 10. Referencias

- W. Stallings — *Fundamentos de Seguridad en Redes* (bibliografía de cátedra).
- ISO/IEC 27001:2022 — Sistemas de gestión de seguridad de la información.
- NIST Cybersecurity Framework 2.0.
- Ley 25.326 (Argentina) — Protección de los Datos Personales.
