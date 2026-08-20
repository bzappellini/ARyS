# Trabajo Práctico 2 — Seguridad Física

> ARyS · IF046 · UNPSJB Trelew. Modalidad: laboratorio guiado + informe.
> Duración estimada: una clase práctica (3 h) + entrega.

## Objetivos

Al finalizar el práctico, el estudiante será capaz de:

1. Evaluar los riesgos físicos de un entorno real aplicando defensa en
   profundidad y las tres familias de amenazas de la unidad.
2. Implementar y verificar controles a nivel de equipo sobre GNU/Linux: cifrado
   de disco, bloqueo de puertos USB y monitoreo de energía.
3. Redactar un plan de mejora priorizado por riesgo, no por intuición.

> **Aclaración ética y legal.** Todas las actividades se realizan sobre
> equipamiento propio, de laboratorio o expresamente autorizado. No se aplica
> ninguna técnica sobre instalaciones o equipos de terceros sin autorización
> escrita.

---

## Parte A — Relevamiento de un entorno (individual)

Elegí un entorno real y acotado al que tengas acceso legítimo: la sala de un
laboratorio de la facultad, una pyme, tu lugar de trabajo o tu propio espacio
de estudio con equipamiento de red.

1. **Diagramá las capas** de defensa en profundidad presentes (perímetro,
   edificio, sala, rack, equipo). Indicá qué capa falta.
2. **Clasificá diez controles** que observes usando la tabla disuasivo /
   preventivo / detectivo / correctivo / compensatorio.
3. **Identificá amenazas** por las tres familias:
   - Acceso físico no autorizado.
   - Desastres naturales (considerá el contexto patagónico: viento, cortes,
     ceniza).
   - Alteraciones del entorno (energía, clima, cableado).
4. **Registrá tres hallazgos** de mayor riesgo con una foto o croquis (sin
   exponer información sensible ni credenciales).

**Entregable A:** informe breve (máx. 2 páginas) con el diagrama de capas, la
tabla de controles y los tres hallazgos.

---

## Parte B — Controles sobre el equipo (laboratorio)

Trabajá en una **máquina virtual** GNU/Linux descartable. No ejecutes estos
comandos sobre tu sistema principal.

### B.1 Cifrado de disco con LUKS

```bash
# Crear un archivo que oficie de "disco" de laboratorio (2 GB)
dd if=/dev/zero of=disco_lab.img bs=1M count=2048
sudo losetup /dev/loop20 disco_lab.img

# Cifrar el dispositivo
sudo cryptsetup luksFormat /dev/loop20

# Abrirlo, formatearlo y montarlo
sudo cryptsetup luksOpen /dev/loop20 caja_fuerte
sudo mkfs.ext4 /dev/mapper/caja_fuerte
sudo mount /dev/mapper/caja_fuerte /mnt

# Inspeccionar la cabecera LUKS y los slots de clave
sudo cryptsetup luksDump /dev/loop20
```

**Consigna B.1.** Guardá un archivo dentro de `/mnt`, desmontá y cerrá el
contenedor (`umount /mnt`, `cryptsetup luksClose caja_fuerte`). Demostrá que sin
la passphrase el contenido es inaccesible. Explicá con tus palabras qué ataque
de la unidad neutraliza el cifrado de disco completo y cuál **no**.

### B.2 Bloqueo de puertos USB con USBGuard

```bash
sudo apt install usbguard
sudo usbguard generate-policy | sudo tee /etc/usbguard/rules.conf
sudo systemctl enable --now usbguard

# Ver dispositivos y su estado de autorización
usbguard list-devices

# Conectar un pendrive y autorizarlo puntualmente por su número
usbguard allow-device <n>
```

**Consigna B.2.** Con la política por defecto en *deny*, conectá un dispositivo
USB y mostrá que queda bloqueado hasta autorizarlo. Relacioná esto con el ataque
**BadUSB / Rubber Ducky** visto en clase: ¿por qué una lista blanca es más
efectiva que una lista negra?

### B.3 Monitoreo de energía (conceptual o real)

Si disponés de un UPS con Network UPS Tools:

```bash
sudo apt install nut-client
upsc ups@localhost
```

Si no disponés de UPS, respondé de forma teórica: dado un servidor crítico con
**RTO de 1 hora** y **RPO de 15 minutos**, proponé una configuración de energía
(UPS, grupo, redundancia N+1/2N) y una estrategia de backup 3‑2‑1‑1‑0 que
cumpla esos objetivos. Justificá cada elección.

**Entregable B:** capturas de pantalla de B.1 y B.2, y las respuestas a las
tres consignas.

---

## Parte C — Plan de mejora priorizado (individual)

Tomá los hallazgos de la Parte A y construí una tabla de tratamiento del riesgo:

| Hallazgo | Amenaza | Impacto (A/M/B) | Probabilidad (A/M/B) | Control propuesto | Tipo de control | Prioridad |
|---|---|---|---|---|---|---|

- Ordená por **riesgo** (impacto × probabilidad), no por costo.
- Para cada control propuesto, indicá a qué cláusula de **ISO 27001 Anexo A
  cláusula 7** o a qué control **PE de NIST 800‑53** corresponde.

**Entregable C:** tabla completa y un párrafo de conclusión: si tuvieras
presupuesto para **un solo** control, ¿cuál implementarías primero y por qué?

---

## Entrega y evaluación

- **Formato:** un único PDF con las partes A, B y C. Nombre:
  `TP2_ApellidoNombre.pdf`.
- **Vía:** campus virtual UNPSJB.
- **Criterios de corrección:**
  - Correcta aplicación de defensa en profundidad y clasificación de controles (30 %).
  - Ejecución y comprensión de los controles de laboratorio B.1–B.3 (35 %).
  - Priorización por riesgo y trazabilidad a marcos normativos (25 %).
  - Claridad, prolijidad y rigor del informe (10 %).

## Para investigar (opcional, suma)

- Diferencia entre borrado, sobrescritura y desmagnetizado; por qué la
  sobrescritura no alcanza en SSD.
- Qué es un ataque **cold boot** y cómo lo mitiga el sellado de claves con TPM.
- Cómo se clona una tarjeta de proximidad de 125 kHz y por qué DESFire EV3 no es
  vulnerable al mismo ataque.
